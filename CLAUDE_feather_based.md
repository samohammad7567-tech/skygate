# DentVerse — Project Instructions

Flutter app (`dentverse_app`) using **feature-based architecture** with Cubit state management.

> **This file overrides the global `~/.claude/CLAUDE.md` clean-architecture rules for this repo.**
> This project does **not** use `corereusablepackage`, `get_it`, `go_router`, `data_source/`, `repos/`, or
> `LangKeys`. Follow the conventions documented here — they match the existing code. Never introduce the
> global-template folders (`data/`, `refactor/`, `presentation/`, `screens/`) into this project.

---

## Structure

```
lib/
  main.dart                          # init + MyApp (MultiBlocProvider + MaterialApp)
  core/
    components/                      # shared dumb widgets (CustomButton, VideoCard, Toast, ...)
    constants/api_endpoints.dart     # ALL endpoint paths
    interceptors/                    # AuthInterceptor (401 + token refresh)
    models/                          # models shared by 2+ features
    services/                        # DioService, AppLifecycleService
    themes/                          # LightTheme, DarkTheme
    utils/                           # CacheUtil, ScreenSize, NavigationService, NaivgatorHelper, ...
  features/<feature>/
    controller/cubit/                # <feature>_cubit.dart + <feature>_state.dart (part file)
    models/                          # models used only by this feature
    views/                           # screens (<name>_screen.dart)
    widgets/                         # feature-only dumb widgets
    utils/                           # feature-only helpers (optional)
  generated/codegen_loader.g.dart    # easy_localization — DO NOT EDIT
assets/
  lang/ar.json, lang/en.json
  images/
```

**Feature folders in use:** `about_us`, `auth`, `category`, `home`, `main`, `profile`, `quiz`, `splash`,
`train_with_us`, `video`, `welcome`.

### Adding a new feature

Create only the folders you need, in this order:

```
lib/features/<feature>/
  controller/cubit/<feature>_cubit.dart
  controller/cubit/<feature>_state.dart
  models/<name>_model.dart          # only if not shared
  views/<name>_screen.dart
  widgets/<name>_item.dart
```

If the model or widget is used by another feature, put it in `core/models/` or `core/components/` instead.

---

## Layer Rules

| Layer | Owns | Must not |
|-------|------|----------|
| **View (screen)** | Scaffold, `BlocBuilder`/`BlocConsumer`, scroll controllers, pagination triggers, navigation | Call `DioService` directly, parse JSON, map errors |
| **Widget** | Render props, forward taps to the cubit or navigate | Call `DioService`, hold business state |
| **Cubit** | API calls via `DioService`, parsing into models, pagination flags, filters, selection, emitting states | Use `BuildContext`, build widgets |
| **Model** | `fromJson` (+ `toJson` when posting), null-safe field mapping | Contain UI or network code |
| **core/services** | HTTP client config, headers, lifecycle | Depend on features |

---

## Cubit Pattern

Every cubit follows the shape of `features/home/controller/cubit/home_cubit.dart`:

```dart
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  HomeCubit get(context) => BlocProvider.of(context);

  AdsModel? ads;

  Future<void> getAds() async {
    emit(AdsLoading());
    DioService.get(ApiEndpoints.ads, queryParameters: {'page': 1, 'per_page': 100})
        .then((response) {
          ads = AdsModel.fromJson(response.data);
          emit(AdsLoaded());
        })
        .catchError((error) {
          debugPrint('getAds error: $error');
          emit(AdsError(message: error.response.data['message'].toString()));
        });
  }
}
```

Rules:
- State file is a `part of` the cubit: `@immutable sealed class <F>State` + `final class` variants.
- One `Loading` / `Loaded` / `Error` triple **per operation** (e.g. `AdsLoading`, `CategoryLoading`), not one
  global triple — screens read data from public cubit fields, states only signal transitions.
- Data lives in **public fields on the cubit** (`ads`, `categoryModel`, `videoModel`), and the UI reads them via
  `context.read<XCubit>()` inside the builder. Emitting a bare `Loaded()` state is what triggers the rebuild.
- Error states carry `final String message`.
- Always `debugPrint` in `catchError` before emitting the error state.
- Never touch `BuildContext` inside a cubit.

### Pagination

Follow `HomeCubit.getVideos` / `CategoryCubit.getCategories`: keep `isLoadingMore` and `hasMorePages` flags on
the cubit, emit `Loading` only for page 1, append to the existing list for page > 1, and recompute
`hasMorePages` from `meta.currentPage` vs `ceil(meta.total / meta.perPage)`. The screen owns the
`ScrollController` and calls `cubit.getX(page: next)` near the bottom.

---

## Networking

- All requests go through the static `DioService` (`get` / `post` / `put` / `delete`). Never create a `Dio`
  instance in a feature.
