import 'dart:convert';

AddUserFamilyModel addUserFamilyModelFromJson(String str) => AddUserFamilyModel.fromJson(json.decode(str));

String addUserFamilyModelToJson(AddUserFamilyModel data) => json.encode(data.toJson());

class AddUserFamilyModel {
  final List<AudioBook> audioBook;

  AddUserFamilyModel({
    required this.audioBook,
  });

  factory AddUserFamilyModel.fromJson(Map<String, dynamic> json) => AddUserFamilyModel(
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
