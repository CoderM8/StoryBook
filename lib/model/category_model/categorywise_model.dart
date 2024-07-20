import 'dart:convert';

CategoryWiseBooks categoryWiseBooksFromJson(String str) => CategoryWiseBooks.fromJson(json.decode(str));

String categoryWiseBooksToJson(CategoryWiseBooks data) => json.encode(data.toJson());

class CategoryWiseBooks {
  final List<AudioBook> audioBook;

  CategoryWiseBooks({
    required this.audioBook,
  });

  factory CategoryWiseBooks.fromJson(Map<String, dynamic> json) => CategoryWiseBooks(
        audioBook: List<AudioBook>.from(json["AUDIO_BOOK"].map((x) => AudioBook.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "AUDIO_BOOK": List<dynamic>.from(audioBook.map((x) => x.toJson())),
      };
}

class AudioBook {
  final String aid;
  final String authorIds;
  final String catIds;
  final String bookName;
  final String bookImage;
  final String bookImageThumb;
  final bool isFavourite;
  final String totalRate;
  final String totalViews;
  final String rateAvg;
  final String totalDownload;
  final String bookDescription;
  final String status;
  final int totalAuthor;
  final int totalCategory;
  final List<AuthorList> authorList;
  final List<CatList> catList;

  AudioBook({
    required this.aid,
    required this.authorIds,
    required this.catIds,
    required this.bookName,
    required this.bookImage,
    required this.bookImageThumb,
    required this.isFavourite,
    required this.totalRate,
    required this.totalViews,
    required this.rateAvg,
    required this.totalDownload,
    required this.bookDescription,
    required this.status,
    required this.totalAuthor,
    required this.totalCategory,
    required this.authorList,
    required this.catList,
  });

  factory AudioBook.fromJson(Map<String, dynamic> json) => AudioBook(
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
        bookDescription: json["book_description"],
        status: json["status"],
        totalAuthor: json["total_author"],
        totalCategory: json["total_category"],
        authorList: List<AuthorList>.from(json["author_list"].map((x) => AuthorList.fromJson(x))),
        catList: List<CatList>.from(json["cat_list"].map((x) => CatList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
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
        "book_description": bookDescription,
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
