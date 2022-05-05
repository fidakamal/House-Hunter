import 'package:flutter/cupertino.dart';
import 'package:house_hunter/bottom_navigation.dart';

class Navigation extends ChangeNotifier {
  PageName currentPage = PageName.map;

  void updateCurrentPage (PageName newPage) {
    currentPage = newPage;
    notifyListeners();
  }
}