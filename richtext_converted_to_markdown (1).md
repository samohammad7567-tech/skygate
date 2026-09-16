دليل تتبّع الموقع والدردشة في تطبيق المعتمر
===========================================

0\. الخلاصة السريعة
-------------------

السؤالالجوابمتى يعمل التتبّع؟فقط عندما تكون الحالة started بالضبطمتى تعمل الدردشة؟في started **و** almost-doneهل أُرسل trip\_id؟**لا.** السيرفر يعرف رحلتك من التوكنكل كم ثانية أُرسل الموقع؟كل **60 ثانية** (الحد الأقصى المسموح 3 دقائق)كيف أرى موقع القائد؟قناة private-trip.{id}.leaderهل أرى مواقع بقية الحجاج؟**لا.** ممنوع تماماً — للقائد والإدارة فقطأين أجد trip\_id للقنوات؟من GET /bookings (حقل trip.id)من أين آتي بالمنطقة الآمنة؟GET /trip-safe-areaمن أين آتي بموقعي أنا؟من geolocator محلياً — **لا** من السيرفر

1\. الصورة الكبيرة
------------------

هناك جزءان يعملان معاً:
                `┌─────────────────────────┐   كل 60 ثانية      │                         │  ───────────────►  │   POST /location-pings  │   (إرسال موقعي)    │                         │                    └───────────┬─────────────┘                                │                    السيرفر يقوم بـ 3 أشياء:                                │              ┌─────────────────┼─────────────────┐              ▼                 ▼                 ▼      يحفظ النبضة      يتحقق: هل خرجت    يبثّ الموقع على       في القاعدة       من المنطقة        القنوات الحيّة                         الآمنة؟                                │                                ▼                    إن خرجت: إشعار Push لك                    + تنبيه للقائد والإدارة`

والدردشة جزء منفصل لكنه **يُفتح ويُغلق في نفس اللحظة** التي يُفتح فيها التتبّع: الرحلة تبدأ ← الدردشة تُفتح والتتبّع يُسمح به. الرحلة تنتهي ← الاثنان يختفيان.

2\. قبل أن تبدأ: المصادقة
-------------------------

### الحصول على التوكن

`   POST /api/v1/auth/login   `

تحصل على **توكن Sanctum**. احفظه في flutter\_secure\_storage (ليس في SharedPreferences — التوكن بيانات حسّاسة).

### الهيدرز المطلوبة في كل طلب

`   final headers = {  'Authorization': 'Bearer $token',  'Accept': 'application/json',   // ⚠️ إجباري — اقرأ التحذير أدناه  'Content-Type': 'application/json',};   `

> ### ⚠️ تحذير مهم جداً: لا تنسَ Accept: application/json
> 
> إذا نسيته وكان التوكن منتهياً، لن يرجع السيرفر 401 بل 500 مع صفحة HTML، لأن Laravel سيحاول تحويلك إلى صفحة تسجيل دخول غير موجودة. هذا أشهر سبب لإهدار ساعات في التنقيب عن خطأ غير موجود.

### شكل الردود

كل الردود لها نفس الغلاف:**نجاح:**

`   { "data": { ... }, "message": "Success", "status_code": 1 }   `

**فشل:**

`   { "message": "الرسالة", "status_code": 0, "errors": { "latitude": ["..."] } }   `

> لاحظ: status\_code هنا **ليس** كود HTTP. اعتمد على كود HTTP الحقيقي (response.statusCode) في منطق الكود، واستخدم message لعرضه للمستخدم.

3\. الشرط الذهبي: الرحلة يجب أن تكون started
--------------------------------------------

هذه أهم فكرة في الدليل كله.الحاج قد يملك حجزاً مؤكداً لرحلة، لكن هذا **لا يكفي**. يجب أن يكون مشرف الرحلة قد غيّر حالة الرحلة من لوحة الإدارة. حالات الرحلة الثماني هي:

`   draft → published → registration_closed → in-process      → started → almost-done → completed      (أو cancelled في أي وقت)   `

### ⚠️ الميزتان لا تُفتحان وتُغلقان في نفس اللحظة

هذه أهم نقطة تقنية في الدليل، وأكثر ما يُربك المطوّر الجديد:الحالةنبضات الموقعالقنوات الحيّة للموقعالدردشةstarted✅ تعمل✅ تعمل✅ مفتوحةalmost-done❌ **400**❌ **مرفوضة**✅ **ما زالت مفتوحة**completed / cancelled❌ 400❌ مرفوضة❌ 404أي حالة قبل started❌ 400❌ مرفوضة❌ 404السبب: التتبّع يتحقّق من status = 'started' **حرفياً**، أما الدردشة فتُفتح عند started ولا تُغلق إلا عند completed أو cancelled — فالرحلة في almost-done لا تزال قائمة والناس بحاجة للتواصل.**النتيجة العملية:** لا تستخدم نجاح GET /trip-chat بوابةً للميزتين معاً. في مرحلة almost-done ستحصل على دردشة تعمل (200) مع نبضات ترجع 400، وستظنّ أن هناك خطأ في كودك وليس كذلك.

### الطريقة الصحيحة

اقرأ حالة الرحلة صراحةً. أسهل مصدر هو GET /api/v1/app/bookings — كل حجز يحتوي كائن trip مضمّناً مع id وstatus:

`   // GET /api/v1/app/bookings  ⇒  data.items[].trip.statusfinal status = booking['trip']['status'];final tripId = booking['trip']['id'];final canSendLocation = status == 'started';                       // التتبّعfinal canChat = status == 'started' || status == 'almost-done';    // الدردشة   `

ثم:

*   canChat == true ⇒ نادِ GET /trip-chat لجلب unread\_count، واشترك في قناة الدردشة
    
*   canSendLocation == true ⇒ شغّل مؤقّت النبضات، واشترك في قناة موقع القائد
    

