class GenreName {
  List<String> genre = [];

  GenreName({required this.genre});

  List<String> get getGenre => this.genre;
  set setGenre(List<String> genre) => this.genre = genre;

  factory GenreName.fromJson(Map<String, dynamic> json) =>
      GenreName(genre: List<String>.from(json['genre']));
}
