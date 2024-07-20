// ignore_for_file: deprecated_member_use

import 'package:wixpod/constants/constant.dart';
import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:wixpod/constants/widget/textfiledwidget.dart';
import 'package:wixpod/constants/widget/textwidget.dart';
import 'package:wixpod/controller/login_controller.dart';
import 'package:wixpod/ui/login/pdf_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final LoginController logincontroller = Get.put(LoginController());

   String countrycode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Styles.regular(
          'Register'.tr,
          fw: FontWeight.bold,
          ff: "Poppins-Bold",
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: Backbutton(),
      ),
      body: Obx(() {
        return ModalProgressHUD(
          inAsyncCall: logincontroller.inAsyncCall.value,
          progressIndicator: CircularProgressIndicator(color: blackColor, backgroundColor: Colors.transparent),
          child: ListView(
            primary: true,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    child: Container(
                      height: 130.h,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: blackColor,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Get.theme.focusColor.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5)),
                        ],
                      ),
                      margin: EdgeInsets.only(bottom: 50.h),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Styles.regular(
                              'SignUp'.tr,
                              fs: 20.sp,
                              ff: "Poppins-Bold",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      child: Image.asset(
                        'assets/images/login_logo.jpg',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Form(
                  key: logincontroller.regformKey,
                  child: Column(
                    children: [
                      TextFieldWidget(
                          labelText: 'Name'.tr,
                          controller: logincontroller.regname,
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          color: blackColor,
                          hint: 'Enter_Name'.tr,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(15.0.r),
                            child: SvgPicture.asset(
                              "assets/icons/parsonicon.svg",
                            ),
                          ),
                          border: false,
                          validation: (value) {
                            if (value!.isEmpty) {
                              return 'Name_is_empty'.tr;
                            }else {
                              return null;
                            }
                          }),
                      TextFieldWidget(
                          labelText: 'EmailAddress'.tr,
                          controller: logincontroller.regemail,
                          textInputType: TextInputType.emailAddress,
                          color: blackColor,
                          textcapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.done,
                          hint: 'EmailAddress'.tr,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(15.0.r),
                            child: SvgPicture.asset(
                              "assets/icons/emailicon.svg",
                            ),
                          ),
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
                          }),
                      Obx(
                        () => TextFieldWidget(
                          labelText: 'Password'.tr,
                          controller: logincontroller.regpass,
                          textInputType: TextInputType.text,
                          obse: logincontroller.passwordVisible.value,
                          color: blackColor,
                          textInputAction: TextInputAction.done,
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
                      Obx(
                        () => TextFieldWidget(
                          labelText: 'ConfirmPassword'.tr,
                          controller: logincontroller.regconform,
                          textInputType: TextInputType.text,
                          obse: logincontroller.conpasswordVisible.value,
                          color: blackColor,
                          textInputAction: TextInputAction.done,
                          hint: 'ConfirmPassword'.tr,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(15.0.r),
                            child: SvgPicture.asset(
                              "assets/icons/lock.svg",
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              logincontroller.conpasswordVisible.value = !logincontroller.conpasswordVisible.value;
                            },
                            icon: Icon(
                              !logincontroller.conpasswordVisible.value ? Icons.visibility : Icons.visibility_off,
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
                      Container(
                        padding: EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
                        margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: Offset(0, 5)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Styles.regular(
                              'Phone_Number'.tr,
                              ff: 'Poppins-Medium',
                              c: blackColor,
                              fs: 12.sp,
                              fw: FontWeight.normal,
                            ),
                            IntlPhoneField(
                              decoration: InputDecoration(
                                  hintText: 'Phone_Number'.tr,
                                  hintStyle: TextStyle(
                                    color: blackColor,
                                    fontFamily: 'Poppins-Regular',
                                    fontSize: 16.sp / MediaQuery.of(context).textScaleFactor,
                                  ),errorStyle: TextStyle(fontSize: 14.sp / MediaQuery.of(context).textScaleFactor),
                                  border: UnderlineInputBorder(borderSide: BorderSide.none)),
                              initialCountryCode: 'US',
                              pickerDialogStyle: PickerDialogStyle(
                                countryCodeStyle: TextStyle(fontSize: 14.sp / MediaQuery.of(context).textScaleFactor),
                                countryNameStyle: TextStyle(fontSize: 14.sp / MediaQuery.of(context).textScaleFactor),
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction, dropdownTextStyle: TextStyle(fontSize: 13.sp / MediaQuery.of(context).textScaleFactor),
                              textInputAction: TextInputAction.done, style: TextStyle(fontSize: 14.sp / MediaQuery.of(context).textScaleFactor),
                              controller: logincontroller.regphone,
                              validator: (v) {
                                if (v == null || v.number.isEmpty) {
                                  return 'Numberisempty'.tr;
                                }
                                return null;
                              },
                              onCountryChanged: (v) {
                                countrycode = v.code;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () async {
                          if (logincontroller.regpass.text == logincontroller.regconform.text) {
                            if (logincontroller.regformKey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Dialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Dearuser'.tr,
                                                    style: TextStyle(color: blackColor, fontSize: 14.sp /  MediaQuery.of(context).textScaleFactor, fontFamily: "Poppins-Regular"),
                                                  ),
                                                  TextSpan(
                                                    text: 'Readmore'.tr,
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Get.to(() => PDFScreen(file: 'assets/file/wixpod_terms_condition.pdf'));
                                                      },
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 14.sp / MediaQuery.of(context).textScaleFactor,
                                                        fontFamily: "Poppins-Bold",
                                                        decoration: TextDecoration.underline),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 20.h),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                    onTap: () async {
                                                      Get.back();
                                                    },
                                                    child: Container(
                                                      height: 40.h,
                                                      width: 85.w,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius: BorderRadius.circular(10.r),
                                                      ),
                                                      child: Center(
                                                        child: Styles.regular('Decline'.tr, ff: "Poppins-Medium", fs: 15.sp),
                                                      ),
                                                    )),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    FocusManager.instance.primaryFocus!.unfocus();
                                                    Get.back();
                                                    await logincontroller.register(
                                                        email: logincontroller.regemail.text,
                                                        password: logincontroller.regpass.text,
                                                        name: logincontroller.regname.text,
                                                        phone: logincontroller.regphone.text,
                                                        pn_countrycode: countrycode.isNotEmpty ? countrycode : 'US');
                                                  },
                                                  child: Container(
                                                    height: 40.h,
                                                    width: 85.w,
                                                    decoration: BoxDecoration(
                                                      color: blackColor,
                                                      borderRadius: BorderRadius.circular(10.r),
                                                    ),
                                                    child: Center(
                                                      child: Styles.regular('Accept'.tr,
                                                          c: whiteColor,
                                                          ff: "Poppins-Medium",
                                                          fs: 15.sp,
                                                          ta: TextAlign.start,
                                                          lns: 1,
                                                          ov: TextOverflow.visible),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ));
                                },
                              );
                            }
                          } else {
                            final snackBar = SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.error_outline, color: whiteColor),
                                  SizedBox(width: 10.w),
                                  Styles.regular('Enter_Both_Password_are_Same'.tr, ff: "Poppins-Regular", fs: 14.sp),
                                ],
                              ),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(20.0),
                              dismissDirection: DismissDirection.startToEnd,
                              backgroundColor: blackColor,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                        child: Button(
                          title: 'SignUp'.tr,
                          titleColor: whiteColor,
                          color: blackColor,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Styles.regular(
                            'Login_have_account'.tr,
                            fs: 14.sp,
                            c: Colors.black,
                            ff: "Poppins-SemiBold",
                          ),
                          SizedBox(width: 5.w),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Styles.regular('Login'.tr,
                                  underline: true, fs: 14.sp, c: Colors.black, ff: "Poppins-SemiBold", fw: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
      // ),
    );
  }
}
