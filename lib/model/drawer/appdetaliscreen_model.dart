import 'dart:convert';

AppDetalisModel appDetalisModelFromJson(String str) => AppDetalisModel.fromJson(json.decode(str));

String appDetalisModelToJson(AppDetalisModel data) => json.encode(data.toJson());

class AppDetalisModel {
  AppDetalisModel({
    required this.audioBook,
  });

  final List<AudioBook> audioBook;

  factory AppDetalisModel.fromJson(Map<String, dynamic> json) => AppDetalisModel(
    audioBook: List<AudioBook>.from(json["AUDIO_BOOK"].map((x) => AudioBook.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "AUDIO_BOOK": List<dynamic>.from(audioBook.map((x) => x.toJson())),
  };
}

class AudioBook {
  AudioBook({
    required this.packageName,
    required this.appName,
    required this.appLogo,
    required this.appVersion,
    required this.appAuthor,
    required this.appContact,
    required this.appEmail,
    required this.appWebsite,
    required this.appDescription,
    required this.appDevelopedBy,
    required this.appPrivacyPolicy,
    required this.publisherId,
    required this.interstitalAd,
    required this.interstitalAdId,
    required this.interstitalAdClick,
    required this.bannerAd,
    required this.bannerAdId,
    required this.appOpenAdId,
    required this.iosInterstitalAd,
    required this.iosInterstitalAdId,
    required this.iosInterstitalAdClick,
    required this.iosBannerAd,
    required this.iosBannerAdId,
    required this.iosAppOpenAdId,
  });

  final String packageName;
  final String appName;
  final String appLogo;
  final String appVersion;
  final String appAuthor;
  final String appContact;
  final String appEmail;
  final String appWebsite;
  final String appDescription;
  final String appDevelopedBy;
  final String appPrivacyPolicy;
  final String publisherId;
  final String interstitalAd;
  final String interstitalAdId;
  final String interstitalAdClick;
  final String bannerAd;
  final String bannerAdId;
  final String appOpenAdId;
  final String iosInterstitalAd;
  final String iosInterstitalAdId;
  final String iosInterstitalAdClick;
  final String iosBannerAd;
  final String iosBannerAdId;
  final String iosAppOpenAdId;

  factory AudioBook.fromJson(Map<String, dynamic> json) => AudioBook(
    packageName: json["package_name"],
    appName: json["app_name"],
    appLogo: json["app_logo"],
    appVersion: json["app_version"],
    appAuthor: json["app_author"],
    appContact: json["app_contact"],
    appEmail: json["app_email"],
    appWebsite: json["app_website"],
    appDescription: json["app_description"],
    appDevelopedBy: json["app_developed_by"],
    appPrivacyPolicy: json["app_privacy_policy"],
    publisherId: json["publisher_id"],
    interstitalAd: json["interstital_ad"],
    interstitalAdId: json["interstital_ad_id"],
    interstitalAdClick: json["interstital_ad_click"],
    bannerAd: json["banner_ad"],
    bannerAdId: json["banner_ad_id"],
    appOpenAdId: json["app_open_ad_id"],
    iosInterstitalAd: json["ios_interstital_ad"],
    iosInterstitalAdId: json["ios_interstital_ad_id"],
    iosInterstitalAdClick: json["ios_interstital_ad_click"],
    iosBannerAd: json["ios_banner_ad"],
    iosBannerAdId: json["ios_banner_ad_id"],
    iosAppOpenAdId: json["ios_app_open_ad_id"],
  );

  Map<String, dynamic> toJson() => {
    "package_name": packageName,
    "app_name": appName,
    "app_logo": appLogo,
    "app_version": appVersion,
    "app_author": appAuthor,
    "app_contact": appContact,
    "app_email": appEmail,
    "app_website": appWebsite,
    "app_description": appDescription,
    "app_developed_by": appDevelopedBy,
    "app_privacy_policy": appPrivacyPolicy,
    "publisher_id": publisherId,
    "interstital_ad": interstitalAd,
    "interstital_ad_id": interstitalAdId,
    "interstital_ad_click": interstitalAdClick,
    "banner_ad": bannerAd,
    "banner_ad_id": bannerAdId,
    "app_open_ad_id": appOpenAdId,
    "ios_interstital_ad": iosInterstitalAd,
    "ios_interstital_ad_id": iosInterstitalAdId,
    "ios_interstital_ad_click": iosInterstitalAdClick,
    "ios_banner_ad": iosBannerAd,
    "ios_banner_ad_id": iosBannerAdId,
    "ios_app_open_ad_id": iosAppOpenAdId,
  };
}
