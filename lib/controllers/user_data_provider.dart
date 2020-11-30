import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {
  int _id;
  String _name, _phone, _deviceToken, _gender, _imageUrl, _apiToken;
  bool _inSide;

  void initialData(Map<String, dynamic> data) {
    print("Data in SharedPreference : $data");
    this._id = data['id'];
    this._name = data['name'];
    this._phone = data['phone'];
    this._deviceToken = data['device_token'];
    this._gender = data['gender'];
    this._imageUrl = data['image_url'];
    this._apiToken = data['api_token'];
    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    return Map<String, dynamic>.from({
      "id": this._id,
      "name": "${this._name}",
      "device_token": "${this._deviceToken}",
      "phone": "${this._phone}",
      "gender": "${this._gender}",
      "image_url": "${this._imageUrl}",
      "api_token": "${this._apiToken}",
    });
  }

  String get apiToken => this._apiToken;

  bool get inSide => this._inSide ?? false;

  set inSide(bool inSide) {
    this._inSide = inSide;
    notifyListeners();
  }

  int get id => _id;

  String get imageUrl => this._imageUrl;

  set imageUrl(String image) {
    this._imageUrl = image;
    notifyListeners();
  }

  String get name => _name;

  String get deviceToke => _deviceToken;

  String get gender => _gender;

  String get nativeGender {
    if (this._gender == "m")
      return "Male";
    else
      return "Female";
  }

  String get phone => _phone;
}
