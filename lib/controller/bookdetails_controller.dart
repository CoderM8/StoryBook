import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookDetailsController extends GetxController {
  RxBool isLike = false.obs;
  TabController? tabController;
  RxBool isDownload = false.obs;
  RxString downloadingBookId = "".obs;
  RxBool israting = false.obs;
}
