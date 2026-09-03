import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/logout_controller.dart';

class LogoutView extends GetView<LogoutController> {
  const LogoutView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LogoutView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LogoutView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
