class DownloadSong {
  int? id;
  int? bookid;
  String? name;
  String? link;
  String? artist;
  String? imagepath;
  String? userId;
  String? bookname;

  DownloadSong({this.id, this.name, this.link, this.artist, this.imagepath,this.bookid,this.userId,this.bookname});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id,'bookid':bookid, 'name': name, 'artist': artist, 'imagepath': imagepath, 'link': link,'userId':userId,'bookname': bookname};
    return map;
  }

  DownloadSong.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    userId = map['userId'];
    bookid = map['bookid'];
    name = map['name'];
    artist = map['artist'];
    imagepath = map['imagepath'];
    link = map['link'];
    bookname = map['bookname'];
  }
}