> يمكنك أيضاً GET /api/v1/app/trips/{trip\_id} — فهو يعمل للحاج المسجَّل على الرحلة في كل الحالات، ويرجع status كاملاً مع الفنادق والبرنامج.

وفي كل الأحوال: **عالج 400 و404 بهدوء** كما في الخطوة 4، فحالة الرحلة قد تتغيّر أثناء عمل التطبيق دون أن يعيد المستخدم فتحه.

4\. إرسال نبضة الموقع
---------------------

`   POST /api/v1/app/location-pings   `

**الجسم (Body):**الحقلالنوعإجباريالمدىlatitudeرقم✅من -90 إلى 90longitudeرقم✅من -180 إلى 180**هذا كل شيء.** لا trip\_id، ولا pilgrim\_id، ولا وقت. السيرفر يستنتج كل ذلك من التوكن ويسجّل الوقت بنفسه.

`   { "latitude": 21.4225, "longitude": 39.8262 }   `

**الرد الناجح — 201:**

`   {  "data": {    "id": 1042,    "pilgrim_id": 7,    "trip_id": 2,    "latitude": 21.4225,    "longitude": 39.8262,    "recorded_at": "2026-09-14 08:31:05"  },  "message": "Location ping stored.",  "status_code": 1}   `

**حالات الفشل:**الكودالمعنىماذا تفعل؟400You must be on an active (started) trip...أوقف المؤقّت. الرحلة لم تبدأ أو انتهت422إحداثيات غير صالحةراجع القيم — الغالب أنك أرسلت null أو نصاً401التوكن غير صالحأعِد تسجيل الدخول

> **مهم:** عند 400 **أوقف المؤقّت فوراً**. لا تستمر بالإرسال كل دقيقة — فذلك يستهلك بطارية المستخدم وباقة بياناته دون أي فائدة.

4.1 جلب المنطقة الآمنة (للحاج)
------------------------------

`   GET /api/v1/app/trip-safe-area   `

بلا معاملات. يرجع **المناطق النشطة فقط** على رحلتك الحالية:

`   {  "data": {    "items": [      {        "id": 1,        "trip_id": 2,        "name": "الحرم ومجمع الفنادق",        "latitude": 21.4224779,        "longitude": 39.8251832,        "radius_meters": 800,        "is_active": true,        "created_at": "2026-08-23 02:04:02"      }    ]  },  "status_code": 1}   `

### ثلاث نقاط لا تُفوّتها

**١. قد تكون هناك أكثر من منطقة واحدة.** الحقل مصفوفة، وليس كائناً واحداً. القائد قد يرسم دائرة للحرم وأخرى للفندق. **ارسمها كلها** — لا تأخذ items\[0\] فقط.**٢. المناطق المعطّلة مخفيّة عنك.** السيرفر يرجع is\_active = true فقط، لأن الدائرة المعطّلة سجلّ تاريخي لا حدود فعلية — ولو رسمتها لأظهرت للحاج خطاً لا يُنبّه أحد عند تجاوزه.**٣. لا يوجد بثّ عند تغيير المنطقة.** إذا حرّك القائد الدائرة، **لن يصلك أي حدث ويب-سوكت**. الأحداث الثلاثة الموجودة في السيرفر هي الرسائل والمواقع فقط. لذلك:

`   // أعد الجلب كل 3 دقائق، أو عند عودة التطبيق للمقدّمة// (الأرخص: كل 3 دورات من مؤقّت النبضات)if (_tickCount % 3 == 0) await _refreshSafeZones();   `

**الفشل:** 400 إن لم تكن على رحلة started — نفس شرط النبضات بالضبط.

> **ملاحظة:** لا تنادِ GET /trip-geofences — هذا مسار القائد للتعديل، وسيرجع لك **403**. مسارك أنت هو /trip-safe-area للقراءة فقط.

5\. كم مرة أُرسل الموقع؟
------------------------

**أرسل كل 60 ثانية.**السبب: في السيرفر إعداد اسمه umrah.gps\_ping\_timeout\_minutes وقيمته الحالية **3 دقائق**. وهناك مهمة مجدولة تعمل **كل دقيقة** تبحث عن الحجاج الذين لم يرسلوا موقعهم منذ أكثر من 3 دقائق، وترفع تنبيه **«فقدان إشارة»** للقائد والإدارة.إذن:

*   أرسلت كل 60 ثانية → ✅ ممتاز، هامش أمان ثلاثة أضعاف
    
*   أرسلت كل 4 دقائق → ❌ القائد سيتلقى تنبيهاً أن الحاج «مفقود» وهو بخير
    

**لا تُرسل كل 5 ثوانٍ.** لن يشكرك أحد على استنزاف البطارية، والإدارة تحتاج موقعاً تقريبياً لا مساراً بدقّة المتر.

### أذونات الموقع في Flutter

`   // pubspec.yaml: geolocator, permission_handler// Android: ACCESS_FINE_LOCATION + ACCESS_BACKGROUND_LOCATION (إن أردت التتبع بالخلفية)// iOS: NSLocationWhenInUseUsageDescription + NSLocationAlwaysAndWhenInUseUsageDescription   `

اشرح للمستخدم **لماذا** تطلب الإذن قبل أن تطلبه («لكي يستطيع مشرف الرحلة الاطمئنان عليك»). نسبة القبول ترتفع كثيراً، ورفض الإذن على iOS يصعب التراجع عنه.

6\. ماذا يفعل السيرفر بكل نبضة؟
-------------------------------

مفيد أن تفهم هذا لتعرف ما تتوقّعه:

1.  **يحفظ** النبضة في جدول location\_pings.
    
2.  **يحدّد** هل هي من قائد الرحلة أم من حاج عادي (هذا يُحدّد من يراها).
    
