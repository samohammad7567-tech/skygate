import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:skygate/tourism/global_widgets/error_panel.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/travel_info_controller.dart';

class TravelInfoView extends GetView<TravelInfoController> {
  TravelInfoView({super.key});
  final travelInfoController = Get.find<TravelInfoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      extendBody: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        centerTitle: true,
        elevation: 0.0,
        title: SvgPicture.asset(
          "assets/images/svgs/big_logo.svg",
          width: 105.0.w,
          height: 47.0.h,
        ),
      ),
      body: Container(
        width: 1 * 1.sw,
        height: 1 * 1.sh,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pngs/seko.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
              Text(
                "معلومات عن السفر",
                style: context.textTheme.displayLarge!.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 40.0,
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 36.0.h)),
              GetBuilder<TravelInfoController>(
                  init: travelInfoController,
                  builder: (travelInfoController) {
                    if (travelInfoController.getTravelInfosDataStatus ==
                            GetTravelInfosDataStatus.initial ||
                        travelInfoController.getTravelInfosDataStatus ==
                            GetTravelInfosDataStatus.loading) {
                      return Center(
                          child: LoadingWidget(
                        color: AppColors.blue,
                        size: 50.0,
                      ));
                    } else if (travelInfoController.getTravelInfosDataStatus ==
                        GetTravelInfosDataStatus.error) {
                      return ErrorPanel(
                        failure: travelInfoController.getTravelInfosDataFailure,
                        onTryAgain: () async {
                          await travelInfoController.getTravelInfosData();
                        },
                      );
                    } else {
                      if (travelInfoController.travelInfosList.isEmpty) {
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.find_in_page,
                                color: AppColors.blue,
                                size: 50.0,
                              ),
                              Text(
                                tr("noRecordsFound"),
                                style: context.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: EdgeInsets.only(bottom: 50.0.h));
                          },
                          itemCount: travelInfoController.panels.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return travelInfoController.panels[index];
                          },
                        );
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
