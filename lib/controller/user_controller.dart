// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:wixpod/constants/constant.dart';
import 'package:wixpod/services/all_services.dart';
import 'package:wixpod/ui/Single_Story/singlestory_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  String? userName;
  String? userEmail;
  String? userImage;
  String? phone;
  String? pn_countrycode;
  RxBool isguest = false.obs;

  RxBool isOnline = true.obs;
  Future<bool> hasNetwork() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('user_id');
    isguest.value = prefs.getBool('guest') ?? false;
    try {
      final result = await InternetAddress.lookup('www.google.com');
      isOnline.value = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline.value = false;
      return false;
    }
  }

  @override
  void onInit() {
    dynamicLinkInit();
    hasNetwork();
    super.onInit();
  }

  /// when Application in background
  dynamicLinkInit() {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      switch (dynamicLinkData.link.path) {
        case "/Wixpod":
          {
            Get.to(
              () => SingleStoryScreen(
                bookid: dynamicLinkData.link.queryParameters['id'].toString(),
                bookimage: dynamicLinkData.link.queryParameters['second'],
              ),
            );
          }
          break;
        default:
          {}
      }
    });
  }

  Future getuser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('user_id');
    isguest.value = prefs.getBool('guest') ?? false;
    if (userid != null) {
      await AllServices().getuserservice(userid: userid).then((value) async {
        if (value != null) {
          await prefs.setString('name', value.onlineMp3[0].name);
          await prefs.setString('email', value.onlineMp3[0].email);
          await prefs.setString('image', value.onlineMp3[0].userImage);
          await prefs.setString('phone', value.onlineMp3[0].phone);
          await prefs.setString('pn_countrycode', value.onlineMp3[0].pnCountrycode);

          userName = prefs.getString('name');
          userEmail = prefs.getString('email');
          userImage = prefs.getString('image');
          phone = prefs.getString('phone');
          pn_countrycode = prefs.getString('pn_countrycode');
          await getSubscriptionPlan();
          update();
        }
      });
    }
  }
}
