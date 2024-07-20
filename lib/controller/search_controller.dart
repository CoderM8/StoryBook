import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchhController extends GetxController {
  TextEditingController search = TextEditingController();

  RxBool isRefresh = false.obs;

  FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    focusNode = FocusNode();
    super.onInit();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  onClose() {
    focusNode.dispose();
    super.onClose();
  }
}
