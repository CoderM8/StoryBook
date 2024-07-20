// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:wixpod/constants/constant.dart';
import 'package:wixpod/constants/widget/textfiledwidget.dart';
import 'package:wixpod/constants/widget/textwidget.dart';
import 'package:wixpod/controller/login_controller.dart';
import 'package:wixpod/services/all_services.dart';
import 'package:wixpod/ui/drawer/privacypolicy_screen.dart';
import 'package:wixpod/ui/home/bottom_navigationbar.dart';
import 'package:wixpod/ui/login/forgotpassword_screen.dart';
import 'package:wixpod/ui/login/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/widget/button_widget.dart';
import '../../controller/user_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final LoginController logincontroller = Get.put(LoginController());
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        actions: [
          Obx(() {
            userController.isguest.value;
            return InkWell(
              onTap: () async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                userController.isguest.value = !userController.isguest.value;
                prefs.setBool('guest', true);
                subscribe.value = false;
                userController.getuser().whenComplete(() => Get.offAll(MyBottomNavigationBar()));
              },
              child: Container(
                margin: EdgeInsets.only(right: 20.w),
                height: 50.h,
                width: 50.w,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Center(
                  child: Styles.regular('Skip'.tr, c: blackColor, fs: 12.sp),
                ),
              ),
            );
          })
        ],
        title: Styles.regular('Login'.tr, fw: FontWeight.bold, ff: "Poppins-Bold"),
        centerTitle: true,
        backgroundColor: blackColor,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Obx(() {
        return ModalProgressHUD(
          inAsyncCall: logincontroller.inAsyncCall.value,
          progressIndicator: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: blackColor, backgroundColor: Colors.transparent),
              SizedBox(height: 5.h),
              Styles.regular('Verifyinguser'.tr, ff: "Poppins-Bold", fs: 15.sp, c: blackColor),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Container(
                      height: 170.h,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: blackColor,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Get.theme.focusColor.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5)),
                        ],
                      ),
                      margin: const EdgeInsets.only(bottom: 50),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Styles.regular(
                              'Welcome_Back'.tr,
                              ff: "Poppins-Bold",
                              fs: 24.sp,
                            ),
                            SizedBox(height: 5.h),
                            Styles.regular('Login_system'.tr, ta: TextAlign.center, fs: 14.sp, c: whiteColor.withOpacity(0.7)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 100.w,
                      width: 100.w,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Image.asset(
                        'assets/images/login_logo.jpg',
                        fit: BoxFit.cover,
                        // width: 100,
                        // height: 100,
                      ),
                    ),
                  ],
                ),
                Form(
                  key: logincontroller.loginformKey,
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      TextFieldWidget(
                        labelText: 'EmailAddress'.tr,
                        controller: logincontroller.useremail,
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        color: blackColor,
                        hint: 'EmailAddress'.tr,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(15.0.r),
                          child: SvgPicture.asset(
                            "assets/icons/emailicon.svg",
                          ),
                        ),
                        border: false,
                        validation: (value) {
                          if (value!.isEmpty) {
                            return 'EmptyEmail'.tr;
                          }
                          String pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value)) {
                            return 'EnterEmail'.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      Obx(
                        () => TextFieldWidget(
                          labelText: 'Password'.tr,
                          controller: logincontroller.password,
                          textInputType: TextInputType.text,
                          obse: logincontroller.passwordVisible.value,
                          textInputAction: TextInputAction.done,
                          color: blackColor,
                          hint: 'Password'.tr,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(15.0.r),
                            child: SvgPicture.asset(
                              "assets/icons/lock.svg",
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              logincontroller.passwordVisible.value = !logincontroller.passwordVisible.value;
                            },
                            icon: Icon(
                              !logincontroller.passwordVisible.value ? Icons.visibility : Icons.visibility_off,
                              color: Colors.black38,
                            ),
                          ),
                          validation: (value) {
                            if (value!.isEmpty) {
                              return 'EmptyPassword'.tr;
                            }
                            if (value.length <= 5) {
                              return 'EnterPassword'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only( top: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  await AllServices().appdetalis().then((value) {
                                    Get.to(() => PrivacyPolicyScreen(
                                          data: value!.audioBook[0].appPrivacyPolicy,
                                        ));
                                  });
                                },
                                child: Styles.regular('PrivacyPolicy'.tr,
                                    ov: TextOverflow.ellipsis, lns: 2, ff: "Poppins-SemiBold", underline: true, c: blackColor, fs: 16.sp),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                  onTap: () {
                                    Get.to(() => ForgotPassword());
                                  },
                                  child: Styles.regular('Login_Forget'.tr,
                                      lns: 2, fs: 14.sp, c: Colors.black, ff: "Poppins-SemiBold", fw: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () async {
                          if (logincontroller.loginformKey.currentState!.validate()) {
                            await logincontroller.signIn(
                                email: logincontroller.useremail.text, loginpassword: logincontroller.password.text);
                          }
                        },
                        child: Button(
                          title: 'Login'.tr,
                          titleColor: whiteColor,
                          color: blackColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(child: Divider(endIndent: 10,color: greyColor,)),
                          Styles.regular(
                            'signinwith'.tr,
                            fs: 14.sp,
                            c: Colors.black,
                            ff: "Poppins-SemiBold",
                          ), Expanded(child: Divider(indent: 10,color: greyColor,)),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(backgroundColor: blackColor,heroTag: '1',
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                            child: SvgPicture.asset("assets/icons/googleicon.svg", height: 35.h),
                            onPressed: () async {
                              logincontroller.inAsyncCall.value = true;
                              await logincontroller.googleSignIn();
                            },
                          ),
                          if (Platform.isIOS)...[
                            SizedBox(width: 20.w),
                            FloatingActionButton(backgroundColor: blackColor,heroTag: '2',
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                              child: SvgPicture.asset("assets/icons/apple.svg", height: 35.h,color: whiteColor,),
                              onPressed: () async {
                                logincontroller.inAsyncCall.value = true;
                                logincontroller.doSignInApple();
                              },
                            ),
        ]
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Styles.regular(
                            'Login_no_account'.tr,
                            fs: 14.sp,
                            c: Colors.black,
                            ff: "Poppins-SemiBold",
                          ),
                          SizedBox(width: 5.w),
                          InkWell(
                              onTap: () {
                                Get.to(() => SignupScreen());
                              },
                              child: Styles.regular('${'SignUp'.tr}',
                                  underline: true, fs: 14.sp, c: Colors.black, ff: "Poppins-SemiBold", fw: FontWeight.bold)),
                        ],
                      ), SizedBox(height: 20.h),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
