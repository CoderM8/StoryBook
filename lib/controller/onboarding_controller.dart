import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;
  var controller = PageController();

  @override
  void onInit() {
    super.onInit();
    controller = PageController(initialPage: 0);
  }
}
