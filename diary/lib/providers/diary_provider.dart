import 'package:flutter/material.dart';
import '../models/diary_model.dart';

class DiaryProvider with ChangeNotifier {
  final List<Diary> _diaries = [];

  List<Diary> get diaries => [..._diaries];

  void addDiary(String title, String content, DateTime date) {
    final newDiary = Diary(
      id: DateTime.now().toString(),
      title: title,
      content: content,
      date: date,
    );
    _diaries.add(newDiary);
    notifyListeners();
  }

  void editDiary(String id, String title, String content, DateTime date) {
    final index = _diaries.indexWhere((diary) => diary.id == id);
    if (index != -1) {
      _diaries[index] = Diary(
        id: id,
        title: title,
        content: content,
        date: date,
      );
      notifyListeners();
    }
  }

  void deleteDiary(String id) {
    _diaries.removeWhere((diary) => diary.id == id);
    notifyListeners();
  }
}
