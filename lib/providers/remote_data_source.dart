import 'package:dio/dio.dart';
import 'package:manga/Beans/genre_name_bean.dart';
import 'package:manga/Beans/manga_bean.dart';

class RemoteDataSource {
  final Dio dio;

  RemoteDataSource({required this.dio});

  Future<GenreName> getGenres() async {
    try {
      final response = await dio.get("api/genre");
      return GenreName.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    }
  }

  Future<MangaBean> getMangaList(String genrename, int page) async {
    try {
      final response = await dio.get("api/genre/$genrename/$page");
      return MangaBean.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}
