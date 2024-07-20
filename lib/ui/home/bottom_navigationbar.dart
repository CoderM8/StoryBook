import 'dart:io';

import 'package:wixpod/constants/constant.dart';
import 'package:wixpod/constants/widget/textwidget.dart';
import 'package:wixpod/controller/user_controller.dart';
import 'package:wixpod/ui/category/search_screen.dart';
import 'package:wixpod/ui/drawer/appdrawer.dart';
import 'package:wixpod/ui/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/audio_constant.dart';
import '../../controller/bottom_navigation_controller.dart';
import '../../controller/play_controller.dart';
import '../category/discover_screen.dart';
import '../favourite/favourite_book.dart';
import 'home_screen.dart';

class MyBottomNavigationBar extends StatelessWidget {
  MyBottomNavigationBar({Key? key}) : super(key: key);

  final BottomNavigationController bottomNavigationController = Get.put(BottomNavigationController());
  final PlayController playController = Get.put(PlayController());
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    debugPrint('USER ID :::: ${userid}');
    debugPrint('SUBSCRIPTION :::: ${subscribe.value}');
    bottomNavigationController.tabPage = [
      HomeScreen(),
      DiscoverScreen(),
      SearchScreen(searchtext: ''),
      FavouriteBook(),
    ];
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
              actionsPadding: EdgeInsets.only(right: 15.w, bottom: 10.h),
              title: Styles.regular(
                'Exitapp'.tr,
                ta: TextAlign.start,
                fs: 20.sp,
                ff: 'Poppins-Bold',
                c: blackColor,
              ),
              content: Styles.regular(
                'Exitthisapp'.tr,
                ta: TextAlign.start,
                fs: 15.sp,
                lns: 2,
                ff: 'Poppins-Medium',
                c: blackColor,
              ),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(greyColor),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)))),
                  child: Styles.regular(
                    'No'.tr,
                    fs: 15.sp,
                    ff: 'Poppins-Regular',
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(blackColor),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)))),
                  child: Styles.regular(
                    'Yes'.tr,
                    fs: 15.sp,
                    ff: 'Poppins-Regular',
                  ),
                  onPressed: () {
                    exit(0);
                  },
                ),
              ],
            );
          },
        );
      },
      child: AdvancedDrawer(
        backdropColor: blackColor,
        controller: advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        disabledGestures: false,
        childDecoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.r)),
        ),
        drawer: DrawerScreen(),
        child: Scaffold(
          bottomNavigationBar: Obx(() {
            return BottomNavigationBar(
              elevation: 0,
              backgroundColor: blackColor,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: whiteColor,
              unselectedItemColor: greyColor,
              onTap: (index) {
                bottomNavigationController.selectedIndex.value = index;
                switch (bottomNavigationController.selectedIndex.value) {
                  case 0:
                    if (bottomNavigationController.homeScroll.positions.isNotEmpty)
                      bottomNavigationController.homeScroll.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
                    break;
                  case 1:
                    if (bottomNavigationController.discoverScroll.positions.isNotEmpty)
                      bottomNavigationController.discoverScroll.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
                    break;
                  case 2:
                    if (bottomNavigationController.searchScroll.positions.isNotEmpty)
                      bottomNavigationController.searchScroll.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
                    break;
                  case 3:
                    if (bottomNavigationController.favouriteScroll.positions.isNotEmpty)
                      bottomNavigationController.favouriteScroll.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
                    break;
                }
              },
              items: bottomNavigationController.tabs,
              currentIndex: bottomNavigationController.selectedIndex.value,
            );
          }),
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                Expanded(child: Obx(() {
                  return IndexedStack(index: bottomNavigationController.selectedIndex.value, children: bottomNavigationController.tabPage);
                })),
                buildPanelHeader(
                  onTap: () async {
                    isdownloaded.value == true
                        ? Get.to(() => PlayerScreen(
                              bookId: playController.getBookId.toString(),
                              bookImage: playController.bookimgurl.value,
                              bookName: playController.getbooktitle.value,
                              bookArtist: playController.getbookauthor.toString(),
                              download: true,
                            ))
                        : Get.to(() => PlayerScreen(
                              bookId: playController.getBookId.toString(),
                              bookImage: playController.bookimgurl.value,
                              bookName: playController.getbooktitle.toString(),
                              bookArtist: playController.getbookauthor.toString(),
                            ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
