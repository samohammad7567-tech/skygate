import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';

import '../modules/logout/controllers/logout_controller.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? scaffoldBody;
  final bool? isBackNeeded;
  final bool? showActionButton;
  final String? title;

  CustomScaffold({super.key, 
    this.scaffoldBody,
    this.isBackNeeded,
    this.showActionButton,
    this.title = "SPOT ON",
  });

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final logoutController = Get.find<LogoutController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _key,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: (isBackNeeded == false)
              ? Container()
              : TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.black,
                  ),
                ),
          actions: (showActionButton == true)
              ? [
                  TextButton(
                    onPressed: () {
                      _key.currentState!.openDrawer();
                    },
                    child: Icon(Icons.grid_4x4, color: Colors.white),
                  ),
                ]
              : [],
          title: Text(
            title!,
            style: context.textTheme.headlineLarge!.copyWith(
              color: AppColors.blue[300],
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(child: Column(children: [scaffoldBody!])),
        ),
      ),
    );
  }
}
