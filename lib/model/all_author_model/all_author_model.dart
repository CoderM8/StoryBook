
import 'dart:convert';

AllAuthorModel allAuthorModelFromJson(String str) => AllAuthorModel.fromJson(json.decode(str));

String allAuthorModelToJson(AllAuthorModel data) => json.encode(data.toJson());

class AllAuthorModel {
  AllAuthorModel({
    this.onlineMp3,
  });

  List<OnlineMp3>? onlineMp3;

  factory AllAuthorModel.fromJson(Map<String, dynamic> json) => AllAuthorModel(
    onlineMp3: List<OnlineMp3>.from(json["AUDIO_BOOK"].map((x) => OnlineMp3.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "AUDIO_BOOK": List<dynamic>.from(onlineMp3!.map((x) => x.toJson())),
  };
}

class OnlineMp3 {
  OnlineMp3({
    this.totalRecords,
    this.id,
    this.authorName,
    this.authorImage,
    this.authorImageThumb,
    this.totalSongs,
  });

  String? totalRecords;
  String? id;
  String? authorName;
  String? authorImage;
  String? authorImageThumb;
  int? totalSongs;

  factory OnlineMp3.fromJson(Map<String, dynamic> json) => OnlineMp3(
    totalRecords: json["total_records"],
    id: json["id"],
    authorName: json["Author_name"],
    authorImage: json["Author_image"],
    authorImageThumb: json["Author_image_thumb"],
    totalSongs: json["total_songs"],
  );

  Map<String, dynamic> toJson() => {
    "total_records": totalRecords,
    "id": id,
    "Author_name": authorName,
    "Author_image": authorImage,
    "Author_image_thumb": authorImageThumb,
    "total_songs": totalSongs,
  };
}
