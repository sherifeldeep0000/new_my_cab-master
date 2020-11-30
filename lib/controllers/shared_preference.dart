import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static final String _userData = "userData";

  Future<void> setUserData(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("$_userData", json.encode(data));
  }

  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      return Map<String, dynamic>.from(json.decode(prefs.get("$_userData")));
    }
    catch(e){
      return null;
    }
  }

  Future<void> deleteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
