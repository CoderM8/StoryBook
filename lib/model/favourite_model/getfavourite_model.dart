import 'dart:convert';

GetFavouriteModel getFavouriteModelFromJson(String str) => GetFavouriteModel.fromJson(json.decode(str));

String getFavouriteModelToJson(GetFavouriteModel data) => json.encode(data.toJson());

class GetFavouriteModel {
  GetFavouriteModel({
    required this.onlineMp3,
  });

  final List<OnlineMp3> onlineMp3;

  factory GetFavouriteModel.fromJson(Map<String, dynamic> json) => GetFavouriteModel(
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
    required this.authorIds,
    required this.catIds,
    required this.bookName,
    required this.bookImage,
    required this.bookImageThumb,
    required this.bookDescription,
    required this.totalRate,
    required this.rateAvg,
    required this.totalViews,
    required this.totalDownload,
    required this.isFavourite,
    required this.totalAuthor,
    required this.totalCategory,
    required this.authorList,
    required this.catList,
  });

  final String totalRecords;
  final String aid;
  final String authorIds;
  final String catIds;
  final String bookName;
  final String bookImage;
  final String bookImageThumb;
  final String bookDescription;
  final String totalRate;
  final String rateAvg;
  final String totalViews;
  final String totalDownload;
  final bool isFavourite;
  final int totalAuthor;
  final int totalCategory;
  final List<AuthorList> authorList;
  final List<CatList> catList;

  factory OnlineMp3.fromJson(Map<String, dynamic> json) => OnlineMp3(
        totalRecords: json["total_records"],
        aid: json["aid"],
        authorIds: json["author_ids"],
        catIds: json["cat_ids"],
        bookName: json["book_name"],
        bookImage: json["book_image"],
        bookImageThumb: json["book_image_thumb"],
        bookDescription: json["book_description"],
        totalRate: json["total_rate"],
        rateAvg: json["rate_avg"],
        totalViews: json["total_views"],
        totalDownload: json["total_download"],
        isFavourite: json["is_favourite"],
        totalAuthor: json["total_author"],
        totalCategory: json["total_category"],
        authorList: List<AuthorList>.from(json["author_list"].map((x) => AuthorList.fromJson(x))),
        catList: List<CatList>.from(json["cat_list"].map((x) => CatList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_records": totalRecords,
        "aid": aid,
        "author_ids": authorIds,
        "cat_ids": catIds,
        "book_name": bookName,
        "book_image": bookImage,
        "book_image_thumb": bookImageThumb,
        "book_description": bookDescription,
        "total_rate": totalRate,
        "rate_avg": rateAvg,
        "total_views": totalViews,
        "total_download": totalDownload,
        "is_favourite": isFavourite,
        "total_author": totalAuthor,
        "total_category": totalCategory,
        "author_list": List<dynamic>.from(authorList.map((x) => x.toJson())),
        "cat_list": List<dynamic>.from(catList.map((x) => x.toJson())),
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
  CatList({
    required this.cid,
    required this.categoryName,
  });

  final String cid;
  final String categoryName;

  factory CatList.fromJson(Map<String, dynamic> json) => CatList(
        cid: json["cid"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "cid": cid,
        "category_name": categoryName,
      };
}
