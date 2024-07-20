import 'package:wixpod/model/home/home_section_by_id_model.dart';
import 'package:wixpod/services/all_services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeBannerController extends GetxController {
  RefreshController refreshController = RefreshController(initialRefresh: false);
  RxInt pages = 1.obs;
  String? id;

  HomeBannerController({this.id});

  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    homebannerBooks(id: id.toString(), page: pages.value).whenComplete(() {
      refreshController.loadComplete();
    });
  }

  HomeSectionbyIdModel? HomeSectionbyIdBooks;

  RxBool HomeSectionbyIdBooksbool = false.obs;

  Future<void> homebannerBooks({required int page, required String id}) async {
    if (HomeSectionbyIdBooks == null) {
      await AllServices().homeSectionbyID(id: id, page: page).then((value) {
        HomeSectionbyIdBooks = value;
      });
      HomeSectionbyIdBooksbool.value = true;
      HomeSectionbyIdBooksbool.value = false;
    } else {
      if (HomeSectionbyIdBooks!.audioBook.length % 12 == 0) {
        await AllServices().homeSectionbyID(id: id, page: page).then((value) {
          for (var i = 0; i < value!.audioBook.length; i++) {
            HomeSectionbyIdBooks!.audioBook.add(value.audioBook[i]);
          }
        });
        HomeSectionbyIdBooksbool.value = true;
        HomeSectionbyIdBooksbool.value = false;
      }
    }
    pages.value++;
  }

  @override
  void onInit() {
    super.onInit();
    homebannerBooks(id: id.toString(), page: pages.value);
  }
}
