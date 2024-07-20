import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:wixpod/constants/constant.dart';
import 'package:wixpod/constants/widget/textwidget.dart';
import 'package:wixpod/model/downlodsong/download_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/play_controller.dart';

RxBool playerVisible = false.obs;
RxBool isdownloaded = false.obs;
AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
final PlayController playController = Get.put(PlayController());
List<Audio> playList = [];
RxInt currentIndex = 0.obs;
RxBool playerError = false.obs;

getDownloadSong({required int startIndex, required List<DownloadSong> songList}) async {
  playList.clear();
  currentIndex.value = startIndex;
  try {
    for (var i = 0; i < songList.length; i++) {
      playList.add(
        Audio.file(
          songList[i].link!,
          metas: Metas(
              id: songList[i].id.toString(),
              title: songList[i].name,
              artist: songList[i].artist,
              image: MetasImage.file(songList[i].imagepath!),
              extra: {"bookname": songList[i].bookname}),
        ),
      );
    }
    await assetsAudioPlayer.open(
      Playlist(audios: playList, startIndex: startIndex),
      seek: const Duration(seconds: 00),
      showNotification: true,
      autoStart: true,
      loopMode: LoopMode.playlist,
      notificationSettings: NotificationSettings(
          stopEnabled: true,
          nextEnabled: true,
          prevEnabled: true,
          customStopAction: (value) {
            playList.clear();
            value.stop();
            playerVisible.value = false;
          }),
    );
    playerVisible.value = true;
    isdownloaded.value = true;
  } catch (e) {
    if (kDebugMode) {
      print("Error In Audio Player: $e");
    }
  }
}

Future<void> selectSong(
    {required int startIndex, required String bookName, required List songList, bool? isTap, String? image, required String artist}) async {
  playerError.value = false;
  playList.clear();
  currentIndex.value = startIndex;
  try {
    for (var i = 0; i < songList.length; i++) {
      playList.add(
        Audio.network(
          songList[i].mp3Url,
          metas: Metas(
              id: songList[i].id.toString(),
              title: songList[i].mp3Title,
              artist: artist,
              image: MetasImage.network(image!),
              extra: {"bookname": bookName}),
        ),
      );
    }
    await assetsAudioPlayer.open(
      Playlist(audios: playList, startIndex: startIndex),
      seek: const Duration(seconds: 00),
      showNotification: true,
      autoStart: true,
      loopMode: LoopMode.playlist,
      notificationSettings: NotificationSettings(
          stopEnabled: true,
          nextEnabled: true,
          prevEnabled: true,
          customStopAction: (value) {
            playList.clear();
            value.stop();
            playerVisible.value = false;
          }),
    );
    isdownloaded.value = false;
    playerVisible.value = true;
    assetsAudioPlayer.onErrorDo = (e) {
      playerError.value = true;
      playerVisible.value = false;
    };
  } catch (e) {
    if (kDebugMode) {
      print("Error In Asset Audio Player ::::: ${e}");
    }
    playerError.value = true;
    playerVisible.value = false;
  }
}

Widget buildPanelHeader({required VoidCallback onTap}) {
  return Obx(() {
    return playerVisible.value
        ? Scrollable(
            viewportBuilder: (BuildContext context, ViewportOffset position) => Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.down,
              onDismissed: (_) {
                playerVisible.value = false;
                assetsAudioPlayer.stop();
              },
              child: assetsAudioPlayer.builderRealtimePlayingInfos(builder: (context, realtimePlayingInfos) {
                return PlayerBuilder.current(
                    player: assetsAudioPlayer,
                    builder: (context, value) {
                      return InkWell(
                        onTap: onTap,
                        child: Container(
                          margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                          width: MediaQuery.of(context).size.width,
                          color: pinkColor,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 10.w),
                                  isdownloaded.value == true
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8.r),
                                          child: !value.audio.audio.metas.image!.path.startsWith('http')
                                              ? Image.file(
                                                  File(value.audio.audio.metas.image!.path),
                                                  fit: BoxFit.cover,
                                                  width: 36.w,
                                                  height: 43.w,
                                                )
                                              : Image.network(
                                                  (value.audio.audio.metas.image!.path),
                                                  fit: BoxFit.cover,
                                                  width: 36.w,
                                                  height: 43.w,
                                                ),
                                        )
                                      : ImageView(
                                          imageUrl: value.audio.audio.metas.image!.path,
                                          memCacheHeight: 180,
                                          width: 36.w,
                                          height: 43.w,
                                          radius: 8.r,
                                        ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Styles.regular(
                                          value.audio.audio.metas.extra!['bookname'].toString(),
                                          ff: "Poppins-Bold",
                                          fs: 13.sp,
                                          ta: TextAlign.start,
                                          c: blackColor,
                                          fw: FontWeight.normal,
                                          ov: TextOverflow.ellipsis,
                                        ),
                                        Styles.regular(
                                          value.audio.audio.metas.title.toString(),
                                          ov: TextOverflow.ellipsis,
                                          c: blackColor,
                                          ff: "Poppins-Regular",
                                          fs: 10.sp,
                                          ta: TextAlign.start,
                                          fw: FontWeight.normal,
                                        ),
                                        Styles.regular(
                                          value.audio.audio.metas.artist.toString(),
                                          ov: TextOverflow.ellipsis,
                                          c: blackColor,
                                          fs: 9.sp,
                                          ta: TextAlign.start,
                                          ff: "Poppins-Regular",
                                          fw: FontWeight.normal,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PlayerBuilder.isPlaying(
                                    player: assetsAudioPlayer,
                                    builder: (context, isPlaying) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: 15.w),
                                        child: InkWell(
                                          onTap: () {
                                            assetsAudioPlayer.playOrPause();
                                          },
                                          child: Container(
                                            height: 35.w,
                                            width: 35.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: blackColor,
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                              size: 30.w,
                                              color: whiteColor,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }),
            ),
          )
        : const SizedBox.shrink();
  });
}
