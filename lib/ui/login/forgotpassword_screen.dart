import 'dart:convert';
import 'package:wixpod/constants/constant.dart';
import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:wixpod/constants/widget/textfiledwidget.dart';
import 'package:wixpod/constants/widget/textwidget.dart';
import 'package:wixpod/controller/login_controller.dart';
import 'package:wixpod/ui/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  final LoginController loginController = Get.put(LoginController());
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Styles.regular('Forgot_Forgotpass'.tr, ff: "Poppins-Bold", fw: FontWeight.bold),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: Backbutton(),
      ),
      body: Form(
        key: globalKey,
        child: ListView(
          primary: true,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Container(
                  child: Container(
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
                            'Login_Forget'.tr,
                            ff: "Poppins-Bold",
                            fs: 24.sp,
                          ),
                          const SizedBox(height: 5),
                          Styles.regular(
                            'Login_system'.tr,
                            fs: 14.sp,
                            c: whiteColor.withOpacity(0.7),
                            ta: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
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
            SizedBox(height: 40.h),
            Column(
              children: [
                TextFieldWidget(
                  labelText: 'EnterEmail'.tr,
                  controller: loginController.useremail,
                  textInputType: TextInputType.emailAddress,
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
                      return 'EnterEmail'.tr;
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
                SizedBox(height: 20.h),
                InkWell(
                  onTap: () async {
                    if (globalKey.currentState!.validate()) {
                      Map body = {"data": '{"method_name":"forgot_pass","user_email":"${loginController.useremail.text}"}'};
                      final response = await http.post(Uri.parse(Api.mainApi), body: body);
                      if (response.statusCode == 200) {
                        final data = jsonDecode(response.body);
                        if (data['AUDIO_BOOK'][0]['success'] == '1') {
                          ShowSnackBar(message: data['AUDIO_BOOK'][0]['msg']);
                          loginController.useremail.clear();
                        } else {
                          ShowSnackBar(message: data['AUDIO_BOOK'][0]['msg']);
                        }
                      }
                    }
                  },
                  child: Button(
                    title: 'Send'.tr,
                    color: blackColor,
                    titleColor: whiteColor,
                  ),
                ),
                SizedBox(height: 20.h),
                InkWell(
                    onTap: () {
                      Get.offAll(() => LoginScreen());
                    },
                    child: Styles.regular('Backtologin'.tr, fs: 14.sp, c: Colors.black, ff: "Poppins-SemiBold", fw: FontWeight.bold)),
                SizedBox(height: 20.h),
              ],
            )
          ],
        ),
      ),
    );
  }
}