- Every path is a constant in `ApiEndpoints`. No inline URL strings.
- Media URLs use `ApiEndpoints.mediaPath`.
- Guest vs authenticated base URL is switched with `DioService.updateBaseUrl(...)`; token with
  `DioService.updateToken(...)`; language header with `DioService.updateLanguage(...)`.
- 401 / refresh-token handling belongs in `core/interceptors/auth_interceptor.dart` — do not re-implement it in
  a cubit.

## Models

Hand-written, no code generation, no freezed/json_serializable:

```dart
class Category {
  int? id;
  String? title;
  String? image;
  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
  }
}
```

List responses wrap `List<T>` + `Meta` (`core/models/meta_model.dart`) and parse `json['meta']['pagination']`.
Add `toJson()` only for models that are sent to the API.

## Persistence

`CacheUtil` (SharedPreferences wrapper) only — `CacheUtil.get(key: 'token')`, `setString`, `setBool`, `remove`.
Keys currently in use: `token`, `lang`, `isGuest`. Call it from cubits/services, never from a widget build.

---

## Localization

`easy_localization` with **codegen**, files in `assets/lang/{ar,en}.json`, loaded by `CodegenLoader`.

- Usage in this project is **raw key + `.tr()`**: `Text('email_required'.tr())`. There is no `LangKeys` class —
  do not create one (that rule is from the global template and does not apply here).
- Adding text: add the key to **both** `assets/lang/ar.json` and `assets/lang/en.json`, then regenerate:

  ```bash
  dart run easy_localization:generate -S assets/lang -O lib/generated
  ```

  Never hand-edit `lib/generated/codegen_loader.g.dart`.
- No hardcoded user-facing strings anywhere.
- Startup locale is `en`, fallback `en`; `ar` is fully supported — keep both files in sync and RTL-safe
  (use `EdgeInsetsDirectional` / `start`-`end` alignment for new layouts).

## Navigation

`Navigator` based — **no go_router**.

- Use `NaivgatorHelper.pushNavigation(context, const XScreen())` (note the existing spelling — do not rename the
  file), `pushReplacementNavigation`, `pushAndRemoveUntilNavigation`, `popNavigation`.
- Context-less navigation (from services/interceptors) uses `NavigationService.navigatorKey`.
- Screens receive arguments as constructor parameters, not route settings.

## Theming

`LightTheme.theme` / `DarkTheme.theme`, toggled by `MaterialCubit` (`isDark`). Read colors from
`Theme.of(context)` — no hardcoded `Color(0x...)` in features.

## UI conventions

- Prefer the existing shared widgets before writing new ones: `CustomAppBar`, `CustomButton`,
  `CustomTextField`, `VideoCard`, `VideoList`, `QuizCard`, `QuizList`, `FilterBar`, `CategoryFilterBar`,
  `IconText`, `AuthWidget`, `YoutubeEmbedPlayer`, `showToast(context, message)`.
- Conditional rendering uses `BuildCondition(condition:, builder:, fallback:)` (package `buildcondition`).
- Responsive sizing via `ScreenSize.isMobile/isTablet/width/height/cardWidth/buttonWidth`.
- Spacing with `Gap()` (package `gap`).
- Forms: `TextFormField` inside a `Form` with a `GlobalKey<FormState>`, validators returning translated strings.
- Images: `CachedNetworkImage` for network, `flutter_svg` for SVG assets, always with a placeholder/fallback.
- Screens that must not rotate wrap content in `OrientationLock`; secure screens rely on `AppProtection`.

---

## Imports

This project uses **absolute package imports**: `import 'package:dentverse_app/core/...';`
(the global "relative imports only" rule does **not** apply here). Match the surrounding file — some files mix
in relative imports; prefer `package:dentverse_app/...` for new code and stay consistent within a file.

## File size

| Type | Target | Max |
|------|--------|-----|
| Screen (view) | 60–150 | 200 |
| Widget | 60–120 | 150 |
| Cubit | no limit | — |

Split oversized screens into `widgets/` inside the same feature.

---

## Commands

```bash
flutter pub get
flutter analyze
flutter run
dart run easy_localization:generate -S assets/lang -O lib/generated   # after editing lang JSON
```

`build_runner` is **not** used in this project — do not add generated-model tooling without being asked.

## Pre-delivery checklist

- [ ] No `DioService` / `CacheUtil` calls inside `views/` or `widgets/`
- [ ] New endpoints added to `ApiEndpoints`
- [ ] New strings added to **both** `ar.json` and `en.json`, codegen regenerated
- [ ] No hardcoded UI text or colors
- [ ] Cubit exposes data via public fields, screens rebuild from state
- [ ] No `domain/`, `use_cases/`, `repos/`, or `data_source/` folders introduced
- [ ] `flutter analyze` result stated
