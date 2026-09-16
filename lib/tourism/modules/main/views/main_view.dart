import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import 'custom_buttom_navigation_bar.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  Widget getSection(BottomNavigationItem selectedItem) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (MainController controller) => Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Builder(
          builder: (context) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(child: getSection(controller.selectedItem)),
                    const SafeArea(top: false, child: SizedBox(height: 60)),
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
