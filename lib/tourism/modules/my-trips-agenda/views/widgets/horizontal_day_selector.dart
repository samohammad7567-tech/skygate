import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/modules/my-trips-agenda/controllers/my_trips_agenda_controller.dart';

class HorizontalDaySelector extends StatelessWidget {
  HorizontalDaySelector({super.key, required this.selectReturnTripPage});

  final myTripsAgendaController = Get.find<MyTripsAgendaController>();
  final bool selectReturnTripPage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () =>
                myTripsAgendaController.navigateDays(-1, selectReturnTripPage),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                final dayOffset = index - 1; // -1, 0, 1
                final date = myTripsAgendaController.currentDate
                    .add(Duration(days: dayOffset));
                final weekday =
                    myTripsAgendaController.arabicWeekdays[date.weekday - 1];
                final month =
                    myTripsAgendaController.arabicMonths[date.month - 1];

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              weekday,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.blue,
                              ),
                            ),
                            if (dayOffset == 0)
                              Text(
                                "${DateFormat('d').format(date)} ${month}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.blue,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () =>
                myTripsAgendaController.navigateDays(1, selectReturnTripPage),
          ),
        ],
      ),
    );
  }
}
