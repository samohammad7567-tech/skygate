import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../utils/failures/base_failure.dart';

class GeneralController extends GetxController {
  late bool _loading;
  late bool _error;
  late bool validateFields;
  late Failure serverFailure;
  late ScrollController scrollController;
  late GlobalKey<FormState> formKey;

  GeneralController() {
    _loading = false;
    _error = false;
    validateFields = false;
    scrollController = ScrollController();
    formKey = GlobalKey<FormState>();
  }

  bool get error => _error;
  bool get loading => _loading;

  void setLoading() {
    _loading = true;
    update();
  }

  void removeLoading() {
    _loading = false;
    update();
  }

  void setError() {
    _error = true;
    update();
  }

  void removeError() {
    _error = false;
    update();
  }
}