3.  **يتحقّق من المنطقة الآمنة**: هل الحاج داخل الدائرة التي رسمها القائد؟
    
    *   إن خرج: إشعار Push للحاج نفسه **مع رقم هاتف القائد**، وتنبيه للقائد والإدارة.
        
4.  **يبثّ** الموقع على القنوات الحيّة.
    

> الخطوة 3 تحدث **قبل** البث، بشكل مقصود: لو تعطّل سيرفر الويب-سوكت، يجب أن يبقى إنذار الخروج من المنطقة الآمنة يعمل.

> **لتصل إشعارات Push فعلاً** لا بدّ أن يكون التطبيق قد أرسل توكن FCM عبر POST /api/v1/auth/update-fcm-token. بدونه لن يُرسل الخادم أي Push للحاج، ولن يظهر أي خطأ — سيكون الصمت هو النتيجة.

7\. الدردشة الجماعية (REST)
---------------------------

دردشة واحدة لكل رحلة، تجمع كل حجاج الرحلة مع الموظفين. مجدداً: **بلا** trip\_id — السيرفر يعرف رحلتك من التوكن.

### أ) بيانات الدردشة والعدّاد

`   GET /api/v1/app/trip-chat   `

`   {  "data": {    "id": 3,    "trip_id": 2,    "status": "open",    "opened_at": "2026-09-10 06:00:00",    "participants_count": 18,    "unread_count": 4,    "last_read_at": "2026-09-14 07:55:00"  },  "status_code": 1}   `

استخدم unread\_count للشارة الحمراء، وtrip\_id لبناء اسم القناة.

### ب) سجلّ الرسائل

`   GET /api/v1/app/trip-chat/messages?limit=50&before_id=120   `

المعاملالافتراضيملاحظاتlimit50يُحصر بين 1 و100before\_id—للتحميل للأعلى (الرسائل الأقدم)**الترتيب: من الأقدم إلى الأحدث** — أي أن آخر عنصر في المصفوفة هو أحدث رسالة.الـ meta يحتوي:

*   next\_before\_id: مرّره في الطلب التالي لجلب صفحة أقدم
    
*   has\_more: هل بقي المزيد؟
    

**شكل الرسالة:**

`   {  "id": 121,  "trip_chat_id": 3,  "sender_pilgrim_id": 7,  "sender_user_id": null,  "sender_name": "أحمد المصري",  "is_mine": true,  "body": "أنا عند باب الملك فهد",  "attachment_url": null,  "sent_at": "2026-09-14 08:20:11"}   `

*   sender\_pilgrim\_id مملوء ⇒ المُرسل **حاج**
    
*   sender\_user\_id مملوء ⇒ المُرسل **موظف/إدارة**
    
*   is\_mine ⇒ استخدمه لمحاذاة الفقاعة يميناً أو يساراً
    

### ج) إرسال رسالة

`   POST /api/v1/app/trip-chat/messages   `

الحقلإجباريالحدbody✅5000 حرفattachment\_url❌255 حرفيرجع **201** مع الرسالة المحفوظة.

### د) تصفير العدّاد

`   POST /api/v1/app/trip-chat/read   `

بلا جسم إطلاقاً. نادِه عندما يفتح المستخدم شاشة الدردشة فعلاً.

8\. الزمن الحقيقي (Reverb)
--------------------------

السيرفر يستخدم **Laravel Reverb**، وهو متوافق مع بروتوكول Pusher — لذا تستطيع استخدام حزمة pusher\_channels\_flutter مباشرة.

### إعدادات الاتصال

اطلب من فريق الباك-إند قيم: REVERB\_APP\_KEY وREVERB\_HOST وREVERB\_PORT وREVERB\_SCHEME.

### نقطة التصريح (Auth Endpoint)

`   POST /broadcasting/auth   `

وتحتاج إرسال **نفس هيدر التوكن** معها:

`   authEndpoint: 'https:///broadcasting/auth',onAuthorizer: (channelName, socketId, options) async {  // أرسل Authorization: Bearer $token هنا}   `

> إن نسيت التوكن في نقطة التصريح، سيفشل الاشتراك **بصمت** ولن تصل أي رسالة، دون أي خطأ ظاهر في الواجهة.

### ⚠️ البادئات (private- و presence-)

في كود Laravel أسماء القنوات مكتوبة بدون بادئة، لكن بروتوكول Pusher **يشترط** البادئة. عند استخدام pusher\_channels\_flutter مباشرة اكتب الاسم كاملاً:في الباك-إندما تكتبه في Fluttertrip.{trip}.chatpresence-trip.2.chattrip.{trip}.leaderprivate-trip.2.leadertrip.{trip}.locationsprivate-trip.2.locationsنسيان البادئة = لا رسائل، ولا رسالة خطأ. اعتبرها أول ما تتحقق منه عند الصمت.

9\. جدول القنوات والصلاحيات
---------------------------

القناةالنوعمَن يُسمح لهالحدثالمحتوىpresence-trip.{id}.chatPresenceكل حجاج الرحلة + الموظفونchat.messageالرسائل الجديدةprivate-trip.{id}.leaderPrivateكل المسافرين على الرحلةlocation.updatedموقع **القائد فقط**private-trip.{id}.locationsPrivate**القائد والإدارة فقط**location.updatedمواقع **كل** الحجاج

> ### لماذا قناتان للمواقع؟
> 
> لأن أي مشترك في قناة يستلم **كل** ما يُنشر فيها. لو كانت قناة واحدة وفلترنا في التطبيق، لكانت إحداثيات كل حاج قد وصلت فعلاً إلى هاتف كل حاج آخر. الفصل على مستوى القناة هو الطريقة الوحيدة الآمنة.**إذن: تطبيق الحاج العادي يشترك في** leader **فقط. لا تحاول الاشتراك في** locations **— سيُرفض، وهذا هو السلوك الصحيح.**

