import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import 'custom_buttom_navigation_bar.dart';


class MainView extends GetView<MainController> {
  MainView({Key? key}) : super(key: key);

  Widget getSection(BottomNavigationItem selectedItem) {
    // TODO: Implement the logic same as the one below
    // switch (selectedItem) {
    //   // case BottomNavigationItem.home:
    //   //   return const HomeSection();
    //   // case BottomNavigationItem.nearestProvider:
    //   //   return const NearestProviderSection();
    //   // case BottomNavigationItem.add:
    //   //   return AddClaimView();
    //   case BottomNavigationItem.alarm:
    //     return const NotificationsView();
    //     // TODO: This default must be removed !
    //   default:
    //     return const NotificationsView();
    // }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (MainController controller) => Scaffold(
        // TODO: Add Your Custom Drawer !
        // drawer:  CustomDrawer(),
        backgroundColor: Colors.grey.shade50,
        body: Builder(builder: (context) {
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(child: getSection(controller.selectedItem)),
                  const SafeArea(
                    child: SizedBox(
                      height: 60,
                    ),
                    top: false,
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: CustomBottomNavigationBar(
                  selectedItem: controller.selectedItem,
                  onSelect: (item) {
                    controller.onSelectedBottomNavigationChanged(item);
                  },
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
