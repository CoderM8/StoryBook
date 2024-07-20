import 'package:wixpod/controller/bookdetails_controller.dart';
import 'package:wixpod/services/all_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/user_controller.dart';
import 'package:wixpod/constants/constant.dart';

class CustomRatingBar extends StatelessWidget {
  final String? bookid;
  final double? userRate;

  CustomRatingBar({super.key, this.bookid, this.userRate});

  final BookDetailsController bookController = Get.put(BookDetailsController());
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bookController.israting.value;
      return RatingBar(
        itemSize: 45.w.h,
        initialRating: double.parse(userRate.toString()),
        minRating: 0,
        direction: Axis.horizontal,updateOnDrag: false,
        allowHalfRating: false,
        itemCount: 5,
        ratingWidget: RatingWidget(
          full: const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          half: const Icon(
            Icons.star_half,
            color: Colors.amber,
          ),
          empty: const Icon(
            Icons.star_border_rounded,
            color: Colors.amber,
          ),
        ),
        itemPadding: EdgeInsets.symmetric(horizontal: 2.0.w),
        onRatingUpdate: (rate) async {
          if (!userController.isguest.value) {
            await AllServices().bookratingservice(bookid: bookid!, userid: userid!, rating: rate).then((value) {
              if (value['AUDIO_BOOK'][0]['success'] == '0') {
                ShowSnackBar(message: value['AUDIO_BOOK'][0]['msg']);
              } else {
                bookController.israting.value = !bookController.israting.value;
              }
            });
          } else {
            ShowSnackBar(message: 'Login_guest'.tr);
          }
        },
      );
    });
  }
}
