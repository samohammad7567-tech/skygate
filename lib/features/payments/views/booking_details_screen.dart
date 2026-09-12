import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/payments/models/booking_details_model.dart';
import 'package:skygate/features/payments/widgets/booking_details_card.dart';
import 'package:skygate/features/payments/widgets/booking_travelers_sheet.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key, required this.details});

  final BookingDetailsModel details;

  void _showTravelers(BuildContext context, BookingRoomDetailsModel room) {
    showBookingTravelersSheet(context, travelers: room.travelers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppPageHeader(title: 'booking_details'.tr()),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.s, 4.s, 20.s, 28.s),
                children: [
                  BookingDetailsCard(
                    details: details,
                    onRoomDetails: (room) => _showTravelers(context, room),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
