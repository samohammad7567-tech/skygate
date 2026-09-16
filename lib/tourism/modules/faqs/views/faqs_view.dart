import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/global_widgets/custom_scaffold.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/faqs_controller.dart';

class FaqsView extends GetView<FaqsController> {
  final faqsController = Get.find<FaqsController>();

  FaqsView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showActionButton: true,
      isBackNeeded: true,
      title: "FAQs",
      scaffoldBody: Column(
        children: [
          Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
          Image.asset("assets/images/faqs.png"),
          Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
          Text(
            "All FAQs about our app: ",
            style: TextStyle(
              color: AppColors.blue,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
          SizedBox(
            height: (150.0 * faqsController.allFAQsList.length).h,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 1 * 1.sw,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                    child: Column(
                      children: [
                        Text(
                          "Q: ${faqsController.allFAQsList[index].question}",
                          style: TextStyle(
                            color: AppColors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "A: ${faqsController.allFAQsList[index].answer}",
                          style: TextStyle(
                            color: AppColors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(height: 1.5, color: AppColors.blue);
              },
              itemCount: faqsController.allFAQsList.length,
            ),
          ),
        ],
      ),
    );
  }
}
