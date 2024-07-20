// ignore_for_file: deprecated_member_use

import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:wixpod/ui/Single_Story/singlestory_screen.dart';
import 'package:wixpod/ui/player/player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/audio_constant.dart';
import '../../constants/constant.dart';
import '../../constants/widget/textwidget.dart';
import '../../controller/allauthor_controller.dart';
import '../../controller/user_controller.dart';

class Author_Book extends GetView {
  Author_Book({Key? key, required this.authorId,required this.totalBooks, this.authorname}) : super(key: key);

  final String authorId;
  final String? authorname;
  final int totalBooks;

  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    final AllAuthorBook_Controller allAuthorBook_Controller = Get.put(AllAuthorBook_Controller(authorId: authorId));

    return Scaffold(
      appBar: AppBar(
        leading: Backbutton(),
        centerTitle: true,
        elevation: 0.0,
        title: Styles.regular(authorname!, fs: 22.sp, ff: "Poppins-Bold", fw: FontWeight.bold),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0.w, right: 10.w),
              child: Obx(() {
                allAuthorBook_Controller.authorBookbool.value;
                return allAuthorBook_Controller.authorBook != null
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
                        controller: allAuthorBook_Controller.refreshController,
                        onRefresh: allAuthorBook_Controller.onRefresh,
                        onLoading: allAuthorBook_Controller.onLoading,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0.w, right: 10.w),
                          child: allAuthorBook_Controller.authorBook!.onlineMp3!.isNotEmpty
                              ? GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: allAuthorBook_Controller.authorBook!.onlineMp3!.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 10.0.r, mainAxisSpacing: 5.0.r, childAspectRatio: 0.6, crossAxisCount: 3),
                                  itemBuilder: (context, index) {
                                    var data = allAuthorBook_Controller.authorBook!.onlineMp3![index];
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(SingleStoryScreen(
                                          bookid: data.aid,
                                          bookimage: data.bookImage,
                                        ));
                                      },
                                      child: Column(

                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
                                              child: CachedNetworkImage(
                                                imageUrl: data.bookImage!,
                                                height: 150.w,
                                                width: 160.w,
                                                fit: BoxFit.cover,
                                                memCacheHeight: 300,
                                                fadeInDuration: const Duration(milliseconds: 0),
                                                placeholderFadeInDuration: const Duration(milliseconds: 0),
                                                placeholder: (context, url) => Center(
                                                  child: Shimmer.fromColors(
                                                    baseColor: shimmerGray,
                                                    highlightColor: greyColor,
                                                    child: Container(
                                                      height: 150.w,
                                                      width: 160.w,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 40.h,
                                            width: 160.w,alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: whiteColor,
                                                borderRadius:
                                                    BorderRadius.only(bottomRight: Radius.circular(10.r), bottomLeft: Radius.circular(10.r))),
                                            child: Styles.regular(data.bookName!,
                                                fs: 13.sp,
                                                c: blackColor,
                                                ff: "Poppins-Regular",lns: 2,
                                                ov: TextOverflow.ellipsis,
                                                fw: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 2.5),
                                child: Styles.regular(
                                  'No_Data'.tr
                                ),
                              ),
                        ),
                      )
                    : GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: totalBooks,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10.0.r, mainAxisSpacing: 5.0.r, childAspectRatio: 0.6, crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(top: 8.h, bottom: 10.h),
                            height: 198.w,
                            width: 170.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Container(
                                height: 198.w,
                                width: 160.w,
                                child: Shimmer.fromColors(
                                  baseColor: shimmerGray,
                                  highlightColor: greyColor,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
              }),
            ),
          ),
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
