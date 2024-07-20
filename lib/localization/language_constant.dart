import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/constant.dart';

class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;
  final String countryCode;

  Language(this.id, this.flag, this.name, this.languageCode, this.countryCode);

  static List<Language> languageList = <Language>[
    Language(0, "🇺🇸", "English", "en", "US"),
    Language(1, "🇩🇰", "Danish", "da", "DK"),
    Language(2, "🇫🇷", "French", "fr", "FR"),
  ];
}

Future setLocale(String languageCode,String languageName) async {
  await box.write('languageCode', languageCode);
  await box.write('languageName', languageName);
  Get.updateLocale(Locale(languageCode));
}