> **ولاحظ:** لا توجد قناة للمنطقة الآمنة. الأحداث الثلاثة في السيرفر هي الرسائل والمواقع فقط، فالمنطقة تُجلب بـ REST من /trip-safe-area وتُحدَّث بإعادة الجلب.

### حدث location.updated

`   {  "pilgrim_id": 7,  "trip_id": 2,  "latitude": 21.4225,  "longitude": 39.8262,  "is_leader": true,  "is_outside_geofence": false,  "distance_meters": null,  "recorded_at": "2026-09-14T08:31:05+00:00"}   `

استخدم is\_outside\_geofence لتلوين المؤشّر (أحمر عند الخروج).

### حدث chat.message

`   {  "id": 121,  "trip_chat_id": 3,  "trip_id": 2,  "sender_pilgrim_id": 7,  "sender_user_id": null,  "sender_name": "أحمد المصري",  "body": "أنا عند باب الملك فهد",  "attachment_url": null,  "sent_at": "2026-09-14T08:20:11+00:00"}   `

> ### ⚠️ فرق جوهري بين REST والويب-سوكت
> 
> رسالة الويب-سوكت **لا تحتوي** is\_mine، بخلاف رد REST. لذا احفظ pilgrim\_id الخاص بك (من GET /trip-chat/messages أو من الملف الشخصي) وقارنه بـ sender\_pilgrim\_id بنفسك.كذلك صيغة التاريخ مختلفة: REST يرجع 2026-09-14 08:20:11 والويب-سوكت يرجع ISO-8601. استخدم DateTime.parse() — يتعامل مع الصيغتين.

10\. الويب-سوكت في Flutter — بالتفصيل
-------------------------------------

> الأكواد **توضيحية** لبيان التسلسل، ولم تُجرَّب على جهاز. أما تفاصيل الـ API (المسارات، الحقول، أسماء القنوات والأحداث) فمستخرجة من كود السيرفر ومُتحقَّق منها.

### أ) ما الفرق أصلاً عن REST؟

في REST **أنت تسأل** والسيرفر يجيب. في الويب-سوكت يبقى اتصال واحد مفتوحاً، و**السيرفر يدفع** إليك متى شاء.لذلك القاعدة الذهبية:الحاجةالأداةالسجلّ، الحالة الأولى، أي شيء عند فتح الشاشة**REST**التحديثات اللاحقة بعد أن تصبح الشاشة مفتوحة**الويب-سوكتلا تبنِ شاشة على الويب-سوكت وحده.** عند الفتح لن يكون هناك شيء لتعرضه، لأن السوكت لا يُعيد إرسال ما فات. اجلب بـ REST أولاً، ثم استمع.

### ب) الحزمة والمكتبة

Reverb متوافق مع بروتوكول Pusher، فتستخدم:

`   dependencies:  pusher_channels_flutter: ^2.2.1   # أو أحدث  dio: ^5.4.0   `

### ج) دورة الحياة كاملة

`   init()          ← تُنفَّذ مرة واحدة: المفاتيح و callbacks   ↓connect()       ← يفتح الاتصال   ↓subscribe()     ← لكل قناة   ↓/broadcasting/auth  ← السيرفر يتحقق: هل يُسمح لك؟  (يحدث تلقائياً)   ↓onSubscriptionSucceeded   ← نجح الاشتراك ✅   ↓onEvent()       ← الرسائل تتدفّق الآن   ↓unsubscribe() + disconnect()   ← عند الخروج   `

### د) التهيئة الكاملة مع شرح كل callback

`   class RealtimeService {  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();  // من الباك-إند: REVERB_APP_KEY / HOST / PORT / SCHEME  static const _key    = 'xxxxxxxx';  static const _host   = 'api.example.com';  static const _port   = 443;  static const _useTLS = true;  final String token;  final int myPilgrimId;  String connectionState = 'DISCONNECTED';  RealtimeService({required this.token, required this.myPilgrimId});  Future init() async {    await _pusher.init(      apiKey: _key,      cluster: '',           // Reverb لا يستخدم clusters — اتركها فارغة      host: _host,      wsPort: _port,      wssPort: _port,      useTLS: _useTLS,      // ① حالة الاتصال — استخدمها لمؤشّر "متصل/يُعيد المحاولة" في الواجهة      onConnectionStateChange: (current, previous) {        connectionState = current ?? 'UNKNOWN';        // CONNECTING / CONNECTED / DISCONNECTED / RECONNECTING / UNAVAILABLE        if (current == 'CONNECTED') _onReconnected();      },      // ② أخطاء الاتصال العامة — سجّلها، لا تُخفِها      onError: (message, code, error) {        debugPrint('Pusher error [$code]: $message');      },      // ③ نجاح الاشتراك — هنا تعرف أن القناة فُتحت فعلاً      onSubscriptionSucceeded: (channelName, data) {        debugPrint('✅ subscribed: $channelName');      },      // ④ فشل الاشتراك — أهم callback للتشخيص، لا تتركه فارغاً أبداً      onSubscriptionError: (message, error) {        debugPrint('❌ subscription failed: $message');        // الأسباب الأشهر: نسيان البادئة، أو التوكن غير مُرسل في onAuthorizer،        // أو الرحلة ليست started فرفض السيرفر القناة.      },      // ⑤ الرسائل الفعلية      onEvent: _handleEvent,      // ⑥ قناة الحضور: من دخل ومن خرج      onMemberAdded:   (channelName, member) => debugPrint('انضم: ${member.userInfo}'),      onMemberRemoved: (channelName, member) => debugPrint('خرج: ${member.userInfo}'),      // ⑦ التصريح — بوّابتك إلى القنوات الخاصة      onAuthorizer: _authorize,    );    await _pusher.connect();  }}   `

