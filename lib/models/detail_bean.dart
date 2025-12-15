import 'dart:convert';

DetailBean detailbeanTojson(String str) =>
    DetailBean.fromJson(json.decode(str));
String detailbeanFromjson(DetailBean data) => json.encode(data.toJson());

class DetailBean {
  String? id;
  String? title;
  String? imageUrl;
  List<String> genres = [];
  List<Chapters> chapters = [];

  DetailBean({
    this.id,
    this.title,
    this.imageUrl,
    List<String>? genres,
    List<Chapters>? chapters,
  }) {}
  get getGenres => this.genres;

  set setGenres(genres) => this.genres = genres;

  get getChapters => this.chapters;

  set setChapters(chapters) => this.chapters = chapters;
  get getId => this.id;

  set setId(id) => this.id = id;

  get getTitle => this.title;

  set setTitle(title) => this.title = title;

  get getImageUrl => this.imageUrl;

  set setImageUrl(imageUrl) => this.imageUrl = imageUrl;

  factory DetailBean.fromJson(Map<String, dynamic> json) => DetailBean(
    id: json["id"]?.toString(),
    title: json["title"]?.toString(),
    imageUrl: json["imageUrl"]?.toString(),
    genres: List<String>.from(json["genres"]?.map((x) => x.toString()) ?? []),
    chapters: List<Chapters>.from(
      json["chapters"].map((x) => Chapters.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "imageUrl": imageUrl,
    "genres": List<dynamic>.from(genres.map((x) => x)),
    "chapters": List<dynamic>.from(chapters.map((x) => x.toJson())),
  };
}

class Chapters {
  String? chapterId;
  String? views;
  String? uploaded;
  String? timestamp;

  Chapters({this.chapterId, this.views, this.uploaded, this.timestamp});

  get getChapterId => this.chapterId;

  set setChapterId(chapterId) => this.chapterId = chapterId;

  get getViews => this.views;

  set setViews(views) => this.views = views;

  get getUploaded => this.uploaded;

  set setUploaded(uploaded) => this.uploaded = uploaded;

  get getTimestamp => this.timestamp;

  set setTimestamp(timestamp) => this.timestamp = timestamp;

  factory Chapters.fromJson(Map<String, dynamic> json) => Chapters(
    chapterId: json["chapterId"]?.toString(),
    views: json["views"]?.toString(),
    uploaded: json["uploaded"]?.toString(),
    timestamp: json["timestamp"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "chapterId": chapterId,
    "views": views,
    "uploaded": uploaded,
    "timestamp": timestamp,
  };
}
