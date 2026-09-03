import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/error_panel.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/views/widgets/booking_request_card.dart';

import '../controllers/my_bookings_requests_controller.dart';

class MyBookingsRequestsView extends GetView<MyBookingsRequestsController> {
  MyBookingsRequestsView({super.key});

  final myBookingsRequestsController = Get.find<MyBookingsRequestsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        actions: [
          TextButton(
            onPressed: () async {
              await myBookingsRequestsController.getBookingsRequestsData();
            },
            child: Text(
              "تحديث الصفحة",
              style: context.textTheme.titleSmall,
            ),
          ),
        ],
        centerTitle: true,
        elevation: 0.0,
        title: SvgPicture.asset(
          "assets/images/big-logo.svg",
          width: 105.0.w,
          height: 47.0.h,
        ),
      ),
      body: Container(
        width: 1 * 1.sw,
        height: 1 * 1.sh,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/seko.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            // Page Title
            Text(
              "الطلبات",
              style: context.textTheme.displayLarge!.copyWith(
                color: AppColors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 40.0,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 36.0.h)),
            // Bookings Requests List
            GetBuilder<MyBookingsRequestsController>(
              init: myBookingsRequestsController,
              builder: (myBookingsRequestsController) {
                if (myBookingsRequestsController
                            .getBookingsRequestsDataStatus ==
                        GetBookingsRequestsDataStatus.initial ||
                    myBookingsRequestsController
                            .getBookingsRequestsDataStatus ==
                        GetBookingsRequestsDataStatus.loading) {
                  return Expanded(
                    child: LoadingWidget(
                      color: AppColors.blue,
                      size: 50.0,
                    ),
                  );
                } else if (myBookingsRequestsController
                        .getBookingsRequestsDataStatus ==
                    GetBookingsRequestsDataStatus.error) {
                  return Expanded(
                    child: ErrorPanel(
                      failure: myBookingsRequestsController
                          .getBookingsRequestsDataFailure,
                      onTryAgain: () async {
                        await myBookingsRequestsController
                            .getBookingsRequestsData();
                      },
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.0.w,
                            ),
                            child: BookingRequestCard(
                              departureDate: myBookingsRequestsController
                                  .bookingsRequestsList[index].departure_date,
                              departureCity: myBookingsRequestsController
                                  .bookingsRequestsList[index].departure_place,
                              arrivalCity: myBookingsRequestsController
                                  .bookingsRequestsList[index].arrival_place,
                              isOneWay: (myBookingsRequestsController
                                          .bookingsRequestsList[index]
                                          .is_one_way ==
                                      "1")
                                  ? true
                                  : false,
                              tripLevel: myBookingsRequestsController
                                  .bookingsRequestsList[index].trip_level,
                              totalCost: myBookingsRequestsController
                                  .bookingsRequestsList[index].total_cost,
                              currency: myBookingsRequestsController
                                  .bookingsRequestsList[index].currency,
                              status: myBookingsRequestsController
                                  .bookingsRequestsList[index].status,
                              paymentMethod: myBookingsRequestsController
                                  .bookingsRequestsList[index].payment_method,
                              bookingRequestID: myBookingsRequestsController
                                  .bookingsRequestsList[index].id
                                  .toString(),
                              requestNumber: myBookingsRequestsController
                                  .bookingsRequestsList[index].request_number,
                              isRegularTrip: myBookingsRequestsController
                                  .bookingsRequestsList[index].is_regular_trip,
                              bookingRequest: myBookingsRequestsController
                                  .bookingsRequestsList[index],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: EdgeInsets.only(bottom: 25.0.h));
                        },
                        itemCount: myBookingsRequestsController
                            .bookingsRequestsList.length),
                  );
                }
              },
            ),
            Padding(padding: EdgeInsets.only(bottom: 36.0.h)),
          ],
        ),
      ),
    );
  }
}
