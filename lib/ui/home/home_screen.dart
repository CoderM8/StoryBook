// ignore_for_file: deprecated_member_use

import 'package:wixpod/ads.dart';
import 'package:wixpod/model/home/home_section_by_id_model.dart';
import 'package:wixpod/model/home/home_section_model.dart';
import 'package:wixpod/services/all_services.dart';
import 'package:wixpod/ui/Single_Story/singlestory_screen.dart';
import 'package:wixpod/ui/home/homebannerwisebook_screen.dart';
import 'package:wixpod/ui/home/playlist_screen.dart';
import 'package:wixpod/ui/profile/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/constant.dart';
import '../../constants/widget/home_widget.dart';
import '../../constants/widget/textwidget.dart';
import '../../controller/bottom_navigation_controller.dart';
import '../../controller/home_controller.dart';
import '../../controller/user_controller.dart';
import '../../model/home/home_banner_model.dart';
import '../author/all_author.dart';
import '../author/author_book.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController homeController = Get.put(HomeController());
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
                      imageUrl: logic.isguest.value ? Api.mainAddimage : logic.userImage!,
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
        title: Styles.regular('Home'.tr, fs: 22.sp, ff: "Poppins-Bold", fw: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        controller: bottomNavigationController.homeScroll,
        child: Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: FutureBuilder<HomeBannerModel?>(
              future: AllServices().home(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 370.w,
                            child: Image.asset(
                              "assets/images/img.png",
                              fit: BoxFit.cover,
                              color: whiteColor.withOpacity(0.1),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 350.w,
                            child: Image.asset("assets/images/homeimgwhite.png", color: blackColor, fit: BoxFit.cover),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 15.h, left: 16.w),
                                child: Styles.regular(
                                  'Our_Top_Picks'.tr,
                                  fs: 24.sp,
                                  ff: "Poppins-SemiBold",
                                  c: whiteColor,
                                ),
                              ),
                              SizedBox(height: 45.h),
                              CarouselSlider.builder(
                                itemCount: snapshot.data!.onlineMp3.homeBanner.length,
                                itemBuilder: (context, index, realIndex) {
                                  return ListView(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            admobads().showInterstitialAd();
                                            Get.to(() => PlaylistBooksScreen(
                                                  books: snapshot.data!.onlineMp3.homeBanner[index].bookList,
                                                  playlistName: snapshot.data!.onlineMp3.homeBanner[index].bannerTitle,
                                                ));
                                          },
                                          child: ImageView(
                                            imageUrl: snapshot.data!.onlineMp3.homeBanner[index].bannerImage,
                                            height: 158.w,
                                            width: 120.w,
                                            memCacheHeight: 320,
                                            radius: 10.r,
                                            // fit: BoxFit.cover,
                                          )),
                                      SizedBox(height: 4.h),
                                      Styles.regular(
                                        snapshot.data!.onlineMp3.homeBanner[index].bannerTitle,
                                        fs: 16.sp,
                                        ff: "Poppins-SemiBold",
                                        ov: TextOverflow.ellipsis,
                                        lns: 2,
                                        fw: FontWeight.bold,
                                      ),
                                    ],
                                  );
                                },
                                options: CarouselOptions(
                                  viewportFraction: 0.35,
                                  enlargeCenterPage: true,
                                  aspectRatio: 1.5,
                                  autoPlay: true,
                                  enableInfiniteScroll: true,
                                  onPageChanged: (index, reason) {
                                    homeController.activeindex = index.obs;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0.w, right: 16.w, bottom: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Styles.regular('Author'.tr, fs: 22.sp, ff: "Poppins-Regular"),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => Author());
                              },
                              child: Styles.regular('See_All'.tr, fs: 16.sp, ff: "Poppins-Regular", c: greyColor),
                            ),
                          ],
                        ),
                      ),

                      /// Author  photo
                      Container(
                        height: 111.w,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data!.onlineMp3.latestArtist.take(6).length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => Author_Book(
                                      authorId: snapshot.data!.onlineMp3.latestArtist[index].id,
                                      authorname: snapshot.data!.onlineMp3.latestArtist[index].authorName,
                                      totalBooks: snapshot.data!.onlineMp3.latestArtist[index].totalsongs,
                                    ));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: Column(
                                  children: [
                                    ImageView(
                                      imageUrl: snapshot.data!.onlineMp3.latestArtist[index].authorImage,
                                      height: 80.w,
                                      width: 80.w,
                                      memCacheHeight: 200,
                                      radius: 40.w,
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 22.h,
                                      width: 90.w,
                                      // color: Colors.yellow,
                                      child: Styles.regular(snapshot.data!.onlineMp3.latestArtist[index].authorName,
                                          fs: 14.sp, ff: "Poppins-Regular", ov: TextOverflow.ellipsis),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),

                      admobads().bannerads(),

                      ///Trending Books
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: Styles.regular('TrendingStories'.tr, fs: 22.sp, ff: "Poppins-Regular"),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      Container(
                          height: 420.w,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.onlineMp3.trendingBooks.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  index % 2 == 0
                                      ? Container()
                                      : GestureDetector(
                                          onTap: () {
                                            admobads().showInterstitialAd();
                                            Get.to(() => SingleStoryScreen(
                                                  bookid: snapshot.data!.onlineMp3.trendingBooks[index - 1].aid,
                                                  bookimage: snapshot.data!.onlineMp3.trendingBooks[index - 1].bookImage,
                                                ));
                                          },
                                          child: ShowBook(
                                              index: index,
                                              tcolor: whiteColor,
                                              bookimage: snapshot.data!.onlineMp3.trendingBooks[index - 1].bookImage,
                                              title: snapshot.data!.onlineMp3.trendingBooks[index - 1].bookName,
                                              description:
                                                  parse(snapshot.data!.onlineMp3.trendingBooks[index - 1].bookDescription).body!.text.toString()),
                                        ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  index % 2 != 0
                                      ? GestureDetector(
                                          onTap: () {
                                            admobads().showInterstitialAd();
                                            Get.to(
                                              () => SingleStoryScreen(
                                                bookid: snapshot.data!.onlineMp3.trendingBooks[index].aid,
                                                bookimage: snapshot.data!.onlineMp3.trendingBooks[index].bookImage,
                                              ),
                                            );
                                          },
                                          child: ShowBook(
                                              index: index + 1,
                                              tcolor: whiteColor,
                                              bookimage: snapshot.data!.onlineMp3.trendingBooks[index].bookImage,
                                              title: snapshot.data!.onlineMp3.trendingBooks[index].bookName,
                                              description:
                                                  parse(snapshot.data!.onlineMp3.trendingBooks[index].bookDescription).body!.text.toString()),
                                        )
                                      : Container(),
                                ],
                              );
                            },
                          )),

                      ///Latest Stories
                      SizedBox(height: 30.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: Styles.regular('Latest_Stories'.tr, fs: 22.sp, ff: "Poppins-Regular"),
                        ),
                      ),
                      SizedBox(height: 11.h),
                      Container(
                        height: 271.w,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.onlineMp3.latestAlbum.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(left: 10.w, right: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => SingleStoryScreen(
                                            bookid: snapshot.data!.onlineMp3.latestAlbum[index].aid,
                                            bookimage: snapshot.data!.onlineMp3.latestAlbum[index].bookImage,
                                          ));
                                    },
                                    child: ImageView(
                                      imageUrl: snapshot.data!.onlineMp3.latestAlbum[index].bookImage,
                                      height: 200.w,
                                      width: 140.w,
                                      memCacheHeight: 400,
                                      radius: 15.r,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Container(
                                    height: 50.w,
                                    width: 140.w,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            width: 150.w,
                                            child: Styles.regular(snapshot.data!.onlineMp3.latestAlbum[index].bookName,
                                                lns: 1, ov: TextOverflow.ellipsis, fs: 16.sp, ff: "Poppins-Regular")),
                                        Row(
                                          children: [
                                            RatingBarIndicator(
                                              rating: double.parse(
                                                snapshot.data!.onlineMp3.latestAlbum[index].rateAvg,
                                              ),
                                              direction: Axis.horizontal,
                                              itemCount: 5,
                                              itemSize: 16.78.h.w,
                                              unratedColor: Colors.grey,
                                              itemPadding: EdgeInsets.only(right: 2.0.w),
                                              itemBuilder: (BuildContext context, int index) {
                                                return const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                );
                                              },
                                            ),
                                            Styles.regular(
                                              "(${double.parse(snapshot.data!.onlineMp3.latestAlbum[index].rateAvg)})",
                                              ff: "Poppins-Regular",
                                              fs: 12.sp,
                                              c: blackColor,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      ///HomeSection
                      FutureBuilder<HomeSectionModel?>(
                          future: AllServices().homeSection(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData || snapshot.connectionState == ConnectionState.done) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.audioBook.length,
                                  itemBuilder: (BuildContext context, index) {
                                    return FutureBuilder<HomeSectionbyIdModel?>(
                                        future: AllServices().homeSectionbyID(id: snapshot.data!.audioBook[index].id, page: 1),
                                        builder: (context, bookData) {
                                          if (bookData.hasData || bookData.connectionState == ConnectionState.done) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(bottom: 10.h, top: 20.h, left: 16.w, right: 16.w),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Styles.regular(snapshot.data!.audioBook[index].sectionTitle,
                                                          fs: 22.sp, ff: "Poppins-Regular", ta: TextAlign.start),
                                                      InkWell(
                                                        onTap: () {
                                                          Get.to(() => HomeBannerAllScreen(
                                                              id: snapshot.data!.audioBook[index].id,
                                                              name: snapshot.data!.audioBook[index].sectionTitle));
                                                        },
                                                        child: Styles.regular(
                                                          'See_All'.tr,
                                                          c: greyColor,
                                                          ff: "Poppins-Regular",
                                                          fs: 15.sp,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                if (bookData.data != null && bookData.data!.audioBook.isNotEmpty)
                                                  SizedBox(
                                                    height: 230.w,
                                                    child: ListView.separated(
                                                      separatorBuilder: (context, i) {
                                                        return SizedBox(width: 20.w);
                                                      },
                                                      physics: BouncingScrollPhysics(),
                                                      scrollDirection: Axis.horizontal,
                                                      shrinkWrap: true,
                                                      padding: EdgeInsets.only(left: 15.w),
                                                      itemCount: bookData.data!.audioBook.length,
                                                      itemBuilder: (context, index2) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            Get.to(() => SingleStoryScreen(
                                                                  bookid: bookData.data!.audioBook[index2].aid,
                                                                  bookimage: bookData.data!.audioBook[index2].bookImage,
                                                                ));
                                                          },
                                                          child: ImageView(
                                                            imageUrl: bookData.data!.audioBook[index2].bookImage,
                                                            height: 200.w,
                                                            width: 140.w,
                                                            memCacheHeight: 400,
                                                            radius: 15.r,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                              ],
                                            );
                                          } else {
                                            return SizedBox.shrink();
                                          }
                                        });
                                  });
                            } else {
                              return Shimmer.fromColors(
                                baseColor: shimmerGray,
                                highlightColor: greyColor,
                                child: Center(
                                  child: Container(
                                    height: 230.w,
                                    width: 153.w,
                                    child: Icon(
                                      Icons.all_inclusive_outlined,
                                      size: 30.h.w,
                                      color: whiteColor,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),

                      ///Playlist
                      if (snapshot.data!.onlineMp3.playlist.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 15.h, left: 16.w),
                            child: Styles.regular('Playlist'.tr, fs: 22.sp, ff: "Poppins-Regular"),
                          ),
                        ),
                      SizedBox(height: 11.h),
                      if (snapshot.data!.onlineMp3.playlist.isNotEmpty)
                        Container(
                          height: 271.w,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data!.onlineMp3.playlist.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => PlaylistBooksScreen(
                                              books: snapshot.data!.onlineMp3.playlist[index].bookList,
                                              playlistName: snapshot.data!.onlineMp3.playlist[index].playlistName,
                                            ));
                                      },
                                      child: ImageView(
                                        imageUrl: snapshot.data!.onlineMp3.playlist[index].playlistImage,
                                        height: 200.w,
                                        width: 140.w,
                                        memCacheHeight: 400,
                                        radius: 15.r,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Styles.regular(snapshot.data!.onlineMp3.playlist[index].playlistName,ta: TextAlign.center,
                                        lns: 1, ov: TextOverflow.ellipsis, fs: 16.sp, ff: "Poppins-Regular"),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  );
                } else {
                  return Center(
                      child: Shimmer.fromColors(
                    baseColor: shimmerGray,
                    highlightColor: greyColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 35.h),
                          Container(
                            height: 25.w,
                            width: 130.w,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: whiteColor),
                          ),
                          SizedBox(height: 35.h),
                          CarouselSlider.builder(
                            itemCount: 4,
                            itemBuilder: (context, index, realIndex) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 8.h),
                                    height: 170.w,
                                    width: 120.w,
                                    decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                                  ),
                                  Container(
                                    height: 20.w,
                                    width: 90.w,
                                    decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                                  )
                                ],
                              );
                            },
                            options: CarouselOptions(
                              height: 250.h,
                              viewportFraction: 0.35,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              enableInfiniteScroll: true,
                              onPageChanged: (index, reason) {
                                homeController.activeindex = index.obs;
                              },
                            ),
                          ),
                          SizedBox(height: 35.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 20.w,
                                width: 80.00.w,
                                decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                              ),
                              Container(
                                height: 20.w,
                                width: 80.00.w,
                                decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                              )
                            ],
                          ),
                          SizedBox(height: 10.h),
                          SizedBox(
                            height: 110.w,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              padding: EdgeInsets.only(top: 10.h),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Container(
                                      height: 80.w,
                                      width: 80.w,
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: whiteColor),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      height: 10.w,
                                      width: 50.w,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: whiteColor),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, i) {
                                return SizedBox(width: 8.w);
                              },
                            ),
                          ),
                          SizedBox(height: 45.h),
                          Container(
                            height: 20.w,
                            width: 120.w,
                            decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                          ),
                          SizedBox(height: 15.h),
                          ListView.separated(
                            scrollDirection: Axis.vertical,
                            itemCount: 2,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, i) {
                              return SizedBox(height: 10.h);
                            },
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 203.08.w,
                                        width: 139.00.w,
                                        decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                                      ),
                                      SizedBox(width: 15.w),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 100.w,
                                            width: 70.w,
                                            decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                                          ),
                                          SizedBox(height: 5.h),
                                          Container(
                                            height: 15.w,
                                            width: 150.w,
                                            decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                                          ),
                                          SizedBox(height: 5.h),
                                          Container(
                                            height: 15.w,
                                            width: 150.w,
                                            decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ));
                }
              }),
        ),
      ),
    );
  }
}
