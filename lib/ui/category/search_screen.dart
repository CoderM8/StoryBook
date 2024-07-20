// ignore_for_file: deprecated_member_use

import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:wixpod/controller/bottom_navigation_controller.dart';
import 'package:wixpod/controller/user_controller.dart';
import 'package:wixpod/model/search/search_model.dart';
import 'package:wixpod/services/all_services.dart';
import 'package:wixpod/ui/Single_Story/singlestory_screen.dart';
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
import '../../controller/search_controller.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key, this.searchtext}) : super(key: key);

  final String? searchtext;
  final SearchhController searchhController = Get.put(SearchhController());
  final UserController userController = Get.put(UserController());
  final BottomNavigationController bottomNavigationController = Get.put(BottomNavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: searchtext!.isNotEmpty
            ? Backbutton()
            : Padding(
              padding: EdgeInsets.only(left: 30, bottom: 10.h, top: 10.h),
              child: InkWell(
                  onTap: () {
                    advancedDrawerController.showDrawer();
                  },
                  child: SvgPicture.asset("assets/icons/drawer.svg", color: whiteColor, width: 30.w, height: 30.h)),
            ),
        actions: [
          if (searchtext!.isEmpty)
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
        centerTitle: true,
        elevation: 0.0,
        title: Styles.regular(searchtext!.isNotEmpty ? searchtext! : 'Search'.tr, fs: 22.sp, ff: "Poppins-Bold", fw: FontWeight.bold),
      ),
      body: Column(
        children: [
          if (searchtext!.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
              child: KeyboardVisibilityBuilder(builder: (context, iskey) {
                if (!iskey) {
                  searchhController.focusNode.unfocus();
                }
                return TextField(
                  controller: searchhController.search,
                  cursorColor: Colors.black54,
                  onSubmitted: (value) {
                    if (searchhController.search.text.isNotEmpty) {
                      searchhController.search.text = value.toString();
                      searchhController.isRefresh.value = !searchhController.isRefresh.value;
                    }
                  },
                  focusNode: searchhController.focusNode,
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
          Obx(() {
            searchhController.isRefresh.value;
            return Expanded(
              child: SingleChildScrollView(
                controller: bottomNavigationController.searchScroll,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  child: FutureBuilder<SearchModel?>(
                      future: AllServices()
                          .searchservice(
                              searchtext: searchhController.search.text.isNotEmpty ? searchhController.search.text : searchtext,
                              userid: userid)
                          .then((value) {
                        searchhController.search.clear();
                        return value;
                      }),
                      builder: (context, snapshot) {
                        if (snapshot.hasData || snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data!.audioBook.isNotEmpty) {
                            return GridView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data!.audioBook.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 10.0.r, mainAxisSpacing: 5.0.r, childAspectRatio: 0.6, crossAxisCount: 3),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Get.to(() => SingleStoryScreen(
                                          bookid: snapshot.data!.audioBook[index].aid,
                                          bookimage: snapshot.data!.audioBook[index].bookImage,
                                        ));
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 8.h, bottom: 10.h),
                                        height: 198.h,
                                        width: 170.w,
                                        child: ImageView(
                                          imageUrl: snapshot.data!.audioBook[index].bookImage,
                                          height: 150.h,
                                          width: 160.w,
                                          memCacheHeight: 300,
                                          radius: 10.r,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0.h,
                                        width: 112.w,
                                        child: Container(
                                          height: 40.h,
                                          width: 158.w,
                                          decoration: BoxDecoration(
                                              color: whiteColor,
                                              borderRadius:
                                                  BorderRadius.only(bottomRight: Radius.circular(10.r), bottomLeft: Radius.circular(10.r))),
                                          child: Center(
                                            child: Styles.regular(snapshot.data!.audioBook[index].bookName,
                                                c: blackColor,
                                                fs: 14.sp,
                                                ff: "Poppins-Regular",lns: 2,
                                                ov: TextOverflow.ellipsis,
                                                fw: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                                child: Padding(
                                  padding:  EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 2.5),
                                  child: Styles.regular('No_Search_Results'.tr,
                                      fs: 14.sp, c: whiteColor, ff: "Poppins-Regular", ov: TextOverflow.ellipsis, fw: FontWeight.bold),
                                ));
                          }
                        } else {
                          return Container(
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: 12,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 10.0.r, mainAxisSpacing: 5.0.r, childAspectRatio: 0.55, crossAxisCount: 3),
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: shimmerGray,
                                  highlightColor: greyColor,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 8.h, bottom: 10.h),
                                    height: 198.h,
                                    width: 170.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
