// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:html/parser.dart';
import 'package:wixpod/model/subscription_model/getsubscription_model.dart';
import 'package:wixpod/services/all_services.dart';

/// Color
const Color shimmerGray = Color(0xffd2cece);
const Color blackColor = Colors.black;
const Color redColor = Colors.red;
const Color whiteColor = Colors.white;
const Color greyColor = Colors.grey;
const Color pinkColor = Color(0xffdb8085);

String? userid;
String planId = '';
RxInt isActivePlan = 0.obs;
RxString isSuccess = '0'.obs;
RxInt isMemberAdd = 0.obs;
RxBool isLoading = false.obs;
RxBool subscribe = false.obs;
RxString success = ''.obs;

String version = '';
String buildNumber = '';

final box = GetStorage();

/// Get AppInfo
Future<void> getVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  version = packageInfo.version;
  buildNumber = packageInfo.buildNumber;
  debugPrint('version ---- ${version}');
  debugPrint('buildNumber ---- ${buildNumber}');
}

enum PurchasesType {
  /// A type of SKU for in-app products.
  inApp,

  /// A type of SKU for subscriptions.
  sub
}

/// getUserId
Future<void> getUserId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  userid = prefs.getString('user_id');
  debugPrint('USER ID :::: ${userid}');
}

/// getSubscriptionPlan
Future<GetSubscriptionModel?> getSubscriptionPlan() async {
  if (userid != null) {
    GetSubscriptionModel? getPlan = await AllServices().getSubscription();
    if (getPlan!.audioBook.isNotEmpty) {
      planId = getPlan.audioBook[0].planId;
      debugPrint('PlanId get ::::: ${planId}');
    }
  }
  return null;
}

/// privacypolicy string convert
String htmlString(String data) {
  final document = parse(data);
  final String parsedString = parse(document.body!.text).documentElement!.text;
  return parsedString;
}

const String appShareAndroid = 'https://play.google.com/store/apps/details?id=com.wixpod';
const String appShareIOS = 'https://apps.apple.com/in/app/wixpod/id6467605650';

String getAppShare() {
  if (Platform.isIOS) {
    return appShareIOS;
  } else {
    return appShareAndroid;
  }
}

/// getUserLanguage
RxString languagename = ''.obs;
String languagecode = '';

getUserLanguage() async {
   languagecode = box.read('languageCode') ?? 'en';
   languagename.value = box.read('languageName') ?? 'English';
}

/// Dynamic Link
const String prefixLink = 'https://wixpod.page.link';

Future<Uri> createDynamicLink({id, required String path, required String image}) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: prefixLink,
    link: Uri.parse(id == null ? '$prefixLink$path' : "$prefixLink$path?id=$id&second=$image"),
    androidParameters: const AndroidParameters(
      packageName: 'com.wixpod',
    ),
    iosParameters: const IOSParameters(
      appStoreId: "6467605650",
      bundleId: 'com.wixpod',
    ),
  );
  final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters, shortLinkType: ShortDynamicLinkType.short);

  return dynamicLink.shortUrl;
}

/// getAndroidVersion
bool isAndroidVersionUp13 = false;

getDeviceInfo() async {
  String? firstPart;
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final allInfo = deviceInfo.data;
  if (allInfo['version']["release"].toString().contains(".")) {
    int indexOfFirstDot = allInfo['version']["release"].indexOf(".");
    firstPart = allInfo['version']["release"].substring(0, indexOfFirstDot);
  } else {
    firstPart = allInfo['version']["release"];
  }
  int intValue = int.parse(firstPart!);
  if (intValue >= 13) {
    isAndroidVersionUp13 = true;
  } else {
    isAndroidVersionUp13 = false;
  }
}

/// snackbar
ShowSnackBar({message}) {
  return Get.snackbar(
    'Wixpod',
    message,
    backgroundColor: whiteColor,
    duration: const Duration(seconds: 2),
  );
}

/// OnBoarding
List<OnBoarding> onboardinglist = [
  OnBoarding(title: "obtitle1".tr, imgUrl: "assets/images/wixpodicon.jpg", description: "obsubtitle1".tr),
  OnBoarding(title: "obtitle2".tr, imgUrl: "assets/images/bookon2.png", description: "obsubtitle2".tr),
  OnBoarding(title: "obtitle3".tr, imgUrl: "assets/images/bookon3.png", description: "obsubtitle3".tr),
];

class OnBoarding {
  final String title;
  final String imgUrl;
  final String description;

  OnBoarding({required this.title, required this.imgUrl, required this.description});
}

/// API
class Api {
  static const mainApi = 'https://wixpod.com/adminpanel/api.php';
  static const mainAddimage = 'https://wixpod.com/adminpanel/images/add-image.png';
}

class ImageView extends StatelessWidget {
  ImageView({Key? key, required this.imageUrl, this.height, this.width, this.radius, this.memCacheHeight, this.boxfit, this.oneSideRadius = false})
      : super(key: key);

  final String imageUrl;
  final double? width;
  final double? height;
  final double? radius;
  final BoxFit? boxfit;
  final int? memCacheHeight;
  final bool? oneSideRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          oneSideRadius == true ? BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)) : BorderRadius.circular(radius ?? 0.r),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: boxfit ?? BoxFit.cover,
        memCacheHeight: memCacheHeight,
        fadeInDuration: const Duration(milliseconds: 0),
        placeholderFadeInDuration: const Duration(milliseconds: 0),
        placeholder: (context, url) => Center(
          child: Shimmer.fromColors(
            baseColor: shimmerGray,
            highlightColor: greyColor,
            child: Container(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              color: Colors.white,
            ),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}

Widget buildContainer({String? svg, Color? colors, double? imgh, double? imgw}) {
  return Container(
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
    ),
    child: Center(
      child: SvgPicture.asset(
        svg!,
        height: imgh,
        width: imgw,
        fit: BoxFit.scaleDown,
        color: colors,
      ),
    ),
  );
}
