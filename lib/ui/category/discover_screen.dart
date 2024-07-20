// ignore_for_file: deprecated_member_use

import 'package:wixpod/ads.dart';
import 'package:wixpod/services/all_services.dart';
import 'package:wixpod/ui/Single_Story/singlestory_screen.dart';
import 'package:wixpod/ui/category/search_screen.dart';
import 'package:wixpod/ui/profile/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/constant.dart';
import '../../constants/widget/textwidget.dart';
import '../../controller/bottom_navigation_controller.dart';
import '../../controller/home_controller.dart';
import '../../controller/user_controller.dart';
import '../../model/home/home_banner_model.dart';
import 'categorywise_books.dart';

class DiscoverScreen extends StatelessWidget {
  DiscoverScreen({Key? key}) : super(key: key);

  final HomeController homeController = Get.put(HomeController());
  final UserController userController = Get.put(UserController());
  final BottomNavigationController bottomNavigationController = Get.put(BottomNavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GetBuilder<UserController>(
              init: UserController(),
              builder: (logic) {
                return InkWell(
                  onTap: () {
                    Get.to(() => ProfileScreen());
                  },
                  child: Container(
                    height: 50.h,
                    width: 50.w,
                    margin: EdgeInsets.only(right: 15.h, top: 5.h, bottom: 5.h),
                    child: CachedNetworkImage(
                      imageUrl: userController.isguest.value ? Api.mainAddimage : userController.userImage!,
                      memCacheHeight: 50,
                      fadeInDuration: const Duration(milliseconds: 100),
                      errorWidget: (context, e, url) => Icon(Icons.error_rounded),
                      imageBuilder: (context, imageProvider) {
                        return CircleAvatar(
                          backgroundImage: imageProvider,
                          backgroundColor: Colors.transparent,
                          maxRadius: 20.0,
                        );
                      },
                    ),
                  ),
                );
              }),
        ],
        leading: Padding(
          padding: EdgeInsets.only(left: 30, bottom: 10.h, top: 10.h),
          child: GestureDetector(
              onTap: () {
                advancedDrawerController.showDrawer();
              },
              child: SvgPicture.asset("assets/icons/drawer.svg", color: whiteColor, width: 30.w, height: 30.h)),
        ),
        centerTitle: true,
        elevation: 0.0,
        title: Styles.regular('Discover'.tr, fs: 22.sp, ff: "Poppins-Bold", fw: FontWeight.bold),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
            child: KeyboardVisibilityBuilder(builder: (context, iskey) {
              if (!iskey) {
                homeController.focusNode.unfocus();
              }
              return TextField(
                controller: homeController.search,
                cursorColor: Colors.black54,
                onSubmitted: (value) {
                  if (homeController.search.text.isNotEmpty) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return SearchScreen(
                          searchtext: homeController.search.text,
                        );
                      },
                    )).then((sdf) {
                      homeController.search.clear();
                    });
                  }
                },
                focusNode: homeController.focusNode,
                autofocus: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: 'Search_stories'.tr,
                  hintStyle: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black54,
                    fontFamily: 'Poppins-Medium',
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
                    child: Icon(
                      Icons.search,
                      color: Colors.black54,
                      size: 30.h.w,
                    ),
                  ),
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontFamily: "Poppins-Medium",
                  fontSize: 20.sp,
                  color: Colors.black54,
                ),
              );
            }),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: bottomNavigationController.discoverScroll,
              child: FutureBuilder<HomeBannerModel?>(
                  future: AllServices().home(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData || snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.h
                          ),
                          if (snapshot.data != null && snapshot.data!.onlineMp3.trendingBooks.isNotEmpty)
                            SizedBox(
                              height: 175.w,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: snapshot.data!.onlineMp3.trendingBooks.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              () => SingleStoryScreen(
                                                bookid: snapshot.data!.onlineMp3.trendingBooks[index].aid,
                                                bookimage: snapshot.data!.onlineMp3.trendingBooks[index].bookImage,
                                              ),
                                            );
                                          },
                                          child: ImageView(
                                            imageUrl: snapshot.data!.onlineMp3.trendingBooks[index].bookImage,
                                            height: 175.w,
                                            width: 120.w,
                                            memCacheHeight: 350,boxfit: BoxFit.cover,
                                            radius: 5.r,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          SizedBox(
                              height: 10.h
                          ),
                          Center(child: admobads().bannerads()),

                          ///============categories===========
                          if (snapshot.data != null && snapshot.data!.onlineMp3.categorylist.isNotEmpty)
                            CustomScrollView(
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              slivers: [
                                SliverList(
                                  delegate: SliverChildListDelegate(
                                    [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Divider(
                                            height: 1.h,
                                            color: whiteColor,
                                            endIndent: 10.w,
                                          )),
                                          Center(child: Styles.regular('Library'.tr, fs: 22.sp, ff: "Poppins-SemiBold")),
                                          Expanded(
                                              child: Divider(
                                            height: 1.h,
                                            color: whiteColor,
                                            indent: 10.w,
                                          )),
                                        ],
                                      ),
                                      SizedBox(height: 12.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20.r),
                                        child: GridView.builder(
                                          scrollDirection: Axis.vertical,
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.onlineMp3.categorylist.length,
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              mainAxisSpacing: 10.h, crossAxisSpacing: 10.w, childAspectRatio: 156 / 155, crossAxisCount: 2),
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Get.to(() => CategoryWiseBooksScreen(
                                                      catId: snapshot.data!.onlineMp3.categorylist[index].cid,
                                                      catname: snapshot.data!.onlineMp3.categorylist[index].categoryName,
                                                      totalBook: snapshot.data!.onlineMp3.categorylist[index].totalsongs,
                                                    ));
                                              },
                                              child: Stack(
                                                fit: StackFit.expand,
                                                alignment: AlignmentDirectional.bottomCenter,
                                                children: [
                                                  Container(
                                                    foregroundDecoration: BoxDecoration(
                                                      color: blackColor.withOpacity(0.9),
                                                      borderRadius:
                                                          BorderRadius.only(bottomLeft: Radius.circular(10.r), bottomRight: Radius.circular(10.r)),
                                                      gradient: LinearGradient(colors: [
                                                        blackColor.withOpacity(0.6),
                                                        blackColor.withOpacity(0.0),
                                                        blackColor.withOpacity(0.0),
                                                        blackColor.withOpacity(0.0),
                                                      ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                                                    ),
                                                    child: ImageView(
                                                      imageUrl: snapshot.data!.onlineMp3.categorylist[index].categoryImage,
                                                      memCacheHeight: 350,
                                                      radius: 10.r,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 10,
                                                    child: SizedBox(
                                                      width: 160.w,
                                                      child: Styles.regular(
                                                        snapshot.data!.onlineMp3.categorylist[index].categoryName,
                                                        fs: 15.sp,
                                                        ff: "Poppins-Bold",
                                                        lns: 1,
                                                        ov: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          else
                            Padding(
                              padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 4),
                              child: Center(child: Styles.regular('No_Data'.tr)),
                            )
                        ],
                      );
                    } else {
                      return Center(
                          child: Shimmer.fromColors(
                        baseColor: shimmerGray,
                        highlightColor: greyColor,
                        child: Container(
                          color: Colors.white,
                        ),
                      ));
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
