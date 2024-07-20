import 'package:wixpod/services/all_services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../model/all_book_model/all_book_model.dart';

class AllBook_Controller extends GetxController {
  RefreshController refreshController = RefreshController(initialRefresh: false);
  RxInt pages = 1.obs;

  void onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    getdata(page: pages.value).whenComplete(() {
      refreshController.loadComplete();
    });
  }

  AllBookModel? allbook;

  RxBool allbokbool = false.obs;

  Future<void> getdata({int? page}) async {
    if (allbook == null) {
      await AllServices().allBook(page: page).then((value) {
        allbook = value;
      });
      allbokbool.value = true;
      allbokbool.value = false;
    } else {
      if (allbook!.onlineMp3.length % 12 == 0) {
        await AllServices().allBook(page: page).then((value) {
          for (var i = 0; i < value!.onlineMp3.length; i++) {
            allbook!.onlineMp3.add(value.onlineMp3[i]);
          }
        });
        allbokbool.value = true;
        allbokbool.value = false;
      }
    }
    pages.value++;
  }

  @override
  void onInit() {
    super.onInit();
    getdata(page: pages.value);
  }
}
