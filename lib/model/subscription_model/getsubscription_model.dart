import 'dart:convert';

GetSubscriptionModel getSubscriptionModelFromJson(String str) => GetSubscriptionModel.fromJson(json.decode(str));

String getSubscriptionModelToJson(GetSubscriptionModel data) => json.encode(data.toJson());

class GetSubscriptionModel {
  final List<AudioBook> audioBook;

  GetSubscriptionModel({
    required this.audioBook,
  });

  factory GetSubscriptionModel.fromJson(Map<String, dynamic> json) => GetSubscriptionModel(
        audioBook: List<AudioBook>.from(json["AUDIO_BOOK"].map((x) => AudioBook.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "AUDIO_BOOK": List<dynamic>.from(audioBook.map((x) => x.toJson())),
      };
}

class AudioBook {
  final String msg;
  final String status;
  final String daysRemain;
  final dynamic bookCoins;
  final String planId;
  final List<Member> member;
  final int isMemeberAdd;
  final String transactionId;
  final String planName;
  final String price;
  final DateTime planStartDate;
  final DateTime planEndDate;
  final String purchaseId;
  final String success;

  AudioBook({
    required this.msg,
    required this.status,
    required this.daysRemain,
    required this.bookCoins,
    required this.planId,
    required this.member,
    required this.isMemeberAdd,
    required this.transactionId,
    required this.planName,
    required this.price,
    required this.planStartDate,
    required this.planEndDate,
    required this.purchaseId,
    required this.success,
  });

  factory AudioBook.fromJson(Map<String, dynamic> json) => AudioBook(
        msg: json["msg"],
        status: json["status"],
        daysRemain: json["days_remain"] ?? '',
        bookCoins: json["book_coins"] ?? '',
        planId: json["plan_id"],
        member: json["member"] != null ? List<Member>.from(json["member"].map((x) => Member.fromJson(x))) : [],
        isMemeberAdd: json["is_memeber_add"] ?? 0,
        transactionId: json["transaction_id"] ?? '',
        planName: json["plan_name"],
        price: json["price"] ?? '',
        planStartDate: json["plan_start_date"] != null ? DateTime.parse(json["plan_start_date"]) : DateTime.now(),
        planEndDate: json["plan_end_date"] != null ? DateTime.parse(json["plan_end_date"]) : DateTime.now(),
        purchaseId: json["purchase_id"] ?? "",
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "status": status,
        "days_remain": daysRemain,
        "book_coins": bookCoins,
        "plan_id": planId,
        "member": List<dynamic>.from(member.map((x) => x.toJson())),
        "is_memeber_add": isMemeberAdd,
        "transaction_id": transactionId,
        "plan_name": planName,
        "price": price,
        "plan_start_date": planStartDate,
        "plan_end_date": planEndDate,
        "purchase_id": purchaseId,
        "success": success,
      };
}

class Member {
  final String name;
  final String email;

  Member({
    required this.name,
    required this.email,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
      };
}
