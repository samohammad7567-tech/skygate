import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'gesture_page.dart';

class WaladyScaffold extends StatelessWidget {
  final Widget? scaffoldBody;
  final bool? isBackNeeded;
  final double? endPadding;
  final double? startPadding;

  WaladyScaffold(
      {this.scaffoldBody,
      this.isBackNeeded,
      this.endPadding = 40.0,
      this.startPadding = 40.0});

  @override
  Widget build(BuildContext context) {
    return GesturePage(
      gestureChild: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 1 * 1.sw,
                height: 1 * 1.sh,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      "assets/images/auth-background.png",
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isBackNeeded!,
              child: PositionedDirectional(
                start: 20.0.w,
                top: 60.0.h,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 35.0,
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              start: startPadding!.w ?? 40.0.w,
              top: 220.0.h,
              bottom: 0.0,
              end: endPadding,
              child: scaffoldBody!,
            ),
          ],
        ),
      ),
    );
  }
}
