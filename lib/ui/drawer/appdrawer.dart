// ignore_for_file: deprecated_member_use

import 'package:wixpod/constants/constant.dart';
import 'package:wixpod/controller/user_controller.dart';
import 'package:wixpod/ui/Stories/all_stories.dart';
import 'package:wixpod/ui/author/all_author.dart';
import 'package:wixpod/ui/setting/setting_screen.dart';
import 'package:wixpod/ui/subscription/subscription_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../constants/widget/textwidget.dart';
import '../../controller/bottom_navigation_controller.dart';
import '../../controller/login_controller.dart';
import 'downloaded_screen.dart';

class DrawerScreen extends StatelessWidget {
  DrawerScreen({super.key});

  final LoginController logincontroller = Get.put(LoginController());
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      textColor: whiteColor,
      iconColor: whiteColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          GetBuilder<UserController>(
              init: UserController(),
              builder: (context) {
                return Container(
                  width: 128.0.w,
                  height: 128.0.w,
                  margin: const EdgeInsets.only(
                    top: 50.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: CachedNetworkImage(
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
          SizedBox(height: 20.h),
          GetBuilder<UserController>(
              init: UserController(),
              builder: (context) {
                return Container(
                  width: 210.w,
                  height: 60.h,
                  child: Center(
                    child: Column(
                      children: [
                        Styles.regular(
                          userController.isguest.value ? 'Guest'.tr : userController.userName!,
                          ff: "Poppins-SemiBold",
                          fs: 16.sp,
                        ),
                        SizedBox(height: 6.h),
                        Styles.regular(
                          userController.isguest.value ? '' : userController.userEmail!,
                          ff: "Poppins-Regular",
                          fs: 14.sp,
                        ),
                      ],
                    ),
                  ),
                );
              }),
          SizedBox(height: 30.h),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ListTile(
                onTap: () {
                  Get.to(() => Author());
                  advancedDrawerController.hideDrawer();
                },
                leading: const Icon(Icons.account_circle_rounded),
                title: Styles.regular('Author'.tr, ff: "Poppins-SemiBold", ta: TextAlign.start),
              ),
              ListTile(
                onTap: () {
                  Get.to(() => StoriesScreen());
                  advancedDrawerController.hideDrawer();
                },
                leading: const Icon(Icons.book),
                title: Styles.regular('Stories'.tr, ff: "Poppins-SemiBold", ta: TextAlign.start),
              ),
              if (!userController.isguest.value && (subscribe.value == true))
                ListTile(
                  onTap: () {
                    Get.to(() => Downloaded());
                    advancedDrawerController.hideDrawer();
                  },
                  leading:  SvgPicture.asset('assets/icons/download.svg',color: whiteColor,),
                  title: Styles.regular('Downloads'.tr, ff: "Poppins-SemiBold", ta: TextAlign.start),
                ),
              ListTile(
                onTap: () {
                  Get.to(() => SettingScreen());
                  advancedDrawerController.hideDrawer();
                },
                leading: const Icon(Icons.settings),
                title: Styles.regular('Settings'.tr, ff: "Poppins-SemiBold", ta: TextAlign.start),
              ),

              /// subscription
              if (!userController.isguest.value)
                ListTile(
                  onTap: () {
                    Get.to(() => SubscriptionScreen());
                    advancedDrawerController.hideDrawer();
                  },
                  leading: SvgPicture.asset('assets/icons/dollar.svg', color: whiteColor),
                  title: Styles.regular('Subscription'.tr, ff: "Poppins-SemiBold", ta: TextAlign.start),
                ),

              ///logout
              userController.isguest.value
                  ? ListTile(
                      onTap: () {
                        logincontroller.signOut();
                      },
                      leading: const Icon(Icons.logout),
                      title: Styles.regular(
                        'Logout'.tr,
                        ta: TextAlign.start,
                        ff: "Poppins-SemiBold",
                      ),
                    )
                  : ListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Styles.regular('AreyouSure_Logout'.tr, ff: "Poppins-Medium", fs: 20.sp, c: blackColor),
                                      SizedBox(height: 20.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Container(
                                                  height: 40.h,
                                                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius: BorderRadius.circular(10.r),
                                                  ),
                                                  child: Center(
                                                    child: Styles.regular('Cancel'.tr, ff: "Poppins-Medium", fs: 15.sp),
                                                  ),
                                                )),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () async {
                                                logincontroller.signOut();
                                                advancedDrawerController.hideDrawer();
                                              },
                                              child: Container(
                                                height: 40.h,
                                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                decoration: BoxDecoration(
                                                  color: blackColor,
                                                  borderRadius: BorderRadius.circular(10.r),
                                                ),
                                                child: Center(
                                                  child: Styles.regular('Logout'.tr,
                                                      ff: "Poppins-Medium", ov: TextOverflow.ellipsis, fs: 15.sp, ta: TextAlign.start),
                                                ),
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
                      },
                      leading: const Icon(Icons.logout),
                      title: Styles.regular(
                        'Logout'.tr,
                        ta: TextAlign.start,
                        ff: "Poppins-SemiBold",
                      ),
                    ),

              ///delete account
              if (!userController.isguest.value)
                ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Styles.regular('are_you_sure_to_delete_account'.tr, ff: "Poppins-Medium", fs: 20.sp, c: blackColor),
                                  SizedBox(height: 20.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: Container(
                                              height: 40.h,
                                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.circular(10.r),
                                              ),
                                              child: Center(
                                                child: Styles.regular('Cancel'.tr, ff: "Poppins-Medium", fs: 15.sp),
                                              ),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            logincontroller.deleteAccount().then((value) {
                                              if (value.isNotEmpty && value == "This user Is Deleted Please Contact Admin") {
                                                logincontroller.signOut();
                                              }
                                            });
                                          },
                                          child: Container(
                                            height: 40.h,
                                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                                            decoration: BoxDecoration(
                                              color: blackColor,
                                              borderRadius: BorderRadius.circular(10.r),
                                            ),
                                            child: Center(
                                              child: Styles.regular('delete'.tr,
                                                  ff: "Poppins-Medium", fs: 15.sp, ta: TextAlign.center, lns: 1, ov: TextOverflow.visible),
                                            ),
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
                  },
                  leading:  SvgPicture.asset(
                    'assets/icons/delete.svg',color: whiteColor,height: 22.w,width: 22.w,
                  ),
                  title: Styles.regular('delete'.tr, ff: "Poppins-SemiBold", ta: TextAlign.start),
                ),
            ],
          )
        ],
      ),
    );
  }
}
