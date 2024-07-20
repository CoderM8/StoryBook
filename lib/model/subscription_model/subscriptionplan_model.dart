import 'dart:convert';

SubscriptionPlanModel subscriptionPlanModelFromJson(String str) => SubscriptionPlanModel.fromJson(json.decode(str));

String subscriptionPlanModelToJson(SubscriptionPlanModel data) => json.encode(data.toJson());

class SubscriptionPlanModel {
  final List<AudioBook> audioBook;

  SubscriptionPlanModel({
    required this.audioBook,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) => SubscriptionPlanModel(
        audioBook: List<AudioBook>.from(json["AUDIO_BOOK"].map((x) => AudioBook.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "AUDIO_BOOK": List<dynamic>.from(audioBook.map((x) => x.toJson())),
      };
}

class AudioBook {
  final String id;
  final String skuId;
  final String planName;
  final String planDuration;
  final String planType;
  final String planPrice;
  final String planDescription;

  AudioBook({
    required this.id,
    required this.skuId,
    required this.planName,
    required this.planDuration,
    required this.planType,
    required this.planPrice,
    required this.planDescription,
  });

  factory AudioBook.fromJson(Map<String, dynamic> json) => AudioBook(
        id: json["id"],
        skuId: json["sku_id"],
        planName: json["plan_name"],
        planDuration: json["plan_duration"],
        planType: json["plan_type"],
        planPrice: json["plan_price"],
        planDescription: json["plan_description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sku_id": skuId,
        "plan_name": planName,
        "plan_duration": planDuration,
        "plan_type": planType,
        "plan_price": planPrice,
        "plan_description": planDescription,
      };
}
