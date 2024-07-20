// ignore_for_file: deprecated_member_use

import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/constant.dart';
import '../../constants/widget/textwidget.dart';
import '../../controller/allauthor_controller.dart';
import 'author_book.dart';

class Author extends StatelessWidget {
  Author({Key? key}) : super(key: key);

  final AllAuthor_Controller allAuthor_Controller = Get.put(AllAuthor_Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Backbutton(),
        centerTitle: true,
        elevation: 0.0,
        title: Styles.regular('Author'.tr, fs: 22.sp, ff: "Poppins-Bold", fw: FontWeight.bold),
      ),
      body: Obx(() {
        allAuthor_Controller.allauthorbool.value;
        return allAuthor_Controller.allauthor != null
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
                controller: allAuthor_Controller.refreshController,
                onRefresh: allAuthor_Controller.onRefresh,
                onLoading: allAuthor_Controller.onLoading,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0.w, right: 10.w),
                  child: SingleChildScrollView(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: allAuthor_Controller.allauthor!.onlineMp3!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 15.0.r, childAspectRatio: 198.w / 300.h, mainAxisSpacing: 20.r, crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        var data = allAuthor_Controller.allauthor!.onlineMp3![index];
                        return Container(
                          margin: EdgeInsets.only(top: 12.h),
                          height: 300.h,
                          width: 198.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: ImageView(
                                    imageUrl: data.authorImage!,
                                    // height: 198.w,
                                    // width: 198.w,
                                    memCacheHeight: 340,
                                    radius: 170.r,
                                  )),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius:
                                          BorderRadius.only(bottomRight: Radius.circular(10.r), bottomLeft: Radius.circular(10.r))),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 23.h,
                                        width: 158.w,
                                        child: Styles.regular(data.authorName!,
                                            fs: 16.sp,
                                            c: blackColor,
                                            ff: "Poppins-Regular",
                                            ov: TextOverflow.ellipsis,
                                            fw: FontWeight.bold),
                                      ),
                                      SizedBox(height: 6.h),
                                      InkWell(
                                        onTap: () {
                                          Get.to(() => Author_Book(authorId: data.id!, authorname: data.authorName,totalBooks: data.totalSongs!,));
                                        },
                                        child: Container(
                                          height: 25.h,
                                          width: 100.w,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: blackColor),
                                          child: Center(
                                            child: Styles.regular(
                                              'Read_Story'.tr,
                                              ff: 'Poppins-Regular',
                                              fs: 14.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Shimmer.fromColors(
                  baseColor: shimmerGray,
                  highlightColor: greyColor,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 6,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 15.0.r, childAspectRatio: 198.w / 300.h, mainAxisSpacing: 20.r, crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: 12.h),
                        height: 300.h,
                        width: 198.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                height: 170.h,
                                width: 198.w,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.r), bottomLeft: Radius.circular(10.r))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 23.h,
                                      width: 158.w,
                                    ),
                                    SizedBox(height: 6.h),
                                    Container(
                                      height: 25.h,
                                      width: 100.w,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
      }),
    );
  }
}
