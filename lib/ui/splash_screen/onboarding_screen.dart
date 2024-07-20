import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:wixpod/constants/widget/textwidget.dart';
import 'package:wixpod/controller/onboarding_controller.dart';
import 'package:wixpod/ui/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/constant.dart';

class onboarding_screen extends StatelessWidget {
  final OnboardingController c = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: c.controller,
              onPageChanged: (int index) {
                c.currentIndex.value = index;
              },
              itemCount: onboardinglist.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 121.h,
                    ),
                    Image.asset(
                      onboardinglist[index].imgUrl,
                      width: 261.53.w,
                      height: 258.68.h,
                    ),
                    SizedBox(
                      height: 68.32.h,
                    ),
                    Styles.regular(onboardinglist[index].title, ff: "Poppins-Bold", fs: 25.sp, c: whiteColor),
                    SizedBox(height: 8.h),
                    Styles.regular(onboardinglist[index].description,
                        ta: TextAlign.center, ff: "Poppins-Regular", fs: 16.sp, c: whiteColor.withOpacity(0.7)),
                  ],
                );
              },
            ),
          ),
          Obx(
            () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(onboardinglist.length, (index) => buildDot(index, context))),
          ),
          Obx(
            () => InkWell(
              onTap: () {
                c.currentIndex.value++;
                if (c.currentIndex.value != 3) {
                  c.controller.jumpToPage(c.currentIndex.value);
                }
                if (c.currentIndex.value == 3) {
                  Get.offAll(() => LoginScreen());
                }
              },
              child: Button(
                title: c.currentIndex.value == onboardinglist.length - 1 ? 'Done'.tr : 'Next'.tr,
              ),
            ),
          ),
          SizedBox(height: 20.h)
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 104.h, right: 10.w),
      height: 13.w,
      width: 13.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c.currentIndex.value == index ? whiteColor : greyColor,
      ),
    );
  }
}
