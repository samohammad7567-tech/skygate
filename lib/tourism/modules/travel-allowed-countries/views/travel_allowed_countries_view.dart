import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/global_widgets/error_panel.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/travel_allowed_countries_controller.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

class TravelAllowedCountriesView
    extends GetView<TravelAllowedCountriesController> {
  TravelAllowedCountriesView({super.key});

  final travelAllowedCountriesController =
      Get.find<TravelAllowedCountriesController>();

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
              Text(
                "الدول التي يمكن السفر إليها",
                style: context.textTheme.displayLarge!.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 40.0,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(padding: EdgeInsets.only(bottom: 36.0.h)),
              GetBuilder<TravelAllowedCountriesController>(
                  init: travelAllowedCountriesController,
                  builder: (travelAllowedCountriesController) {
                    if (travelAllowedCountriesController
                                .getTravelAllowedCountriesDataStatus ==
                            GetTravelAllowedCountriesDataStatus.initial ||
                        travelAllowedCountriesController
                                .getTravelAllowedCountriesDataStatus ==
                            GetTravelAllowedCountriesDataStatus.loading) {
                      return LoadingWidget(
                        color: AppColors.blue,
                        size: 50.0,
                      );
                    } else if (travelAllowedCountriesController
                            .getTravelAllowedCountriesDataStatus ==
                        GetTravelAllowedCountriesDataStatus.error) {
                      return ErrorPanel(
                        failure: travelAllowedCountriesController
                            .getTravelAllowedCountriesDataFailure,
                        onTryAgain: () async {
                          await travelAllowedCountriesController
                              .getTravelAllowedCountriesData();
                        },
                      );
                    } else {
                      if (travelAllowedCountriesController
                          .travelAllowedCountriesList.isEmpty) {
                        return Column(
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
                        );
                      } else {
                        return ListView(
                          shrinkWrap: true,
                          children: [
                            ExpandedTile(
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                              ),
                              theme: ExpandedTileThemeData(
                                headerColor: AppColors.blue,
                                headerPadding: EdgeInsets.all(10.0.r),
                                contentBackgroundColor: Colors.transparent,
                                headerSplashColor: AppColors.blue,
                                contentPadding: EdgeInsets.all(10.0.r),
                              ),
                              title: Text(
                                'دول لا تحتاج لتأشيرة للدخول إليها',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: AppFonts.skygateFont,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              content: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: 420.0.w,
                                    height: 50.0.h,
                                    decoration: BoxDecoration(
                                      color: Color(0x66CED7E3),
                                      borderRadius:
                                          BorderRadius.circular(20.0.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        travelAllowedCountriesController
                                            .countriesWithoutVisa[index],
                                        style: context.textTheme.titleMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Padding(
                                      padding: EdgeInsets.only(bottom: 12.0.h));
                                },
                                itemCount: travelAllowedCountriesController
                                    .countriesWithoutVisa.length,
                              ),
                              controller: travelAllowedCountriesController
                                  .expandedTileController1,
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 50.0.h)),
                            ExpandedTile(
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                              ),
                              theme: ExpandedTileThemeData(
                                headerColor: AppColors.blue,
                                headerPadding: EdgeInsets.all(10.0.r),
                                contentBackgroundColor: Colors.transparent,
                                headerSplashColor: AppColors.blue,
                                contentPadding: EdgeInsets.all(10.0.r),
                              ),
                              controller: travelAllowedCountriesController
                                  .expandedTileController2,
                              title: Text(
                                'دول تحتاج لتأشيرة للدخول إليها',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: AppFonts.skygateFont,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              content: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: 420.0.w,
                                    height: 50.0.h,
                                    decoration: BoxDecoration(
                                      color: Color(0x66CED7E3),
                                      borderRadius:
                                          BorderRadius.circular(20.0.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        travelAllowedCountriesController
                                            .countriesNeedVisa[index],
                                        textAlign: TextAlign.center,
                                        style: context.textTheme.titleMedium,
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Padding(
                                      padding: EdgeInsets.only(bottom: 12.0.h));
                                },
                                itemCount: travelAllowedCountriesController
                                    .countriesNeedVisa.length,
                              ),
                            ),
                          ],
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
