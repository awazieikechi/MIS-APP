import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class ImageUtility {
  //

  getImageFromPreferences(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? null;
  }

  saveImageToPreferences(String key, var value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}
