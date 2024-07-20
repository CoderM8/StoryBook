import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../model/all_author_model/all_author_model.dart';
import '../model/all_author_model/author_book.dart';
import '../services/all_services.dart';
import 'user_controller.dart';

class AllAuthor_Controller extends GetxController {
  RefreshController refreshController = RefreshController(initialRefresh: false);
  RxInt pages = 1.obs;

  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    getdata(page: pages.value).whenComplete(() {
      refreshController.loadComplete();
    });
  }

  AllAuthorModel? allauthor;

  RxBool allauthorbool = false.obs;

  Future<void> getdata({int? page}) async {
    if (allauthor == null) {
      await AllServices().allAuthor(page: page).then((value) {
        allauthor = value;
      });
      allauthorbool.value = true;
      allauthorbool.value = false;
    } else {
      if (allauthor!.onlineMp3!.length % 10 == 0) {
        await AllServices().allAuthor(page: page).then((value) {
          for (var i = 0; i < value!.onlineMp3!.length; i++) {
            allauthor!.onlineMp3!.add(value.onlineMp3![i]);
          }
        });
        allauthorbool.value = true;
        allauthorbool.value = false;
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

class AllAuthorBook_Controller extends GetxController {
  final UserController userController = Get.put(UserController());
  RefreshController refreshController = RefreshController(initialRefresh: false);
  RxInt pages = 1.obs;
  String? authorId;

  AllAuthorBook_Controller({this.authorId});

  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    authorBookData(authorId: authorId.toString(), page: pages.value).whenComplete(() {
      refreshController.loadComplete();
    });
  }

  AuthorBookModel? authorBook;

  RxBool authorBookbool = false.obs;

  Future<void> authorBookData({required int page, required String authorId}) async {
    if (authorBook == null) {
      await AllServices().authorBook(authorId: authorId, page: page).then((value) {
        authorBook = value;
      });
      authorBookbool.value = true;
      authorBookbool.value = false;
    } else {
      if (authorBook!.onlineMp3!.length % 10 == 0) {
        await AllServices().authorBook(authorId: authorId, page: page).then((value) {
          for (var i = 0; i < value!.onlineMp3!.length; i++) {
            authorBook!.onlineMp3!.add(value.onlineMp3![i]);
          }
        });
        authorBookbool.value = true;
        authorBookbool.value = false;
      }
    }
    pages.value++;
  }

  @override
  void onInit() {
    super.onInit();
    authorBookData(authorId: authorId.toString(), page: pages.value);
  }
}
