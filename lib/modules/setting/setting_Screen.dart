import 'package:flutter/material.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/constance.dart';
import 'package:my_cab/constance/routes.dart';
import 'package:my_cab/constant_styles/styles.dart';
import 'package:my_cab/controllers/user_data_provider.dart';
import 'package:my_cab/helper_providers/client_providers/client_info_provider.dart';
import 'package:my_cab/models/auth_model/user_info.dart';
import 'package:my_cab/modules/setting/myProfile.dart';
import 'package:my_cab/constance/constance.dart' as constance;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  UserDataProvider _userDataProvider;

  @override
  void didChangeDependencies() {
    this._userDataProvider = Provider.of<UserDataProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColors,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.blue,
            ),
            Text(
              AppLocalizations.of('Settings'),
              style:
                  headLineStyle.copyWith(fontSize: 20.0, color: Colors.black),
            )
          ],
        ),
        actions: [
          Image.asset("assets/images/setting_effect.PNG"),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                myProfileDetail(),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 16,
                ),
                userSettings(),
                SizedBox(
                  height: 16,
                ),
                userDocs(),
                SizedBox(
                  height: 32,
                ),
                Container(
                  color: Theme.of(context).backgroundColor,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.INTRODUCTION,
                              (Route<dynamic> route) => false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('Logout'),
                                style: Theme.of(context)
                                    .textTheme
                                    .subhead
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).disabledColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  openShowPopupLanguage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                AppLocalizations.of('Select Language'),
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.title.color,
                      fontSize: 18,
                    ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    selectLanguage('en');
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of('English'),
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(height: 1, color: Theme.of(context).dividerColor),
                SizedBox(height: 8),
                //InkWell(
                //                   highlightColor: Colors.transparent,
                //                   splashColor: Colors.transparent,
                //                   onTap: () {
                //                     selectLanguage('fr');
                //                     Navigator.of(context).pop();
                //                   },
                //                   child: Row(
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     children: <Widget>[
                //                       Text(
                //                         AppLocalizations.of('French'),
                //                         style: Theme.of(context).textTheme.subtitle.copyWith(
                //                               fontWeight: FontWeight.bold,
                //                               color: Theme.of(context).disabledColor,
                //                               fontSize: 16,
                //                             ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //                 SizedBox(
                //                   height: 8,
                //                 ),
                //                 Container(
                //                   height: 1,
                //                   color: Theme.of(context).dividerColor,
                //                 ),
                //                 SizedBox(
                //                   height: 8,
                //                 ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    selectLanguage('ar');
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of('Arabic'),
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                // Container(
                //   height: 1,
                //   color: Theme.of(context).dividerColor,
                // ),
                // SizedBox(
                //   height: 8,
                // ),
                // InkWell(
                //   highlightColor: Colors.transparent,
                //   splashColor: Colors.transparent,
                //   onTap: () {
                //     selectLanguage('ja');
                //     Navigator.of(context).pop();
                //   },
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //       Text(
                //         AppLocalizations.of('Japanese'),
                //         style: Theme.of(context).textTheme.subtitle.copyWith(
                //               fontWeight: FontWeight.bold,
                //               color: Theme.of(context).disabledColor,
                //               fontSize: 16,
                //             ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          );
        });
  }

  selectLanguage(String languageCode) {
    constance.locale = languageCode;
    MyApp.setCustomLanguage(context, languageCode);
  }

  Widget userDocs() {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
          // InkWell(
          //   highlightColor: Colors.transparent,
          //   splashColor: Colors.transparent,
          //   onTap: () {
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(
          //     //     builder: (context) => VehicalManagement(),
          //     //   ),
          //     // );
          //   },
          //   child: Padding(
          //     padding:
          //         const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
          //     child: Row(
          //       children: <Widget>[
          //         Text(
          //           AppLocalizations.of('Clear cache'),
          //           style: Theme.of(context).textTheme.subhead.copyWith(
          //                 fontWeight: FontWeight.bold,
          //                 color: Theme.of(context).textTheme.title.color,
          //               ),
          //         ),
          //         Expanded(child: SizedBox()),
          //         Icon(
          //           Icons.arrow_forward_ios,
          //           size: 18,
          //           color: staticGreenColor,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 16),
          //   child: Container(
          //     height: 1,
          //     color: Theme.of(context).dividerColor,
          //   ),
          // ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => VehicalManagement(),
              //   ),
              // );
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppLocalizations.of('Terms & Prvacy Policy'),
                      style: Theme.of(context).textTheme.subhead.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.title.color,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: staticGreenColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => launch("https://gardentaxi.net/contact-us/"),
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Contact us'),
                    style: Theme.of(context).textTheme.subhead.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.title.color,
                        ),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: staticGreenColor,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }

  Widget myProfileDetail() {
    var data = Provider.of<ClientInfoProvider>(context);
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyProfile(),
          ),
        );
      },
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: EdgeInsets.only(right: 10, left: 14, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Container(
                height: 70.0,
                width: 70.0,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: (this._userDataProvider.imageUrl == null)
                        ? AssetImage("assets/profile_icon.png")
                        : NetworkImage("${this._userDataProvider.imageUrl}"),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${this._userDataProvider.name}",
                    style: headLineStyle.copyWith(fontSize: 20.0),
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              Icon(Icons.arrow_forward_ios, size: 18, color: staticGreenColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget userSettings() {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          InkWell(
            onTap: () {
              openShowPopupLanguage();
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Language'),
                    style: Theme.of(context).textTheme.subhead.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.title.color,
                        ),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: staticGreenColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          InkWell(
            onTap: () {
              openShowPopup();
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Theme Mode'),
                    style: Theme.of(context).textTheme.subhead.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.title.color,
                        ),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: staticGreenColor,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }

  openShowPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                AppLocalizations.of('Select theme mode'),
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.title.color,
                      fontSize: 18,
                    ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        changeColor(light);
                      },
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor:
                            Theme.of(context).textTheme.title.color,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 32,
                          child: Text(
                            AppLocalizations.of('Light'),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        changeColor(dark);
                      },
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor:
                            Theme.of(context).textTheme.title.color,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 32,
                          child: Text(
                            AppLocalizations.of('Dark'),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  int light = 1;
  int dark = 2;

  changeColor(int color) {
    if (color == light) {
      MyApp.changeTheme(context);
    } else {
      MyApp.changeTheme(context);
    }
  }
}
