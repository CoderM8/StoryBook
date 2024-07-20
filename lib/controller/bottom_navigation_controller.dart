// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

late AdvancedDrawerController advancedDrawerController;

class BottomNavigationController extends GetxController {
  RxInt selectedIndex = 0.obs;

  List<Widget> tabPage = [];

  ScrollController homeScroll = ScrollController();
  ScrollController discoverScroll = ScrollController();
  ScrollController searchScroll = ScrollController();
  ScrollController favouriteScroll = ScrollController();

  @override
  Future<void> onInit() async {
    advancedDrawerController = AdvancedDrawerController();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  var tabs = [
    BottomNavigationBarItem(
        activeIcon: SvgPicture.asset('assets/icons/homeactive.svg', height: 25.w, width: 25.w),
        icon: SvgPicture.asset('assets/icons/home.svg', height: 25.w, width: 25.w),
        label: 'Home'.tr),
    BottomNavigationBarItem(
        activeIcon: SvgPicture.asset('assets/icons/discoveractive.svg', height: 25.w, width: 25.w),
        icon: SvgPicture.asset('assets/icons/discover.svg', height: 25.w, width: 25.w),
        label: 'Discover'.tr),
    BottomNavigationBarItem(
        activeIcon: SvgPicture.asset('assets/icons/searchactive.svg', height: 25.w, width: 25.w),
        icon: SvgPicture.asset('assets/icons/search.svg', height: 25.w, width: 25.w),
        label: 'Search'.tr),
    BottomNavigationBarItem(
        activeIcon: SvgPicture.asset('assets/icons/favouriteactive.svg', height: 25.w, width: 25.w),
        icon: SvgPicture.asset('assets/icons/favourite.svg', height: 25.w, width: 25.w),
        label: 'Favourite'.tr),
  ];
}
