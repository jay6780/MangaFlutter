import 'package:dio/dio.dart';
import 'package:manga/Beans/genre_name_bean.dart';
class RemoteDataSource {
  final Dio dio;

  RemoteDataSource({
    required this.dio,
  });

  Future<GenreName> getGenres() async {
    try {
      final response = await dio.get("api/genre");
      return GenreName.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    }
  }
}