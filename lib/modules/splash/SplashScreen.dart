import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_cab/Language/LanguageData.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/constance.dart';
import 'package:my_cab/constance/global.dart' as globals;
import 'package:my_cab/constance/routes.dart';
import 'package:my_cab/constance/themes.dart';

import 'package:my_cab/constance/constance.dart' as constance;
import 'package:my_cab/controllers/shared_preference.dart';
import 'package:my_cab/controllers/user_data_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // AnimationController animationController;
  BuildContext myContext;

  @override
  void initState() {
    myContext = context;
    Timer(Duration(seconds: 2), () {
      _loadNextScreen();
    });
    super.initState();
  }

  _loadNextScreen() async {
    //await Future.delayed(const Duration(milliseconds: 500));
    await Firebase.initializeApp();

    SharedPreferenceService prefsService = new SharedPreferenceService();
    Map<String, dynamic> data = await prefsService.getUserData();
    if (data != null) this._userDataProvider.initialData(data);

    if (!mounted) return;
    if (constance.allTextData == null) {
      constance.allTextData = AllTextData.fromJson(json.decode(
          await DefaultAssetBundle.of(myContext)
              .loadString("assets/jsonFile/languagetext.json")));
    }
    await Future.delayed(const Duration(milliseconds: 1200));
    Navigator.pushReplacementNamed(context, Routes.Languages);
  }

  // checkUserStatus() {
  //   Navigator.pushReplacementNamed(context, Routes.INTRODUCTION);
  // }

  // @override
  // void dispose() {
  //   animationController?.dispose();
  //   super.dispose();
  // }

  UserDataProvider _userDataProvider;

  @override
  void didChangeDependencies() {
    this._userDataProvider = Provider.of<UserDataProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Image.asset(
              "assets/splash/splash1.jpg",
              fit: BoxFit.cover,
              width: double.infinity,
              height: height,
            ),
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
