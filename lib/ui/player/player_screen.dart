// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:wixpod/controller/bookdetails_controller.dart';
import 'package:wixpod/controller/play_controller.dart';
import 'package:wixpod/ui/login/login_view.dart';
import 'package:wixpod/ui/subscription/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../constants/audio_constant.dart';
import '../../constants/constant.dart';
import '../../constants/PositionSeekWidget.dart';
import '../../constants/download_mp3.dart';
import '../../constants/widget/textwidget.dart';
import '../../controller/user_controller.dart';
import '../../model/downlodsong/download_model.dart';
import '../../services/database.dart';

class PlayerScreen extends StatelessWidget {
  PlayerScreen({Key? key, this.bookId, this.bookName, this.bookImage, this.bookArtist, this.download = false}) : super(key: key);

  final PlayController playController = Get.put(PlayController());
  final UserController userController = Get.put(UserController());
  final BookDetailsController bookController = Get.put(BookDetailsController());
  final String? bookId;
  final String? bookName;
  final String? bookImage;
  final String? bookArtist;
  final RxBool isdownload = false.obs;
  final bool? download;
  Uri? dynamicUrl;

  getdownload(id) async {
    isdownload.value = await DatabaseHelper().isdownload(id);
  }

  shareBook() async {
    dynamicUrl = await createDynamicLink(id: bookId, path: "/Wixpod", image: bookImage!);
  }

