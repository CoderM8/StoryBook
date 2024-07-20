import 'dart:convert';

SingalBookModel singalBookModelFromJson(String str) => SingalBookModel.fromJson(json.decode(str));

String singalBookModelToJson(SingalBookModel data) => json.encode(data.toJson());

class SingalBookModel {
  SingalBookModel({
    required this.onlineMp3,
  });

  final List<OnlineMp3> onlineMp3;

  factory SingalBookModel.fromJson(Map<String, dynamic> json) => SingalBookModel(
        onlineMp3: List<OnlineMp3>.from(json["AUDIO_BOOK"].map((x) => OnlineMp3.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "AUDIO_BOOK": List<dynamic>.from(onlineMp3.map((x) => x.toJson())),
      };
}

class OnlineMp3 {
  OnlineMp3({
    required this.aid,
    required this.artistIds,
    required this.catIds,
    required this.bookName,
    required this.bookImage,
    required this.bookImageThumb,
    required this.isFavourite,
    required this.playTime,
    required this.bookDescription,
    required this.totalRate,
    required this.totalViews,
    required this.total5,
    required this.total4,
    required this.total3,
    required this.total2,
    required this.total1,
    required this.rateAvg,
    required this.totalDownload,
    required this.readDescription,
    required this.userRate,
    required this.totalChapter,
    required this.totalAuthor,
    required this.totalCategory,
    required this.chapterList,
    required this.authorList,
    required this.artistList,
    required this.catList,
  });

  final String aid;
  final String artistIds;
  final String catIds;
  final String bookName;
  final String bookImage;
  final String bookImageThumb;
  final bool isFavourite;
  final String playTime;
  final String bookDescription;
  final String totalRate;
  final String totalViews;
  final String total5;
  final String total4;
  final String total3;
  final String total2;
  final String total1;
  final String rateAvg;
  final String totalDownload;
  final String readDescription;
  final dynamic userRate;
  final int totalChapter;
  final int totalAuthor;
  final int totalCategory;
  final List<ChapterList> chapterList;
  final List<AuthorList> authorList;
  final String artistList;
  final List<CatList> catList;

  factory OnlineMp3.fromJson(Map<String, dynamic> json) => OnlineMp3(
        aid: json["aid"],
        artistIds: json["artist_ids"],
        catIds: json["cat_ids"],
        bookName: json["book_name"],
        bookImage: json["book_image"],
        bookImageThumb: json["book_image_thumb"],
        isFavourite: json["is_favourite"],
        playTime: json["play_time"],
        bookDescription: json["book_description"],
        totalRate: json["total_rate"],
        totalViews: json["total_views"],
        total5: json["total_5"],
        total4: json["total_4"],
        total3: json["total_3"],
        total2: json["total_2"],
        total1: json["total_1"],
        rateAvg: json["rate_avg"],
        totalDownload: json["total_download"],
        readDescription: json["read_description"] ?? "",
        userRate: json["user_rate"],
        totalChapter: json["total_chapter"],
        totalAuthor: json["total_author"],
        totalCategory: json["total_category"],
        chapterList: List<ChapterList>.from(json["chapter_list"].map((x) => ChapterList.fromJson(x))),
        authorList: List<AuthorList>.from(json["author_list"].map((x) => AuthorList.fromJson(x))),
        artistList: json["artist_list"],
        catList: List<CatList>.from(json["cat_list"].map((x) => CatList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "aid": aid,
        "artist_ids": artistIds,
        "cat_ids": catIds,
        "book_name": bookName,
        "book_image": bookImage,
        "book_image_thumb": bookImageThumb,
        "is_favourite": isFavourite,
        "play_time": playTime,
        "book_description": bookDescription,
        "total_rate": totalRate,
        "total_views": totalViews,
        "total_5": total5,
        "total_4": total4,
        "total_3": total3,
        "total_2": total2,
        "total_1": total1,
        "rate_avg": rateAvg,
        "total_download": totalDownload,
        "read_description": readDescription,
        "user_rate": userRate,
        "total_chapter": totalChapter,
        "total_author": totalAuthor,
        "total_category": totalCategory,
        "chapter_list": List<dynamic>.from(chapterList.map((x) => x.toJson())),
        "author_list": List<dynamic>.from(authorList.map((x) => x.toJson())),
        "artist_list": artistList,
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

class ChapterList {
  ChapterList({
    required this.id,
    required this.catId,
    required this.albumId,
    required this.mp3Type,
    required this.mp3Title,
    required this.mp3Url,
    required this.mp3Thumbnail,
    required this.mp3ThumbnailThumb,
    required this.mp3Duration,
    required this.mp3Artist,
    required this.mp3Description,
    required this.totalRate,
    required this.totalViews,
    required this.rateAvg,
    required this.totalDownload,
  });

  final String id;
  final String catId;
  final String albumId;
  final String mp3Type;
  final String mp3Title;
  final String mp3Url;
  final String mp3Thumbnail;
  final String mp3ThumbnailThumb;
  final String mp3Duration;
  final String mp3Artist;
  final String mp3Description;
  final String totalRate;
  final String totalViews;
  final String rateAvg;
  final String totalDownload;

  factory ChapterList.fromJson(Map<String, dynamic> json) => ChapterList(
        id: json["id"],
        catId: json["cat_id"],
        albumId: json["album_id"],
        mp3Type: json["mp3_type"],
        mp3Title: json["mp3_title"],
        mp3Url: json["mp3_url"],
        mp3Thumbnail: json["mp3_thumbnail"],
        mp3ThumbnailThumb: json["mp3_thumbnail_thumb"],
        mp3Duration: json["mp3_duration"],
        mp3Artist: json["mp3_artist"],
        mp3Description: json["mp3_description"],
        totalRate: json["total_rate"],
        totalViews: json["total_views"],
        rateAvg: json["rate_avg"],
        totalDownload: json["total_download"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cat_id": catId,
        "album_id": albumId,
        "mp3_type": mp3Type,
        "mp3_title": mp3Title,
        "mp3_url": mp3Url,
        "mp3_thumbnail": mp3Thumbnail,
        "mp3_thumbnail_thumb": mp3ThumbnailThumb,
        "mp3_duration": mp3Duration,
        "mp3_artist": mp3Artist,
        "mp3_description": mp3Description,
        "total_rate": totalRate,
        "total_views": totalViews,
        "rate_avg": rateAvg,
        "total_download": totalDownload,
      };
}
