import 'package:flutter/foundation.dart';
import 'package:manga/providers/remote_data_source.dart';
import 'package:manga/Beans/genre_name_bean.dart';
enum UiState {
  loading,
  success,
  error
}

class Genrenamenotifier extends ChangeNotifier {
  final RemoteDataSource remoteDataSource;
  Genrenamenotifier({
    required this.remoteDataSource,
  });

  String? _message;
  String? get message => _message;

  final List<String> _genreList = [];
  List<String> get genrenameList => _genreList;

  UiState _uiState = UiState.loading;
  UiState get uiState => _uiState;

  Future<void> fetchGenrelist() async {
    try {
      final response = await remoteDataSource.getGenres();
      _genreList.addAll(response.genre);
      _uiState = UiState.success;
      notifyListeners();
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
      notifyListeners();
    }
  }
}