import 'dart:convert';

AllBookModel allBookModelFromJson(String str) => AllBookModel.fromJson(json.decode(str));

String allBookModelToJson(AllBookModel data) => json.encode(data.toJson());

class AllBookModel {
  AllBookModel({
    required this.onlineMp3,
  });

  final List<OnlineMp3> onlineMp3;

  factory AllBookModel.fromJson(Map<String, dynamic> json) => AllBookModel(
        onlineMp3: List<OnlineMp3>.from(json["AUDIO_BOOK"].map((x) => OnlineMp3.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "AUDIO_BOOK": List<dynamic>.from(onlineMp3.map((x) => x.toJson())),
      };
}

class OnlineMp3 {
  OnlineMp3({
    required this.totalRecords,
    required this.aid,
    required this.bookName,
    required this.catIds,
    required this.bookImage,
    required this.bookImageThumb,
    required this.isFavourite,
    required this.total5,
    required this.total4,
    required this.total3,
    required this.total2,
    required this.total1,
    required this.totalRate,
    required this.totalViews,
    required this.rateAvg,
    required this.totalDownload,
    required this.totalAuthor,
    required this.authorList,
    required this.artistList,
  });

  final String totalRecords;
  final String aid;
  final String bookName;
  final String catIds;
  final String bookImage;
  final String bookImageThumb;
  final bool isFavourite;
  final String total5;
  final String total4;
  final String total3;
  final String total2;
  final String total1;
  final String totalRate;
  final String totalViews;
  final String rateAvg;
  final String totalDownload;
  final int totalAuthor;
  final List<AuthorList> authorList;
  final String artistList;

  factory OnlineMp3.fromJson(Map<String, dynamic> json) => OnlineMp3(
        totalRecords: json["total_records"],
        aid: json["aid"],
        bookName: json["book_name"],
        catIds: json["cat_ids"],
        bookImage: json["book_image"],
        bookImageThumb: json["book_image_thumb"],
        isFavourite: json["is_favourite"],
        total5: json["total_5"],
        total4: json["total_4"],
        total3: json["total_3"],
        total2: json["total_2"],
        total1: json["total_1"],
        totalRate: json["total_rate"],
        totalViews: json["total_views"],
        rateAvg: json["rate_avg"],
        totalDownload: json["total_download"],
        totalAuthor: json["total_author"],
        authorList: List<AuthorList>.from(json["author_list"].map((x) => AuthorList.fromJson(x))),
        artistList: json["artist_list"],
      );

  Map<String, dynamic> toJson() => {
        "total_records": totalRecords,
        "aid": aid,
        "book_name": bookName,
        "cat_ids": catIds,
        "book_image": bookImage,
        "book_image_thumb": bookImageThumb,
        "is_favourite": isFavourite,
        "total_5": total5,
        "total_4": total4,
        "total_3": total3,
        "total_2": total2,
        "total_1": total1,
        "total_rate": totalRate,
        "total_views": totalViews,
        "rate_avg": rateAvg,
        "total_download": totalDownload,
        "total_author": totalAuthor,
        "author_list": List<dynamic>.from(authorList.map((x) => x.toJson())),
        "artist_list": artistList,
      };
}

class AuthorList {
  AuthorList({
    required this.id,
    required this.authorName,
    required this.authorImage,
    required this.authorImageThumb,
  });

  final String id;
  final String authorName;
  final String authorImage;
  final String authorImageThumb;

  factory AuthorList.fromJson(Map<String, dynamic> json) => AuthorList(
        id: json["id"],
        authorName: json["author_name"],
        authorImage: json["author_image"],
        authorImageThumb: json["author_image_thumb"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author_name": authorName,
        "author_image": authorImage,
        "author_image_thumb": authorImageThumb,
      };
}
