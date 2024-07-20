// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:wixpod/constants/download_mp3.dart';
import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:wixpod/controller/bookdetails_controller.dart';
import 'package:wixpod/model/single_book/single_book_model.dart';
import 'package:wixpod/services/all_services.dart';
import 'package:wixpod/services/database.dart';
import 'package:wixpod/ui/home/bottom_navigationbar.dart';
import 'package:wixpod/ui/player/player_screen.dart';
import 'package:wixpod/ui/subscription/subscription_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/audio_constant.dart';
import '../../constants/constant.dart';
import '../../constants/widget/Iconbutton_widget.dart';
import '../../constants/widget/ratingbar_widget.dart';
import '../../constants/widget/textwidget.dart';
import '../../controller/play_controller.dart';
import '../../controller/user_controller.dart';
import '../../model/downlodsong/download_model.dart';
import '../login/login_view.dart';

class SingleStoryScreen extends GetView {
  SingleStoryScreen({super.key, this.bookid, this.bookimage,this.isBack});

  final BookDetailsController bookController = Get.put(BookDetailsController());
  final PlayController playController = Get.put(PlayController());
  final UserController userController = Get.put(UserController());
  final String? bookid;
  final String? bookimage;
  final bool? isBack;
  RxBool isdownload = false.obs;
  File? bytes;
  Uri? dynamicUrl;
  RxBool isShareActive = false.obs;

  shareBook() async {
    // final url = Uri.parse(bookimage!);
    // final response = await http.get(url);
    // final documentDirectory = await getApplicationDocumentsDirectory();
    // bytes = await File('${documentDirectory.path}/wixpod.png').writeAsBytes(response.bodyBytes);
    dynamicUrl = await createDynamicLink(id: bookid, path: "/Wixpod", image: bookimage!).whenComplete(() {
      isShareActive.value = true;
    });
  }

  getdownload(id) async {
    isdownload.value = await DatabaseHelper().isdownload(id);
  }

  Widget build(BuildContext context) {
    shareBook();
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: FutureBuilder<SingalBookModel?>(
            future: AllServices().singalbookservice(bookid: bookid),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                List<ChapterList> chapterList = [];
                for (var i = 0; i < snapshot.data!.onlineMp3[0].chapterList.length; i++) {
                  if (snapshot.data!.onlineMp3[0].chapterList[i].mp3Url.isNotEmpty) {
                    chapterList.add(snapshot.data!.onlineMp3[0].chapterList[i]);
                  }
                  getdownload(snapshot.data!.onlineMp3[0].chapterList[i].id);
                }

                playController.getBookId.value = int.parse(snapshot.data!.onlineMp3[0].aid.toString());
                playController.getbooktitle.value = snapshot.data!.onlineMp3[0].bookName;
                playController.bookimgurl.value = snapshot.data!.onlineMp3[0].bookImage;
                playController.audiochapterId.value = chapterList.isNotEmpty ? chapterList[0].mp3Url : "";
                playController.getbooksubtitle.value = chapterList.isNotEmpty ? chapterList[0].mp3Title : "";
                playController.getbookauthor.value = snapshot.data!.onlineMp3[0].authorList[0].authorName;

                final bookdocs = parse(snapshot.data!.onlineMp3[0].bookDescription);
                String bookDescription = parse(bookdocs.body!.text).documentElement!.text;
                final readDocs = parse(snapshot.data!.onlineMp3[0].readDescription);
                String readDescription = parse(readDocs.body!.text).documentElement!.text;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  bookController.isLike.value = snapshot.data!.onlineMp3[0].isFavourite;
                });

