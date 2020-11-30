import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/constance.dart';
import 'package:my_cab/constance/routes.dart';
import 'package:my_cab/constant_styles/styles.dart';
import 'package:my_cab/controllers/user_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_cab/helper_providers/client_providers/client_info_provider.dart';

class InsideAndOutSide extends StatefulWidget {
  @override
  _InsideAndOutSideState createState() => _InsideAndOutSideState();
}

class _InsideAndOutSideState extends State<InsideAndOutSide> {
  var appBarheight = 0.0;
  UserDataProvider _userDataProvider;

  @override
  void didChangeDependencies() {
    this._userDataProvider = Provider.of<UserDataProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    appBarheight =
        AppBar().preferredSize.height + MediaQuery.of(context).padding.top + 20;

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          height: height * 1.0,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: appBarheight),
                    Card(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: height * 0.2,
                            decoration: BoxDecoration(
                              color: staticGreenColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: <Widget>[
                                Animator(
                                    tweenMap: {
                                      "translateAnim": Tween<Offset>(
                                        begin: Offset(0, 0.9),
                                        end: Offset(0, 0),
                                      ),
                                    },
                                    duration: Duration(seconds: 3),
                                    cycles: 1,
                                    builder: (BuildContext context,
                                        AnimatorState anim, Widget child) {
                                      return SlideTransition(
                                        position:
                                            anim.getAnimation("translateAnim"),
                                        child: Image.asset(
                                          ConstanceData.splashBackground,
                                          fit: BoxFit.cover,
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      );
                                    }),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 16.0, top: 15.0),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                        AppLocalizations.of('Location'),
                                      style: headLineStyle.copyWith(
                                          color: Colors.white, fontSize: 40.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 16, left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${AppLocalizations.of("The Area Must Be Determined")}",
                                  style: describtionStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Routes.INTRODUCTION);

                                    Provider.of<ClientInfoProvider>(context,
                                            listen: false)
                                        .getInside("1");
                                    this._userDataProvider.inSide = true;
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(top: 10.0),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(color: Colors.black12),
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      "${AppLocalizations.of("Inside")}",
                                      style: headLineStyle.copyWith(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Routes.INTRODUCTION);
                                    Provider.of<ClientInfoProvider>(context,
                                            listen: false)
                                        .getOutSide("0");
                                    this._userDataProvider.inSide = false;
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(color: Colors.black12),
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      "${AppLocalizations.of("Outside")}",
                                      style: headLineStyle.copyWith(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 36,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  "assets/images/effect.PNG",
                  height: 100.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
