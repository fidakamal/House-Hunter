import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:house_hunter/bottom_navigation.dart';

class Navigation extends ChangeNotifier {
  PageName currentPage = PageName.map;
  late DocumentSnapshot selectedDocument;

  void updateCurrentPage (PageName newPage) {
    currentPage = newPage;
    notifyListeners();
  }

  void updateSelectedDocument(DocumentSnapshot newDocument) {
    selectedDocument = newDocument;
  }
}