# Current State — رحلاتي & المدفوعات

What each screen of the `SCREENS/payments` flow reads today, and what it is still
waiting on. Written against `Skygate API Documentation.openapi.json`.

> **There is no mock or hardcoded data anywhere in this flow.** The split below is
> not "real vs. fake" — it is **wired to a live endpoint** vs. **rendered from a
> model the caller has to supply, which nothing supplies yet**. Where a figure is
> unavailable the screen renders its empty state (a `0%` ring, a hidden card, a
> `—`) rather than inventing a number.

---

## 1. Screens on a live endpoint

| Screen | Endpoint | What it actually gets back |
|---|---|---|
| **رحلاتي** `trips_screen.dart` | `GET app/bookings` | `BookingResource`: `id`, `status`, `total_amount`, `draft_expires_at` |
| **المدفوعات** `payments_screen.dart` | `GET app/bookings/{id}` | Same four fields |
| **معلومات الدفع** (sheet) `payment_sheet.dart` | `GET app/payment-methods` | **Complete** — `name`, `subtitle`, `instructions[]`, `image`, `is_active` |
| **معلومات الدفع** — ارسال | `POST app/financial-transactions` | **Complete** — multipart `booking_id`, `payment_method_id`, `amount`, `currency`, `reference_number`, `receipt` (≤ 2 MB) |
| **تفاصيل الرحلة** `package_details_screen.dart` | `GET app/trips/{id}` | **Complete** — pre-existing, via `TripService` |

Only the **payment sheet** is fully served by the API. It is the one screen in
this flow that is finished end to end.

---

## 2. Screens wired to an endpoint that under-serves them

### المدفوعات — `payments_screen.dart`
Calls `GET app/bookings/{id}`, but `BookingResource` carries no payment breakdown.

| Element | State |
|---|---|
| إجمالي المبلغ | ✅ `total_amount` |
| المدفوع | ⚠️ renders `0` — no `paid_amount` field exists |
| المتبقي | ⚠️ equals the total, because المدفوع is 0 |
| Ring percentage | ⚠️ always `0%` for the same reason |
| جدول المدفوعات | ❌ **card hides itself** — no instalment plan is published |
| ادفع الآن | ✅ opens the sheet, which works |
| عرض تفاصيل الحجز | ❌ **button never appears** — see §3 |

`BookingPaymentModel.fromJson` already reads `paid_amount` and an `installments[]`
array opportunistically, so the ring and the schedule light up on their own the
day the resource grows them. No client change needed.

### رحلاتي — `trips_screen.dart`
Calls `GET app/bookings`, but `BookingResource` carries no trip.

| Element | State |
|---|---|
| Status chip (حالية / بانتظار الدفع / منتهية) | ✅ from `status` |
| Tab filtering | ✅ from `status` |
| المبلغ المتبقي | ⚠️ equals `total_amount` — no `paid_amount` |
| Trip name | ⚠️ renders `—` — no `trip` / `campaign_name` |
| Trip number | ⚠️ hidden |
| Departure / return dates | ⚠️ render `—` |
| Cover photo | ⚠️ falls back to the bundled Kaaba artwork |
| Progress rail (الحالية tab) | ❌ **hidden** — no itinerary on the booking |
| استكمال الدفع | ✅ opens المدفوعات |
| **عرض التفاصيل** | ❌ **shows an error toast** — needs a `trip_id` the booking never carries |

`BookingTripModel.fromJson` already looks for a nested `trip` object and for the
flat field names the rest of the API uses (`trip_id`, `campaign_name`,
`trip_number`, `start_date_g`, `end_date_g`, `itinerary[]`). Adding any of them
server-side lights up the matching row with no client change.

### المعاملات المالية — `transactions_screen.dart`

| Element | State |
|---|---|
| Summary ring at the top | Same as المدفوعات above |
| Transaction list | ⚠️ **session-only** |

`PaymentsCubit.getTransactions()` makes **no network call** — the document
publishes `POST app/financial-transactions` but no list beside it. The screen
shows transfers created in the current session (filed by `addTransaction` when
the sheet returns) and its empty state otherwise; the list is gone after a
restart.

`FinancialTransactionModel.fromJson` fully parses `FinancialTransactionResource`,
so pointing this at `GET app/financial-transactions?booking_id=` is a one-line
change in the cubit. Two fields the design prints are not in the resource at all:

- **Payer name** — the card falls back to `reference_number`, then `—`
- **سبب الرفض** — a rejected transfer shows the chip with no reason line

---

## 3. Screens with no data source at all

### تفاصيل الحجز — `booking_details_screen.dart` (+ تفاصيل المسافرين sheet)

**Currently unreachable.** It takes a `BookingDetailsModel` rather than a booking
id, because `GET app/bookings/{id}` publishes no route, room type, hotels or
travellers — there is nothing to fetch. `PaymentsScreen` hides its
"عرض تفاصيل الحجز" button while that model is null.

`BookingDetailsModel` is **never constructed anywhere in the codebase today**, so
the button never appears and neither the screen nor the travellers sheet can be
opened. The widgets are complete and cover both mockups — the individual table
(`5.png`) and the group layout with per-room cards (`7.png`) and the travellers
sheet (`8.png`).

**To make it reachable, either:**

1. Have the booking wizards build a `BookingDetailsModel` at the point they call
   `POST app/bookings` — they already hold the route, rooms, hotels and
   travellers — and hand it to `PaymentsScreen(bookingId:, details:)`; **or**
2. Extend `BookingResource` with `rooms[]` (room type, hotel per city, total,
   travellers) and parse it in `PaymentsCubit.getPayment()`.

### تأكيد الدفع — `payment_success_screen.dart`
Static by design. Reads nothing; states that the transfer is **under review**,
which matches the backend actually deciding the outcome.

---

## 4. Endpoints added to `ApiEndpoints` in this pass

```dart
ApiEndpoints.booking(id)                // GET  app/bookings/{id}
ApiEndpoints.paymentMethods             // GET  app/payment-methods
ApiEndpoints.financialTransactions      // POST app/financial-transactions
ApiEndpoints.transactionReceipt(id)     // POST app/financial-transactions/{id}/receipt
```

`transactionReceipt(id)` is declared but **not called** — the sheet attaches the
receipt to the create request in one go. It is there for a later "add a receipt
to an existing transaction" path.

---

## 5. Backend changes, in the order that unblocks the most UI

| # | Change | Unblocks |
|---|---|---|
| 1 | Add `trip` (or `trip_id` + trip fields) to `BookingResource` | رحلاتي card title, number, dates, photo, and its عرض التفاصيل action |
| 2 | Add `paid_amount` to `BookingResource` | The ring, المدفوع, المتبقي — on **both** payment screens and the رحلاتي card |
| 3 | Add `installments[]` to `BookingResource` | جدول المدفوعات (`4.png`), currently hidden entirely |
| 4 | Publish `GET app/financial-transactions?booking_id=` | المعاملات المالية surviving a restart |
| 5 | Add `rooms[]` + travellers to `BookingResource` | تفاصيل الحجز (`5/7/8.png`) — or resolve client-side per §3 option 1 |
| 6 | Add `payer` and `rejection_reason` to `FinancialTransactionResource` | The payer name and the سبب الرفض line on a transaction card |

Items 2, 3, 4 and 6 need **no client changes** — the models already parse those
field names.
