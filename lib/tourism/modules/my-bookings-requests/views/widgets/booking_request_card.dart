import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/global_widgets/custom_white_outlined_button.dart';
import 'package:skygate/tourism/global_widgets/error_banner.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/modules/change-operation/controllers/change_operation_controller.dart';
import 'package:skygate/tourism/modules/change-operation/views/detect_navigation_view.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/controllers/my_bookings_requests_controller.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/models/booking_request_model.dart';
import 'package:skygate/tourism/modules/refund-operation/controllers/refund_operation_controller.dart';
import 'package:skygate/tourism/modules/refund-operation/views/refund_request_result_view.dart';
import 'package:skygate/tourism/routes/app_pages.dart';

class BookingRequestCard extends StatelessWidget {
  BookingRequestCard(
      {super.key,
      this.departureDate,
      this.departureCity,
      this.arrivalCity,
      this.isOneWay,
      this.tripLevel,
      this.totalCost,
      this.currency,
      this.status,
      this.bookingRequestID,
      this.paymentMethod,
      this.requestNumber,
      this.isRegularTrip,
      this.bookingRequest});

  final String? departureDate;
  final String? departureCity;
  final String? arrivalCity;
  final bool? isOneWay;
  final String? tripLevel;
  final String? totalCost;
  final String? currency;
  final String? status;
  final String? bookingRequestID;
  final String? requestNumber;
  final String? paymentMethod;
  final String? isRegularTrip;
  final BookingRequestModel? bookingRequest;

