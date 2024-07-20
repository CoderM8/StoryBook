
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wixpod/constants/constant.dart';
import 'package:wixpod/controller/bookdetails_controller.dart';
import 'package:wixpod/services/all_services.dart';
import '../../controller/user_controller.dart';

class CustomFavouriteButton extends StatelessWidget {
  final String? bookid;

  CustomFavouriteButton({super.key, this.bookid});

  final BookDetailsController bookController = Get.put(BookDetailsController());
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bookController.isLike.value;
      return InkWell(splashColor: Colors.transparent,
        onTap: () async {
          if (!userController.isguest.value) {
            await AllServices().favouriteBook(bookid: bookid).then((val) async {
              val!.onlineMp3[0].success == "1" ? bookController.isLike.value = true : bookController.isLike.value = false;
              await AllServices().getfavouriteBook();
            }).whenComplete(() => bookController.update());
          } else {
            ShowSnackBar(message: 'Login_guest'.tr);
          }
        },
        child:Container(
          height: 50.r,
          width: 50.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(66.sp),
          ),
              child:  bookController.isLike.value == true ? Icon(
                  Icons.favorite_outlined,
                  color: redColor,
                ) : Icon(
                Icons.favorite_border_rounded,
                color: greyColor,
              ),
            )
      );
    });
  }
}
