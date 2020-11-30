import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_cab/widgets/exception_dialog.dart';
import 'package:my_cab/widgets/loading_dialog.dart';

Future<Map<String, dynamic>> selectAndGetImageData(BuildContext context) async {
  const url = "https://api.cloudinary.com/v1_1/dtatjqbra/image/upload";
  var image = await ImagePicker().getImage(source: ImageSource.gallery);

  if (image != null) {
    loadingDialog(context);

    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(image.path),
      "upload_preset": "market",
      "cloud_name": "dtatjqbra",
    });
    try {
      Response response = await Dio().post(url, data: formData);

      Map<String, dynamic> data = jsonDecode(response.toString());

      Map<String, dynamic> imageDataFile = {
        "original": data['secure_url'],
        "xl": data['eager'][0]['secure_url'],
        "sm": data['eager'][1]['secure_url'],
        "lg": data['eager'][2]['secure_url'],
        "md": data['eager'][3]['secure_url'],
        "cloudId": data['public_id'],
      };
      Navigator.pop(context);
      return imageDataFile;
    } catch (e) {
      print("Exception in Upload Image Method : $e");
      Navigator.pop(context);
      exceptionDialog(context);
      return null;
    }
  }
  return null;
}
