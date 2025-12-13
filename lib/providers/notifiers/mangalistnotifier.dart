import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:manga/Beans/manga_bean.dart';
import 'package:manga/providers/remote_data_source.dart';
import 'package:logger/logger.dart';

enum UimangaState { loading, success, error }

class Mangalistnotifier extends ChangeNotifier {
  final RemoteDataSource remoteDataSource;
  Mangalistnotifier({required this.remoteDataSource});

  String? _message;
  String? get message => _message;

  final List<Manga> manga = [];
  List<Manga> get ma => manga;
  var logger = Logger();
  UimangaState _uiState = UimangaState.loading;
  UimangaState get uiState => _uiState;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  String? _searchQuery;
  String? get searchQuery => _searchQuery;

  Future<void> fetchMangaList(
    String genreOrQuery,
    int page,
    bool isRefresh,
    bool isSearch,
  ) async {
    try {
      if (isRefresh) {
        manga.clear();
        _hasMore = true;
        _currentPage = 1;
        if (isSearch) {
          _searchQuery = genreOrQuery;
        }
      }

      if (!_hasMore) return;

      _uiState = UimangaState.loading;
      notifyListeners();

      final response;

      if (isSearch) {
        // Call search method
        response = await remoteDataSource.getSearchList(genreOrQuery);
      } else {
        // Call regular manga list method
        response = await remoteDataSource.getMangaList(genreOrQuery, page);
      }

      if (response.getManga.isEmpty) {
        _hasMore = false;
      } else {
        manga.addAll(response.getManga);
        _currentPage = page;
      }

      _uiState = UimangaState.success;
      notifyListeners();
    } catch (error) {
      _uiState = UimangaState.error;
      _message = error.toString();
      logger.e("Error fetching manga: $error");
      _hasMore = false;
      notifyListeners();
    }
  }
}
