import 'package:flutter/material.dart';
import 'package:manga/models/detail_bean.dart';
import 'package:manga/service/remote_data_source.dart';

enum UiState { loading, success, error }

class Detaildatanotifier extends ChangeNotifier {
  final RemoteDataSource remoteDataSource;
  Detaildatanotifier({required this.remoteDataSource});

  String? _message;
  String? get message => _message;

  final List<DetailBean> detail = [];
  List<DetailBean> get detailbeanList => detail;

  UiState _uiState = UiState.loading;
  UiState get uiState => _uiState;

  Future<void> getDetailData(String id) async {
    try {
      final response = await remoteDataSource.getDetails(id);
      detailbeanList.add(response);
      _uiState = UiState.success;
      notifyListeners();
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
      notifyListeners();
    }
  }
}