                return Column(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          NestedScrollView(
                            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                              return [
                                SliverAppBar(
                                  pinned: true,
                                  title: Styles.regular(playController.getbooktitle.value,
                                      ov: TextOverflow.ellipsis, fs: 18.sp, ta: TextAlign.start, ff: "Poppins-Bold", lns: 1, fw: FontWeight.bold),
                                  centerTitle: false,
                                  expandedHeight: 420.0,
                                  leading: Backbutton(onTap: () => isBack == true ? Get.offAll(()=> MyBottomNavigationBar()) : Get.back()),
                                  actions: [
                                    userController.isguest.value
                                        ? InkWell(
                                            onTap: () {
                                              Get.offAll(() => LoginScreen());
                                            },
                                            child: SvgPicture.asset(
                                              "assets/icons/download.svg",
                                              color: whiteColor,
                                            ),
                                          )
                                        : Obx(() {
                                            isdownload.value;
                                            bookController.isDownload.value;
                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              onTap: () async {
                                                if (subscribe.value == true) {
                                                  if (cancel.value && isdownload.value == false && bookController.isDownload.value == false) {
                                                    for (var i = 0; i < chapterList.length; i++) {
                                                      if (await DatabaseHelper().isdownload(chapterList[i].id) == true) {
                                                      } else {
                                                        String bookname = snapshot.data!.onlineMp3[0].bookName;
                                                        String audiourl = chapterList[i].mp3Url;
                                                        String title = chapterList[i].mp3Title;
                                                        String artist = snapshot.data!.onlineMp3[0].authorList[0].authorName;
                                                        String audioid = chapterList[i].id;
                                                        String imageUrl = snapshot.data!.onlineMp3[0].bookImage;

                                                        File? file;
                                                        if (!isAndroidVersionUp13) {
                                                          if (await Permission.storage.request().isGranted) {
                                                            bookController.isDownload.value = true;
                                                            bookController.downloadingBookId.value = bookid!;
                                                            Directory appDocDir = await getApplicationDocumentsDirectory();
                                                            if (Platform.isAndroid) {
                                                              Directory('${appDocDir.path}/Wixpod').create();
                                                            }
                                                            file = File(Platform.isIOS
                                                                ? '${appDocDir.path}/$title.png'
                                                                : '${appDocDir.path}/Wixpod/$title.png');
                                                            // file.writeAsBytesSync(image.bodyBytes);
                                                          }
                                                        } else {
                                                          bookController.isDownload.value = true;
                                                          bookController.downloadingBookId.value = bookid!;

                                                          Directory appDocDir = await getApplicationDocumentsDirectory();
                                                          if (Platform.isAndroid) {
                                                            Directory('${appDocDir.path}/Wixpod').create();
                                                          }
                                                          file = File(Platform.isIOS
                                                              ? '${appDocDir.path}/$title.png'
                                                              : '${appDocDir.path}/Wixpod/$title.png');
                                                        }
                                                        try {
                                                          Dio dio = Dio();
                                                          await dio.download(imageUrl, file!.path);
                                                          await downloadMp3(songUrl: audiourl, title: title, image: imageUrl).then((val) {
                                                            if (val != null) {
                                                              isdownload.value = true;
                                                              DatabaseHelper()
                                                                  .addDownload(DownloadSong(
                                                                      id: int.parse(audioid),
                                                                      name: title,
                                                                      bookname: bookname,
                                                                      artist: artist,
                                                                      link: val,
                                                                      imagepath: file!.path,
                                                                      userId: userid,
                                                                      bookid: int.parse(bookid!)))
                                                                  .whenComplete(() {
                                                                bookController.isDownload.value = false;
                                                                bookController.downloadingBookId.value = "";
                                                              });
                                                            }
                                                          });
                                                        } catch (e, trace) {
                                                          if (kDebugMode) {
                                                            print('ERROR IN DOWNLOAD $e');
                                                            print('ERROR IN Detail Screen $trace');
                                                          }
                                                        }
                                                      }
                                                      if (!cancel.value) {
                                                        cancel.value = true;
                                                        isdownload.value = false;
                                                        break;
                                                      }
                                                    }
                                                  } else {
                                                    ShowSnackBar(message: 'Download_Progress'.tr);
                                                  }
                                                } else {
                                                  Get.to(() => SubscriptionScreen());
                                                }
                                              },
                                              child: bookController.isDownload.value == true && bookController.downloadingBookId.value == bookid!
                                                  ? InkWell(
                                                      splashColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      onTap: () async {
                                                        cancel.value = false;
                                                      },
                                                      child: CircularPercentIndicator(
                                                        radius: 18.r,
                                                        lineWidth: 4.0.w,
                                                        backgroundColor: whiteColor,
                                                        percent: progress.value / 100,
                                                        center: Styles.regular(
                                                          "${(progress.value)}%",
                                                          fw: FontWeight.bold,
                                                          fs: 12.sp,
                                                        ),
                                                        circularStrokeCap: CircularStrokeCap.round,
                                                        progressColor: blackColor,
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
                                    SizedBox(width: 5.w),
                                    Obx(() {
                                      isShareActive.value;
                                      return IconButton(
                                        splashRadius: 20,
                                        disabledColor: Colors.grey,
                                        onPressed: isShareActive.value
                                            ? () async {
                                                await Share.shareUri(Uri.parse('${dynamicUrl}'));
                                              }
                                            : () {},
                                        icon: SvgPicture.asset(
                                          "assets/icons/share.svg",
                                          color: whiteColor,
                                        ),
                                      );
                                    }),
                                  ],
                                  flexibleSpace: FlexibleSpaceBar(
                                    background: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 20.w),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(image: NetworkImage(bookimage!), fit: BoxFit.cover, opacity: 0.4),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 220.w,
                                              width: 150.w,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height: 200.w,
                                                    width: 150.w,
                                                    decoration: const BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black26,
                                                          offset: Offset(
                                                            1.0,
                                                            1.0,
                                                          ),
                                                          blurRadius: 12.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: ImageView(
                                                      imageUrl: snapshot.data!.onlineMp3[0].bookImage,
                                                      height: 175.w,
                                                      width: 120.w,
                                                      memCacheHeight: 390,
                                                      radius: 10.r,
                                                    ),
                                                  ),

                                                  ///like page
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: CustomFavouriteButton(bookid: snapshot.data!.onlineMp3[0].aid),
                                                  )
                                                ],
                                              )),
                                          SizedBox(width: 10.w),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Styles.regular(snapshot.data!.onlineMp3[0].bookName,
                                                    ta: TextAlign.start,
                                                    fs: 20.sp,
                                                    lns: 2,
                                                    ff: "Poppins-Regular",
                                                    fw: FontWeight.bold,
                                                    ov: TextOverflow.ellipsis),
                                                SizedBox(height: 5.h),
                                                Styles.regular(
                                                  "By".tr + "${snapshot.data!.onlineMp3[0].authorList[0].authorName}",
                                                  fs: 16.sp,
                                                  lns: 2,
                                                  ta: TextAlign.start,
                                                  ff: "Poppins-Regular",
                                                ),
                                                SizedBox(height: 20.h),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    RatingBarIndicator(
                                                      rating: double.parse(snapshot.data!.onlineMp3[0].rateAvg.toString()),
                                                      direction: Axis.horizontal,
                                                      itemCount: 5,
                                                      itemSize: 22.78.h.w,
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
                                                      '${double.parse(snapshot.data!.onlineMp3[0].rateAvg.toString())}',
                                                      ff: "Poppins-Medium",
                                                      fs: 14.sp,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 20.h),
                                                Styles.regular(snapshot.data!.onlineMp3[0].playTime,
                                                    fs: 14.sp, ff: "Poppins-Regular", ov: TextOverflow.ellipsis),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  bottom: PreferredSize(
                                    preferredSize: Size.fromHeight(60),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                                      height: 48.h,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(25.0),
                                      ),
                                      child: TabBar(
                                        labelStyle: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            color: whiteColor,
                                            fontSize: 18.sp / MediaQuery.of(context).textScaleFactor,
                                            fontWeight: FontWeight.normal),
                                        controller: bookController.tabController,
                                        indicator: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25.0),
                                          color: blackColor,
                                        ),
                                        dividerColor: Colors.transparent,
                                        isScrollable: true,
                                        labelColor: Colors.white,
                                        tabAlignment: TabAlignment.center,
                                        unselectedLabelColor: Colors.black,
                                        tabs: [
                                          Tab(
                                            text: 'About'.tr,
                                          ),
                                          Tab(
                                            text: 'Stories'.tr,
                                          ),
                                          Tab(
                                            text: 'Reading'.tr,
                                          ),
                                          Tab(
                                            text: 'Review'.tr,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ];
                            },
                            body: TabBarView(
                              controller: bookController.tabController,
                              children: [
                                ///about
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.all(15.0.r),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10.w),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0.r), color: const Color(0xFFF8F7F7)),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 155.w,
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 10.0.w),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(Icons.access_alarm, size: 28.sp),
                                                          SizedBox(width: 10.w),
                                                          Styles.regular('Duration'.tr, c: blackColor, ff: "Poppins-Regular", fs: 16.sp),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5.h),
                                                      Styles.regular(
                                                          snapshot.data!.onlineMp3[0].playTime.isNotEmpty
                                                              ? snapshot.data!.onlineMp3[0].playTime
                                                              : '00 : 00',
                                                          ov: TextOverflow.ellipsis,
                                                          ff: "Poppins-Regular",
                                                          c: blackColor,
                                                          fs: 14.sp,
                                                          fw: FontWeight.bold),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                width: 155.w,
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 10.0.w),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(Icons.computer, size: 28.sp),
                                                          SizedBox(width: 10.w),
                                                          Styles.regular('Stories'.tr, ff: "Poppins-Regular", c: blackColor, fs: 16.sp),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5.h),
                                                      Styles.regular("${snapshot.data!.onlineMp3[0].totalChapter.toString()} ${'Stories'.tr}",
                                                          ff: "Poppins-Regular", fs: 16.sp, c: blackColor, fw: FontWeight.bold),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20.w),
                                        Styles.regular('Summary'.tr, ta: TextAlign.start, fs: 22.sp, ff: "Poppins-Regular"),
                                        SizedBox(
                                          width: MediaQuery.sizeOf(context).width,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 20.h),
                                            child: Styles.regular(
                                              bookDescription,
                                              ta: TextAlign.start,
                                              fs: 18.sp,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 50.h)
                                      ],
                                    ),
                                  ),
                                ),

                                /// stories
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      chapterList.isNotEmpty
                                          ? ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: chapterList.length,
                                              itemBuilder: (context, index) {
                                                if (snapshot.hasData || snapshot.connectionState == ConnectionState.done) {
                                                  return Obx(() {
                                                    success.value;
                                                    return InkWell(
                                                      splashColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      onTap: () async {
                                                        if (subscribe.value == true) {
                                                        await selectSong(
                                                              startIndex: index,
                                                              bookName: snapshot.data!.onlineMp3[0].bookName,
                                                              artist: snapshot.data!.onlineMp3[0].authorList[0].authorName,
                                                              songList: chapterList,
                                                              image: bookimage!).whenComplete(() {
                                                          if(playerError.value == true){
                                                            ShowSnackBar(message: 'Filecorrupted'.tr);
                                                            playerVisible.value = false;
                                                          }else{
                                                            Get.to(
                                                                  () => PlayerScreen(
                                                                  bookId: snapshot.data!.onlineMp3[0].aid,
                                                                  bookName: snapshot.data!.onlineMp3[0].bookName,
                                                                  bookImage: snapshot.data!.onlineMp3[0].bookImage,
                                                                  bookArtist: snapshot.data!.onlineMp3[0].authorList[0].authorName
                                                                // download: false,
                                                              ),
                                                            );
                                                          }
                                                        });
                                                        } else {
                                                          await AllServices().addcount();
                                                          if (success.value == '0') {
                                                            Get.to(() => SubscriptionScreen());
                                                          } else {
                                                            selectSong(
                                                                    startIndex: index,
                                                                    bookName: snapshot.data!.onlineMp3[0].bookName,
                                                                    artist: snapshot.data!.onlineMp3[0].authorList[0].authorName,
                                                                    songList: chapterList,
                                                                    image: bookimage!).whenComplete(() {
                                                              if(playerError.value == true){
                                                                ShowSnackBar(message: 'Filecorrupted'.tr);
                                                                playerVisible.value = false;
                                                              }else{
                                                                Get.to(
                                                                  () => PlayerScreen(
                                                                    bookId: snapshot.data!.onlineMp3[0].aid,
                                                                    bookName: snapshot.data!.onlineMp3[0].bookName,
                                                                    bookImage: snapshot.data!.onlineMp3[0].bookImage,
                                                                    bookArtist: snapshot.data!.onlineMp3[0].authorList[0].authorName,
                                                                  ),
                                                                );
                                                              }
                                                            });
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 70.h,
                                                        width: MediaQuery.sizeOf(context).width,
                                                        decoration:
                                                            BoxDecoration(color: const Color(0xFFF8F7F7), borderRadius: BorderRadius.circular(10.r)),
                                                        margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(5.r),
                                                              ),
                                                              margin: EdgeInsets.only(left: 8.w),
                                                              height: 60.h,
                                                              width: 60.w,
                                                              child: SvgPicture.asset("assets/icons/music.svg"),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(top: 15.h, left: 14.w, bottom: 10.h),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                      alignment: Alignment.centerLeft,
                                                                      width: 190.w,
                                                                      height: 22.h,
                                                                      child: Styles.regular(chapterList[index].mp3Title,
                                                                          ov: TextOverflow.ellipsis, c: blackColor, fs: 16.sp, fw: FontWeight.bold)),
                                                                  SizedBox(
                                                                    height: 4.h,
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons.access_time_outlined,
                                                                          color: blackColor,
                                                                          size: 13.sp,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 3.w,
                                                                        ),
                                                                        Styles.regular(
                                                                          chapterList[index].mp3Duration,
                                                                          c: blackColor,
                                                                          fs: 13.sp,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            PlayerBuilder.isPlaying(
                                                                player: assetsAudioPlayer,
                                                                builder: (context, isPlaying) {
                                                                  return isPlaying
                                                                      ? PlayerBuilder.current(
                                                                          player: assetsAudioPlayer,
                                                                          builder: (context, value) {
                                                                            return buildContainer(
                                                                              svg: value.audio.audio.metas.id == chapterList[index].id
                                                                                  ? 'assets/icons/headerPausebutton.svg'
                                                                                  : 'assets/icons/musicplayblack.svg',
                                                                              imgw: 35.r,
                                                                              imgh: 35.r,
                                                                              colors: Colors.black,
                                                                            );
                                                                          },
                                                                        )
                                                                      : buildContainer(
                                                                          svg: 'assets/icons/musicplayblack.svg',
                                                                          imgw: 35.r,
                                                                          imgh: 35.r,
                                                                          colors: Colors.black,
                                                                        );
                                                                }),
                                                            SizedBox(
                                                              width: 32.w,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                } else {
                                                  return Center(
                                                    child: Styles.regular(
                                                      'No_Data'.tr,
                                                      c: blackColor,
                                                    ),
                                                  );
                                                }
                                              },
                                            )
                                          : Padding(
                                              padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 5),
                                              child: Styles.regular('No_Data'.tr),
                                            ),
                                      SizedBox(height: 50.h)
                                    ],
                                  ),
                                ),

                                /// reading
                                SingleChildScrollView(
                                  child: SizedBox(
                                    width: MediaQuery.sizeOf(context).width,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 20.h),
                                      child: Styles.regular(
                                        readDescription,
                                        ta: TextAlign.start,
                                        fs: 18.sp,
                                      ),
                                    ),
                                  ),
                                ),

                                ///review
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10.h),
                                      Container(
                                        width: 341.w,
                                        height: 210.h,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.sp), color: const Color(0xFFF8F7F7)),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 8.w, top: 10.h),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Styles.regular('OverallRatings'.tr, c: blackColor, fs: 20.sp, ff: "Poppins-Regular"),
                                              SizedBox(height: 3.h),
                                              Row(
                                                children: [
                                                  Styles.regular('${double.parse(snapshot.data!.onlineMp3[0].rateAvg)}',
                                                      ff: "Poppins-Regular", fs: 18.sp, c: blackColor, fw: FontWeight.bold),
                                                  SizedBox(width: 5.w),
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 9.0.w),
                                                    child: RatingBarIndicator(
                                                      rating: double.parse(snapshot.data!.onlineMp3[0].rateAvg),
                                                      direction: Axis.horizontal,
                                                      itemCount: 5,
                                                      itemSize: 40.78.h.w,
                                                      unratedColor: Colors.grey,
                                                      itemPadding: EdgeInsets.only(right: 2.0.w),
                                                      itemBuilder: (BuildContext context, int index) {
                                                        return const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Styles.regular("5", fs: 14.sp, c: blackColor, ff: "Poppins-Regular", fw: FontWeight.normal),
                                                  LinearPercentIndicator(
                                                    width: 300.0.w,
                                                    lineHeight: 11.0,
                                                    barRadius: Radius.circular(2.r),
                                                    percent: double.parse(snapshot.data!.onlineMp3[0].total5) / 10,
                                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                                    backgroundColor: Colors.grey,
                                                    progressColor: Colors.green,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Styles.regular("4", fs: 14.sp, c: blackColor, ff: "Poppins-Regular", fw: FontWeight.normal),
                                                  LinearPercentIndicator(
                                                    width: 300.0.w,
                                                    lineHeight: 12.0,
                                                    percent: double.parse(snapshot.data!.onlineMp3[0].total4) / 10,
                                                    barRadius: Radius.circular(2.r),
                                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                                    backgroundColor: Colors.grey,
                                                    progressColor: Colors.greenAccent,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Styles.regular("3", fs: 14.sp, c: blackColor, ff: "Poppins-Regular", fw: FontWeight.normal),
                                                  LinearPercentIndicator(
                                                    width: 300.0.w,
                                                    lineHeight: 12.0,
                                                    percent: double.parse(snapshot.data!.onlineMp3[0].total3) / 10,
                                                    barRadius: Radius.circular(2.r),
                                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                                    backgroundColor: Colors.grey,
                                                    progressColor: Colors.yellow,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Styles.regular("2", fs: 14.sp, c: blackColor, ff: "Poppins-Regular", fw: FontWeight.normal),
                                                  LinearPercentIndicator(
                                                    width: 300.0.w,
                                                    lineHeight: 12.0,
                                                    barRadius: Radius.circular(2.r),
                                                    percent: double.parse(snapshot.data!.onlineMp3[0].total2) / 10,
                                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                                    backgroundColor: Colors.grey,
                                                    progressColor: Colors.orange,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Styles.regular("1", fs: 14.sp, c: blackColor, ff: "Poppins-Regular", fw: FontWeight.normal),
                                                  SizedBox(width: 5.w),
                                                  LinearPercentIndicator(
                                                    width: 300.0.w,
                                                    lineHeight: 12.0,
                                                    barRadius: Radius.circular(2.r),
                                                    percent: double.parse(snapshot.data!.onlineMp3[0].total1) / 10,
                                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                                    backgroundColor: Colors.grey,
                                                    progressColor: Colors.red,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Container(
                                        width: 350.w,
                                        height: 60.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.sp),
                                          color: const Color(0xFFF8F7F7),
                                        ),
                                        child: Center(
                                          child: CustomRatingBar(
                                              bookid: bookid, userRate: double.parse(snapshot.data!.onlineMp3[0].userRate.toString())),
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(() {
                            playerVisible.value;
                            return playerVisible.value == false
                                ? Positioned(bottom: 0.h,
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 15.w, bottom: 15.h),
                                      child: InkWell(
                                        onTap: () {
                                          if (subscribe.value == true) {
                                            selectSong(
                                                startIndex: 0,
                                                bookName: snapshot.data!.onlineMp3[0].bookName,
                                                artist: snapshot.data!.onlineMp3[0].authorList[0].authorName,
                                                songList: chapterList,
                                                image: bookimage!).whenComplete(() {
                                              if(playerError.value == true){
                                                ShowSnackBar(message: 'Filecorrupted'.tr);
                                                playerVisible.value = false;
                                              }else{
                                                 Get.to(
                                                   () => PlayerScreen(
                                                     bookId: snapshot.data!.onlineMp3[0].aid,
                                                     bookName: snapshot.data!.onlineMp3[0].bookName,
                                                     bookImage: snapshot.data!.onlineMp3[0].bookImage,
                                                     bookArtist: snapshot.data!.onlineMp3[0].authorList[0].authorName,
                                                   ),
                                                 );
                                              }
                                            });
                                          } else {
                                            if (success.value == '0') {
                                              Get.to(() => SubscriptionScreen());
                                            } else {
                                              selectSong(
                                                  startIndex: 0,
                                                  bookName: snapshot.data!.onlineMp3[0].bookName,
                                                  artist: snapshot.data!.onlineMp3[0].authorList[0].authorName,
                                                  songList: chapterList,
                                                  image: bookimage!).whenComplete(() {
                                                if(playerError.value == true){
                                                  ShowSnackBar(message: 'Filecorrupted'.tr);
                                                  playerVisible.value = false;
                                                }else{
                                                   Get.to(
                                                     () => PlayerScreen(
                                                       bookId: snapshot.data!.onlineMp3[0].aid,
                                                       bookName: snapshot.data!.onlineMp3[0].bookName,
                                                       bookImage: snapshot.data!.onlineMp3[0].bookImage,
                                                       bookArtist: snapshot.data!.onlineMp3[0].authorList[0].authorName,
                                                     ),
                                                   );
                                                }
                                              });
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: 55.h,
                                          width: 60.w,
                                          decoration: BoxDecoration(color: whiteColor, shape: BoxShape.circle),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: SvgPicture.asset(
                                              "assets/icons/play_icon.svg",
                                              color: blackColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                )
                                : SizedBox.shrink();
                          })
                        ],
                      ),
                    ),
                    buildPanelHeader(
                      onTap: () {
                        isdownloaded.value == true
                            ? Get.to(() => PlayerScreen(
                                  bookId: playController.getBookId.toString(),
                                  bookImage: playController.bookimgurl.value,
                                  bookName: playController.getbooktitle.value,
                                  bookArtist: playController.getbookauthor.toString(),
                                  download: true,
                                ))
                            : Get.to(() => PlayerScreen(
                                  bookId: playController.getBookId.toString(),
                                  bookImage: playController.bookimgurl.value,
                                  bookName: playController.getbooktitle.toString(),
                                  bookArtist: playController.getbookauthor.toString(),
                                ));
                      },
                    ),
                  ],
                );
              } else {
                return Container(
                  color: Colors.black12,
                  child: Shimmer.fromColors(
                    baseColor: shimmerGray,
                    highlightColor: greyColor,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///======book details========
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Backbutton(),
                                SizedBox(width: 15.w),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: Colors.white,
                                  ),
                                  height: 30.h,
                                  width: 155.w,
                                ),
                              ],
                            ),
                          ),

                          ///========image part and details========
                          Container(
                            height: 300.h,
                            width: double.infinity,
                            margin: const EdgeInsets.only(left: 20, top: 40, right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 240.h,
                                  width: 150.w,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 200.h,
                                        width: 150.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.r),
                                          color: Colors.white,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: 50.r,
                                          width: 50.r,
                                          margin: const EdgeInsets.only(bottom: 20),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF4B45D),
                                            borderRadius: BorderRadius.circular(66.sp),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 25.h),

                                    ///======bookname=======
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.r),
                                        color: Colors.white,
                                      ),
                                      // margin: const EdgeInsets.only(left: 30, top: 55),
                                      height: 30.h,
                                      width: 140.w,
                                    ),
                                    SizedBox(height: 15.h),

                                    ///=====artist========
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.r),
                                        color: Colors.white,
                                      ),
                                      // margin: const EdgeInsets.only(left: 30, top: 55),
                                      height: 25.h,
                                      width: 180.w,
                                    ),
                                    SizedBox(height: 20.h),

                                    ///=====rating bar======
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.r),
                                        color: Colors.white,
                                      ),
                                      // margin: const EdgeInsets.only(left: 30, top: 55),
                                      height: 25.h,
                                      width: 170.w,
                                    ),
                                    SizedBox(height: 20.h),

                                    ///=====time=======
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.r),
                                        color: Colors.white,
                                      ),
                                      // margin: const EdgeInsets.only(left: 30, top: 55),
                                      height: 40.h,
                                      width: 180.w,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          ///=======tab bar=========
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              color: Colors.white,
                            ),
                            height: 50.h,
                            width: double.infinity,
                          ),

                          ///======duration and chapters=======
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.r),
                                    color: Colors.white,
                                  ),
                                  height: 80.h,
                                  width: 130.w,
                                ),
                                SizedBox(width: 30.w),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.r),
                                    color: Colors.white,
                                  ),
                                  height: 80.h,
                                  width: 130.w,
                                ),
                              ],
                            ),
                          ),

                          ///=====summary=====
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.r),
                                  color: Colors.white,
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 18),
                                height: 30.h,
                                width: 130.w,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 30),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 20.h),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30.r),
                                        color: Colors.white,
                                      ),
                                      height: 25.h,
                                      width: 160.w,
                                    ),
                                    SizedBox(height: 10.h),
                                    Container(
                                      height: 195.h,
                                      child: ListView.separated(
                                        itemCount: 5,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30.r),
                                              color: Colors.white,
                                            ),
                                            height: 25.h,
                                          );
                                        },
                                        separatorBuilder: (BuildContext context, int index) {
                                          return SizedBox(height: 10.h);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
