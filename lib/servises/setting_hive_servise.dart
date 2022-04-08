import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:pinterest/models/settings_model.dart';

class DBService {
  static const String dbName = "db_notes";
  static Box box = Hive.box(dbName);

  static Future<void> storeMode(bool isLight) async {
    await box.put("isLight", isLight);
  }

  static bool loadMode() {
    return box.get("isLight", defaultValue: false);
  }

  static Future<void> storeNotes(List<Settings> noteList) async {
    // object => map => String
    List<String> stringList = noteList.map((note) => jsonEncode(note.toJson())).toList();
    await box.put("notes", stringList);
  }

  static List<Settings> loadNotes() {
    // String =>  Map => Object
    List<String> stringList = box.get("notes") ?? <String>[];
    List<Settings> noteList = stringList.map((string) => Settings.fromJson(jsonDecode(string))).toList();
    return noteList;
  }

  static Future<void> removeNotes() async {
    await box.delete("notes");
  }
}