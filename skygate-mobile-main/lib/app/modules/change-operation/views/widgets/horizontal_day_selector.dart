import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:sky_gate/app/modules/change-operation/controllers/change_operation_controller.dart';


class HorizontalDaySelector extends StatelessWidget {
  HorizontalDaySelector({super.key, required this.selectReturnTripPage});

  final changeOperationController = Get.find<ChangeOperationController>();
  final bool selectReturnTripPage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => changeOperationController.navigateDays(-1,selectReturnTripPage),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                final dayOffset = index - 1; // -1, 0, 1
                final date = changeOperationController.currentDate.add(Duration(days: dayOffset));
                final weekday = changeOperationController.arabicWeekdays[date.weekday - 1];
                final month = changeOperationController.arabicMonths[date.month - 1];

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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.blue,
                              ),
                            ),
                            if (dayOffset == 0)
                              Text(
                                "${DateFormat('d').format(date)} ${month}",
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
            onPressed: () => changeOperationController.navigateDays(1,selectReturnTripPage),
          ),
        ],
      ),
    );
  }
}