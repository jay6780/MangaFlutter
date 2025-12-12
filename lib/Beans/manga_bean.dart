import 'dart:convert';

MangaBean amiiboResponseDtoFromJson(String str) =>
    MangaBean.fromJson(json.decode(str));
String amiiboResponseDtoToJson(MangaBean data) => json.encode(data.toJson());

class MangaBean {
  List<Manga> manga = [];
  List<Manga> get getManga => this.manga;

  set setManga(List<Manga> manga) => this.manga = manga;

  MangaBean({required this.manga});

  factory MangaBean.fromJson(Map<String, dynamic> json) => MangaBean(
    manga: List<Manga>.from(json["manga"].map((x) => Manga.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "manga": List<dynamic>.from(manga.map((x) => x.toJson())),
  };
}

class Manga {
  late String id;
  late String title;
  late String image;
  late String latestChapter;
  late String description;

  Manga({
    required this.id,
    required this.title,
    required this.image,
    required this.latestChapter,
    required this.description,
  });

  get getId => this.id;

  set setId(id) => this.id = id;

  get getTitle => this.title;

  set setTitle(title) => this.title = title;

  get getImage => this.image;

  set setImage(image) => this.image = image;

  get getLatestChapter => this.latestChapter;

  set setLatestChapter(latestChapter) => this.latestChapter = latestChapter;

  get getDescription => this.description;

  set setDescription(description) => this.description = description;

  factory Manga.fromJson(Map<String, dynamic> json) => Manga(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    latestChapter: json["latestChapter"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "latestChapter": latestChapter,
    "description": description,
  };
}
