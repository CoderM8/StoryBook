// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wixpod/constants/constant.dart';
import 'package:wixpod/constants/widget/textwidget.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    this.hint,
    this.maxLine = 1,
    this.padding = 0,
    this.hintpaddingheight = 13,
    this.hintpaddingwidth = 13,
    this.prefixIcon,
    this.suffixIcon,
    this.obse = false,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.onchange,
    this.pretxt,
    this.enabled,
    this.color,
    this.height,
    this.labelText,
    this.width,
    this.minLines,
    this.onSubmitted,
    this.onTap,
    this.border = false,
    this.inputFormatters,
    this.validation,
    this.textcapitalization,
    @required this.controller,
  });

  final TextEditingController? controller;
  final String? hint;
  final String? labelText;
  final double? hintpaddingheight;
  final double? hintpaddingwidth;
  final Color? color;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obse;
  final bool? enabled;
  final bool? border;
  final int? maxLine;
  final int? minLines;
  final Function(String)? onchange;
  final void Function()? onTap;
  final Function(String?)? onSubmitted;
  final String? pretxt;
  final double? height;
  final double? width;
  final double? padding;
  final String? Function(String?)? validation;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textcapitalization;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Styles.regular(
            labelText ?? "",
          ff: 'Poppins-Medium', c: blackColor, fs: 12.sp, fw: FontWeight.normal,ta: TextAlign.start
          ),
          TextFormField(
            onChanged: onchange,
            textCapitalization: labelText == 'Name' ? TextCapitalization.words : TextCapitalization.none,
            validator: validation,
            onTap: onTap,
            controller: controller,
            maxLines: maxLine,
            autofocus: false,
            enabled: enabled,
            obscureText: obse!,
            initialValue: pretxt,
            cursorColor: color,
            cursorWidth: 1,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintText: hint,
              isDense: false,
              prefixStyle: const TextStyle(color: Colors.black),
              contentPadding: EdgeInsets.symmetric(
                horizontal: hintpaddingwidth!.w,
                vertical: hintpaddingheight!.h,
              ),
              errorStyle:
                  TextStyle(fontFamily: 'Poppins-Regular', color: Colors.red, fontSize: 14.sp / MediaQuery.of(context).textScaleFactor, height: 0, decoration: TextDecoration.none),
              hintStyle: TextStyle(
                color: blackColor,
                fontFamily: 'Poppins-Regular',
                fontSize: 16.sp / MediaQuery.of(context).textScaleFactor,
              ),
              fillColor: color,
              border: border == true
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: blackColor, width: 1.w),
                    )
                  : InputBorder.none,
              enabledBorder: border == true
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: blackColor, width: 1.w),
                    )
                  : InputBorder.none,
              focusedBorder: border == true
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: blackColor, width: 1.w),
                    )
                  : InputBorder.none,
              focusedErrorBorder: border == true
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: blackColor, width: 1.w),
                    )
                  : InputBorder.none,
              errorBorder: border == true
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: blackColor, width: 1.w),
                    )
                  : InputBorder.none,
            ),
            keyboardType: textInputType,
            textInputAction: textInputAction,
            style: TextStyle(
              fontFamily: 'Poppins_Medium',
              color: blackColor,
              fontSize: 14.sp / MediaQuery.of(context).textScaleFactor,
            ),
          ),
        ],
      ),
    );
  }
}

class TextFieldprofiWidget extends StatelessWidget {
  const TextFieldprofiWidget({
    this.hint,
    this.maxLine = 1,
    this.padding = 0,
    this.hintpaddingheight = 13,
    this.hintpaddingwidth = 13,
    this.prefixIcon,
    this.suffixIcon,
    this.obse = false,
    this.textInputType = TextInputType.text,
    this.onchange,
    this.pretxt,
    this.enabled,
    this.color,
    this.height,
    this.width,
    this.minLines,
    this.onSubmitted,
    this.onTap,
    this.border = false,
    this.inputFormatters,
    this.focusNode,
    this.validation,
    @required this.controller,
  });

  final TextEditingController? controller;
  final String? hint;
  final double? hintpaddingheight;
  final double? hintpaddingwidth;
  final Color? color;
  final TextInputType? textInputType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obse;
  final bool? enabled;
  final bool? border;
  final int? maxLine;
  final int? minLines;
  final Function(String)? onchange;
  final void Function()? onTap;
  final Function(String?)? onSubmitted;
  final String? pretxt;
  final double? height;
  final double? width;
  final double? padding;
  final FocusNode? focusNode;
  final String? Function(String?)? validation;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding!.w,
      ),
      child: SizedBox(
        height: height,
        width: width,
        child: TextFormField(
          onChanged: onchange,
          validator: validation,
          onTap: onTap,
          controller: controller,
          maxLines: maxLine,
          autofocus: false,
          enabled: enabled,
          focusNode: focusNode,
          obscureText: obse!,
          initialValue: pretxt,
          cursorColor: color,
          cursorWidth: 1,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            hintText: hint,
            isDense: false,
            prefixStyle: const TextStyle(color: Colors.black),
            contentPadding: EdgeInsets.symmetric(
              horizontal: hintpaddingwidth!.w,
              vertical: hintpaddingheight!.h,
            ),
            errorStyle:
                TextStyle(fontFamily: 'Poppins-Regular', color: Colors.red, fontSize: 14.sp / MediaQuery.of(context).textScaleFactor, height: 0, decoration: TextDecoration.none),
            hintStyle: TextStyle(
              color: blackColor,
              fontFamily: 'Poppins-Regular',
              fontSize: 16.sp / MediaQuery.of(context).textScaleFactor,
            ),
            fillColor: color,
            border: border == true
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.black12, width: 1.w),
                  )
                : InputBorder.none,
            enabledBorder: border == true
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.black12, width: 1.w),
                  )
                : InputBorder.none,
            focusedBorder: border == true
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.black12, width: 1.w),
                  )
                : InputBorder.none,
            focusedErrorBorder: border == true
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.black12, width: 1.w),
                  )
                : InputBorder.none,
            errorBorder: border == true
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.black12, width: 1.w),
                  )
                : InputBorder.none,
          ),
          keyboardType: textInputType,
          style: TextStyle(
            fontFamily: 'Poppins_Medium',
            color: blackColor,
            fontSize: 14.sp / MediaQuery.of(context).textScaleFactor,
          ),
        ),
      ),
    );
  }
}
