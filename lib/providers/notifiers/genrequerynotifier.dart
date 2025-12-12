// Source - https://stackoverflow.com/a
// Posted by Balaji Venkatraman
// Retrieved 2025-12-11, License - CC BY-SA 4.0

// class for storing data(Counter.dart)
import 'package:flutter/material.dart';

class Genrequerynotifier extends ChangeNotifier {
  String? _selectedGenre = "All";

  String? get selectedGenre => _selectedGenre;

  set selectedGenre(String? value) {
    _selectedGenre = value;
    notifyListeners();
  }

  void selectGenre(String genre) {
    _selectedGenre = genre;
    notifyListeners();
  }

  void clearSelection() {
    _selectedGenre = null;
    notifyListeners();
  }
}
