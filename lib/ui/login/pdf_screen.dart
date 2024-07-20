// ignore_for_file: deprecated_member_use

import 'package:wixpod/constants/widget/button_widget.dart';
import 'package:wixpod/constants/widget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFScreen extends StatelessWidget {
  PDFScreen({Key? key, required this.file}) : super(key: key);
  final String file;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Styles.regular('Terms'.tr, fw: FontWeight.bold, ff: "Poppins-Bold", ov: TextOverflow.ellipsis),
          leading: Backbutton(),
          elevation: 0,
        ),
        body: SfPdfViewer.asset(
          file,
        ),
      ),
    );
  }
}