  final myBookingsRequestsController = Get.find<MyBookingsRequestsController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.0.h,
      padding: EdgeInsets.symmetric(horizontal: 30.0.w, vertical: 23.0.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0.r),
        color: Colors.white,
        border: Border.all(
          color: AppColors.blue,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // First Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'طلب حجز رحلة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF22509E),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  height: 1.57,
                ),
              ),
              Text(
                departureDate!.isNotEmpty
                    ? departureDate!.substring(0, 10)
                    : "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  height: 1.57,
                ),
              )
            ],
          ),
          // Second Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${departureCity} - ${arrivalCity}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF22509E),
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  height: 1.10,
                ),
              ),
              Text(
                '${totalCost} ${currency}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontFamily: 'Aileron',
                  fontWeight: FontWeight.w700,
                  height: 1.57,
                ),
              )
            ],
          ),
          // Third Row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                (isOneWay == true)
                    ? 'ذهاب فقط| ${tripLevel}'
                    : 'ذهاب - إياب | ${tripLevel}',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFF22509E),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  height: 1.57,
                ),
              )
            ],
          ),
          // Forth Row  Payment + Cancel BTNs
          Row(
            mainAxisAlignment: (myBookingsRequestsController
                    .getPaymentButtonCondition(status: status))
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              // Payment Button
              Visibility(
                visible: myBookingsRequestsController.getPaymentButtonCondition(
                    status: status),
                child: SizedBox(
                  width: 150.0.w,
                  child: CustomButton(
                    onTap: () {
                      myBookingsRequestsController.selectedBookingRequest =
                          bookingRequest;
                      myBookingsRequestsController.selectedBookingRequestID =
                          int.parse(bookingRequestID!);
                      myBookingsRequestsController.getPaymentMethodsData();

                      // Check if conditions are already accepted
                      if (bookingRequest?.conditions_accepted == "1") {
                        // Conditions already accepted, load existing passports and go to add passports
                        myBookingsRequestsController
                            .loadPassportsFromSelectedBooking();
                        myBookingsRequestsController.getCameraPermission();
                        Get.toNamed(Routes.ADD_PASSPORTS_VIEW);
                      } else {
                        // Conditions not accepted, go to confirm conditions first
                        Get.toNamed(Routes.CONFIRM_BOOKING_CONDITION);
                      }
                    },
                    btnColor: AppColors.blue,
                    addShadow: false,
                    borderRadius: 30.0.r,
                    padding: 10.0.r,
                    child: Text(
                      "دفع التذكرة",
                      style: context.textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ),
              // Cancel Button
              Visibility(
                visible: (myBookingsRequestsController.getCancelButtonCondition(
                    status: status)),
                child: SizedBox(
                  width: 150.0.w,
                  height: 40.0.h,
                  child: CustomWhiteOutlinedButton(
                    onTap: () async {
                      await myBookingsRequestsController.cancelBookingRequest(
                          bookingRequestID: bookingRequestID);
                      await myBookingsRequestsController
                          .getBookingsRequestsData();
                    },
                    addShadow: false,
                    borderColor: AppColors.blue,
                    child: GetBuilder<MyBookingsRequestsController>(
                        init: myBookingsRequestsController,
                        builder: (myBookingsRequestsController) {
                          if (myBookingsRequestsController
                                  .cancelBookingsRequestStatus ==
                              CancelBookingsRequestStatus.loading) {
                            return LoadingWidget(
                              color: AppColors.blue,
                              size: 25.0,
                            );
                          } else if (myBookingsRequestsController
                                  .cancelBookingsRequestStatus ==
                              CancelBookingsRequestStatus.error) {
                            return ErrorBanner(
                                failure: myBookingsRequestsController
                                    .cancelBookingsRequestFailure);
                          } else {
                            return Text(
                              "إلغاء",
                              style: context.textTheme.titleMedium!.copyWith(
                                color: AppColors.blue,
                                fontSize: 15.0,
                              ),
                            );
                          }
                        }),
                  ),
                ),
              ),
            ],
          ),
          // Fifth Row Refund + Change Button
          Row(
            mainAxisAlignment: (myBookingsRequestsController
                    .getRefundButtonCondition(status: status))
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              // Refund Button
              Visibility(
                visible: myBookingsRequestsController.getRefundButtonCondition(
                    status: status),
                child: SizedBox(
                  width: 150.0.w,
                  height: 40.0.h,
                  child: CustomButton(
                    onTap: () {
                      Get.toNamed(Routes.REFUND_OPERATION,
                          arguments: {"id": bookingRequestID});
                    },
                    btnColor: AppColors.blue,
                    addShadow: false,
                    borderRadius: 30.0.r,
                    padding: 10.0.r,
                    child: Text(
                      "طلب استرداد",
                      style: context.textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ),
              // Change Button
              Visibility(
                visible: myBookingsRequestsController.getChangeButtonCondition(
                    status: status, isRegularTrip: isRegularTrip),
                child: SizedBox(
                  width: 150.0.w,
                  height: 40.0.h,
                  child: CustomButton(
                    onTap: () {
                      Get.toNamed(Routes.CHANGE_OPERATION,
                          arguments: {"id": bookingRequestID});
                    },
                    btnColor: AppColors.blue,
                    addShadow: false,
                    borderRadius: 30.0.r,
                    padding: 10.0.r,
                    child: Text(
                      "طلب تعديل",
                      style: context.textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Sixth Row Refund Status + ChangeRequest Status Button
          Row(
            mainAxisAlignment: (myBookingsRequestsController
                    .getRefundButtonCondition(status: status))
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              // Refund Request Status Button
              Visibility(
                visible: (status == "refund-operation"),
                child: SizedBox(
                  width: 150.0.w,
                  height: 40.0.h,
                  child: CustomButton(
                    onTap: () {
                      Get.lazyPut(() => RefundOperationController());
                      Get.to(() => RefundRequestResultView(),
                          arguments: {"id": bookingRequestID});
                    },
                    btnColor: AppColors.blue,
                    addShadow: false,
                    borderRadius: 30.0.r,
                    padding: 10.0.r,
                    child: Text(
                      "حالة طلب الاسترداد",
                      style: context.textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ),
              // Change Request Status Button
              Visibility(
                visible: (status == "change-operation"),
                child: SizedBox(
                  width: 150.0.w,
                  height: 40.0.h,
                  child: CustomButton(
                    onTap: () {
                      Get.lazyPut(() => ChangeOperationController(),
                          fenix: true);
                      Get.to(() => DetectNavigationView(),
                          arguments: {"id": bookingRequestID});
                    },
                    btnColor: AppColors.blue,
                    addShadow: false,
                    borderRadius: 30.0.r,
                    padding: 10.0.r,
                    child: Text(
                      "حالة طلب التعديل",
                      style: context.textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Booking Request Status Container
          Container(
            width: 284.0.w,
            height: 35.0.h,
            decoration: ShapeDecoration(
              color: myBookingsRequestsController.getRequestStatusColor(
                  status: status),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Center(
              child: Text(
                myBookingsRequestsController.getRequestStatusString(
                    status: status),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  height: 1.57,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
