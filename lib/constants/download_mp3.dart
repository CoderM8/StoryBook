import 'dart:io';
import 'package:wixpod/controller/bookdetails_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wixpod/constants/constant.dart';

RxBool cancel = true.obs;
RxInt progress = 0.obs;

Future<String?> downloadMp3({
  var songUrl,
  String? title,
  String? image,
}) async {
  Directory? externaldir;
  Dio dio = Dio();
  BookDetailsController bookController = Get.put(BookDetailsController());

  CancelToken canceltoken = CancelToken();

  progress.value = 0;
  cancel.value = true;
  try {
    if (!isAndroidVersionUp13) {
      if (await Permission.storage.request().isGranted) {
        externaldir = await getApplicationDocumentsDirectory();
        await dio.download(
          songUrl,
          '${externaldir.path}/$title.mp3',
          cancelToken: canceltoken,
          onReceiveProgress: (rcv, total) {
            progress.value = int.parse(((rcv / total) * 100).toStringAsFixed(0));
            if (cancel.value == false) {
              canceltoken.cancel('you cancelled');
              progress.value = 0;
              bookController.isDownload.value = false;
              bookController.downloadingBookId.value = "";
            }
          },
          deleteOnError: true,
        );

        return '${externaldir.path}/$title.mp3';
      } else {
        return null;
      }
    } else {
      externaldir = await getApplicationDocumentsDirectory();
      await dio.download(
        songUrl,
        '${externaldir.path}/$title.mp3',
        cancelToken: canceltoken,
        onReceiveProgress: (rcv, total) {
          progress.value = int.parse(((rcv / total) * 100).toStringAsFixed(0));
          if (cancel.value == false) {
            canceltoken.cancel('you cancelled');
            progress.value = 0;
            bookController.isDownload.value = false;
            bookController.downloadingBookId.value = "";
          }
        },
        deleteOnError: true,
      );
      return '${externaldir.path}/$title.mp3';
    }
  } on DioException catch (e) {
    bookController.isDownload.value = false;
    progress.value = 0;
    if (kDebugMode) {
      print('DIO ERROR::  ${e.message}');
    }
    return null;
  }
}