  @override
  Widget build(BuildContext context) {
    shareBook();
    return Scaffold(
        backgroundColor: blackColor.withOpacity(0.9),
        body: SingleChildScrollView(
          child: PlayerBuilder.current(
              player: assetsAudioPlayer,
              builder: (context, value) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 45.h, right: 10.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Backbutton(),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Styles.regular(
                              value.audio.audio.metas.extra!['bookname'] ?? "",
                              fs: 20.sp,
                              ta: TextAlign.start,
                              ff: "Poppins-Bold",
                              ov: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          IconButton(
                            splashRadius: 20,
                            disabledColor: Colors.grey,
                            onPressed: () async {
                              await Share.shareUri(Uri.parse('${dynamicUrl}'));
                              // if (download == true) {
                              //   Share.shareXFiles([XFile(value.audio.audio.metas.image!.path)],
                              //       text:
                              //           '${'Storyname'.tr} : ${value.audio.audio.metas.extra!['bookname']} \n ${'Storytitle'.tr} : ${value.audio.audio.metas.title} \n ${'Storyartist'.tr} : ${value.audio.audio.metas.artist}');
                              // } else {
                              //   final url = Uri.parse(value.audio.audio.metas.image!.path);
                              //   final response = await http.get(url);
                              //   final documentDirectory = await getApplicationDocumentsDirectory();
                              //   File bytes = await File('${documentDirectory.path}/${value.audio.audio.metas.title}.png')
                              //       .writeAsBytes(response.bodyBytes);
                              //   Share.shareXFiles([XFile(bytes.path)],
                              //       text:
                              //           '${'Storyname'.tr} : ${value.audio.audio.metas.extra!['bookname']} \n ${'Storytitle'.tr} : ${value.audio.audio.metas.title} \n ${'Storyartist'.tr} : ${value.audio.audio.metas.artist}');
                              // }
                            },
                            icon: SvgPicture.asset(
                              "assets/icons/share.svg",
                              color: whiteColor,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          userController.isguest.value
                              ? InkWell(
                                  onTap: () {
                                    Get.offAll(LoginScreen());
                                  },
                                  child: SvgPicture.asset(
                                    "assets/icons/download.svg",
                                    color: whiteColor,
                                  ),
                                )
                              : Obx(() {
                                  isdownload.value;
                                  bookController.isDownload.value;
                                  bookController.downloadingBookId.value;
                                  getdownload(value.audio.audio.metas.id);
                                  return download == true
                                      ? Icon(Icons.download_done, color: whiteColor)
                                      : InkWell(
                                          onTap: () async {
                                            if (subscribe.value == true) {
                                              if (cancel.value && isdownload.value == false && bookController.isDownload.value == false) {
                                                String audiourl = playList[currentIndex.value].path;
                                                String? title = value.audio.audio.metas.title;
                                                String? audioid = value.audio.audio.metas.id;
                                                String bookname = bookName!;
                                                String imageUrl = bookImage!;
                                                var image = await http.get(Uri.parse(imageUrl));
                                                File? file;
                                                if (!isAndroidVersionUp13) {
                                                  if (await Permission.storage.request().isGranted) {
                                                    bookController.isDownload.value = true;
                                                    bookController.downloadingBookId.value = bookId!;
                                                    Directory appDocDir = await getApplicationDocumentsDirectory();
                                                    if (Platform.isAndroid) {
                                                      Directory('${appDocDir.path}/Wixpod').create();
                                                    }
                                                    file =
                                                        File(Platform.isIOS ? '${appDocDir.path}/$title.png' : '${appDocDir.path}/Wixpod/$title.png');
                                                    file.writeAsBytesSync(image.bodyBytes);
                                                  }
                                                } else {
                                                  bookController.isDownload.value = true;
                                                  bookController.downloadingBookId.value = bookId!;
                                                  Directory appDocDir = await getApplicationDocumentsDirectory();
                                                  if (Platform.isAndroid) {
                                                    Directory('${appDocDir.path}/Wixpod').create();
                                                  }
                                                  file =
                                                      File(Platform.isIOS ? '${appDocDir.path}/$title.png' : '${appDocDir.path}/Wixpod/$title.png');
                                                  file.writeAsBytesSync(image.bodyBytes);
                                                }
                                                try {
                                                  await downloadMp3(songUrl: audiourl, title: title, image: imageUrl).then((val) {
                                                    if (val != null) {
                                                      isdownload.value = true;
                                                      DatabaseHelper()
                                                          .addDownload(DownloadSong(
                                                              id: int.parse(audioid!),
                                                              name: title,
                                                              link: val,
                                                              bookname: bookname,
                                                              artist: bookArtist,
                                                              imagepath: file!.path,
                                                              userId: userid,
                                                              bookid: int.parse(bookId!)))
                                                          .whenComplete(() {
                                                        bookController.isDownload.value = false;
                                                        bookController.downloadingBookId.value = "";
                                                      });
                                                    }
                                                  });
                                                } catch (e) {
                                                  print('ERROR IN DOWNLOAD Player Screen $e');
                                                }
                                              } else {
                                                ShowSnackBar(message: 'Download_Progress'.tr);
                                              }
                                            } else {
                                              Get.to(() => SubscriptionScreen());
                                            }
                                          },
                                          child: bookController.isDownload.value == true && bookController.downloadingBookId.value == bookId!
                                              ? InkWell(
                                                  onTap: () async {
                                                    cancel.value = false;
                                                  },
                                                  child: CircularPercentIndicator(
                                                    radius: 18.r,
                                                    lineWidth: 4.w,
                                                    percent: progress.value / 100,
                                                    backgroundColor: Colors.transparent,
                                                    center: Styles.regular(
                                                      "${(progress.value)}%",
                                                      fw: FontWeight.bold,
                                                      fs: 12.sp,
                                                    ),
                                                    circularStrokeCap: CircularStrokeCap.round,
                                                    progressColor: whiteColor,
                                                  ),
                                                )
                                              : Center(
                                                  child: isdownload.value == false
                                                      ? SvgPicture.asset(
                                                          "assets/icons/download.svg",
                                                          color: whiteColor,
                                                        )
                                                      : Icon(Icons.download_done, color: whiteColor),
                                                ),
                                        );
                                }),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Stack(
                      children: [
                        SizedBox(
                            height: 375.h,
                            width: 253.w,
                            child: download == true
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(15.r),
                                    child: Image.file(
                                      File(value.audio.audio.metas.image!.path),
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                : ImageView(
                                    imageUrl: value.audio.audio.metas.image!.path,
                                    height: 175.h,
                                    width: 120.w,
                                    memCacheHeight: 500,
                                    radius: 15.r,
                                  )),
                        Container(
                          height: 375.h,
                          width: 253.w,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.black26, Colors.transparent, Colors.transparent, Colors.transparent, Colors.black26],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Styles.regular(value.audio.audio.metas.title ?? "",
                              fs: 22.sp, c: Colors.white, ff: "Poppins-Regular", fw: FontWeight.bold, lns: 1),
                          Styles.regular(value.audio.audio.metas.artist ?? '',
                              fs: 18.sp, c: Colors.white, ff: "Poppins-Regular", fw: FontWeight.bold, ov: TextOverflow.ellipsis, lns: 1),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    assetsAudioPlayer.builderRealtimePlayingInfos(builder: (context, RealtimePlayingInfos? infos) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        if (assetsAudioPlayer.current.value!.audio.audio.metas.id == assetsAudioPlayer.playlist!.audios.last.metas.id) {
                          if (infos!.currentPosition.inSeconds == infos.duration.inSeconds) {
                            assetsAudioPlayer.stop();
                            if (Get.currentRoute.contains('/PlayerScreen')) {
                              Get.back();
                            }
                            playerVisible.value = false;
                          }
                        }
                      });
                      if (infos!.duration > const Duration(seconds: 0)) {
                        return PositionSeekWidget(
                            currentPosition: infos.currentPosition,
                            duration: infos.duration,
                            bgColor: blackColor,
                            seekTo: (to) {
                              assetsAudioPlayer.seek(to);
                            });
                      } else {
                        return PositionSeekWidget(
                            currentPosition: Duration(seconds: 0),
                            duration: Duration(seconds: 0),
                            bgColor: blackColor,
                            seekTo: (to) {
                              assetsAudioPlayer.seek(to);
                            });
                      }
                    }),
                    SizedBox(height: 20.h),
                    assetsAudioPlayer.builderIsPlaying(
                      builder: (context, isPlaying) {
                        return PlayerBuilder.isPlaying(
                          player: assetsAudioPlayer,
                          builder: (context, isPlaying) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        assetsAudioPlayer.previous();
                                      },
                                      child: SvgPicture.asset(
                                        "assets/icons/previous.svg",
                                        height: 20.w,
                                        width: 20.w,
                                        fit: BoxFit.cover,
                                        color: whiteColor,
                                      )),
                                  InkWell(
                                    onTap: () {
                                      assetsAudioPlayer.seekBy(
                                        Duration(seconds: -playController.currentIntValue.value),
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      "assets/icons/left10.svg",
                                      height: 30.w,
                                      width: 30.w,
                                      color: whiteColor,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    onTap: () {
                                      assetsAudioPlayer.playOrPause();
                                    },
                                    child: Container(
                                      height: 50.w,
                                      width: 50.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: whiteColor,
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          isPlaying == false ? "assets/icons/play.svg" : "assets/icons/pause.svg",
                                          fit: BoxFit.cover,
                                          color: blackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(width: 30.w),
                                  InkWell(
                                    onTap: () {
                                      assetsAudioPlayer.seekBy(
                                        Duration(seconds: playController.currentIntValue.value),
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      "assets/icons/right10.svg",
                                      height: 30.w,
                                      width: 30.w,
                                      color: whiteColor,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      assetsAudioPlayer.next();
                                    },
                                    child: SvgPicture.asset(
                                      "assets/icons/next.svg",
                                      height: 20.w,
                                      width: 20.w,
                                      color: whiteColor,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                  ],
                );
              }),
        ));
  }
}
