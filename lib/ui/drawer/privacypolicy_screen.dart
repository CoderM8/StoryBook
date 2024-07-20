// ignore_for_file: deprecated_member_use

import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/constant.dart';
import '../../constants/widget/textwidget.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key, required this.data}) : super(key: key);
  final String data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Backbutton(),
        centerTitle: true,
        elevation: 0.0,
        title: Styles.regular('Privacy_Policy'.tr, fs: 22.sp, ff: "Poppins-Bold", fw: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        child: Html(data: data, style: {
          "body": Style(
           color: whiteColor,fontSize: FontSize(15.sp / MediaQuery.of(context).textScaleFactor)
          ), "h3":Style(
              color: whiteColor,fontSize: FontSize(16.sp / MediaQuery.of(context).textScaleFactor)
          ), "strong":Style(
              color: whiteColor,fontSize: FontSize(18.sp / MediaQuery.of(context).textScaleFactor)
          ),
        },),
      ),
    );
  }
}
