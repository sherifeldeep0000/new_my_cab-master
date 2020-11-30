import 'package:flutter/material.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/constance.dart';
import 'package:my_cab/constance/global.dart' as globals;
import 'package:my_cab/constance/routes.dart';
import 'package:my_cab/constance/themes.dart';
import 'package:my_cab/constant_styles/styles.dart';

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  var otpController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animationController..forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    otpController.dispose();
    super.dispose();
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
                          (MediaQuery.of(context).size.width < 360 ? 124 : 86),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Card(
                        margin: EdgeInsets.all(0),
                        elevation: 8,
                        child: Column(
                          children: <Widget>[
                            _loginTextUI(),
                            _emailUI(),
                            _getVerifyUI(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  SizedBox(
                    height: AppBar().preferredSize.height,
                    child: Container(
                      padding: EdgeInsets.only(top: 0, left: 8),
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: AppBar().preferredSize.height - 8,
                        height: AppBar().preferredSize.height - 8,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: new BorderRadius.circular(
                                AppBar().preferredSize.height),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 26,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 0, left: 8),
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              AppLocalizations.of('Phone Verification'),
                              style:
                                  Theme.of(context).textTheme.headline.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
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
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: Image.asset(
                "assets/images/effect.PNG",
                height: 100.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailUI() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 0, left: 16, right: 16),
          child: getOtpTextUI(otptxt: otpController.text),
        ),
        Opacity(
          opacity: 0.0,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: otpController,
                            maxLength: 6,
                            onChanged: (String txt) {
                              setState(() {
                                txt = otpController.text;
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelStyle: TextStyle(
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _loginTextUI() {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 16, top: 30, bottom: 30),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          AppLocalizations.of('Enter your OTP code here'),
          style: headLineStyle.copyWith(fontSize: 18.0),
        ),
      ),
    );
  }

  Widget _getVerifyUI() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.HOME, (Route<dynamic> route) => false);
            },
            child: Center(
              child: Text(
                AppLocalizations.of("Verify now"),
                style: buttonsText,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getOtpTextUI({String otptxt = ""}) {
    List<Widget> otplist = List<Widget>();
    Widget getUI({String otxt = ""}) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 4, right: 4),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: Colors.black12, width: 1.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    otxt,
                    style: headLineStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    for (var i = 0; i < 6; i++) {
      otplist.add(getUI(otxt: otptxt.length > i ? otptxt[i] : "-"));
    }
    return Row(
      children: otplist,
    );
  }
}
