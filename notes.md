# ملاحظات على واجهة الـ API مقابل شاشات التطبيق

> المرجع: `Skygate API Documentation.openapi.json` (OpenAPI 3.0.1 — 43 مساراً / 50 عملية)
> مقابل: مجلد `SCREENS/` والكود الحالي في `lib/`
> التاريخ: 2026-08-31

---

## الخلاصة

**التطابق جزئي.** التوثيق الحالي يصف **واجهة تشغيل رحلة قائمة** (ما بعد الحجز)، بينما الشاشات تصف **رحلة تصفح وحجز** (ما قبل الحجز).

- التطبيق يعرّف **22 مساراً** في `lib/core/constants/api_endpoints.dart`.
- **5 مسارات فقط** موجودة فعلاً في التوثيق.
- **3 من هذه الـ 5** يختلف شكل جسم الطلب (body) فيها عمّا يرسله التطبيق.
- لا يوجد `servers` في التوثيق، لذلك الـ host الحالي (`https://dev.skygate.site`) مجرد قيمة افتراضية عبر `--dart-define=API_HOST`.
- المصادقة: `bearer` token ✅ متوافقة مع `DioService`.

---

## 1. ما هو متطابق ✅

| الشاشة | المسار | الحالة |
|---|---|---|
| تسجيل الدخول | `POST /api/v1/auth/login` | ✅ `mobile` + `password` |
| إنشاء حساب | `POST /api/v1/auth/register` | ⚠️ حقول زائدة — انظر 3-و |
| مسح جواز السفر | `POST /app/passport-ocr/scan` | ✅ multipart `passport_image` بحد 5 ميجابايت، مطابق لـ `ImagePickerService` |
| رفع مستندات العمرة | `POST /app/pilgrim-documents` | ⚠️ يحتاج `pilgrim_id` و `document_type_id` رقمي — انظر 3-هـ |
| عروض الرحلة (`trip_offers`) | `GET /app/trips/{id}` ← `packages[]` | ✅ `room_type` و `audience` و `price_adult/child/infant` و `bed_lock_fee` و `currency` تقابل بطاقات العروض حرفياً |
| الأنشطة | `GET /app/activities` | ✅ لكنها مرتبطة بالرحلة لا بالباقة |
| مؤقّت الدفع في ملخص الحجز | `BookingResource.draft_expires_at` | ✅ |
| **الحجز الجماعي** (الغرف، ولي الأمر، قفل الأسرّة، جواز لكل مسافر) | `POST /app/pilgrims` + `POST /app/bookings` مع `rooms[].pilgrims[].guardian_pilgrim_id` و `locked_beds_count` | ✅ الـ API مبني أصلاً لهذا المسار — وهو المسار الذي لم يُنفَّذ بعد في التطبيق |

---

## 2. شاشات بلا أي مسار في التوثيق ❌

### الصفحة الرئيسية (`home_screen.dart`) — كامل قمع ما قبل الحجز

| المطلوب في الشاشة | الحالة |
|---|---|
| `travel-categories` — شريط (عمرة / طيران / فنادق / قطارات / نقل بحري) | ❌ غير موجود |
| `offers` — "العروض الحالية" | ❌ أقرب شيء `GET /app/trips`، لكن `TripResource` **بلا سعر، بلا صورة، بلا ملخّص وسائل النقل**، وبلا أي معاملات صفحات/بحث/فلترة/تاريخ |
| `services` — شبكة "ماذا تشمل خدماتنا" | ❌ غير موجود |
| `custom-trips` — "اطلب رحلتك الخاصة" | ⚠️ البديل `POST /app/private-trip-requests` لكنه يطلب `people_count` و `adult/child/infant_count` و `preferred_start/end_date` و `hotel_ids` و `room_type_ids`، بينما `HomeCubit` يرسل `category` + `travel_date` فقط |
| جرس الإشعارات | ✅ `GET /app/notifications` موجود لكنه غير مستخدم في الكود |

### تفاصيل الرحلة (`journey_details`)

المسارات التالية **غير موجودة إطلاقاً**:

```
packages/{id}
packages/{id}/routes
packages/{id}/hotels
packages/{id}/activities
packages/{id}/offers
packages/{id}/room-types
segments/{id}
hotels/{id}
```

جزء من البيانات متاح عبر `GET /app/trips/{id}` (`hotels[]`, `itinerary[]`, `staff[]`, `packages[]`)، لكن:
- فقط لرحلة **محجوزة مسبقاً** للمعتمر — لا توجد نسخة عامة للتصفّح.
- لا توجد صور للفنادق، ولا شاشة تفاصيل فندق، ولا بحث/فرز.

### الحجز

- `bookings/summary` ❌ غير موجود
- `bookings/documents` ❌ غير موجود

### المصادقة

- `auth/refresh` ❌ — مسار إعادة المحاولة في الـ interceptor بلا هدف
- `auth/logout` ❌
- `auth/forgot-password` ❌ — زر "هل نسيت كلمة المرور ؟" بلا مسار

---

## 3. اختلافات بنيوية (الأهم والأكثر كلفة) ⚠️

### أ) `POST /app/bookings` يتبع نموذج حجز مختلف تماماً

```jsonc
// ما يتوقعه الـ API
{ "trip_id": 1, "rooms": [ { "package_id": 1, "locked_beds_count": 0,
                             "pilgrims": [ { "pilgrim_id": 1 } ] } ] }

// ما يرسله BookingCubit._selection()
{ "package_id": …, "booking_type": …, "route_id": …, "room_type_id": …,
  "hotels": { "makkah": …, "madinah": … }, "passport": { … } }
```

