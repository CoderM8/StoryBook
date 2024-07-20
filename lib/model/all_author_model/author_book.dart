import 'dart:convert';

AuthorBookModel authorBookModelFromJson(String str) => AuthorBookModel.fromJson(json.decode(str));

String authorBookModelToJson(AuthorBookModel data) => json.encode(data.toJson());

class AuthorBookModel {
  AuthorBookModel({
    this.onlineMp3,
  });

  List<OnlineMp3>? onlineMp3;

  factory AuthorBookModel.fromJson(Map<String, dynamic> json) => AuthorBookModel(
        onlineMp3: List<OnlineMp3>.from(json["AUDIO_BOOK"].map((x) => OnlineMp3.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "AUDIO_BOOK": List<dynamic>.from(onlineMp3!.map((x) => x.toJson())),
      };
}

class OnlineMp3 {
  OnlineMp3({
    this.totalRecords,
    this.aid,
    this.authorIds,
    this.catIds,
    this.bookName,
    this.bookImage,
    this.bookImageThumb,
    this.isFavourite,
    this.totalRate,
    this.totalViews,
    this.rateAvg,
    this.totalDownload,
    this.totalAuthor,
    this.totalCategory,
    this.authorList,
    this.catList,
  });

  String? totalRecords;
  String? aid;
  String? authorIds;
  String? catIds;
  String? bookName;
  String? bookImage;
  String? bookImageThumb;
  bool? isFavourite;
  String? totalRate;
  String? totalViews;
  String? rateAvg;
  String? totalDownload;
  int? totalAuthor;
  int? totalCategory;
  List<AuthorList>? authorList;
  List<CatList>? catList;

  factory OnlineMp3.fromJson(Map<String, dynamic> json) => OnlineMp3(
        totalRecords: json["total_records"],
        aid: json["aid"],
        authorIds: json["author_ids"],
        catIds: json["cat_ids"],
        bookName: json["book_name"],
        bookImage: json["book_image"],
        bookImageThumb: json["book_image_thumb"],
        isFavourite: json["is_favourite"],
        totalRate: json["total_rate"],
        totalViews: json["total_views"],
        rateAvg: json["rate_avg"],
        totalDownload: json["total_download"],
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
        "is_favourite": isFavourite,
        "total_rate": totalRate,
        "total_views": totalViews,
        "rate_avg": rateAvg,
        "total_download": totalDownload,
        "total_author": totalAuthor,
        "total_category": totalCategory,
        "author_list": List<dynamic>.from(authorList!.map((x) => x.toJson())),
        "cat_list": List<dynamic>.from(catList!.map((x) => x.toJson())),
      };
}

class AuthorList {
  AuthorList({
    this.id,
    this.authorName,
    this.authorImage,
    this.authorImageThumb,
  });

  String? id;
  String? authorName;
  String? authorImage;
  String? authorImageThumb;

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
    this.cid,
    this.categoryName,
  });

  String? cid;
  String? categoryName;

  factory CatList.fromJson(Map<String, dynamic> json) => CatList(
        cid: json["cid"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "cid": cid,
        "category_name": categoryName,
      };
}
