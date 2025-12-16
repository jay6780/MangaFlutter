import 'package:flutter/material.dart';
import 'package:manga/service/remote_data_source.dart';

enum UiState { loading, success, error }

class Imageurldatanotifer extends ChangeNotifier {
  final RemoteDataSource remoteDataSource;
  Imageurldatanotifer({required this.remoteDataSource});

  String? _message;
  String? get message => _message;

  final List<String> _imageList = [];
  List<String> get imageUrls => _imageList;

  UiState _uiState = UiState.loading;
  UiState get uiState => _uiState;

  Future<void> getImageQuery(String id, String chapterId) async {
    try {
      final response = await remoteDataSource.getImageList(id, chapterId);

      _imageList.clear();

      _imageList.addAll(response.imageUrls);

      _uiState = UiState.success;
      notifyListeners();
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
      notifyListeners();
    }
  }
}
