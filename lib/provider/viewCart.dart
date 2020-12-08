import 'package:flutter/material.dart';

class ViewCart with ChangeNotifier {
  bool isView;

  void checkCart(bool view) {
    isView = view;
  }

  setViewCart(bool view) {
    isView = view;

    // notifyListeners();
  }

  isViewCart() {
    return isView;
  }
}
