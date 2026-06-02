import 'dart:convert';
import 'package:flutter/services.dart';

class AssetLoader {
  static Future<String> loadJsonAsset(String path) async {
    return await rootBundle.loadString(path);
  }
}