> **⚠️ لا تترك** onSubscriptionError **فارغاً.** فشل الاشتراك في هذا النظام **صامت تماماً**: لن ترى استثناءً ولا شاشة حمراء — فقط لا تصل رسائل. هذا الـ callback هو نافذتك الوحيدة.

### هـ) التصريح (onAuthorizer) — اقرأه بتمعّن

عند كل subscribe على قناة private- أو presence-، تسأل المكتبة السيرفر: «هل يُسمح لهذا المستخدم بهذه القناة؟». وأنت من يبني هذا الطلب:

`   Future> _authorize(  String channelName, String socketId, dynamic options,) async {  final res = await Dio().post(    'https://$_host/broadcasting/auth',    data: {      'socket_id': socketId,        // من المكتبة      'channel_name': channelName,  // مع البادئة كاملة    },    options: Options(headers: {      'Authorization': 'Bearer $token',   // ⚠️ بدونه: 401 ⇒ فشل صامت      'Accept': 'application/json',    }),  );  // أعِد جسم الرد كما هو — يحتوي auth (وchannel_data لقنوات الحضور)  return Map.from(res.data);}   `

**ما يحدث في السيرفر:** يقرأ التوكن، يعرف من أنت، ثم يطبّق قاعدة القناة: هل أنت على هذه الرحلة؟ هل هي started؟ هل أنت القائد (لقناة locations)؟ إن رفض، يرجع 403 ويفشل الاشتراك.

### و) الاشتراك والاستماع

`   Future subscribeTo(int tripId, {required bool canSendLocation}) async {  // الدردشة: قناة حضور  await _pusher.subscribe(channelName: 'presence-trip.$tripId.chat');  // موقع القائد: قناة خاصة — للتتبّع فقط  if (canSendLocation) {    await _pusher.subscribe(channelName: 'private-trip.$tripId.leader');  }  // ❌ لا تشترك في private-trip.$tripId.locations — للقائد والإدارة فقط}void _handleEvent(PusherEvent event) {  // event.data نصّ JSON، لا كائن — يجب فكّه  final data = jsonDecode(event.data ?? '{}') as Map;  switch (event.eventName) {    case 'chat.message':      final isMine = data['sender_pilgrim_id'] == myPilgrimId;      // أضف الرسالة للقائمة (بعد التحقق من عدم تكرار الـ id)      break;    case 'location.updated':      if (data['is_leader'] == true) {        // حرّك علامة القائد على الخريطة      }      break;  }}   `

> **صيغة أسماء الأحداث:** إن استخدمت laravel\_echo اكتب .chat.message **بنقطة في البداية**. وإن استخدمت pusher\_channels\_flutter مباشرة (كما هنا) اكتب chat.message **بلا نقطة**. النقطة في Echo تعني «لا تُضِف namespace».

### ز) قناة الحضور: من معي في الرحلة؟

قناة الدردشة من نوع **presence**، أي أنها تعطيك قائمة الأعضاء مجاناً — بلا أي طلب إضافي. السيرفر يُرسل لكل عضو:

`   { "id": 7, "name": "أحمد المصري", "type": "pilgrim" }   `

type يكون pilgrim أو staff — استخدمه لتمييز الموظفين بشارة في قائمة الأعضاء.

`   // بعد نجاح الاشتراكfinal channel = _pusher.getChannel('presence-trip.$tripId.chat');final members = channel?.members;   // القائمة الحالية// والتغييرات لاحقاً عبر onMemberAdded / onMemberRemoved   `

### ح) إعادة الاتصال — والمصيدة الكبرى

المكتبة **تُعيد الاتصال تلقائياً** عند انقطاع الشبكة. لا تكتب منطق إعادة اتصال يدوياً.لكن هذه هي المصيدة التي يقع فيها معظم المتدرّبين:

> **السوكت لا يُعيد إرسال ما فات.** الرسائل التي وصلت أثناء انقطاعك **ضائعة إلى الأبد** من ناحية السوكت. إذا لم تفعل شيئاً، سيرى المستخدم فراغاً في المحادثة.

الحل: عند كل عودة للاتصال، أعد جلب آخر صفحة بـ REST واندمجها:

`   Future _onReconnected() async {  // لا يوجد معامل after_id في الـ API — اجلب آخر صفحة وادمج بالـ id  final res = await _dio.get('/api/v1/app/trip-chat/messages',      queryParameters: {'limit': 50});  final fetched = res.data['data']['items'] as List;  for (final m in fetched) {    if (!_messageIds.contains(m['id'])) {   // منع التكرار      _messageIds.add(m['id']);      _messages.add(m);    }  }  _messages.sort((a, b) => a['id'].compareTo(b['id']));  notifyListeners();}   `

> **لماذا الدمج بالـ** id**؟** لأن رسالة قد تصل مرّتين: مرّة من السوكت ومرّة من إعادة الجلب. الـ id هو الحقل الوحيد المضمون التفرّد. لا تعتمد على sent\_at — رسالتان في نفس الثانية ممكنتان تماماً.

### ط) التنظيف عند الخروج

`   Future dispose() async {  await _pusher.unsubscribe(channelName: 'presence-trip.$_tripId.chat');  await _pusher.unsubscribe(channelName: 'private-trip.$_tripId.leader');  await _pusher.disconnect();}   `

نادِها عند تسجيل الخروج وعند انتهاء الرحلة. اتصال مفتوح ومنسيّ يستهلك بطارية بلا أي فائدة.

### ي) تشخيص «لا تصل أي رسالة»

مرّ على هذه بالترتيب — تسعة من عشرة أسباب في أول ثلاث نقاط:

1.  **البادئة**: هل كتبت presence- / private-؟
    
2.  **التوكن في** onAuthorizer: اطبع الرد — هل هو 403؟
    
3.  onSubscriptionError: هل هو فارغ؟ املأه واقرأ الرسالة.
    
