// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:wixpod/constants/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:wixpod/controller/profile_controller.dart';
import 'package:wixpod/controller/user_controller.dart';
import 'package:wixpod/services/all_services.dart';
import '../../constants/widget/textfiledwidget.dart';
import '../../constants/widget/textwidget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final ProfileController profileController = Get.put(ProfileController());
  final UserController userController = Get.put(UserController());
  final String countrycode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              height: 220.h,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: blackColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40.r),
                  bottomLeft: Radius.circular(40.r),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h, top: 0.h),
                      child: Row(
                        children: [
                          Backbutton(),
                          Spacer(),
                          Styles.regular('Profilescreen'.tr, fs: 22.sp, ff: "Poppins-Bold", fw: FontWeight.bold),
                          Spacer(
                            flex: 2,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 60.h),
                    Stack(
                      children: [
                        Obx(() {
                          profileController.profilebool.value;
                          return profileController.selectedImagePath != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100.r),
                                  child: Image.file(
                                    File(profileController.selectedImagePath!.path),
                                    height: 100.w,
                                    fit: BoxFit.cover,
                                    width: 100.w,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100.r),
                                  child: CachedNetworkImage(
                                    height: 100.w,
                                    width: 100.w,
                                    imageUrl: userController.isguest.value ? Api.mainAddimage : userController.userImage ?? Api.mainAddimage,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, e, url) => Icon(Icons.error_rounded),
                                    imageBuilder: (context, imageProvider) {
                                      return CircleAvatar(
                                        backgroundImage: imageProvider,
                                        backgroundColor: Colors.transparent,
                                        maxRadius: 40.0,
                                      );
                                    },
                                  ),
                                );
                        }),
                        if (!userController.isguest.value)
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                onTap: () {
                                  profileController.getImage(ImageSource.gallery);
                                },
                                child: CircleAvatar(
                                  radius: 15.r,
                                  backgroundColor: Colors.black,
                                  child: Icon(Icons.camera_alt_outlined, size: 18.sp, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    if (!userController.isguest.value)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(top: 15.h),
                            child: Form(
                              key: profileController.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 11.h),
                                  Styles.regular(
                                    'Username'.tr,
                                    ff: 'Poppins-Medium',
                                    c: blackColor,
                                    fs: 12.sp,
                                    fw: FontWeight.bold,
                                  ),
                                  TextFieldprofiWidget(
                                    controller: profileController.username,
                                    textInputType: TextInputType.text,
                                    color: blackColor,
                                    border: true,
                                    validation: (v) {
                                      final alphanumeric = RegExp(r'^[a-zA-Z0-9\s]*$');
                                      if (v!.isEmpty) {
                                        return 'Name_is_empty'.tr;
                                      } else if (!alphanumeric.hasMatch(v)) {
                                        return "Specialcharactersnot".tr;
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(height: 11.h),
                                  Styles.regular(
                                    'Gmail'.tr,
                                    ff: 'Poppins-Medium',
                                    c: blackColor,
                                    fs: 12.sp,
                                    fw: FontWeight.bold,
                                  ),
                                  TextFieldprofiWidget(
                                    controller: profileController.usergmail,
                                    textInputType: TextInputType.emailAddress,
                                    color: blackColor,
                                    border: true,
                                    enabled: false,
                                  ),
                                  SizedBox(height: 11.h),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Styles.regular(
                                        'PhoneNumber'.tr,
                                        ff: 'Poppins-Medium',
                                        c: blackColor,
                                        fs: 12.sp,
                                        fw: FontWeight.bold,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.r), border: Border.all(color: Colors.black12, width: 1.w)),
                                        child: IntlPhoneField(
                                          decoration: InputDecoration(
                                              hintText: 'Phone_Number'.tr,
                                              hintStyle: TextStyle(
                                                color: blackColor,
                                                fontFamily: 'Poppins-Regular',
                                                fontSize: 16.sp / MediaQuery.of(context).textScaleFactor,
                                              ),
                                              errorStyle: TextStyle(fontSize: 14.sp / MediaQuery.of(context).textScaleFactor),
                                              border: UnderlineInputBorder(borderSide: BorderSide.none)),
                                          initialCountryCode: profileController.countrycode.isNotEmpty ? profileController.countrycode : 'US',
                                          pickerDialogStyle: PickerDialogStyle(
                                            countryCodeStyle: TextStyle(fontSize: 14.sp / MediaQuery.of(context).textScaleFactor),
                                            countryNameStyle: TextStyle(fontSize: 14.sp / MediaQuery.of(context).textScaleFactor),
                                          ),
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          textInputAction: TextInputAction.done,
                                          dropdownTextStyle: TextStyle(fontSize: 13.sp / MediaQuery.of(context).textScaleFactor),
                                          controller: profileController.monumber,
                                          style: TextStyle(fontSize: 14.sp / MediaQuery.of(context).textScaleFactor),
                                          validator: (v) {
                                            if (v == null || v.number.isEmpty) {
                                              return 'Numberisempty'.tr;
                                            }
                                            return null;
                                          },
                                          onCountryChanged: (v) {
                                            profileController.countrycode = v.code;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 40.h),
                                  Center(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        fixedSize: Size(210.w, 50.h),
                                        backgroundColor: blackColor,
                                        side: BorderSide.none,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                                      ),
                                      onPressed: () {
                                        if (profileController.formKey.currentState!.validate()) {
                                          AllServices()
                                              .getupdatedservice(
                                                  name: profileController.username.text,
                                                  email: userController.userEmail,
                                                  phonenumber: profileController.monumber.text,
                                                  pn_countrycode: profileController.countrycode.isNotEmpty ? profileController.countrycode : 'US',
                                                  image: profileController.selectedImagePath)
                                              .whenComplete(() async {
                                            await userController.getuser();
                                            UserController().update();
                                            ShowSnackBar(
                                              message: 'Profilesuccessfullyupdated'.tr,
                                            );
                                          });
                                        }
                                      },
                                      child: Center(
                                        child: Styles.regular('Update'.tr, ff: 'Poppins-Regular', fs: 16.sp, fw: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (userController.isguest.value)
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 150.w),
                          child: Styles.regular('Login_guest'.tr, c: blackColor, fw: FontWeight.bold, ff: "Poppins-Bold"),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
