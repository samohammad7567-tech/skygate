#!/usr/bin/env node
// Zero-dependency MCP server: free AI image generation via Pollinations.ai
// No API key, no account. Writes Flutter 1x / 2.0x / 3.0x asset variants.

import { spawnSync } from "node:child_process";
import { mkdirSync, writeFileSync, existsSync } from "node:fs";
import { dirname, join, resolve } from "node:path";

const PROJECT_ROOT = resolve(process.env.SKYGATE_ROOT ?? process.cwd());
const ASSET_DIR = join(PROJECT_ROOT, "assets", "images");
const ENDPOINT = "https://image.pollinations.ai/prompt";

// ---------- image helpers ----------

function haveMagick() {
  return spawnSync("magick", ["-version"], { stdio: "ignore" }).status === 0;
}

function resize(src, dst, w, h) {
  mkdirSync(dirname(dst), { recursive: true });
  const r = haveMagick()
    ? spawnSync("magick", [src, "-resize", `${w}x${h}`, dst], { stdio: "pipe" })
    : spawnSync("python", ["-c",
        `from PIL import Image;i=Image.open(r"${src}");i.resize((${w},${h}),Image.LANCZOS).save(r"${dst}")`,
      ], { stdio: "pipe" });
  if (r.status !== 0) throw new Error(`resize failed: ${r.stderr?.toString().trim()}`);
}

// Make a near-white background transparent (useful for icons / spot illustrations).
function keyOutWhite(src, dst, fuzz = 12) {
  mkdirSync(dirname(dst), { recursive: true });
  if (!haveMagick()) throw new Error("transparent:true requires ImageMagick");
  const r = spawnSync("magick", [
    src, "-fuzz", `${fuzz}%`, "-transparent", "white",
    "-bordercolor", "none", "-border", "1", "-trim", "+repage", dst,
  ], { stdio: "pipe" });
  if (r.status !== 0) throw new Error(`transparency failed: ${r.stderr?.toString().trim()}`);
}

async function fetchImage(prompt, w, h, model, seed) {
  const q = new URLSearchParams({
    width: String(w), height: String(h), model, nologo: "true", safe: "true",
  });
  if (seed !== undefined && seed !== null) q.set("seed", String(seed));
  const url = `${ENDPOINT}/${encodeURIComponent(prompt)}?${q}`;

  let lastErr;
  for (let attempt = 1; attempt <= 3; attempt++) {
    try {
      const res = await fetch(url, { signal: AbortSignal.timeout(120_000) });
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      const buf = Buffer.from(await res.arrayBuffer());
      if (buf.length < 2048) throw new Error(`suspiciously small response (${buf.length}B)`);
      return buf;
    } catch (e) {
      lastErr = e;
      if (attempt < 3) await new Promise((r) => setTimeout(r, 2000 * attempt));
    }
  }
  throw new Error(`generation failed after 3 attempts: ${lastErr.message}`);
}

// ---------- tool ----------

const TOOL = {
  name: "generate_image",
  description:
    "Generate an image with a free AI model (Pollinations/FLUX, no API key) and write it " +
    "into assets/images/ as Flutter 1x, 2.0x and 3.0x variants. Use for illustrations, " +
    "empty states and onboarding art — NOT for icons or logos, which should stay vector SVG.",
  inputSchema: {
    type: "object",
    properties: {
      prompt: { type: "string", description: "What to draw. Be explicit about style, palette and background." },
      name: { type: "string", description: "Base filename, kebab-case, no extension. e.g. 'empty-bookings'" },
      base_width: { type: "integer", description: "Logical (1x) width in px. Default 256.", default: 256 },
      base_height: { type: "integer", description: "Logical (1x) height in px. Default 256.", default: 256 },
      model: { type: "string", enum: ["flux", "turbo"], default: "flux",
               description: "'flux' = higher quality, 'turbo' = faster." },
      seed: { type: "integer", description: "Fix the seed to keep a set of images visually consistent." },
      transparent: { type: "boolean", default: false,
                     description: "Key out the white background and trim. Requires a white-background prompt." },
    },
    required: ["prompt", "name"],
  },
};

