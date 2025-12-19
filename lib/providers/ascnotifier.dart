import 'package:flutter/material.dart';

class Ascnotifier extends ChangeNotifier {
  bool _shouldRefresh = false;

  bool get shouldRefresh => _shouldRefresh;

  void isAsc() {
    _shouldRefresh = true;
    notifyListeners();
  }

  void isDesc() {
    _shouldRefresh = false;
    notifyListeners();
  }
}
