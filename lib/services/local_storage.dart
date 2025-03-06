import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/poll.dart';

class LocalStorage {
  static const String key = 'polls';

  static Future<void> savePolls(List<Poll> polls) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(polls.map((p) => p.toJson()).toList()));
  }

  static Future<List<Poll>> loadPolls() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(key);
    if (data != null) {
      List<dynamic> decoded = jsonDecode(data);
      return decoded.map((item) => Poll.fromJson(item)).toList();
    }
    return [];
  }
}
