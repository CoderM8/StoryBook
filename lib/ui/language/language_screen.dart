import 'package:wixpod/constants/constant.dart';
import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:wixpod/constants/widget/textwidget.dart';
import 'package:wixpod/localization/language_constant.dart';
import 'package:wixpod/ui/splash_screen/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});

  final RxInt lanindex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Styles.regular(
          'ChooseLanguage'.tr,
          fw: FontWeight.bold,
          fs: 20.sp,
          ff: "Poppins-Bold",
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20.h),
          Expanded(
            child: ListView.builder(
                itemCount: Language.languageList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => ListTile(
                      leading: Styles.regular(Language.languageList[index].flag,
                          ta: TextAlign.start, c: blackColor, fs: 20.sp, ff: 'Poppins-Medium'),
                      visualDensity: const VisualDensity(vertical: -3),
                      minLeadingWidth: 60.w,
                      title: Transform(
                        transform: Matrix4.translationValues(-16, 0, 0),
                        child: Styles.regular(Language.languageList[index].name, ta: TextAlign.start, fs: 20.sp, ff: 'Poppins-Medium'),
                      ),
                      onTap: () async {
                        await setLocale(Language.languageList[index].languageCode,Language.languageList[index].name);
                        getUserLanguage();
                      },
                      trailing: languagecode == Language.languageList[index].languageCode
                          ? Icon(Icons.check_circle, color: whiteColor)
                          : null,
                    )),
          ),
          InkWell(
            onTap: () {
              Get.off(() => onboarding_screen());
            },
            child: Button(
              title: 'Done'.tr,
              titleColor: blackColor,
              color: whiteColor,
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
