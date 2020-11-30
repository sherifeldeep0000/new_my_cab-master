import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/constance.dart';
import 'package:my_cab/constance/routes.dart';
import 'package:my_cab/constant_styles/styles.dart';
import 'package:my_cab/controllers/navigators.dart';
import 'package:my_cab/controllers/user_data_provider.dart';
import 'package:my_cab/helper_providers/client_providers/client_info_provider.dart';
import 'package:my_cab/models/auth_model/user_info.dart';
import 'package:my_cab/modules/chat/chat_Screen.dart';
import 'package:my_cab/modules/history/history_Screen.dart';
import 'package:my_cab/modules/setting/setting_Screen.dart';
import 'package:my_cab/modules/wallet/myWallet.dart';
import 'package:my_cab/views/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  final String selectItemName;

  const AppDrawer({Key key, this.selectItemName}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  UserDataProvider _userDataProvider;

  @override
  void didChangeDependencies() {
    this._userDataProvider = Provider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<ClientInfoProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              Container(
                color: staticGreenColor,
                height: 200,
              ),
              SizedBox(
                height: 200,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: -150,
                      right: -10,
                      top: -800,
                      bottom: 80,
                      child: SizedBox(
                        height: 800,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(500),
                          ),
                          margin: EdgeInsets.all(0),
                          color: Colors.black.withOpacity(0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -200,
                      right: 110,
                      top: -50,
                      bottom: -5,
                      child: SizedBox(
                        height: 400,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(500),
                          ),
                          margin: EdgeInsets.all(0),
                          color: Colors.black.withOpacity(0.06),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, top: 16 ,right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Container(
                        color: Theme.of(context).cardColor,
                        padding: EdgeInsets.all(2),
                        child: Container(
                          height: 70.0,
                          width: 70.0,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: (this._userDataProvider.imageUrl == null)
                                  ? AssetImage("assets/profile_icon.png")
                                  : NetworkImage(
                                      "${this._userDataProvider.imageUrl}"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "${this._userDataProvider.name}",
                      style: describtionStyle.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    // Row(
                    //   children: <Widget>[
                    //     Card(
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(36.0),
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(4),
                    //         child: Row(
                    //           children: <Widget>[
                    //             Text(
                    //               AppLocalizations.of("Cash"),
                    //               style: describtionStyle.copyWith(
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //             SizedBox(
                    //               width: 4,
                    //             ),
                    //             // Text("00.00",
                    //             //     style: describtionStyle.copyWith(
                    //             //         color: Colors.blue)),
                    //             SizedBox(
                    //               width: 4,
                    //             ),
                    //             Icon(
                    //               Icons.arrow_forward_ios,
                    //               color: staticGreenColor,
                    //               size: 16,
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: 15.0),
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 26,
                    ),
                    Row(
                      children: <Widget>[
                        widget.selectItemName == 'Home'
                            ? selectedData()
                            : SizedBox(),
                        Icon(
                          Icons.home,
                          size: 28,
                          color: widget.selectItemName == 'Home'
                              ? staticGreenColor
                              : Colors.black38,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          AppLocalizations.of('Home'),
                          style: headLineStyle.copyWith(fontSize: 18.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    GestureDetector(
                      onTap: () => pushNavigator(context, MyChatScreen()),
                      child: Row(
                        children: <Widget>[
                          widget.selectItemName == 'Chat'
                              ? selectedData()
                              : SizedBox(),
                          Icon(
                            Icons.chat_bubble,
                            size: 28,
                            color: widget.selectItemName == 'Chat'
                                ? staticGreenColor
                                : Colors.black38,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            AppLocalizations.of('Chat'),
                            style: headLineStyle.copyWith(fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => MyWallet(),
                    //       ),
                    //     );
                    //   },
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 4),
                    //     child: Row(
                    //       children: <Widget>[
                    //         widget.selectItemName == 'MyWallet'
                    //             ? selectedData()
                    //             : SizedBox(),
                    //         Icon(
                    //           FontAwesomeIcons.wallet,
                    //           size: 20,
                    //           color: widget.selectItemName == 'MyWallet'
                    //               ? staticGreenColor
                    //               : Colors.black38,
                    //         ),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         Text(
                    //           AppLocalizations.of('My Wallet'),
                    //           style: headLineStyle.copyWith(fontSize: 18.0),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 32,
                    // ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Row(
                          children: <Widget>[
                            widget.selectItemName == 'History'
                                ? selectedData()
                                : SizedBox(),
                            Icon(
                              FontAwesomeIcons.history,
                              size: 20,
                              color: widget.selectItemName == 'History'
                                  ? staticGreenColor
                                  : Colors.black38,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalizations.of('History'),
                              style: headLineStyle.copyWith(fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => NotificationScreen(),
                    //       ),
                    //     );
                    //   },
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 4),
                    //     child: Row(
                    //       children: <Widget>[
                    //         widget.selectItemName == 'Notification'
                    //             ? selectedData()
                    //             : SizedBox(),
                    //         Icon(
                    //           FontAwesomeIcons.solidBell,
                    //           size: 20,
                    //           color: widget.selectItemName == 'Notification'
                    //               ? Theme.of(context).primaryColor
                    //               : Theme.of(context)
                    //                   .disabledColor
                    //                   .withOpacity(0.2),
                    //         ),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         Text(
                    //           AppLocalizations.of('Notification'),
                    //           style: Theme.of(context)
                    //               .textTheme
                    //               .subtitle
                    //               .copyWith(
                    //                 fontWeight: FontWeight.bold,
                    //                 color:
                    //                     Theme.of(context).textTheme.title.color,
                    //               ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 32,
                    // ),
                    // InkWell(
                    //   highlightColor: Colors.transparent,
                    //   splashColor: Colors.transparent,
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => InviteFriendsScreen(),
                    //       ),
                    //     );
                    //   },
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 4),
                    //     child: Row(
                    //       children: <Widget>[
                    //         widget.selectItemName == 'Invite'
                    //             ? selectedData()
                    //             : SizedBox(),
                    //         Icon(
                    //           FontAwesomeIcons.gifts,
                    //           size: 18,
                    //           color: widget.selectItemName == 'Invite'
                    //               ? Theme.of(context).primaryColor
                    //               : Theme.of(context)
                    //                   .disabledColor
                    //                   .withOpacity(0.2),
                    //         ),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         Text(
                    //           AppLocalizations.of('Invite Friends'),
                    //           style: Theme.of(context)
                    //               .textTheme
                    //               .subtitle
                    //               .copyWith(
                    //                 fontWeight: FontWeight.bold,
                    //                 color:
                    //                     Theme.of(context).textTheme.title.color,
                    //               ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 32,
                    // ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Row(
                          children: <Widget>[
                            widget.selectItemName == 'Setting'
                                ? selectedData()
                                : SizedBox(),
                            Icon(
                              FontAwesomeIcons.cog,
                              size: 20,
                              color: widget.selectItemName == 'Setting'
                                  ? staticGreenColor
                                  : Colors.black38,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalizations.of('Setting'),
                              style: headLineStyle.copyWith(fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    InkWell(
                      onTap: () async {
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        prefs.remove("userToken");
                        prefs.remove("registerToken");
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.INTRODUCTION,
                                (Route<dynamic> route) => false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.signOutAlt,
                              size: 20,
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.2),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalizations.of('Logout'),
                              style: headLineStyle.copyWith(fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget selectedData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 28,
          width: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: staticGreenColor,
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
