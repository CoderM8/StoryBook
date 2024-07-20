// ignore_for_file: deprecated_member_use

import 'package:wixpod/constants/audio_constant.dart';
import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:wixpod/ui/Single_Story/singlestory_screen.dart';
import 'package:wixpod/ui/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/constant.dart';
import '../../constants/widget/textwidget.dart';
import '../../model/home/home_banner_model.dart';

class PlaylistBooksScreen extends StatelessWidget {
  PlaylistBooksScreen({Key? key, required this.books, required this.playlistName}) : super(key: key);
  final List<BookList> books;
  final String playlistName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Backbutton(),
        centerTitle: true,
        elevation: 0.0,
        title: Styles.regular(playlistName, fs: 22.sp, ff: "Poppins-Bold", fw: FontWeight.bold),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0.w, right: 10.w),
              child: books.isNotEmpty ?  GridView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: books.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10.0.r, mainAxisSpacing: 5.0.r, childAspectRatio: 0.6, crossAxisCount: 3),
                itemBuilder: (context, index) {
                  var data = books[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => SingleStoryScreen(
                            bookid: data.aid,
                            bookimage: data.bookImage,
                          ));
                    },
                    child:  Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
                            child: ImageView(
                              imageUrl: data.bookImage,
                              height: 150.h,
                              width: 160.w,
                              memCacheHeight: 350,
                            ),
                          ),
                        ),
                        Container(
                          height: 40.h,
                          width: 160.w,alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.r), bottomLeft: Radius.circular(10.r))),
                          child: Styles.regular(data.bookName,
                              c: Colors.black,
                              fs: 14.sp,lns: 2,
                              ff: "Poppins-Regular",
                              ov: TextOverflow.ellipsis,
                              fw: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ) : Center(
                child: Styles.regular(
                    'No_Data'.tr,
                ),
              ),
            ),
          ),
          Positioned(bottom: 0.h,
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
