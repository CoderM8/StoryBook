
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wixpod/constants/constant.dart';
import 'package:wixpod/constants/widget/textwidget.dart';

class ShowBook extends StatelessWidget {
  ShowBook({Key? key, this.index, this.tcolor, this.bookimage, this.title, this.author, this.description, this.icolor}) : super(key: key);

  final int? index;
  final Color? tcolor;
  final Color? icolor;
  final String? bookimage;
  final String? title;
  final String? author;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 381.w,
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          Container(
            height: 203.08.w,
            width: 139.00.w,
            child: ImageView(
              imageUrl: bookimage!,
              memCacheHeight: 400,
              radius: 10.r,
              height: 203.08.w,
              width: 139.00.w,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Styles.regular("$index", fs: 50.sp, c: icolor ?? greyColor, ta: TextAlign.start),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 200.w,
                    child: Styles.regular(title!,
                        fs: 14.sp, c: tcolor, ff: "Poppins-SemiBold", lns: 2, ta: TextAlign.start, ov: TextOverflow.ellipsis),
                  ),
                  Styles.regular(description!, fs: 10.sp, ff: "Poppins-Regular", ov: TextOverflow.ellipsis, ta: TextAlign.start, lns: 5),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
