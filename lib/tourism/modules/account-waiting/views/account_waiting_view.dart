import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';

import '../controllers/account_waiting_controller.dart';

class AccountWaitingView extends GetView<AccountWaitingController> {
  const AccountWaitingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      extendBody: true,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "شكراً لتسجيلك معنا في تطبيق SkyGate",
              style: context.textTheme.displayLarge!.copyWith(
                color: AppColors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            Text(
              "يرجى مراجعة مكتب الإدارة لتأكيد حسابك.",
              style: context.textTheme.displayLarge!.copyWith(
                color: AppColors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
