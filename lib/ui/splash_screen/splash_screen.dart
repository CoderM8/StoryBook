// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:wixpod/controller/user_controller.dart';
import 'package:wixpod/ui/Single_Story/singlestory_screen.dart';
import 'package:wixpod/ui/drawer/downloaded_screen.dart';
import 'package:wixpod/ui/home/bottom_navigationbar.dart';
import 'package:wixpod/ui/language/language_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/constant.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);
  final UserController userController = Get.put(UserController());

  /// when app kill
  initDynamicLinks(BuildContext context) async {
    var deepLink = initialLink!.link;
    loadData().then((sdf) {
      switch (deepLink.path) {
        case "/Wixpod":
          {
            Get.to(
              () => SingleStoryScreen(
                bookid: deepLink.queryParameters['id'].toString(),
                bookimage: deepLink.queryParameters['second'],isBack : true
              ),
            );
          }
          break;
        default:
          {
            Get.off(() => userid != null ? MyBottomNavigationBar() : LanguageScreen());
          }
      }
    });
  }

  PendingDynamicLinkData? initialLink;

  Future<void> loadData() async {
    initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      getDeviceInfo();
    }
    Future.delayed(const Duration(seconds: 3), () {
      if (userController.isOnline.value) {
        userController.getuser().whenComplete(() {
          loadData().then((value) {
            if (initialLink != null) {
              initDynamicLinks(context);
            } else {
              Get.off(() => userid != null || userController.isguest.value ? MyBottomNavigationBar() : LanguageScreen());
            }
          });
        });
      } else {
        Get.offAll(() => Downloaded());
      }
    });

    return Scaffold(
      backgroundColor: blackColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Image.asset("assets/images/wixpod_splash.png"),
          ),
        ],
      ),
    );
  }
}
