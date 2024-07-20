import 'dart:io';
import 'package:wixpod/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/constant.dart';

class ProfileController extends GetxController {
  String countrycode = '';
  TextEditingController username = TextEditingController();
  TextEditingController usergmail = TextEditingController();
  TextEditingController monumber = TextEditingController();
  final UserController userController = Get.put(UserController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  final ImagePicker picker = ImagePicker();
  var selectedImageSize = ''.obs;
  File? selectedImagePath;
  RxBool profilebool = false.obs;

  void getImage(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      selectedImagePath = File(pickedFile.path);
      selectedImageSize.value = "${((File(selectedImagePath!.path)).lengthSync() / 1024 / 1024).toStringAsFixed(2)} Mb";
      profilebool.value = true;
      profilebool.value = false;
    } else {
      Get.snackbar('Error'.tr, 'NoImageselected'.tr,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          backgroundColor: blackColor,
          colorText: whiteColor);
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (userController.isguest.value == false) {
      username.text = userController.userName!;
      usergmail.text = userController.userEmail!;
      monumber.text = userController.phone!;
      countrycode = userController.pn_countrycode!;
      selectedImagePath;
    }
  }
}
