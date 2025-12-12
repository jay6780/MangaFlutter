import 'package:dio/dio.dart';

class TimeoutException extends DioException {
  TimeoutException({required super.requestOptions});
  @override
  String toString() {
    return "Connection timeout. Please try again later";
  }
}

class UnknownErrorException extends DioException {
  UnknownErrorException({required super.requestOptions});
  @override
  String toString() {
    return "Unknown error occured. Please try again later";
  }
}

class NoInternetException extends DioException {
  NoInternetException({required super.requestOptions});
  @override
  String toString() {
    return "No internet detected, please check your connection";
  }
}
