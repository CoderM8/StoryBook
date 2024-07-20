import 'dart:convert';

HomeBannerModel homeBannerModelFromJson(String str) => HomeBannerModel.fromJson(json.decode(str));

String homeBannerModelToJson(HomeBannerModel data) => json.encode(data.toJson());

class HomeBannerModel {
  final AudioBook onlineMp3;

  HomeBannerModel({
    required this.onlineMp3,
  });

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) => HomeBannerModel(
        onlineMp3: AudioBook.fromJson(json["AUDIO_BOOK"]),
      );

  Map<String, dynamic> toJson() => {
        "AUDIO_BOOK": onlineMp3.toJson(),
      };
}

class AudioBook {
  final List<HomeBanner> homeBanner;
  final List<Trending> trendingBooks;
  final List<LatestAlbum> latestAlbum;
  final List<Ist> latestArtist;
  final List<BookPlayList> playlist;
  final List<Categorylist> categorylist;

  AudioBook({
    required this.homeBanner,
    required this.trendingBooks,
    required this.latestAlbum,
    required this.latestArtist,
    required this.playlist,
    required this.categorylist,
  });

  factory AudioBook.fromJson(Map<String, dynamic> json) => AudioBook(
        homeBanner: List<HomeBanner>.from(json["home_banner"].map((x) => HomeBanner.fromJson(x))),
        trendingBooks: List<Trending>.from(json["trending_books"].map((x) => Trending.fromJson(x))),
        latestAlbum: List<LatestAlbum>.from(json["latest_album"].map((x) => LatestAlbum.fromJson(x))),
        latestArtist: List<Ist>.from(json["latest_artist"].map((x) => Ist.fromJson(x))),
        playlist: List<BookPlayList>.from(json["playlist"].map((x) => BookPlayList.fromJson(x))),
        categorylist: List<Categorylist>.from(json["categorylist"].map((x) => Categorylist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "home_banner": List<dynamic>.from(homeBanner.map((x) => x.toJson())),
        "trending_books": List<dynamic>.from(trendingBooks.map((x) => x.toJson())),
        "latest_album": List<dynamic>.from(latestAlbum.map((x) => x.toJson())),
        "latest_artist": List<dynamic>.from(latestArtist.map((x) => x.toJson())),
        "playlist": List<dynamic>.from(playlist.map((x) => x.toJson())),
        "categorylist": List<dynamic>.from(categorylist.map((x) => x.toJson())),
      };
}

class Categorylist {
  final String totalRecords;
  final String cid;
  final int totalsongs;
  final String categoryName;
  final String categoryImage;
  final String categoryImageThumb;

  Categorylist({
    required this.totalRecords,
    required this.cid,
    required this.totalsongs,
    required this.categoryName,
    required this.categoryImage,
    required this.categoryImageThumb,
  });

  factory Categorylist.fromJson(Map<String, dynamic> json) => Categorylist(
        totalRecords: json["total_records"],
        cid: json["cid"],
        totalsongs: json["total_songs"],
        categoryName: json["category_name"],
        categoryImage: json["category_image"],
        categoryImageThumb: json["category_image_thumb"],
      );

  Map<String, dynamic> toJson() => {
        "total_records": totalRecords,
        "cid": cid,
        "total_songs": totalsongs,
        "category_name": categoryName,
        "category_image": categoryImage,
        "category_image_thumb": categoryImageThumb,
      };
}

class HomeBanner {
  final String bid;
  final String bannerTitle;
  final String bannerSortInfo;
  final String totalViews;
  final String bannerImage;
  final String bannerImageThumb;
  final int totalBooks;
  final List<BookList> bookList;

  HomeBanner({
    required this.bid,
    required this.bannerTitle,
    required this.bannerSortInfo,
    required this.totalViews,
    required this.bannerImage,
    required this.bannerImageThumb,
    required this.totalBooks,
    required this.bookList,
  });

  factory HomeBanner.fromJson(Map<String, dynamic> json) => HomeBanner(
        bid: json["bid"],
        bannerTitle: json["banner_title"],
        bannerSortInfo: json["banner_sort_info"],
        totalViews: json["total_views"],
        bannerImage: json["banner_image"],
        bannerImageThumb: json["banner_image_thumb"],
        totalBooks: json["total_books"],
        bookList: List<BookList>.from(json["book_list"].map((x) => BookList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "bid": bid,
        "banner_title": bannerTitle,
        "banner_sort_info": bannerSortInfo,
        "total_views": totalViews,
        "banner_image": bannerImage,
        "banner_image_thumb": bannerImageThumb,
        "total_books": totalBooks,
        "book_list": List<dynamic>.from(bookList.map((x) => x.toJson())),
      };
}

class LatestAlbum {
  final String aid;
  final String bookName;
  final String bookImage;
  final String bookImageThumb;
  final bool isFavourite;
  final String bookDescription;
  final String totalViews;
  final String totalRate;
  final String rateAvg;
  final String totalDownload;
  final int totalAuthor;
  final int totalCategory;
  final List<AlbumAuthorList> albumAuthorList;
  final List<AlbumCatList> albumCatList;

  LatestAlbum({
    required this.aid,
    required this.bookName,
    required this.bookImage,
    required this.bookImageThumb,
    required this.isFavourite,
    required this.bookDescription,
    required this.totalViews,
    required this.totalRate,
    required this.rateAvg,
    required this.totalDownload,
    required this.totalAuthor,
    required this.totalCategory,
    required this.albumAuthorList,
    required this.albumCatList,
  });

  factory LatestAlbum.fromJson(Map<String, dynamic> json) => LatestAlbum(
        aid: json["aid"],
        bookName: json["book_name"],
        bookImage: json["book_image"],
        bookImageThumb: json["book_image_thumb"],
        isFavourite: json["is_favourite"],
        bookDescription: json["book_description"],
        totalViews: json["total_views"],
        totalRate: json["total_rate"],
        rateAvg: json["rate_avg"],
        totalDownload: json["total_download"],
        totalAuthor: json["total_author"] ?? 0,
        totalCategory: json["total_category"] ?? 0,
        albumAuthorList: List<AlbumAuthorList>.from(json["author_list"].map((x) => AlbumAuthorList.fromJson(x))),
        albumCatList: List<AlbumCatList>.from(json["cat_list"].map((x) => AlbumCatList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "aid": aid,
        "book_name": bookName,
        "book_image": bookImage,
        "book_image_thumb": bookImageThumb,
        "is_favourite": isFavourite,
        "book_description": bookDescription,
        "total_views": totalViews,
        "total_rate": totalRate,
        "rate_avg": rateAvg,
        "total_download": totalDownload,
        "total_author": totalAuthor,
        "total_category": totalCategory,
        "author_list": List<dynamic>.from(albumAuthorList.map((x) => x.toJson())),
        "cat_list": List<dynamic>.from(albumCatList.map((x) => x.toJson())),
      };
}

class AlbumAuthorList {
  final String id;
  final String authorName;
  final String authorImage;
  final String authorImageThumb;

  AlbumAuthorList({
    required this.id,
    required this.authorName,
    required this.authorImage,
    required this.authorImageThumb,
  });

  factory AlbumAuthorList.fromJson(Map<String, dynamic> json) => AlbumAuthorList(
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

class AlbumCatList {
  final String cid;
  final String categoryName;

  AlbumCatList({
    required this.cid,
    required this.categoryName,
  });

  factory AlbumCatList.fromJson(Map<String, dynamic> json) => AlbumCatList(
        cid: json["cid"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "cid": cid,
        "category_name": categoryName,
      };
}

class Trending {
  final String aid;
  final String bookName;
  final String bookImage;
  final String bookImageThumb;
  final bool isFavourite;
  final String bookDescription;
  final String totalViews;
  final String totalRate;
  final String rateAvg;
  final String totalDownload;
  final int totalAuthor;
  final int totalCategory;
  final List<AuthorList> authorList;
  final List<TrendingCatList> catList;

  Trending({
    required this.aid,
    required this.bookName,
    required this.bookImage,
    required this.bookImageThumb,
    required this.isFavourite,
    required this.bookDescription,
    required this.totalViews,
    required this.totalRate,
    required this.rateAvg,
    required this.totalDownload,
    required this.totalAuthor,
    required this.totalCategory,
    required this.authorList,
    required this.catList,
  });

  factory Trending.fromJson(Map<String, dynamic> json) => Trending(
        aid: json["aid"],
        bookName: json["book_name"],
        bookImage: json["book_image"],
        bookImageThumb: json["book_image_thumb"],
        isFavourite: json["is_favourite"],
        bookDescription: json["book_description"],
        totalViews: json["total_views"],
        totalRate: json["total_rate"],
        rateAvg: json["rate_avg"],
        totalDownload: json["total_download"],
        totalAuthor: json["total_author"],
        totalCategory: json["total_category"],
        authorList: List<AuthorList>.from(json["author_list"].map((x) => AuthorList.fromJson(x))),
        catList: List<TrendingCatList>.from(json["cat_list"].map((x) => TrendingCatList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "aid": aid,
        "book_name": bookName,
        "book_image": bookImage,
        "book_image_thumb": bookImageThumb,
        "is_favourite": isFavourite,
        "book_description": bookDescription,
        "total_views": totalViews,
        "total_rate": totalRate,
        "rate_avg": rateAvg,
        "total_download": totalDownload,
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

class Ist {
  final String id;
  final String authorImage;
  final String authorImageThumb;
  final String authorName;
  final int totalsongs;

  Ist({
    required this.id,
    required this.authorImage,
    required this.authorImageThumb,
    required this.authorName,
    required this.totalsongs,
  });

  factory Ist.fromJson(Map<String, dynamic> json) => Ist(
        id: json["id"],
        authorImage: json["Author_image"],
        authorImageThumb: json["Author_image_thumb"],
        authorName: json["Author_name"],
        totalsongs: json["total_songs"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Author_image": authorImage,
        "Author_image_thumb": authorImageThumb,
        "Author_name": authorName,
        "total_songs": totalsongs,
      };
}

class BookPlayList {
  final String totalRecords;
  final String pid;
  final String playlistName;
  final String playlistImage;
  final String playlistImageThumb;
  final String playlistDescription;
  final String playlistBooks;
  final String totalViews;
  final String totalRate;
  final String rateAvg;
  final String totalDownload;
  final int totalBooks;
  final List<BookList> bookList;

  BookPlayList({
    required this.totalRecords,
    required this.pid,
    required this.playlistName,
    required this.playlistImage,
    required this.playlistImageThumb,
    required this.playlistDescription,
    required this.playlistBooks,
    required this.totalViews,
    required this.totalRate,
    required this.rateAvg,
    required this.totalDownload,
    required this.totalBooks,
    required this.bookList,
  });

  factory BookPlayList.fromJson(Map<String, dynamic> json) => BookPlayList(
        totalRecords: json["total_records"],
        pid: json["pid"],
        playlistName: json["playlist_name"],
        playlistImage: json["playlist_image"],
        playlistImageThumb: json["playlist_image_thumb"],
        playlistDescription: json["playlist_description"],
        playlistBooks: json["playlist_books"],
        totalViews: json["total_views"],
        totalRate: json["total_rate"],
        rateAvg: json["rate_avg"],
        totalDownload: json["total_download"],
        totalBooks: json["total_books"],
        bookList: List<BookList>.from(json["book_list"].map((x) => BookList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_records": totalRecords,
        "pid": pid,
        "playlist_name": playlistName,
        "playlist_image": playlistImage,
        "playlist_image_thumb": playlistImageThumb,
        "playlist_description": playlistDescription,
        "playlist_books": playlistBooks,
        "total_views": totalViews,
        "total_rate": totalRate,
        "rate_avg": rateAvg,
        "total_download": totalDownload,
        "total_books": totalBooks,
        "book_list": List<dynamic>.from(bookList.map((x) => x.toJson())),
      };
}

class BookList {
  final String aid;
  final String authorIds;
  final String catIds;
  final String bookName;
  final String bookImage;
  final String bookImageThumb;
  final bool isFavourite;
  final String bookDescription;
  final String totalViews;
  final String totalRate;
  final String rateAvg;
  final String totalDownload;

  BookList({
    required this.aid,
    required this.authorIds,
    required this.catIds,
    required this.bookName,
    required this.bookImage,
    required this.bookImageThumb,
    required this.isFavourite,
    required this.bookDescription,
    required this.totalViews,
    required this.totalRate,
    required this.rateAvg,
    required this.totalDownload,
  });

  factory BookList.fromJson(Map<String, dynamic> json) => BookList(
        aid: json["aid"],
        authorIds: json["author_ids"],
        catIds: json["cat_ids"],
        bookName: json["book_name"],
        bookImage: json["book_image"],
        bookImageThumb: json["book_image_thumb"],
        isFavourite: json["is_favourite"],
        bookDescription: json["book_description"],
        totalViews: json["total_views"],
        totalRate: json["total_rate"],
        rateAvg: json["rate_avg"],
        totalDownload: json["total_download"],
      );

  Map<String, dynamic> toJson() => {
        "aid": aid,
        "author_ids": authorIds,
        "cat_ids": catIds,
        "book_name": bookName,
        "book_image": bookImage,
        "book_image_thumb": bookImageThumb,
        "is_favourite": isFavourite,
        "book_description": bookDescription,
        "total_views": totalViews,
        "total_rate": totalRate,
        "rate_avg": rateAvg,
        "total_download": totalDownload,
      };
}

class TrendingCatList {
  final String cid;
  final String categoryName;

  TrendingCatList({
    required this.cid,
    required this.categoryName,
  });

  factory TrendingCatList.fromJson(Map<String, dynamic> json) => TrendingCatList(
        cid: json["cid"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "cid": cid,
        "category_name": categoryName,
      };
}

class Playlist {
  final String totalRecords;
  final String pid;
  final String playlistName;
  final String playlistImage;
  final String playlistImageThumb;
  final String playlistTime;
  final String playlistDescription;
  final String playlistBooks;
  final String totalViews;
  final String totalRate;
  final String rateAvg;
  final String totalDownload;
  final int totalBooks;
  final List<BookPlayList> bookList;

  Playlist({
    required this.totalRecords,
    required this.pid,
    required this.playlistName,
    required this.playlistImage,
    required this.playlistImageThumb,
    required this.playlistTime,
    required this.playlistDescription,
    required this.playlistBooks,
    required this.totalViews,
    required this.totalRate,
    required this.rateAvg,
    required this.totalDownload,
    required this.totalBooks,
    required this.bookList,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        totalRecords: json["total_records"],
        pid: json["pid"],
        playlistName: json["playlist_name"],
        playlistImage: json["playlist_image"],
        playlistImageThumb: json["playlist_image_thumb"],
        playlistTime: json["playlist_time"],
        playlistDescription: json["playlist_description"],
        playlistBooks: json["playlist_books"],
        totalViews: json["total_views"],
        totalRate: json["total_rate"],
        rateAvg: json["rate_avg"],
        totalDownload: json["total_download"],
        totalBooks: json["total_books"],
        bookList: List<BookPlayList>.from(json["book_list"].map((x) => BookPlayList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_records": totalRecords,
        "pid": pid,
        "playlist_name": playlistName,
        "playlist_image": playlistImage,
        "playlist_image_thumb": playlistImageThumb,
        "playlist_time": playlistTime,
        "playlist_description": playlistDescription,
        "playlist_books": playlistBooks,
        "total_views": totalViews,
        "total_rate": totalRate,
        "rate_avg": rateAvg,
        "total_download": totalDownload,
        "total_books": totalBooks,
        "book_list": List<dynamic>.from(bookList.map((x) => x.toJson())),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
