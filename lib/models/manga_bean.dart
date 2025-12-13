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
  String? id;
  String? title;
  String? image;
  String? latestChapter;
  String? description;
  String? imgUrl;

  Manga({
    this.id,
    this.title,
    this.image,
    this.latestChapter,
    this.description,
    this.imgUrl,
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

  get getImgUrl => this.imgUrl;
  set setImgUrl(imgUrl) => this.imgUrl = imgUrl;

  factory Manga.fromJson(Map<String, dynamic> json) => Manga(
    id: json["id"]?.toString(),
    title: json["title"]?.toString(),
    image: json["image"]?.toString(),
    latestChapter: json["latestChapter"]?.toString(),
    description: json["description"]?.toString(),
    imgUrl: json["imgUrl"]?.toString() ?? json["image"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "latestChapter": latestChapter,
    "description": description,
    "imgUrl": imgUrl,
  };
}
