import 'package:dio/dio.dart';
import 'package:manga/models/detail_bean.dart';
import 'package:manga/models/genre_name_bean.dart';
import 'package:manga/models/manga_bean.dart';

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

  Future<MangaBean> getSearchList(String query) async {
    try {
      final response = await dio.get("api/search/$query");
      return MangaBean.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<DetailBean> getDetails(String id) async {
    try {
      final response = await dio.get("api/manga/$id");
      return DetailBean.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}
