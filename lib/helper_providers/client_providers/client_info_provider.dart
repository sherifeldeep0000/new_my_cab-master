import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_cab/models/auth_model/user_info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ClientInfoProvider extends ChangeNotifier {
  String clientToken;
  String inside;
  String outSide;

  void getInside(String clientInside) {
    inside = clientInside;
    notifyListeners();
  }

  void getOutSide(String clientOutSide) {
    outSide = clientOutSide;
    notifyListeners();
  }

  void getToken(String token) {
    clientToken = token;
    notifyListeners();
  }

  Future<ClientInfo> getClientInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var clientRegisterToken = prefs.getString("registerToken");
    var clientLoginToken = prefs.getString("userToken");
    ClientInfo details;
    String url = "https://gardentaxi.net/Back_End/public/api/user/user";

    var response = await http.post(
      url,
      body: {"api_token": clientLoginToken ?? clientRegisterToken},
    );
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      details = ClientInfo(
        id: decodedData["data"]["id"],
        name: decodedData["data"]["name"],
        phone: decodedData["data"]["phone"],
      );
    }
    return details;
  }
}
