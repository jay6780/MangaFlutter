import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:manga/service/interceptor.dart';

class ApiService {
  final _baseUrl = "https://gomanga-api.vercel.app/";
  final _receiveTimeout = const Duration(seconds: 20);
  final _connectTimeout = const Duration(seconds: 20);
  final _sendTimeout = const Duration(seconds: 20);

  late Dio _dio;
  bool isDev = true;
  ApiService._internal();

  static final ApiService _apiService = ApiService._internal();

  factory ApiService() => _apiService;

  Dio provideDio() {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: _baseUrl,
      receiveTimeout: _receiveTimeout,
      connectTimeout: _connectTimeout,
      sendTimeout: _sendTimeout,
    );

    _dio = Dio(baseOptions);

    _dio.interceptors.add(CustomInterceptor());

    if (isDev) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    return _dio;
  }
}
