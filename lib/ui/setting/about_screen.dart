// ignore_for_file: deprecated_member_use

import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:wixpod/services/all_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/constant.dart';
import '../../constants/widget/textwidget.dart';
import '../../model/drawer/appdetaliscreen_model.dart';

class AppAboutScreen extends GetView {
  AppAboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Backbutton(),
        centerTitle: true,
        elevation: 0.0,
        title: Styles.regular('AboutUs'.tr, fs: 22.sp, ff: "Poppins-Bold", fw: FontWeight.bold),
      ),
      body: FutureBuilder<AppDetalisModel?>(
          future: AllServices().appdetalis(),
          builder: (context, snapshot) {
            if (snapshot.hasData || snapshot.connectionState == ConnectionState.done) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(20.r)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Styles.regular('App_Name'.tr, fs: 16.sp, ff: "Poppins-SemiBold", ta: TextAlign.start, c: blackColor),
                      subtitle: Styles.regular(
                        snapshot.data!.audioBook[0].appName,
                        ta: TextAlign.start,
                        fs: 13.sp,
                        c: blackColor,
                        ff: "Poppins-Regular",
                      ),
                    ),
                    ListTile(
                      title: Styles.regular('App_Version'.tr, fs: 16.sp, ff: "Poppins-SemiBold", ta: TextAlign.start, c: blackColor),
                      subtitle: Styles.regular('${version} (${buildNumber})', fs: 14.sp, ff: "Poppins-Regular", ta: TextAlign.start, c: blackColor),
                    ),
                    ListTile(
                      title: Styles.regular('Company'.tr, fs: 16.sp, ff: "Poppins-SemiBold", ta: TextAlign.start, c: blackColor),
                      subtitle:
                          Styles.regular(snapshot.data!.audioBook[0].appAuthor, fs: 14.sp, ff: "Poppins-Regular", ta: TextAlign.start, c: blackColor),
                    ),
                    ListTile(
                      title: Styles.regular('Email'.tr, fs: 16.sp, ff: "Poppins-SemiBold", ta: TextAlign.start, c: blackColor),
                      subtitle:
                          Styles.regular(snapshot.data!.audioBook[0].appEmail, fs: 14.sp, ff: "Poppins-Regular", ta: TextAlign.start, c: blackColor),
                    ),
                    ListTile(
                      title: Styles.regular('Website'.tr, fs: 16.sp, ff: "Poppins-SemiBold", ta: TextAlign.start, c: blackColor),
                      subtitle: Styles.regular(snapshot.data!.audioBook[0].appWebsite,
                          fs: 14.sp, ff: "Poppins-Regular", ta: TextAlign.start, c: blackColor),
                    ),
                    ListTile(
                      title: Styles.regular('Contacts'.tr, fs: 16.sp, ff: "Poppins-SemiBold", ta: TextAlign.start, c: blackColor),
                      subtitle: Styles.regular(snapshot.data!.audioBook[0].appContact,
                          fs: 14.sp, ff: "Poppins-Regular", ta: TextAlign.start, c: blackColor),
                    ),
                    ListTile(
                      title: Styles.regular('Developer_by'.tr, fs: 16.sp, ff: "Poppins-SemiBold", ta: TextAlign.start, c: blackColor),
                      subtitle: Styles.regular(snapshot.data!.audioBook[0].appDevelopedBy,
                          fs: 14.sp, ff: "Poppins-Regular", ta: TextAlign.start, c: blackColor),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                height: 540.h,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: whiteColor,
                ),
                child: Shimmer.fromColors(
                    baseColor: shimmerGray,
                    highlightColor: greyColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 20.h);
                        },
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Container(
                                height: 20.h,
                                width: 160.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: Colors.white,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    )),
              );
            }
          }),
    );
  }
}
