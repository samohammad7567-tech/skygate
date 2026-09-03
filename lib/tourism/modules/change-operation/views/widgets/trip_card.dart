import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/modules/change-operation/controllers/change_operation_controller.dart';

class TripCard extends StatelessWidget {
  TripCard({super.key, this.flightCompanyLogo, this.tripNumber, this.tripDuration,
    this.departureCity, this.departureAirport, this.arrivalCity,
    this.arrivalAirport, this.firstWayLevel, this.tripPrice,
    this.departureTime, this.arrivalTime,this.index, this.isFirstWay,
    this.firstTransitCity, this.firstTransitAirport, this.secondTransitCity, this.secondTransitAirport});

  final String? flightCompanyLogo;
  final String? tripNumber;
  final String? tripDuration;
  final String? departureCity;
  final String? departureTime;
  final String? departureAirport;
  final String? arrivalCity;
  final String? arrivalTime;
  final String? arrivalAirport;
  final String? firstWayLevel;
  final String? tripPrice;
  final String? firstTransitCity;
  final String? firstTransitAirport;
  final String? secondTransitCity;
  final String? secondTransitAirport;
  final int? index;
  final bool? isFirstWay;

  final changeOperationController = Get.find<ChangeOperationController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0.r),
          border: Border.all(
            width: 1.5,
            color: changeOperationController.checkTripCardBorderColor(index: index, isFirstWay: isFirstWay),
          )),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
          // Flight company logo - trip code - trip duration
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CachedNetworkImage(
                imageUrl: flightCompanyLogo!,
                width: 75.0.w,
              ),
              Text(
                "${tripNumber}",
                style: context.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "${tripDuration!.substring(0, 1)} ساعة ${tripDuration!.substring(2, 4)}دقيقة",
                style: context.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
          // Departure Time - Plane with line img - Arrival Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "${departureTime}",
                style: context.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
              ),
              Image.asset(
                "assets/images/plane.png",
                width: 100.0.w,
              ),
              Text(
                "${arrivalTime}",
                style: context.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Airports Row
          Builder(builder: (_) {
            if (firstTransitCity != null || firstTransitCity != "") {
              if (secondTransitCity != null || secondTransitCity != "") {
                return FittedBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${departureCity}",
                              style: context.textTheme.titleSmall,
                            ),
                            Text(
                              "${departureAirport}",
                              style: context.textTheme.titleSmall,
                            )
                          ],
                        ),
                        SvgPicture.asset("assets/images/left-arrow.svg"),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${firstTransitCity}",
                              style: context.textTheme.titleSmall,
                            ),
                            Text(
                              "${firstTransitAirport}",
                              style: context.textTheme.titleSmall,
                            )
                          ],
                        ),
                        SvgPicture.asset("assets/images/left-arrow.svg"),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${secondTransitCity}",
                              style: context.textTheme.titleSmall,
                            ),
                            Text(
                              "${secondTransitAirport}",
                              style: context.textTheme.titleSmall,
                            )
                          ],
                        ),
                        SvgPicture.asset("assets/images/left-arrow.svg"),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${arrivalCity}",
                              style: context.textTheme.titleSmall,
                            ),
                            Text(
                              "${arrivalAirport}",
                              style: context.textTheme.titleSmall,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${departureCity}",
                          style: context.textTheme.titleSmall,
                        ),
                        Text(
                          "${departureAirport}",
                          style: context.textTheme.titleSmall,
                        )
                      ],
                    ),
                    SvgPicture.asset("assets/images/left-arrow.svg"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${firstTransitCity}",
                          style: context.textTheme.titleSmall,
                        ),
                        Text(
                          "${firstTransitAirport}",
                          style: context.textTheme.titleSmall,
                        )
                      ],
                    ),
                    SvgPicture.asset("assets/images/left-arrow.svg"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${arrivalCity}",
                          style: context.textTheme.titleSmall,
                        ),
                        Text(
                          "${arrivalAirport}",
                          style: context.textTheme.titleSmall,
                        )
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${departureCity}",
                          style: context.textTheme.titleSmall,
                        ),
                        Text(
                          "${departureAirport}",
                          style: context.textTheme.titleSmall,
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${arrivalCity}",
                          style: context.textTheme.titleSmall,
                        ),
                        Text(
                          "${arrivalAirport}",
                          style: context.textTheme.titleSmall,
                        )
                      ],
                    ),
                  ],
                ),
              );
            }
          }),

          Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
          const Divider(
            thickness: 1.5,
            color: Colors.grey,
          ),
          Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
          // trip level - cost
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "الدرجة ${firstWayLevel}",
                style: context.textTheme.titleSmall,
              ),
              Text(
                "ابتداءً من",
                style: context.textTheme.titleSmall,
              ),
              Text(
                "${tripPrice}",
                style: context.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
        ],
      ),
    );
  }
}
