import 'package:flutter/material.dart';

class RefreshNotifier extends ChangeNotifier {
  bool _shouldRefresh = false;

  bool get shouldRefresh => _shouldRefresh;

  void triggerRefresh() {
    _shouldRefresh = true;
    notifyListeners();
  }

  void resetRefresh() {
    _shouldRefresh = false;
  }
}
