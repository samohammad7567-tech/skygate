
The "رحلاتي" exports arrived in `assets/images/my_trips/` and have been taken
up. What the app bundles was harvested from them into the flat
`assets/images/{svgs,pngs}` folders the rest of the app reads, under names that
say what each file is, and declared in `lib/core/constants/my_trips_assets.dart`.

**The raw export now lives in `screens/my-trips/exports/`**, beside the frames
it came from. It was moved out of `assets/` on purpose: it is 150 files, most
of them the same glyph re-exported at three or four sizes, and everything under
`assets/images` is bundled into the app and checked by `app_assets_test`.
Nothing was deleted — harvest more from it any time.

---

| Was standing in as | Now draws | Call site |
|---|---|---|
| `Icons.download_rounded` | `svgs/download.svg` | `core/components/app_document_actions.dart` |
| `Icons.link_rounded` | `svgs/link.svg` | `journey_details/widgets/ticket_tile.dart` |
| `Icons.thumb_up_outlined` | `svgs/thumb_up.svg` | `journey_details/widgets/activity_action_button.dart` |
| `Icons.keyboard_arrow_down_rounded` | `svgs/chevron_up.svg`, turned over when closed | `core/components/app_expandable_tile.dart` |
| `id_card.svg` on "رقم التأشيرة" | `svgs/serial_number.svg` | `journey_details/widgets/visa_tile.dart` |
| `confirmation_number.svg` on "نوع التذكرة" | `svgs/type_specimen.svg` | `journey_details/widgets/ticket_tile.dart` |
| `id_card.svg` on "نوع التأشيرة" | `svgs/id_card_2.svg` | `journey_details/widgets/visa_tile.dart` |
| One shared `map.png` for every leg | `route_map_{air,land,sea,train}.png`, picked by mode | `core/models/journey_transport.dart` → `routeMap` |
| A plain white card face | `pngs/card_watermark_skyline.png` at 14% behind the face | `core/components/app_id_card.dart` |

Also harvested and declared, not yet placed: `svgs/luggage.svg`,
`svgs/check_small.svg`, `svgs/location_pin.svg`, `pngs/qr_placeholder.png`,
`pngs/activity_place_map.png`.

---

- **`تنزيل (1) 1.png` / `تنزيل (1) 2.png`** — the Jeddah Transport and ALBORAQ
  logos. These are mock data on the Figma frame, not app chrome: a carrier's
  logo arrives at runtime as `carrier.logo_url`, and the generic fallbacks the
  app already ships are the right stand-in when it is null. Wiring them in
  replaced the Syrian carrier branding on the browse screens, which is a
  different flow.
- **The circle, bar and dashed-line shapes** (`Ellipse *`, `Track.svg`,
  `Segment.svg`, `Stop.svg`, `Group 184*`) — these are geometry, not artwork.
  Their colours were read off and encoded directly, which is why the progress
  rail on a "رحلاتي" card now rings blue `#195AA7` when travelled, gold
  `#FF9E00` when under way, and grey `#94A3B8` at half opacity when still
  ahead, joined by `#EFF6FF`.
- **Every glyph the app already ships** — `train`, `flight`, `domain`,
  `today`, `person`, `passport`, `search`, `sort`, `settings`, `home`, `menu`
  and the rest were re-exported but are byte-for-byte the job the existing
  constants already do.

---

| Suggested file | Design | Currently drawn as | Call site |
|---|---|---|---|
| `svgs/holy_site.svg` | Last glyph of the card's inclusions row — a wide arched dome flanked by two pillars | `svgs/mosque.svg`, a Material mosque with one minaret | `core/constants/payment_assets.dart` → `PaymentAssets.inclusions` |

One export note worth keeping: **`svgs/makkah.svg` cannot be tinted.** It bakes
a `#EFF6FF` circular plate and a drop-shadow `<filter>` into the file, so
`AppImage(..., color:)` floods the whole thing and it renders as a solid dot.
`svgs/makka.svg` is the same drawing without the plate. `Group 167.svg` and
`Ellipse 11-4.svg` in the new export have the same problem. Anything exported
for a call site that tints should be a bare single-colour path — no plate, no
`<filter>`.

---

Not design assets — these arrive as URLs at runtime and fall back to a bundled
image meanwhile.

- **Trip photo on the "رحلاتي" card** — `my-trips` publishes `trip_image_url`
  and the card reads it, but every demo trip sends `null`, so the cards fall
  back to `pngs/makka.png`.
- **Activity maps** (designs 28–30) — fall back to `pngs/map.png` until the
  activity resource publishes a rendered map for its place and meeting point.
  `pngs/activity_place_map.png` is now bundled as a closer stand-in.
- **QR codes** (designs 8, 13) — read from `qr_url` on the card and luggage-tag
  resources; `svgs/qr_code.svg` is drawn while that is null. Nothing is
  generated on device.

---

Not assets — listed because the design draws them and the screen cannot, so a
reviewer comparing design 1 against the running app will notice.

| Design element | Field the card reads | What the demo payload sends |
|---|---|---|
| The photo behind the status badge | `trip_image_url` | `null` on every trip |
| The five plates of the progress rail | `transport_modes` | `[]` on every trip — the rail hides entirely |
| Which plate is gold (the leg under way) | `current_leg` | absent from the schema; the rail falls back to stating the route, every plate ringed in blue |

The readers are already in place, so each starts drawing the moment the API
fills it in — no call site changes.

---

Read off `Skygate API Documentation.openapi.json` while wiring the booking
through. Listed so the gap is deliberate rather than overlooked:

- `GET app/trip-segments/{id}/boarding-pass` — a per-leg boarding pass. No
  frame in `screens/my-trips/` shows one; "تذاكر" reads `app/pilgrim-tickets`.
- `GET app/bookings` — the booking list. "رحلاتي" is a trip list that nests
  its booking, so nothing needs it.
- `POST app/booking-change-requests` — booking amendment, no frame.
- `GET app/room-assignments` — room allocation, no frame.

The collection documents no response schemas (every example is the 401 body),
so the shapes the screens parse come from the live demo payloads, not from it.
