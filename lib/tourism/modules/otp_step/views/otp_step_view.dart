import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/otp_step_controller.dart';

class OtpStepView extends GetView<OtpStepController> {
  const OtpStepView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OtpStepView'), centerTitle: true),
      body: const Center(
        child: Text('OtpStepView is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
