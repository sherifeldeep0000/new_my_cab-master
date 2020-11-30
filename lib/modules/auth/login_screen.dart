import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/constance.dart';
import 'package:my_cab/constance/global.dart' as globals;
import 'package:my_cab/constance/routes.dart';
import 'package:my_cab/constant_styles/styles.dart';
import 'package:http/http.dart' as http;
import 'package:my_cab/controllers/shared_preference.dart';
import 'package:my_cab/controllers/user_data_provider.dart';
import 'package:my_cab/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _formSignUpKey = GlobalKey<FormState>();
  final _formSignInKey = GlobalKey<FormState>();
  bool isSignUp = true;
  TextEditingController nameSignUpControl = TextEditingController();
  TextEditingController phoneSignUpControl = TextEditingController();
  TextEditingController passSignUpControl = TextEditingController();
  TextEditingController phoneSignInControl = TextEditingController();
  TextEditingController passSignInControl = TextEditingController();

  @override
  void initState() {
    firebaseMessagingListeners();
    _getPrefrences();
    animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animationController..forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    nameSignUpControl.dispose();
    phoneSignUpControl.dispose();
    passSignUpControl.dispose();
    phoneSignInControl.dispose();
    passSignInControl.dispose();

    super.dispose();
  }

  // String deviceId = "";
  // Future getDeviceId() async {
  //   DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  //   AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
  //   String id = androidDeviceInfo.id;
  //   setState(() {
  //     deviceId = id;
  //   });
  //   print("device id isss :$deviceId");
  // }

  void _loading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Loading(status: "Loading"),
    );
  }

  void _userNotFound() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        contentPadding: EdgeInsets.all(20.0),
        title: Text(
          "Sorry User Not Found",
          style: headLineStyle.copyWith(fontSize: 20),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Ok",
              style: describtionStyle.copyWith(fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }

  String deviceToken = "";

  void firebaseMessagingListeners() async {
    _firebaseMessaging.getToken().then((token) {
      setState(() {
        deviceToken = token;
      });
    });
  }

  Future<void> saveDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("DeviceToken", deviceToken);
  }

  void loginIn() async {
    print("Login Shehab ////////////////////////////");
    ////save data////
    await saveDeviceToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _loading();
    try {
      String url = "https://gardentaxi.net/Back_End/public/api/user/login";
      Map<String, dynamic> dataBody = {
        "phone": phoneSignInControl.text,
        "password": passSignInControl.text,
        "device_token": deviceToken,
      };
      print("///////////////////////////////////////////////////////");
      print("Data Body : $dataBody");
      http.Response response = await http.post(url, body: dataBody);
      if (response.statusCode == 200) {
        print("Sign in Data : ////////////////////////////////////////////////////////////////");
        print(response.body);
        if (response.body.contains("success")) {
          var dataDecoded = jsonDecode(response.body);

          prefs.setString(
            "userToken",
            dataDecoded["data"]['api_token'],
          );
          int clientId = dataDecoded["data"]['id'];
          prefs.setInt("clinetId", clientId);
          String clientName = dataDecoded['data']['name'];
          prefs.setString("ClientName", clientName);

          /////saveData////

          Map<String, dynamic> storedData = {
            "id": clientId,
            "name": "$clientName",
            "phone": "${dataDecoded['data']['phone']}",
            "device_token": "${dataBody['device_token']}",
            "gender": "${dataDecoded['data']['gender']}",
            "image_url" :"${dataDecoded['data']['img_url']}",
            "api_token" : "${dataDecoded['data']['api_token']}",
          };
          print("storedData : $storedData");
          SharedPreferenceService prefsService = new SharedPreferenceService();
          prefsService.setUserData(storedData);
          this._userDataProvider.initialData(storedData);

          Navigator.pop(context);
          phoneSignInControl.clear();
          passSignInControl.clear();

          Navigator.pushNamedAndRemoveUntil(
              context, Routes.HOME, (route) => false);
        } else {
          Navigator.pop(context);
          _userNotFound();
          phoneSignInControl.clear();
          passSignInControl.clear();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  bool _genderIsMale = true;

  UserDataProvider _userDataProvider;

  @override
  void didChangeDependencies() {
    this._userDataProvider = Provider.of<UserDataProvider>(context);
    super.didChangeDependencies();
  }

  void registerClient() async {
    print(
        "//////////////////////////////////////////Sehhab//////////////////////");
    _loading();
    await saveDeviceToken();
    try {
      String url = "https://gardentaxi.net/Back_End/public/api/user/register";
      Map<String, dynamic> dataBody = {
        "name": nameSignUpControl.text,
        "phone": phoneSignUpControl.text,
        "password": passSignUpControl.text,
        "device_token": deviceToken,
        "gender": this._genderIsMale ? "m" : "f",
      };
      print("/////////////////////////////////////////////");
      print("Data Body : $dataBody");
      var response = await http.post(url, body: dataBody);
      print("response.statusCode : ${response.statusCode}");
      if (response.statusCode == 200) {
        var dataDecoded = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("registerToken", dataDecoded["data"]['api_token']);
        int id = dataDecoded["data"]['id'];
        prefs.setInt("clinetId", id);

        String clientName = dataDecoded['data']['name'];
        prefs.setString("ClientName", clientName);

        ////save data////
        dataBody['id'] = id;
        print("Store Data Body : $dataBody");
        SharedPreferenceService prefsService = new SharedPreferenceService();
        prefsService.setUserData(dataBody);
        this._userDataProvider.initialData(dataBody);

        Navigator.pop(context);
        nameSignUpControl.clear();
        phoneSignUpControl.clear();
        passSignUpControl.clear();
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.HOME, (route) => false);
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  void _getPrefrences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginToken = prefs.getString("userToken");
    var signUpToken = prefs.getString("registerToken");
    if (loginToken != null || signUpToken != null) {
      Navigator.pushNamedAndRemoveUntil(context, Routes.HOME, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    globals.locale = Localizations.localeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ClipRect(
                        child: Container(
                          color: staticGreenColor,
                          child: AnimatedBuilder(
                            animation: animationController,
                            builder: (BuildContext context, Widget child) {
                              return Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Transform(
                                    transform: new Matrix4.translationValues(
                                        0.0,
                                        160 *
                                                (1.0 -
                                                    (AlwaysStoppedAnimation(Tween(
                                                                    begin: 0.4,
                                                                    end: 1.0)
                                                                .animate(CurvedAnimation(
                                                                    parent:
                                                                        animationController,
                                                                    curve: Curves
                                                                        .fastOutSlowIn)))
                                                            .value)
                                                        .value) -
                                            16,
                                        0.0),
                                    child: Image.asset(
                                      ConstanceData.buildingImageBack,
                                      color: Colors.black12,
                                    ),
                                  ),
                                  Transform(
                                    transform: new Matrix4.translationValues(
                                        0.0,
                                        160 *
                                            (1.0 -
                                                (AlwaysStoppedAnimation(Tween(
                                                                begin: 0.8,
                                                                end: 1.0)
                                                            .animate(CurvedAnimation(
                                                                parent:
                                                                    animationController,
                                                                curve: Curves
                                                                    .fastOutSlowIn)))
                                                        .value)
                                                    .value),
                                        0.0),
                                    child: Image.asset(
                                      ConstanceData.buildingImage,
                                      color: Colors.black12,
                                    ),
                                  ),
                                  Positioned(
                                    bottom:
                                        (MediaQuery.of(context).size.height /
                                            8),
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: SizedBox(
                                        width: 120,
                                        height: 120,
                                        child: AnimatedBuilder(
                                          animation: animationController,
                                          builder: (BuildContext context,
                                              Widget child) {
                                            return Transform(
                                              transform: new Matrix4
                                                      .translationValues(
                                                  0.0,
                                                  80 *
                                                      (1.0 -
                                                          (AlwaysStoppedAnimation(
                                                            Tween(
                                                                    begin: 0.0,
                                                                    end: 1.0)
                                                                .animate(
                                                              CurvedAnimation(
                                                                parent:
                                                                    animationController,
                                                                curve: Curves
                                                                    .fastOutSlowIn,
                                                              ),
                                                            ),
                                                          ).value)
                                                              .value),
                                                  0.0),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(0.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: (MediaQuery.of(context).size.height / 2) -
                          (MediaQuery.of(context).size.height < 600 ? 124 : 86),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Card(
                        margin: EdgeInsets.all(0),
                        elevation: 8,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    splashColor: Colors.green.withOpacity(0.2),
                                    onTap: () {
                                      setState(() {
                                        isSignUp = true;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              AppLocalizations.of('Sign Up'),
                                              style: headLineStyle.copyWith(
                                                fontSize: 20.0,
                                                color: isSignUp
                                                    ? Colors.black
                                                    : Colors.black38,
                                              ),
                                            ),
                                          ),
                                          isSignUp
                                              ? Padding(
                                                  padding: EdgeInsets.all(0.0),
                                                  child: Card(
                                                    elevation: 0,
                                                    color: staticGreenColor,
                                                    child: SizedBox(
                                                      height: 6,
                                                      width: 48,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    splashColor: Colors.green.withOpacity(0.2),
                                    onTap: () {
                                      setState(() {
                                        isSignUp = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              AppLocalizations.of('Sign In'),
                                              style: headLineStyle.copyWith(
                                                fontSize: 20.0,
                                                color: !isSignUp
                                                    ? Colors.black
                                                    : Colors.black38,
                                              ),
                                            ),
                                          ),
                                          !isSignUp
                                              ? Padding(
                                                  padding: EdgeInsets.all(0.0),
                                                  child: Card(
                                                    elevation: 0,
                                                    color: staticGreenColor,
                                                    child: SizedBox(
                                                      height: 6,
                                                      width: 48,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 1,
                            ),
                            AnimatedCrossFade(
                              alignment: Alignment.topCenter,
                              reverseDuration: Duration(milliseconds: 420),
                              duration: Duration(milliseconds: 420),
                              crossFadeState: !isSignUp
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              firstCurve: Curves.fastOutSlowIn,
                              secondCurve: Curves.fastOutSlowIn,
                              sizeCurve: Curves.fastOutSlowIn,
                              firstChild: IgnorePointer(
                                ignoring: !isSignUp,
                                child: Form(
                                  key: _formSignUpKey,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 10.0),
                                      _nameUI(),
                                      SizedBox(height: 10.0),
                                      _phoneSignUpUi(),
                                      SizedBox(height: 10.0),
                                      _passSignUpUI(),
                                      SizedBox(height: 10.0),
                                      this._selectGender(context),
                                      _getSignUpButtonUI(),
                                    ],
                                  ),
                                ),
                              ),
                              secondChild: IgnorePointer(
                                ignoring: isSignUp,
                                child: Form(
                                  key: _formSignInKey,
                                  child: Column(
                                    children: <Widget>[
                                      _loginTextUI(),
                                      SizedBox(height: 10.0),
                                      _phoneSignInUi(),
                                      SizedBox(height: 10.0),
                                      _passSignInUI(),
                                      SizedBox(height: 10.0),
                                      _getSignInButtonUI()
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nameUI() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: TextFormField(
        controller: nameSignUpControl,
        validator: (value) =>
            value.isEmpty ? "You Should Enter Full Name" : null,
        autofocus: false,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          hintText: 'User Name',
          hintStyle: describtionStyle.copyWith(color: Colors.black26),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _passSignUpUI() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: TextFormField(
        controller: passSignUpControl,
        obscureText: true,
        validator: (value) =>
            value.isEmpty ? "You Should Enter Password" : null,
        autofocus: false,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          hintText: 'Password',
          hintStyle: describtionStyle.copyWith(color: Colors.black26),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _passSignInUI() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: TextFormField(
        controller: passSignInControl,
        obscureText: true,
        validator: (value) =>
            value.isEmpty ? "You Should Enter Password" : null,
        autofocus: false,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          hintText: 'Password',
          hintStyle: describtionStyle.copyWith(color: Colors.black26),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _loginTextUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 16, top: 30, bottom: 30),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          AppLocalizations.of('Login with your phone number'),
          style: headLineStyle.copyWith(fontSize: 18.0),
        ),
      ),
    );
  }

  Widget _phoneSignUpUi() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: TextFormField(
        controller: phoneSignUpControl,
        validator: (value) =>
            value.isEmpty ? "You Should Enter Phone Number" : null,
        autofocus: false,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          hintText: 'Phone Number',
          hintStyle: describtionStyle.copyWith(color: Colors.black26),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _phoneSignInUi() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: TextFormField(
        controller: phoneSignInControl,
        validator: (value) =>
            value.isEmpty ? "You Should Enter Phone Number" : null,
        autofocus: false,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          hintText: 'Phone Number',
          hintStyle: describtionStyle.copyWith(color: Colors.black26),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _getSignUpButtonUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: staticGreenColor,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            highlightColor: Colors.transparent,
            onTap: () {
              if (_formSignUpKey.currentState.validate()) {
                print("Done sign up");
                registerClient();
              }
            },
            child: Center(
              child: Text(
                "Sign Up",
                style: buttonsText,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSignInButtonUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: staticGreenColor,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            highlightColor: Colors.transparent,
            onTap: () {
              if (_formSignInKey.currentState.validate()) {
                print("Done Sign in");
                loginIn();
              }
            },
            child: Center(
              child: Text(
                "Sign In",
                style: buttonsText,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectGender(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: RadioListTile(
              title: Text("Male"),
              value: true,
              groupValue: this._genderIsMale,
              onChanged: (bool isMale) =>
                  setState(() => this._genderIsMale = isMale),
            ),
          ),
          Expanded(
            child: RadioListTile(
              title: Text("FeMale"),
              value: false,
              groupValue: this._genderIsMale,
              onChanged: (bool isMale) =>
                  setState(() => this._genderIsMale = isMale),
            ),
          ),
        ],
      ),
    );
  }
}
