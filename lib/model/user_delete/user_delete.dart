import 'dart:convert';

DeleteProfileModel deleteProfileModelFromJson(String str) => DeleteProfileModel.fromJson(json.decode(str));

String deleteProfileModelToJson(DeleteProfileModel data) => json.encode(data.toJson());

class DeleteProfileModel {
  DeleteProfileModel({
    required this.onlineMp3,
  });

  final List<OnlineMp3> onlineMp3;

  factory DeleteProfileModel.fromJson(Map<String, dynamic> json) => DeleteProfileModel(
    onlineMp3: List<OnlineMp3>.from(json["AUDIO_BOOK"].map((x) => OnlineMp3.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "AUDIO_BOOK": List<dynamic>.from(onlineMp3.map((x) => x.toJson())),
  };
}

class OnlineMp3 {
  OnlineMp3({
    required this.msg,
    required this.success,
  });

  final String msg;
  final String success;

  factory OnlineMp3.fromJson(Map<String, dynamic> json) => OnlineMp3(
    msg: json["MSG"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "MSG": msg,
    "success": success,
  };
}
