import 'dart:convert';

RegistrationModel registrationModelFromJson(String str) => RegistrationModel.fromJson(json.decode(str));

String registrationModelToJson(RegistrationModel data) => json.encode(data.toJson());

class RegistrationModel {
  final List<AudioBook> audioBook;

  RegistrationModel({
    required this.audioBook,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) => RegistrationModel(
    audioBook: List<AudioBook>.from(json["AUDIO_BOOK"].map((x) => AudioBook.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "AUDIO_BOOK": List<dynamic>.from(audioBook.map((x) => x.toJson())),
  };
}

class AudioBook {
  final String userId;
  final String name;
  final String userImage;
  final String email;
  final String msg;
  final String authId;
  final String success;

  AudioBook({
    required this.userId,
    required this.name,
    required this.userImage,
    required this.email,
    required this.msg,
    required this.authId,
    required this.success,
  });

  factory AudioBook.fromJson(Map<String, dynamic> json) => AudioBook(
    userId: json["user_id"] ?? '',
    name: json["name"] ?? '',
    userImage: json["user_image"] ?? '',
    email: json["email"] ?? '',
    msg: json["msg"] ?? '',
    authId: json["auth_id"] ?? '',
    success: json["success"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "user_image": userImage,
    "email": email,
    "msg": msg,
    "auth_id": authId,
    "success": success,
  };
}
