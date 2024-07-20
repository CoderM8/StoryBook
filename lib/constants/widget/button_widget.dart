// ignore_for_file: deprecated_member_use


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wixpod/constants/constant.dart';
import 'package:wixpod/constants/widget/textwidget.dart';

class Button extends StatelessWidget {
  const Button({Key? key, required this.title, this.color, this.titleColor, this.width}) : super(key: key);

  final String title;
  final Color? color;
  final Color? titleColor;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      width: width ?? 268.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: color ?? whiteColor),
      child: Center(
        child: Styles.regular(title, ff: "Poppins-SemiBold", fs: 20.sp, c: titleColor ?? blackColor, fw: FontWeight.bold),
      ),
    );
  }
}

class Backbutton extends StatelessWidget {
  const Backbutton({Key? key, this.color, this.onTap}) : super(key: key);
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            Get.back();
          },
      child: Container(
        height: 50.w,
        width: 50.w,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
        child: SvgPicture.asset(
          "assets/icons/back.svg",
          color: color ?? whiteColor,
        ),
      ),
    );
  }
}
