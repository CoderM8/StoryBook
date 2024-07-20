import 'dart:convert';

AddCountDataModel addCountDataModelFromJson(String str) => AddCountDataModel.fromJson(json.decode(str));

String addCountDataModelToJson(AddCountDataModel data) => json.encode(data.toJson());

class AddCountDataModel {
  final List<AudioBook> audioBook;

  AddCountDataModel({
    required this.audioBook,
  });

  factory AddCountDataModel.fromJson(Map<String, dynamic> json) => AddCountDataModel(
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
