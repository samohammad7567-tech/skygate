import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';

import '../controllers/fingerprint_setup_controller.dart';

class FingerprintSetupView extends GetView<FingerprintSetupController> {
  FingerprintSetupView({super.key});
  final fingerprintSetupController = Get.find<FingerprintSetupController>();

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
        child: GetBuilder<FingerprintSetupController>(
          init: fingerprintSetupController,
          builder: (fingerprintLoginController) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!fingerprintLoginController.canCheckBiometrics)
                    const Text('المصادقة بالبصمة غير ممكنة.'),
                  if (fingerprintLoginController.availableBiometrics.isNotEmpty)
                    Column(
                      children: [
                        const Text('البصمات المتوافرة :'),
                        ...fingerprintLoginController.availableBiometrics
                            .map(
                              (bio) =>
                                  Text('- ${bio.toString().split('.').last}'),
                            )
                            ,
                      ],
                    ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.fingerprint),
                    label: Text(
                      'تأكيد بصمة الأصبع',
                      style: context.textTheme.titleMedium,
                    ),
                    onPressed: () async {
                      await fingerprintLoginController.authenticate(
                        context: context,
                      );
                    },
                  ),
                  if (fingerprintLoginController.isAuthenticating)
                    Padding(
                      padding: EdgeInsets.only(top: 20.0.h),
                      child: LoadingWidget(color: AppColors.blue, size: 50.0),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
