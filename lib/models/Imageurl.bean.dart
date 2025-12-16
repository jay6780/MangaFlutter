class ImageurlBean {
  List<String> imageUrls = [];

  ImageurlBean({required this.imageUrls});

  get getImageUrls => this.imageUrls;
  set setImageUrls(imageUrls) => this.imageUrls = imageUrls;

  factory ImageurlBean.fromJson(Map<String, dynamic> json) =>
      ImageurlBean(imageUrls: List<String>.from(json['imageUrls']));
}
