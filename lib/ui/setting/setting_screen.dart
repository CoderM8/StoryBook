// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:one_context/one_context.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wixpod/constants/constant.dart';
import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:wixpod/constants/widget/textwidget.dart';
import 'package:wixpod/controller/profile_controller.dart';
import 'package:wixpod/main.dart';
import 'package:wixpod/services/all_services.dart';
import 'package:wixpod/ui/login/pdf_screen.dart';
import '../../localization/language_constant.dart';
import '../drawer/privacypolicy_screen.dart';
import 'about_screen.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  final ProfileController profileController = Get.put(ProfileController());

  final RxBool isProgress = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Backbutton(),
        centerTitle: true,
        elevation: 0.0,
        title: Styles.regular('Settings'.tr, fs: 22.sp, ff: "Poppins-Bold", fw: FontWeight.bold),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 28.0.w, right: 28.w, top: 50.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  languagename.value;
                  return InkWell(
                    onTap: () {
                      selectLanguageBottomSheet(context);
                    },
                    child: Container(
                      height: 60.h,
                      width: 310.w,
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(15.r), color: Colors.white, border: Border.all(color: Colors.black)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Styles.regular('Language'.tr, c: blackColor, ff: "Poppins-Medium"),
                          Styles.regular(languagename.value, c: blackColor, ff: "Poppins-SemiBold"),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: 15.h),
                InkWell(
                  onTap: () {
                    isProgress.value = true;
                    Share.share('Wixpod\n ${getAppShare()}', subject: 'Weaving Dreams, Streaming Joy, One Story at a Time!');
                    isProgress.value = false;
                  },
                  child: Container(
                    height: 60.h,
                    width: 310.w,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.w),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15.r), color: Colors.white, border: Border.all(color: Colors.black)),
                    child: Styles.regular('ShareApp'.tr, c: blackColor, ff: "Poppins-Medium"),
                  ),
                ),
                SizedBox(height: 15.h),
                InkWell(
                  onTap: () async {
                    isProgress.value = true;
                    await AllServices().appdetalis().then((value) {
                      isProgress.value = false;
                      Get.to(() => PrivacyPolicyScreen(
                            data: value!.audioBook[0].appPrivacyPolicy,
                          ));
                    });
                  },
                  child: Container(
                    height: 60.h,
                    width: 310.w,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.w),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15.r), color: Colors.white, border: Border.all(color: Colors.black)),
                    child: Styles.regular('PrivacyPolicy'.tr, c: blackColor, ff: "Poppins-Medium"),
                  ),
                ),
                SizedBox(height: 15.h),
                InkWell(
                  onTap: () async {
                    Get.to(() => PDFScreen(file: 'assets/file/wixpod_terms_condition.pdf'));
                  },
                  child: Container(
                    height: 60.h,
                    width: 310.w,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.w),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15.r), color: Colors.white, border: Border.all(color: Colors.black)),
                    child: Styles.regular('Terms'.tr, c: blackColor, ff: "Poppins-Medium"),
                  ),
                ),
                SizedBox(height: 15.h),
                InkWell(
                  onTap: () {
                    Get.to(() => AppAboutScreen());
                  },
                  child: Container(
                    height: 60.h,
                    width: 310.w,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.w),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15.r), color: Colors.white, border: Border.all(color: Colors.black)),
                    child: Styles.regular('AboutUs'.tr, c: blackColor, ff: "Poppins-Medium"),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            return isProgress.value
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    color: Colors.black26,
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  selectLanguageBottomSheet(context) {
    return showModalBottomSheet(
      constraints: BoxConstraints(maxHeight: 240.h),
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.r),
          topLeft: Radius.circular(20.r),
        ),
      ),
      builder: (context) {
        return Column(
          children: [
            ListTile(
              title: Styles.regular(
                'Language'.tr,
                fs: 25.sp,
                c: blackColor,
                ta: TextAlign.start,
                ff: 'Poppins-Medium',
              ),
              trailing: IconButton(
                splashRadius: 25.r,
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.clear,
                  size: 20.sp,
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: Language.languageList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => ListTile(
                  leading: Styles.regular(Language.languageList[index].flag, ta: TextAlign.start, c: blackColor, fs: 20.sp, ff: 'Poppins-Medium'),
                  visualDensity: const VisualDensity(vertical: -3),
                  minLeadingWidth: 60.w,
                  title: Transform(
                    transform: Matrix4.translationValues(-16, 0, 0),
                    child: Styles.regular(Language.languageList[index].name, ta: TextAlign.start, c: blackColor, fs: 20.sp, ff: 'Poppins-Medium'),
                  ),
                  onTap: () async {
                    await setLocale(Language.languageList[index].languageCode, Language.languageList[index].name);
                    getUserLanguage();

                    /// restart app
                    OnePlatform.reboot(
                      setUp: () {
                        OneContext().key = GlobalKey<NavigatorState>();
                      },
                      builder: () => MyApp(),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
