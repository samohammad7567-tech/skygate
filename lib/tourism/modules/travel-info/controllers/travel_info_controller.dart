import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import "package:flutter/material.dart";
import 'package:skygate/tourism/core/theme/app_theme.dart';
import 'package:skygate/tourism/core/utils/failures/failures.dart';
import 'package:skygate/tourism/modules/travel-info/models/travel_info_model.dart';
import 'package:skygate/tourism/modules/travel-info/repository/get_travel_infos_repository.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

enum GetTravelInfosDataStatus { initial, loading, error, success }

class TravelInfoController extends GetxController {
  List<ExpandedTileController> expandedTileControllersList = [];
  int? fakeTravelInfoCounter = 0;
  List<ExpandedTile> panels = [];

  GetTravelInfosDataStatus getTravelInfosDataStatus =
      GetTravelInfosDataStatus.initial;
  Failure getTravelInfosDataFailure = const ServerFailure();

  List<TravelInfoModel> travelInfosList = [];
  late GetTravelInfosRepository getTravelInfosRepository;

  @override
  void onInit() async {
    super.onInit();
    getTravelInfosRepository = GetTravelInfosRepository();
    await getTravelInfosData();
    fakeTravelInfoCounter = travelInfosList.length;
    for (int i = 0; i < fakeTravelInfoCounter!; i++) {
      expandedTileControllersList.add(ExpandedTileController(
          isExpanded: false, key: GlobalKey(debugLabel: "${i}")));
    }

    for (int i = 0; i < travelInfosList.length; i++) {
      final element = travelInfosList[i];
      panels.add(ExpandedTile(
        theme: ExpandedTileThemeData(
          headerColor: Colors.white,
          headerPadding: EdgeInsets.all(10.0.r),
          contentBackgroundColor: const Color(0xFFD9D9D9),
          contentPadding: EdgeInsets.all(10.0.r),
        ),
        title: Text(
          element.title ?? "",
          style: TextStyle(
              color: AppColors.blue,
              fontFamily: AppFonts.skygateFont,
              fontSize: 20.0,
              fontWeight: FontWeight.w400),
        ),
        content: Text(
          element.details ?? "",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            shadows: const [
              Shadow(
                color: Colors.grey,
                blurRadius: 10.0,
                offset: Offset(0, 2.0),
              ),
            ],
            fontSize: 14.0,
            color: AppColors.blue,
            fontFamily: AppFonts.skygateFont,
          ),
        ),
        controller: expandedTileControllersList[i],
      ));
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getTravelInfosData() async {
    getTravelInfosDataStatus = GetTravelInfosDataStatus.loading;
    update();

    (await getTravelInfosRepository.getTravelInfos()).fold((left) {
      getTravelInfosDataStatus = GetTravelInfosDataStatus.error;
      update();
    }, (right) async {
      if (right.code == "1") {
        getTravelInfosDataStatus = GetTravelInfosDataStatus.success;
        update();
        travelInfosList = right.data!;
      } else {
        travelInfosList = [];
        getTravelInfosDataStatus = GetTravelInfosDataStatus.success;
        update();
      }
    });
  }
}
