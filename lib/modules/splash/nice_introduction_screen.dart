import 'package:flutter/material.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/global.dart' as globals;
import 'package:my_cab/constant_styles/styles.dart';
import 'package:my_cab/modules/auth/login_screen.dart';

class NiceIntroductionScreen extends StatefulWidget {
  @override
  _NiceIntroductionScreenState createState() => _NiceIntroductionScreenState();
}

class _NiceIntroductionScreenState extends State<NiceIntroductionScreen> {
  // AnimationController animationController;

  // @override
  // void initState() {
  //   super.initState();
  //   animationController = new AnimationController(
  //       vsync: this, duration: Duration(milliseconds: 1000));
  //   animationController..forward();
  // }

  @override
  Widget build(BuildContext context) {
    globals.locale = Localizations.localeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Image.asset(
                  "assets/images/splash_location.PNG",
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Text(
                          AppLocalizations.of('Hi, nice to meet you!'),
                          style: headLineStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(
                              'Choose your location to start to find\nrestaurants around you.'),
                          textAlign: TextAlign.center,
                          style: describtionStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 8, top: 8),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: staticGreenColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Theme.of(context).dividerColor,
                                  blurRadius: 8,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(
                                          'Use current location'),
                                      style: buttonsText,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
