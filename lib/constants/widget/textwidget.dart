import 'package:wixpod/constants/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Styles {
  static Text regular(
    String text, {
    double? fs,
    String? ff,
    Color? c,
    double? ls,
    TextAlign? ta,
    double? h,
    FontWeight? fw,
    bool strike = false,
    int? lns,
    bool underline = false,
    TextOverflow? ov,
  }) {
    return Text(
      text,
      textAlign: ta ?? TextAlign.center,
      maxLines: lns,
      overflow: ov,textScaler: TextScaler.linear(1),
      softWrap: true,
      style: TextStyle(
        fontSize: fs ?? 18.sp,
        fontWeight: fw ?? FontWeight.normal,
        color: c ?? whiteColor,
        letterSpacing: ls,
        height: h,
        fontFamily: ff ?? "Poppins-Medium",
        decoration: underline
            ? TextDecoration.underline
            : strike
                ? TextDecoration.lineThrough
                : TextDecoration.none,
      ),
    );
  }
}
