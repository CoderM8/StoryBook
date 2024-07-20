import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../model/category_model/categorywise_model.dart';
import '../services/all_services.dart';

class CategoryController extends GetxController {
  RefreshController refreshController = RefreshController(initialRefresh: false);

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  RxInt pages = 1.obs;
  String? categoryId;

  CategoryController({this.categoryId});

  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    categoryBookData(catId: categoryId.toString(), page: pages.value).whenComplete(() {
      refreshController.loadComplete();
    });
  }

  CategoryWiseBooks? categoryWiseBooks;

  RxBool categorywiseBookbool = false.obs;

  Future<void> categoryBookData({required int page, required String catId}) async {
    if (categoryWiseBooks == null) {
      await AllServices().categoryBooks(catId: catId, page: page).then((value) {
        categoryWiseBooks = value;
      });
      categorywiseBookbool.value = true;
      categorywiseBookbool.value = false;
    } else {
      if (categoryWiseBooks!.audioBook.length % 10 == 0) {
        await AllServices().categoryBooks(catId: catId, page: page).then((value) {
          for (var i = 0; i < value!.audioBook.length; i++) {
            categoryWiseBooks!.audioBook.add(value.audioBook[i]);
          }
        });
        categorywiseBookbool.value = true;
        categorywiseBookbool.value = false;
      }
    }
    pages.value++;
  }

  @override
  void onInit() {
    super.onInit();
    categoryBookData(catId: categoryId.toString(), page: pages.value);
  }
}
