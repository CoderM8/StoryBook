// ignore_for_file: deprecated_member_use

import 'package:wixpod/controller/bookdetails_controller.dart';
import 'package:wixpod/services/all_services.dart';
import 'package:wixpod/ui/Single_Story/singlestory_screen.dart';
import 'package:wixpod/ui/profile/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/constant.dart';
import '../../constants/widget/textwidget.dart';
import '../../controller/bottom_navigation_controller.dart';
import '../../controller/user_controller.dart';
import '../../model/favourite_model/getfavourite_model.dart';

class FavouriteBook extends StatelessWidget {
  FavouriteBook({Key? key}) : super(key: key);

  final BookDetailsController bookController = Get.put(BookDetailsController());
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
                      memCacheHeight: 100,
                      fadeInDuration: const Duration(milliseconds: 100),
                      imageUrl: userController.isguest.value ? Api.mainAddimage : userController.userImage!,
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
          child: InkWell(
              onTap: () {
                advancedDrawerController.showDrawer();
              },
              child: SvgPicture.asset("assets/icons/drawer.svg", color: whiteColor, width: 30.w, height: 30.h)),
        ),
        centerTitle: true,
        elevation: 0.0,
        title: Styles.regular('Favourite'.tr, fs: 22.sp, ff: "Poppins-Bold", fw: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        controller: bottomNavigationController.favouriteScroll,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.r),
          child: GetBuilder<BookDetailsController>(
            builder: (logic) {
              return FutureBuilder<GetFavouriteModel?>(
                future: AllServices().getfavouriteBook(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      bookController.isLike.value = false;
                      bookController.isLike.value = snapshot.data!.onlineMp3.isNotEmpty ? snapshot.data!.onlineMp3[0].isFavourite : false;
                    });
                    if (snapshot.data!.onlineMp3.isNotEmpty) {
                      return GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.onlineMp3.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 20.0.r, mainAxisSpacing: 0.0.r, childAspectRatio: 160.w / 260.h, crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return Container(
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  height: 260.h,
                                  width: 160.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: const Color(0xEFD3D1D1),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.red,
                                            onTap: () {

                                               Get.to(() => SingleStoryScreen(
                                                   bookid: snapshot.data!.onlineMp3[index].aid,
                                                   bookimage: snapshot.data!.onlineMp3[index].bookImage));
                                            },
                                            child: Container(
                                                height: 210.h,
                                                width: MediaQuery.sizeOf(context).width,
                                                decoration: const BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(color: Colors.black26, offset: Offset(1.0, 1.0), blurRadius: 12.0, spreadRadius: 1.0),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(5.r)),
                                                  child: ImageView(
                                                    imageUrl: snapshot.data!.onlineMp3[index].bookImage,
                                                    height: 170.h,
                                                    width: 120.w,
                                                    memCacheHeight: 370,
                                                  ),
                                                )),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 5.w, right: 5.w,bottom: 5.h),
                                            height: 18.h,
                                            width: double.infinity,
                                            child: Styles.regular(snapshot.data!.onlineMp3[index].bookName,
                                                fs: 13.sp, c: Colors.black, ff: "Poppins-Regular", fw: FontWeight.bold, ov: TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ),
                                      Positioned(bottom: 25,
                                        child: InkWell(
                                          onTap: () async {

                                             await AllServices()
                                                 .favouriteBook(bookid: snapshot.data!.onlineMp3[index].aid)
                                                 .then((val) async => {
                                                       val!.onlineMp3[0].success == "1"
                                                           ? bookController.isLike.value = true
                                                           : bookController.isLike.value = false,
                                                     })
                                                 .whenComplete(() => bookController.update());
                                          },
                                          child: Container(
                                              height: 50.r,
                                              width: 50.r,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: whiteColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.favorite_outlined,
                                                color: redColor,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 2.5),
                        child: Center(
                          child: Styles.regular('No_Favourite_Stories'.tr,
                              fs: 15.sp, ff: "Poppins-Regular", ov: TextOverflow.ellipsis, fw: FontWeight.bold),
                        ),
                      );
                    }
                  } else {
                    return Shimmer.fromColors(
                      baseColor: shimmerGray,
                      highlightColor: greyColor,
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 6,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 20.0.r, mainAxisSpacing: 0.0.r, childAspectRatio: 160.w / 260.h, crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return Container(
                            height: 260.h,
                            width: 160.w,
                            margin: EdgeInsets.only(top: 12.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
