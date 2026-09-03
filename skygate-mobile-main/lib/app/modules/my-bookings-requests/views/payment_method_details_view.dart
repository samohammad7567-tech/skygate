import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sky_gate/app/modules/my-bookings-requests/controllers/my_bookings_requests_controller.dart';

class PaymentMethodDetailsView extends GetView<MyBookingsRequestsController> {
  PaymentMethodDetailsView({super.key});

  final myBookingsRequestsController = Get.find<MyBookingsRequestsController>();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
