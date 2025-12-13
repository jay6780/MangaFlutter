import 'package:flutter/foundation.dart';
import 'package:manga/providers/remote_data_source.dart';

enum UiState { loading, success, error }

class Genrenamenotifier extends ChangeNotifier {
  final RemoteDataSource remoteDataSource;
  Genrenamenotifier({required this.remoteDataSource});

  String? _message;
  String? get message => _message;

  final List<String> _genreList = [];
  List<String> get genrenameList => _genreList;

  UiState _uiState = UiState.loading;
  UiState get uiState => _uiState;

  Future<void> fetchGenrelist() async {
    try {
      final response = await remoteDataSource.getGenres();

      _genreList.clear();

      _genreList.addAll(response.genre);

      _moveAllToFirst();

      _uiState = UiState.success;
      notifyListeners();
    } catch (error) {
      _uiState = UiState.error;
      _message = error.toString();
      notifyListeners();
    }
  }

  void _moveAllToFirst() {
    const allKeyword = 'All';

    final allIndex = _genreList.indexWhere((genre) => genre == allKeyword);

    if (allIndex != -1 && allIndex != 0) {
      final allItem = _genreList.removeAt(allIndex);
      _genreList.insert(0, allItem);
    }
  }
}
