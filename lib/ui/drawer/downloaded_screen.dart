// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:wixpod/constants/audio_constant.dart';
import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:wixpod/model/downlodsong/download_model.dart';
import 'package:wixpod/services/database.dart';
import 'package:wixpod/ui/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/constant.dart';
import '../../constants/widget/textwidget.dart';
import '../../controller/play_controller.dart';

class Downloaded extends GetView {
  Downloaded({Key? key}) : super(key: key);

  final PlayController playController = Get.put(PlayController());

  final RxBool isdelete = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Backbutton(),
        centerTitle: true,
        elevation: 0.0,
        title: Styles.regular('Downloads'.tr, fs: 22.sp, ff: "Poppins-Bold"),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Obx(() {
              isdelete.value;
              return FutureBuilder<List<DownloadSong>>(
                  future: DatabaseHelper().getDownloadSongs(userId: userid),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      if (snap.data!.isNotEmpty) {
                        return GridView.builder(
                          padding: EdgeInsets.only(left: 10.0.w, right: 10.w),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,physics: BouncingScrollPhysics(),
                          itemCount: snap.data!.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 5.0.r, mainAxisSpacing: 5.0.r, childAspectRatio: 140.w / 200.h, crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            playController.getbooktitle.value = snap.data![index].bookname.toString();
                            playController.getbooksubtitle.value = snap.data![index].name.toString();
                            playController.getbookauthor.value = snap.data![index].artist.toString();
                            playController.bookimgurl.value = snap.data![index].imagepath!;
                            playController.getBookId.value = snap.data![index].bookid!;
                            return InkWell(
                              onTap: () {
                                playController.getBookId.value = snap.data![index].bookid!;
                                playController.bookimgurl.value = snap.data![index].imagepath!;
                                playController.getbooktitle.value = snap.data![index].bookname.toString();
                                playController.getbookauthor.value = snap.data![index].artist.toString();
            
                                getDownloadSong(songList: snap.data!, startIndex: index);
                                Get.to(
                                  () => PlayerScreen(
                                    bookId: playController.getBookId.value.toString(),
                                    bookImage: playController.bookimgurl.value,
                                    bookName: playController.getbooktitle.value,
                                    bookArtist: playController.getbookauthor.value,
                                    download: true,
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 200.h,
                                    width: MediaQuery.sizeOf(context).width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
                                        image: DecorationImage(image: FileImage(File(snap.data![index].imagepath!)), fit: BoxFit.fill)),
                                  ),
                                  Container(
                                    height: 40.h,
                                    padding: EdgeInsets.only(left: 5.w),
                                    width: MediaQuery.sizeOf(context).width,
                                    decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.r), bottomLeft: Radius.circular(10.r))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Styles.regular(snap.data![index].name!,
                                              fs: 15.sp,
                                              c: blackColor,
                                              ff: "Poppins-Regular",
                                              ta: TextAlign.start,
                                              lns: 1,
                                              ov: TextOverflow.ellipsis,
                                              fw: FontWeight.bold),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            isdelete.value = true;
                                            isdelete.value = false;
                                            await DatabaseHelper().deleteDownloadSongs(snap.data![index].id!);
                                          },
                                          child: Container(
                                            height: 40.h,
                                            width: 45.w,
                                            child: const Icon(Icons.delete),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Styles.regular('No_Stories_Download'.tr, fs: 15.sp, ff: "Poppins-Regular", ov: TextOverflow.ellipsis, fw: FontWeight.bold),
                        );
                      }
                    } else {
                      return Center(child: CircularProgressIndicator(color: whiteColor));
                    }
                  });
            }),
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
