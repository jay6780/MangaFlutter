import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:manga/Service/interceptor.dart';
class ApiService {
  final _baseUrl = "https://gomanga-api.vercel.app/";
final _receiveTimeout = const Duration(seconds: 120);
final _connectTimeout = const Duration(seconds: 120);
final _sendTimeout = const Duration(seconds: 120);

  late Dio _dio;
  bool isDev = false;
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

    PrettyDioLogger prettyDioLogger = PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    );
    Interceptor customInterceptor = CustomInterceptor();

    _dio = Dio(baseOptions);

    // Add the Interceptors here
    if(isDev){
    _dio.interceptors.add(prettyDioLogger);
    }else{
      _dio.interceptors.add(customInterceptor);
    }
   

    return _dio;
  }
}