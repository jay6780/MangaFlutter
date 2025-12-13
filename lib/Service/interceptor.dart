import 'package:dio/dio.dart';
import 'timeout.dart';

class CustomInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    DioException exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        exception = TimeoutException(requestOptions: err.requestOptions);
        break;
      case DioExceptionType.connectionError:
        exception = NoInternetException(requestOptions: err.requestOptions);
        break;
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        exception = UnknownErrorException(requestOptions: err.requestOptions);
        break;
      default:
        exception = err;
    }

    handler.reject(exception);
  }
}