4.  **حالة الرحلة**: هل هي started بالضبط؟ في almost-done تُرفض قنوات الموقع.
    
5.  **اسم الحدث**: chat.message بلا نقطة مع Pusher، وبنقطة مع Echo.
    
6.  jsonDecode: event.data نصّ لا كائن.
    
7.  **Reverb يعمل؟** اسأل الباك-إند: هل خدمة reverb:start قائمة على السيرفر؟
    

11\. الخريطة: geolocator + Google Maps
--------------------------------------

التطبيق يستخدم geolocator وgoogle\_maps\_flutter أصلاً، فهذه الشاشة تركيب لما لديك مع البيانات الثلاثة.

### أ) المصادر الثلاثة — والأهم: أصل كل واحد

هذا الجدول هو خلاصة القسم كله:ما يُرسممن أين يأتيالتحديث🔵 **موقعي أنا**geolocator **محلياً على الجهاز**فوري ومستمر⭐ **موقع القائد**حدث location.updated من السوكتكل ~60 ثانية⭕ **المنطقة الآمنة**GET /trip-safe-areaإعادة جلب دورية

> ### ⚠️ أشهر خطأ في هذه الشاشة
> 
> انتظار عودة موقعك أنت من السيرفر. **لن يعود أبداً.** النبضة التي ترسلها تُبثّ إلى القائد والإدارة، **وليس إليك**. قناة leader تحمل موقع القائد فقط، وقناة locations مرفوضة عليك.**موقعك يأتي من** geolocator **مباشرة.** إرسال النبضة وعرض موقعك عمليتان مستقلّتان تماماً: الأولى للإدارة، والثانية لك.

### ب) رسم المنطقة الآمنة

`   Set _buildSafeZones(List zones) {  return zones.map((z) => Circle(    circleId: CircleId('zone_${z['id']}'),    center: LatLng(z['latitude'], z['longitude']),    radius: (z['radius_meters'] as num).toDouble(),   // Circle يتوقّع أمتاراً    fillColor: Colors.green.withOpacity(0.12),    strokeColor: Colors.green.shade700,    strokeWidth: 2,  )).toSet();}   `

تذكّر: **مصفوفة** — قد تكون أكثر من دائرة.

### ج) موقعي أنا

أبسط حلّ وأفضله: اترك الخريطة ترسم النقطة الزرقاء الأصلية.

`   GoogleMap(  myLocationEnabled: true,        // النقطة الزرقاء الأصلية — مجاناً  myLocationButtonEnabled: true,  // ...)   `

وإن احتجت الإحداثيات في الكود (للحساب أو لإرسال النبضة):

`   _positionSub = Geolocator.getPositionStream(  locationSettings: const LocationSettings(    accuracy: LocationAccuracy.high,    distanceFilter: 10,     // لا تُحدّث إلا بعد 10 أمتار — يوفّر بطارية كثيراً  ),).listen((pos) {  _myPosition = LatLng(pos.latitude, pos.longitude);  _checkIfOutsideLocally();  setState(() {});});   `

> distanceFilter هو أهم سطر للبطارية في الشاشة كلها. بدونه تحصل على تحديث كل ثانية وأنت واقف مكانك.

### د) موقع القائد

`   void _onLeaderMoved(Map data) {  setState(() {    _leaderPosition = LatLng(data['latitude'], data['longitude']);    _leaderOutside  = data['is_outside_geofence'] == true;  });}Marker get _leaderMarker => Marker(  markerId: const MarkerId('leader'),  position: _leaderPosition!,  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),  infoWindow: const InfoWindow(title: 'مشرف الرحلة'),  zIndex: 2,     // فوق كل شيء آخر);   `

> **قبل وصول أول نبضة من القائد،** \_leaderPosition **تكون** null**.** لا تضع علامة على (0,0) — ستظهر في المحيط الأطلسي. أظهر نصاً هادئاً: «جارٍ تحديد موقع المشرف…». وقد لا يصل شيء إن كان هاتف القائد مغلقاً.

### هـ) تحذير فوري: هل أنا خارج المنطقة؟

السيرفر هو المرجع وهو من يُرسل الإشعار، لكن يمكنك تحذير المستخدم **فوراً** دون انتظار دورة النبضة — بحساب محلي بسيط:

`   void _checkIfOutsideLocally() {  if (_myPosition == null || _safeZones.isEmpty) return;  // داخل المنطقة = داخل أي دائرة نشطة واحدة على الأقل  final inside = _safeZones.any((z) {    final meters = Geolocator.distanceBetween(      _myPosition!.latitude, _myPosition!.longitude,      z['latitude'], z['longitude'],    );    return meters <= (z['radius_meters'] as num);  });  setState(() => _iAmOutside = !inside);}   `

> **هذا للواجهة فقط.** لا تبنِ عليه منطق إنذار ولا ترسل تنبيهات بناءً عليه — السيرفر هو صاحب القرار، وهو من يُخبر القائد والإدارة. حسابك المحلي مجرد لُطف بالمستخدم: يُلوّن الشريط أحمر قبل أن يصل الإشعار.

### و) ضبط الكاميرا

`   Future _fitEverything() async {  final points = [    if (_myPosition != null) _myPosition!,    if (_leaderPosition != null) _leaderPosition!,    for (final z in _safeZones) LatLng(z['latitude'], z['longitude']),  ];  if (points.isEmpty) return;  if (points.length == 1) {    await _controller.animateCamera(CameraUpdate.newLatLngZoom(points.first, 16));    return;  }  final bounds = LatLngBounds(    southwest: LatLng(      points.map((p) => p.latitude).reduce(min),      points.map((p) => p.longitude).reduce(min),    ),    northeast: LatLng(      points.map((p) => p.latitude).reduce(max),      points.map((p) => p.longitude).reduce(max),    ),  );  await _controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));}   `