async function runTool(args) {
  const name = String(args.name ?? "").trim();
  if (!/^[a-z0-9]+(-[a-z0-9]+)*$/.test(name)) {
    throw new Error(`'name' must be kebab-case with no extension (got: "${name}")`);
  }
  const bw = Math.max(32, Math.min(1024, args.base_width ?? 256));
  const bh = Math.max(32, Math.min(1024, args.base_height ?? 256));
  const model = args.model ?? "flux";
  const ext = args.transparent ? "png" : "png";

  // Generate at 3x, then downscale so all variants share identical composition.
  const raw = await fetchImage(args.prompt, bw * 3, bh * 3, model, args.seed);

  const tmp = join(PROJECT_ROOT, ".dart_tool", `imgmcp-${name}-${Date.now()}.img`);
  mkdirSync(dirname(tmp), { recursive: true });
  writeFileSync(tmp, raw);

  let source = tmp;
  if (args.transparent) {
    const keyed = `${tmp}.keyed.png`;
    keyOutWhite(tmp, keyed);
    source = keyed;
  }

  const targets = [
    [join(ASSET_DIR, `${name}.${ext}`), bw, bh],
    [join(ASSET_DIR, "2.0x", `${name}.${ext}`), bw * 2, bh * 2],
    [join(ASSET_DIR, "3.0x", `${name}.${ext}`), bw * 3, bh * 3],
  ];
  for (const [dst, w, h] of targets) resize(source, dst, w, h);

  const rel = targets.map(([p]) => p.replace(PROJECT_ROOT, "").split(String.fromCharCode(92)).join("/").replace(/^\//, ""));
  return (
    `Generated "${name}" (${bw}x${bh} @1x, model=${model}` +
    (args.seed != null ? `, seed=${args.seed}` : "") +
    `)\n` + rel.map((r) => `  ${r}`).join("\n") +
    `\n\nReference in Dart as: Image.asset('assets/images/${name}.${ext}')` +
    `\nFlutter resolves 2.0x/3.0x automatically — declare only the 1x path in pubspec.yaml.`
  );
}

// ---------- MCP stdio plumbing (raw JSON-RPC, no SDK) ----------

function send(msg) {
  process.stdout.write(JSON.stringify(msg) + "\n");
}

function reply(id, result) { send({ jsonrpc: "2.0", id, result }); }
function fail(id, code, message) { send({ jsonrpc: "2.0", id, error: { code, message } }); }

async function handle(msg) {
  const { id, method, params } = msg;

  if (method === "initialize") {
    return reply(id, {
      protocolVersion: params?.protocolVersion ?? "2024-11-05",
      capabilities: { tools: {} },
      serverInfo: { name: "free-image-gen", version: "1.0.0" },
    });
  }
  if (method === "notifications/initialized" || method === "notifications/cancelled") return;
  if (method === "ping") return reply(id, {});
  if (method === "tools/list") return reply(id, { tools: [TOOL] });

  if (method === "tools/call") {
    if (params?.name !== TOOL.name) return fail(id, -32602, `Unknown tool: ${params?.name}`);
    try {
      const text = await runTool(params.arguments ?? {});
      return reply(id, { content: [{ type: "text", text }] });
    } catch (e) {
      return reply(id, { content: [{ type: "text", text: `Error: ${e.message}` }], isError: true });
    }
  }

  if (id !== undefined) fail(id, -32601, `Method not found: ${method}`);
}

let buf = "";
process.stdin.setEncoding("utf8");
process.stdin.on("data", (chunk) => {
  buf += chunk;
  let nl;
  while ((nl = buf.indexOf("\n")) !== -1) {
    const line = buf.slice(0, nl).trim();
    buf = buf.slice(nl + 1);
    if (!line) continue;
    let msg;
    try { msg = JSON.parse(line); } catch { continue; }
    handle(msg).catch((e) => {
      if (msg.id !== undefined) fail(msg.id, -32603, e.message);
    });
  }
});
