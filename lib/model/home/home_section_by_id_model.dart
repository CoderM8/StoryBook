import 'dart:convert';

HomeSectionbyIdModel homeSectionbyIdModelFromJson(String str) => HomeSectionbyIdModel.fromJson(json.decode(str));

String homeSectionbyIdModelToJson(HomeSectionbyIdModel data) => json.encode(data.toJson());

class HomeSectionbyIdModel {
  final List<AudioBook> audioBook;

  HomeSectionbyIdModel({
    required this.audioBook,
  });

  factory HomeSectionbyIdModel.fromJson(Map<String, dynamic> json) => HomeSectionbyIdModel(
        audioBook: List<AudioBook>.from(json["AUDIO_BOOK"].map((x) => AudioBook.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "AUDIO_BOOK": List<dynamic>.from(audioBook.map((x) => x.toJson())),
      };
}

class AudioBook {
  final String totalRecords;
  final String aid;
  final String artistIds;
  final String catIds;
  final String bookSubscriptionType;
  final String bookName;
  final String bookImage;
  final String bookImageThumb;
  final bool isFavourite;
  final String playTime;
  final String bookDescription;
  final String totalRate;
  final String totalViews;
  final String rateAvg;
  final String totalDownload;
  final String status;
  final int totalAuthor;
  final int totalCategory;
  final List<AuthorList> authorList;
  final List<CatList> catList;

  AudioBook({
    required this.totalRecords,
    required this.aid,
    required this.artistIds,
    required this.catIds,
    required this.bookSubscriptionType,
    required this.bookName,
    required this.bookImage,
    required this.bookImageThumb,
    required this.isFavourite,
    required this.playTime,
    required this.bookDescription,
    required this.totalRate,
    required this.totalViews,
    required this.rateAvg,
    required this.totalDownload,
    required this.status,
    required this.totalAuthor,
    required this.totalCategory,
    required this.authorList,
    required this.catList,
  });

  factory AudioBook.fromJson(Map<String, dynamic> json) => AudioBook(
        totalRecords: json["total_records"],
        aid: json["aid"],
        artistIds: json["artist_ids"],
        catIds: json["cat_ids"],
        bookSubscriptionType: json["book_subscription_type"],
        bookName: json["book_name"],
        bookImage: json["book_image"],
        bookImageThumb: json["book_image_thumb"],
        isFavourite: json["is_favourite"],
        playTime: json["play_time"],
        bookDescription: json["book_description"],
        totalRate: json["total_rate"],
        totalViews: json["total_views"],
        rateAvg: json["rate_avg"],
        totalDownload: json["total_download"],
        status: json["status"],
        totalAuthor: json["total_author"],
        totalCategory: json["total_category"],
        authorList: List<AuthorList>.from(json["author_list"].map((x) => AuthorList.fromJson(x))),
        catList: List<CatList>.from(json["cat_list"].map((x) => CatList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_records": totalRecords,
        "aid": aid,
        "artist_ids": artistIds,
        "cat_ids": catIds,
        "book_subscription_type": bookSubscriptionType,
        "book_name": bookName,
        "book_image": bookImage,
        "book_image_thumb": bookImageThumb,
        "is_favourite": isFavourite,
        "play_time": playTime,
        "book_description": bookDescription,
        "total_rate": totalRate,
        "total_views": totalViews,
        "rate_avg": rateAvg,
        "total_download": totalDownload,
        "status": status,
        "total_author": totalAuthor,
        "total_category": totalCategory,
        "author_list": List<dynamic>.from(authorList.map((x) => x.toJson())),
        "cat_list": List<dynamic>.from(catList.map((x) => x.toJson())),
      };
}

class AuthorList {
  final String id;
  final String authorName;
  final String authorImage;
  final String authorImageThumb;

  AuthorList({
    required this.id,
    required this.authorName,
    required this.authorImage,
    required this.authorImageThumb,
  });

  factory AuthorList.fromJson(Map<String, dynamic> json) => AuthorList(
        id: json["id"],
        authorName: json["author_name"],
        authorImage: json["Author_image"],
        authorImageThumb: json["Author_image_thumb"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author_name": authorName,
        "Author_image": authorImage,
        "Author_image_thumb": authorImageThumb,
      };
}

class CatList {
  final String cid;
  final String categoryName;

  CatList({
    required this.cid,
    required this.categoryName,
  });

  factory CatList.fromJson(Map<String, dynamic> json) => CatList(
        cid: json["cid"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "cid": cid,
        "category_name": categoryName,
      };
}