> نادِها **مرّة** عند فتح الشاشة، لا مع كل نبضة. تحريك الكاميرا كل دقيقة يمنع المستخدم من تصفّح الخريطة بيده، وهو سلوك مُزعج جداً. إن أردت متابعة القائد فاجعلها زراً يُشغّله المستخدم.

### ز) الشاشة مجمّعة

`   class TripMapScreen extends StatefulWidget { /* ... */ }class _TripMapScreenState extends State {  GoogleMapController? _controller;  StreamSubscription? _positionSub;  LatLng? _myPosition;  LatLng? _leaderPosition;  List _safeZones = [];  bool _iAmOutside = false;  bool _didFit = false;  @override  void initState() {    super.initState();    _boot();  }  Future _boot() async {    // ١. المنطقة الآمنة (REST) — قبل أي شيء، فهي أساس الرسم    await _refreshSafeZones();    // ٢. موقعي (محلي)    _positionSub = Geolocator.getPositionStream(      locationSettings: const LocationSettings(        accuracy: LocationAccuracy.high, distanceFilter: 10),    ).listen((pos) {      _myPosition = LatLng(pos.latitude, pos.longitude);      _checkIfOutsideLocally();      if (!_didFit) { _didFit = true; _fitEverything(); }      setState(() {});    });    // ٣. موقع القائد (سوكت) — RealtimeService من القسم 10    widget.realtime.onLeaderMoved = _onLeaderMoved;  }  Future _refreshSafeZones() async {    try {      final res = await widget.dio.get('/api/v1/app/trip-safe-area');      setState(() => _safeZones = res.data['data']['items']);      _checkIfOutsideLocally();    } on DioException catch (e) {      if (e.response?.statusCode == 400) {        // الرحلة لم تبدأ / انتهت: لا مناطق ولا خريطة        setState(() => _safeZones = []);      }    }  }  @override  void dispose() {    _positionSub?.cancel();      // ⚠️ تسريب هذا الـ stream يستنزف البطارية    _controller?.dispose();    super.dispose();  }  @override  Widget build(BuildContext context) {    return Stack(children: [      GoogleMap(        initialCameraPosition: const CameraPosition(          target: LatLng(21.4225, 39.8262), zoom: 14),   // الحرم كبداية        myLocationEnabled: true,        myLocationButtonEnabled: true,        circles: _buildSafeZones(_safeZones),        markers: {          if (_leaderPosition != null) _leaderMarker,        },        onMapCreated: (c) => _controller = c,      ),      if (_iAmOutside)        Positioned(          top: 0, left: 0, right: 0,          child: MaterialBanner(            backgroundColor: Colors.red.shade700,            content: const Text('أنت خارج المنطقة الآمنة',                style: TextStyle(color: Colors.white)),            actions: [              // الجسر إلى الدردشة — انظر القسم 12              TextButton(                onPressed: widget.onOpenChat,                child: const Text('تواصل مع المجموعة',                    style: TextStyle(color: Colors.white)),              ),            ],          ),        ),    ]);  }}   `

### ح) نصائح أداء

*   **لا تُعِد بناء** Set **في كل** build**.** خزّنها في متغيّر وأعِد بناءها فقط عند تغيّر المناطق فعلاً.
    
*   markerId **و**circleId **ثابتة** لنفس العنصر (leader، zone\_$id) — تغييرها يجعل الخريطة تحذف العلامة وتُعيد إنشاءها، فترتجف بصرياً.
    
*   distanceFilter في geolocator هو أكبر مكسب للبطارية.
    
*   setState **واحدة لكل حدث**، لا واحدة لكل حقل.
    

12\. الخروج من المنطقة الآمنة
-----------------------------

قائد الرحلة يرسم دائرة على الخريطة (المنطقة الآمنة)، ونصف قطرها بين **25 متراً و50 كم**. عند كل نبضة يتحقق السيرفر: هل الحاج داخلها؟**إذا خرج الحاج:**

*   إشعار Push للحاج نفسه، **ويحتوي رقم هاتف القائد** ليتصل به مباشرة
    
*   تنبيه للقائد والإدارة بالمسافة والإحداثيات
    

**ما تفعله أنت في التطبيق:**

*   اعرض شريطاً تحذيرياً واضحاً عند وصول الإشعار
    
*   ضع زر «اتصال بالقائد» يستخدم الرقم الآتي في الإشعار
    
*   **وضع زراً يفتح الدردشة** — فهي أسرع طريقة ليقول الحاج «أنا هنا، تأخرت» أو ليطلب انتظاره
    

> هذه أهم نقطة تلتقي فيها الميزتان: التتبّع **يكتشف** المشكلة، والدردشة هي **وسيلة حلّها**. اجعل الانتقال بينهما بضغطة واحدة.

13\. زر الطوارئ (SOS)
---------------------

`   POST /api/v1/app/sos-events   `

نفس جسم نبضة الموقع بالضبط: latitude وlongitude.

`   GET /api/v1/app/sos-events/{id}   `

لمتابعة حالة الاستغاثة.

> اجعله زراً كبيراً واضحاً، واطلب تأكيداً قبل الإرسال (لتفادي الضغط الخاطئ في الجيب).

14\. للقائد فقط: إدارة المنطقة الآمنة
-------------------------------------

إن كان حساب المستخدم role = leader، تُفتح له هذه المسارات:المسارالوظيفةGET /api/v1/app/trip-geofencesقائمة المناطق الآمنةPOST /api/v1/app/trip-geofencesإنشاء منطقةPUT /api/v1/app/trip-geofences/{id}تعديل منطقةGET /api/v1/app/trip-geofences/breachesمَن خرج من المنطقة**جسم الإنشاء:** name (≤150)، latitude، longitude، radius\_meters (من 25 إلى 50000).القائد **وحده** يستطيع أيضاً الاشتراك في private-trip.{id}.locations لرؤية كل الحجاج.

