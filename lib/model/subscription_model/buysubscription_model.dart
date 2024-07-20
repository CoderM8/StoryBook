import 'dart:convert';

BuySubscriptionModel buySubscriptionModelFromJson(String str) => BuySubscriptionModel.fromJson(json.decode(str));

String buySubscriptionModelToJson(BuySubscriptionModel data) => json.encode(data.toJson());

class BuySubscriptionModel {
  final List<AudioBook> audioBook;

  BuySubscriptionModel({
    required this.audioBook,
  });

  factory BuySubscriptionModel.fromJson(Map<String, dynamic> json) => BuySubscriptionModel(
        audioBook: List<AudioBook>.from(json["AUDIO_BOOK"].map((x) => AudioBook.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "AUDIO_BOOK": List<dynamic>.from(audioBook.map((x) => x.toJson())),
      };
}

class AudioBook {
  final String msg;
  final String success;

  AudioBook({
    required this.msg,
    required this.success,
  });

  factory AudioBook.fromJson(Map<String, dynamic> json) => AudioBook(
        msg: json["msg"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "success": success,
      };
}
