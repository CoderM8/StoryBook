// ignore_for_file: deprecated_member_use

import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:wixpod/constants/widget/textwidget.dart';
import 'package:wixpod/ui/Single_Story/singlestory_screen.dart';
import 'package:wixpod/ui/player/player_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/audio_constant.dart';
import '../../constants/constant.dart';
import '../../controller/allbook_controller.dart';

class StoriesScreen extends StatelessWidget {
  StoriesScreen({Key? key}) : super(key: key);

  final AllBook_Controller allbookcontroller = Get.put(AllBook_Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Backbutton(),
        centerTitle: true,
        elevation: 0.0,
        title: Styles.regular('Stories'.tr, fs: 22.sp, ff: "Poppins-Bold", fw: FontWeight.bold),
      ),
      body: Stack(
        children: [
          Obx(() {
            allbookcontroller.allbokbool.value;
            return allbookcontroller.allbook != null
                ? SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: const WaterDropHeader(),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus? mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = Styles.regular("pull up load", ff: 'Poppins-Regular', fs: 14.sp);
                        } else if (mode == LoadStatus.loading) {
                          body = const CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = Styles.regular("Load Failed!Click retry!", ff: 'Poppins-Regular', fs: 14.sp);
                        } else if (mode == LoadStatus.canLoading) {
                          body = Styles.regular("release to load more", ff: 'Poppins-Regular', fs: 14.sp);
                        } else {
                          body = Styles.regular("No more Data", ff: 'Poppins-Regular', fs: 14.sp);
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    controller: allbookcontroller.refreshController,
                    onRefresh: allbookcontroller.onRefresh,
                    onLoading: allbookcontroller.onLoading,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0.w, right: 10.w),
                      child: SingleChildScrollView(
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: allbookcontroller.allbook!.onlineMp3.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10.0.r, mainAxisSpacing: 5.0.r, childAspectRatio: 0.6, crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            var data = allbookcontroller.allbook!.onlineMp3[index];
                            return InkWell(
                              onTap: () {
                                Get.to(() => SingleStoryScreen(
                                      bookid: data.aid,
                                      bookimage: data.bookImage,
                                    ));
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ImageView(
                                      imageUrl: data.bookImage,
                                      height: 150.h,
                                      width: 160.w,
                                      memCacheHeight: 350,
                                      oneSideRadius: true,
                                    ),
                                  ),
                                  Container(
                                    height: 50.h,
                                    width: 158.w,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.r), bottomLeft: Radius.circular(10.r))),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Styles.regular(data.bookName,
                                            fs: 13.sp, c: blackColor, ff: "Poppins-Regular", ov: TextOverflow.ellipsis, lns: 1, fw: FontWeight.bold),
                                        Styles.regular(data.authorList[0].authorName,
                                            lns: 1, fs: 13.sp, c: blackColor, ff: "Poppins-Regular", fw: FontWeight.normal),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
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
          }),
          Positioned(
            bottom: 0.h,
            child: buildPanelHeader(
                onTap: () {
                  isdownloaded.value == true
                      ? Get.to(() => PlayerScreen(
                    bookId: playController.getBookId.toString(),
                    bookImage: playController.bookimgurl.value,
                    bookName: playController.getbooktitle.value,
                    bookArtist: playController.getbookauthor.toString(),
                    download: true,
                  ))
                      : Get.to(()=>PlayerScreen(
                    bookId: playController.getBookId.toString(),
                    bookImage: playController.bookimgurl.value,
                    bookName: playController.getbooktitle.toString(),
                    bookArtist: playController.getbookauthor.toString(),
                  ));
                }),
          ),
        ],
      ),
    );
  }
}
