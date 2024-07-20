import 'dart:convert';

HomeSectionModel homeSectionModelFromJson(String str) => HomeSectionModel.fromJson(json.decode(str));

String homeSectionModelToJson(HomeSectionModel data) => json.encode(data.toJson());

class HomeSectionModel {
  final List<AudioBook> audioBook;

  HomeSectionModel({
    required this.audioBook,
  });

  factory HomeSectionModel.fromJson(Map<String, dynamic> json) => HomeSectionModel(
        audioBook: List<AudioBook>.from(json["AUDIO_BOOK"].map((x) => AudioBook.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "AUDIO_BOOK": List<dynamic>.from(audioBook.map((x) => x.toJson())),
      };
}

class AudioBook {
  final String id;
  final String sectionTitle;
  final String bookList;

  AudioBook({
    required this.id,
    required this.sectionTitle,
    required this.bookList,
  });

  factory AudioBook.fromJson(Map<String, dynamic> json) => AudioBook(
        id: json["id"],
        sectionTitle: json["section_title"],
        bookList: json["Book_list"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "section_title": sectionTitle,
        "Book_list": bookList,
      };
}
