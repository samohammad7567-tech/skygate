import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sky_gate/app/modules/account/views/account_view.dart';
import 'package:sky_gate/app/modules/home-tab/views/home_tab_view.dart';
import 'package:sky_gate/app/modules/my-trips/views/my_trips_view.dart';
import 'package:sky_gate/app/modules/notifications/views/notifications_view.dart';
import 'package:sky_gate/app/modules/support/views/support_view.dart';

class HomeController extends GetxController {
  int currentIndex = 0;
  List<Widget> pageViewList = [
    HomeTabView(),
    MyTripsView(),
    SupportView(),
    NotificationsView(),
    AccountView(),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void changeCurrentIndex({int? index}) {
    currentIndex = index!;
    getCurrentTabView();
    update();
  }

  Widget getCurrentTabView() {
    return pageViewList[currentIndex];
  }

}