الـ API يحجز **معرّفات معتمرين موجودين داخل غرف**، بينما المعالج (wizard) يحجز **جواز سفر + اختيارات**.
بالشكل الحالي `submit()` سيفشل في التحقق (validation).
**المطلوب:** إنشاء المعتمرين أولاً عبر `POST /app/pilgrims` (multipart) وحمل المعرّفات الراجعة.

### ب) لا يوجد مفهوم "مسار" (route) في الـ API

شاشتا `Selecting_route.png` و `trip_offers.png` تعرضان مسارات بديلة (المسار الأول / الثاني، الجوي / البري) يختار منها المستخدم وتُسعَّر العروض على أساسها.

- الـ API يقدّم `itinerary[]` واحدة مسطّحة لكل رحلة مع `sequence_order`.
- `TripPackageResource` **بلا حقل مسار**.
- `POST /app/bookings` **بلا `route_id`**.

هذه فجوة في **نموذج البيانات** وليست مجرد مسار ناقص.

### ج) اختيار الفندق غير قابل للحجز

شاشتا `Choosing_hotel_in_Makkah / Madinah` تتيحان اختيار فندق واحد لكل مدينة.
`TripHotelResource` قائمة للقراءة فقط مع `is_default`، **بلا صورة**، و `POST /app/bookings` **لا يقبل أي اختيار فندق**.

### د) جدول الدفعات غير موجود

`Payment_Summary.png` يحتاج جدول أقساط (دفعة #1 بنسبة 30% خلال 24 ساعة، #2 بنسبة 70% …).
`BookingResource` يوفّر فقط: `status` و `total_amount` و `draft_expires_at`.
`POST /app/financial-transactions` يسجّل دفعة لكن لا يُنشَر أي جدول أقساط.

### هـ) `POST /app/pilgrim-documents` يحتاج `document_type_id` رقمي

التطبيق يرسل الـ slug الخاص بالتصميم (`passport`، `photo` …)، و**لا يوجد مسار lookup لأنواع المستندات** للترجمة بينهما. الملاحظة موجودة أصلاً في تعليق داخل `RegisterCubit._uploadDocuments()`.

### و) حقول زائدة في `auth/register`

التطبيق يرسل `full_name_ar` و `full_name_en` و `issue_place` و `issue_date` (تجمعها شاشات الجواز) وهي غير مذكورة في مثال التوثيق.
ملاحظة: مخطط `register` هو `{"properties": {}}` مع مثال فقط، أي **غير قابل للتحقق**. في المقابل `POST /app/pilgrims` يقبل `passport_issue_date` و `passport_issue_place`.

### ز) لا توجد معاملات استعلام (query params) في أي `GET`

كل عمليات الـ GET تعرّف رؤوساً فقط (`Accept-Language`, `Accept`, `Content-Type`) — بلا `page` / `per_page` / `search` / `sort` / `filter`.
هذا يكسر: تقسيم صفحات العروض في الرئيسية، وبحث وفرز الفنادق، وحتى `?before_id=` المذكور في وصف محادثة الرحلة دون تعريفه كمعامل.

---

## 4. مسارات في الـ API بلا شاشات ولا تنفيذ

حوالي **25 مساراً** بلا تصميم وبلا كود:

- بلاغات الاستغاثة `sos-events`
- النطاقات الجغرافية `trip-geofences` + `breaches`
- نبضات الموقع `location-pings`
- بطاقات الحقائب `luggage-tags`
- المفقودات `lost-items`
- الإشعارات `notifications`
- توزيع الغرف `room-assignments`
- التذاكر `pilgrim-tickets` وبطاقة الصعود `boarding-pass`
- بطاقة المعتمر `id-card` (+ PDF + النسخة العامة)
- التأشيرات `visas`
- حضور وتقييم الأنشطة `attendance` / `feedback`
- طلبات تعديل الحجز `booking-change-requests`
- طرق الدفع `payment-methods` والمعاملات المالية `financial-transactions`
- محادثة الرحلة `trip-chat`

المحادثة والأنشطة موجودتان في `SCREENS/`، أما البقية فبلا شاشات وبلا كود — أي أن **النصف التشغيلي من المنتج معرّف في الـ API وغير معرّف في التصاميم**.

---

## 5. التوصيات

1. **قرار أساسي مطلوب:** إمّا أن يضيف الباك إند طبقة التصفّح والتسعير، أو يُعاد بناء معالج الحجز حول `pilgrims → rooms → trip_id`.
2. **المطلوب من الباك إند (أولوية عالية):**
   - محتوى الرئيسية: التصنيفات، العروض بأسعارها وصورها، الخدمات.
   - كيان باقة/عرض قابل للتصفّح قبل الحجز (بدون اشتراط حجز مسبق).
   - مفهوم "المسار" وربطه بالباقة والحجز (`route_id`).
   - ملخص حجز مسعّر + جدول أقساط.
   - `document-types` lookup.
   - `auth/refresh` و `auth/logout` و `auth/forgot-password`.
   - معاملات الصفحات والبحث والفرز في قوائم الـ GET.
   - إضافة `servers` إلى التوثيق، وتعبئة مخطط `register` بدل المثال المجرّد.
3. **المطلوب من التطبيق:**
   - إعادة توجيه `BookingCubit._selection()` إلى عقد `trip_id` + `rooms[]`.
   - إنشاء المعتمرين عبر `POST /app/pilgrims` قبل `POST /app/bookings`.
   - تنفيذ مسار الحجز الجماعي (مدعوم بالكامل من الـ API حالياً).
   - ربط شاشات التبويبات المعلّقة: رحلاتي، الخريطة، حسابي، الإعدادات (كلها `ComingSoonView` الآن).