> **للحاج العادي:** لا تنادِ أي مسار من هذه. مسارك هو GET /trip-safe-area (القسم 4.1) — قراءة فقط، وللمناطق النشطة فقط.

الحاج العادي إذا نادى هذه المسارات يحصل على:

`   { "message": "Only the trip leader can manage the trip safe area.", "status_code": 0 }   `

بكود **403**. أخفِ هذه الشاشات بناءً على الدور، ولا تعتمد على الإخفاء وحده — السيرفر يفرض القاعدة أيضاً.

15\. الأخطاء الشائعة وحلولها
----------------------------

العَرَضالسبب الأرجحالحل500 بدل 401نسيان Accept: application/jsonأضف الهيدركل النبضات ترجع 400الرحلة ليست startedتحقّق من GET /trip-chat أولاًلا تصل أي رسالة حيّةنسيان بادئة private-/presence-صحّح اسم القناةالاشتراك يفشل بلا خطأالتوكن غير مُرسل في /broadcasting/authأضفه في onAuthorizerكل الرسائل تظهر يساراًis\_mine غير موجود في حدث الويب-سوكتقارن sender\_pilgrim\_id بنفسكالقائد يتلقّى «فقدان إشارة» والحاج بخيرفاصل الإرسال أطول من 3 دقائقاجعله 60 ثانيةالاشتراك في locations مرفوضهذا هو السلوك الصحيحاستخدم leader بدلاً منهلا تصل إشعارات الخروجلم يُرسل توكن FCMنادِ update-fcm-token بعد الدخولموقعي لا يظهر على الخريطةتنتظره من السيرفرموقعك من geolocator محلياً — لا يعود من السوكتعلامة القائد في وسط المحيطرسمتها قبل وصول أول نبضةلا ترسمها إلا إذا \_leaderPosition != nullالدائرة لا تظهرأخذت items\[0\] فقط أو المنطقة معطّلةارسم كل عناصر المصفوفة؛ المعطّلة لا تُرجَع أصلاًالمنطقة قديمة بعد تحريك القائد لهالا يوجد بثّ لتغيّر المنطقةأعد جلب /trip-safe-area دورياًالخريطة ترتجف أو تقفزmarkerId متغيّر أو كاميرا تتحرك كل نبضةثبّت المعرّفات، واضبط الكاميرا مرّة واحدةالبطارية تنفد بسرعةdistanceFilter غير مضبوط أو stream مُسرَّباضبطه، وألغِ الـ stream في dispose403 على /trip-geofencesاستخدمت مسار القائداستخدم /trip-safe-area للقراءةالدردشة تعمل لكن النبضات 400الرحلة في almost-doneهذا سلوك صحيح — أوقف التتبّع وأبقِ الدردشةالدردشة صارت 404 فجأةالرحلة completed أو cancelledأغلق الشاشة وأوقف المؤقّت

16\. قائمة تحقّق قبل التسليم
----------------------------

*   Accept: application/json في **كل** طلب
    
*   التوكن في flutter\_secure\_storage لا في SharedPreferences
    
*   حالة الرحلة مقروءة من GET /bookings قبل إظهار أي ميزة
    
*   التتبّع مشروط بـ started فقط، والدردشة بـ started أو almost-done
    
*   المؤقّت 60 ثانية، ويتوقف عند 400 و401
    
*   المؤقّت يتوقف عند إغلاق التطبيق/تسجيل الخروج (لا تُسرّب Timer)
    
*   أسماء القنوات تحتوي البادئة الصحيحة
    
*   التوكن مُرسل في onAuthorizer
    
*   توكن FCM مُرسل بعد تسجيل الدخول
    
*   is\_mine محسوب يدوياً لرسائل الويب-سوكت
    
*   POST /trip-chat/read عند فتح شاشة الدردشة
    
*   لا محاولة للاشتراك في private-trip.{id}.locations من تطبيق الحاج
    
*   إذن الموقع مشروح للمستخدم قبل طلبه
    
*   زر للانتقال من تحذير «خارج المنطقة» إلى الدردشة
    
*   فشل الشبكة لا يُظهر رسالة خطأ لكل محاولة
    
*   onSubscriptionError مملوء ويُسجّل الرسالة (لا تتركه فارغاً)
    
*   إعادة جلب الرسائل عند العودة من الانقطاع، مع دمج بالـ id
    
*   unsubscribe + disconnect في dispose وعند تسجيل الخروج
    
*   موقعي يُرسم من geolocator لا من السوكت
    
*   كل المناطق النشطة مرسومة، لا items\[0\] فقط
    
*   إعادة جلب /trip-safe-area دورياً (لا يوجد بثّ لتغيّرها)
    
*   distanceFilter مضبوط في getPositionStream
    
*   \_positionSub.cancel() في dispose
    
*   علامة القائد لا تُرسم قبل وصول أول نبضة منه
    
*   الكاميرا تُضبط مرّة واحدة لا مع كل تحديث
    

ملاحظة أخيرة
------------

القاعدة التي تحلّ معظم الالتباس في هذا النظام:

> **لا تُرسل** trip\_id **أبداً في جسم الطلب.** السيرفر يستنتج رحلتك من التوكن، وهذا مقصود — لو أخذها من الطلب لاستطاع أي حساب أن يقرأ دردشة رحلة غيره. أنت تحتاج trip\_id لشيء واحد فقط: **بناء أسماء القنوات الحيّة**.

وقاعدة ثانية لا تقلّ أهمية:

> **التتبّع والدردشة بوّابتان منفصلتان، لا بوّابة واحدة.** التتبّع يحتاج started بالضبط؛ الدردشة تبقى مفتوحة حتى almost-done.