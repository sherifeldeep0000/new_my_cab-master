import 'dart:ui';
import 'package:my_cab/constance/global.dart' as globals;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/constance.dart';
import 'package:my_cab/constance/themes.dart';
import 'package:my_cab/constant_styles/styles.dart';
import 'package:my_cab/modules/setting/myProfile.dart';
import 'package:my_cab/modules/wallet/paymentMethod.dart';

class MyWallet extends StatefulWidget {
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColors,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 234,
                color: staticGreenColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 16,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 14, left: 14),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 14, left: 14, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of('My Wallet'),
                          style: headLineStyle.copyWith(color: Colors.white),
                        ),
                        // Card(
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(32),
                        //   ),
                        //   elevation: 0,
                        //   color: Colors.blue,
                        //   child: Padding(
                        //     padding: EdgeInsets.only(
                        //         right: 8, left: 8, top: 4, bottom: 4),
                        //     child: Row(
                        //       children: <Widget>[
                        //         Image.asset(
                        //           ConstanceData.coin,
                        //           height: 20,
                        //           width: 20,
                        //         ),
                        //         SizedBox(
                        //           width: 8,
                        //         ),
                        //         Text(
                        //           "2500",
                        //           style: Theme.of(context)
                        //               .textTheme
                        //               .subhead
                        //               .copyWith(
                        //                 fontWeight: FontWeight.bold,
                        //                 color: Colors.white,
                        //               ),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 30, left: 30),
                        child: Center(
                          child: Card(
                            color: globals.isLight
                                ? HexColor("#EEF3F1")
                                : Colors.black.withOpacity(0.8),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20, left: 20, top: 10),
                        child: Center(
                          child: Card(
                            color: globals.isLight
                                ? HexColor("#EEF3F1")
                                : Colors.black.withOpacity(0.8),
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 14, left: 14, top: 20),
                        child: Center(
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  color: staticGreenColor.withOpacity(0.6),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 16,
                                        bottom: 8,
                                        left: 24,
                                        right: 24),
                                    child: Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 30,
                                          child: CircleAvatar(
                                            backgroundColor: Theme.of(context)
                                                .backgroundColor,
                                            radius: 14,
                                            child: Text("LE"),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                AppLocalizations.of('Cash'),
                                                style:
                                                    describtionStyle.copyWith(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(
                                                    'Default Payment Method'),
                                                style:
                                                    describtionStyle.copyWith(
                                                  fontSize: 15.0,
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Theme.of(context).dividerColor,
                                ),
                                Container(
                                  color: Colors.blue,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 16,
                                        bottom: 16,
                                        left: 24,
                                        right: 24),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of('BALANCE'),
                                              style: describtionStyle.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "00.00 LE",
                                              style: describtionStyle.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of('EXPIRES'),
                                              style: describtionStyle.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "09/21",
                                              style: describtionStyle.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     CircleAvatar(
                  //       backgroundColor: Theme.of(context).primaryColor,
                  //       radius: 4,
                  //     ),
                  //     SizedBox(
                  //       width: 4,
                  //     ),
                  //     CircleAvatar(
                  //       backgroundColor: Theme.of(context).dividerColor,
                  //       radius: 4,
                  //     ),
                  //     SizedBox(
                  //       width: 4,
                  //     ),
                  //     CircleAvatar(
                  //       backgroundColor: Theme.of(context).dividerColor,
                  //       radius: 4,
                  //     )
                  //   ],
                  // ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => PaymentMethod(),
                    //   ),
                    // );
                  },
                  child: MyAccountInfo(
                    headText: AppLocalizations.of('Payment Methods'),
                    subtext: "",
                  ),
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                MyAccountInfo(
                  headText: AppLocalizations.of('Coupon'),
                  subtext: "3",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                MyAccountInfo(
                  headText: AppLocalizations.of('Integral Mall'),
                  subtext: "4500",
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
    );
  }

  Widget confirmDriverBox(context) {
    return Padding(
      padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 16,
            child: Padding(
              padding: const EdgeInsets.only(right: 24, left: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    new BoxShadow(
                      color: globals.isLight
                          ? Colors.black.withOpacity(0.2)
                          : Colors.white.withOpacity(0.2),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 0,
            left: 0,
            bottom: 16,
            child: Padding(
              padding: const EdgeInsets.only(right: 12, left: 12),
              child: Container(
                // height: 256,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    new BoxShadow(
                      color: globals.isLight
                          ? Colors.black.withOpacity(0.2)
                          : Colors.white.withOpacity(0.2),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  new BoxShadow(
                    color: globals.isLight
                        ? Colors.black.withOpacity(0.2)
                        : Colors.white.withOpacity(0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).dividerColor.withOpacity(0.03),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              ConstanceData.userImage,
                              height: 50,
                              width: 50,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('Gregory Smith'),
                                style: Theme.of(context)
                                    .textTheme
                                    .subhead
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .title
                                          .color,
                                    ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow[800],
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    AppLocalizations.of('4.9'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .dividerColor
                                              .withOpacity(0.4),
                                        ),
                                  )
                                ],
                              )
                            ],
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {},
                                child: CircleAvatar(
                                  backgroundColor: HexColor("#4353FB"),
                                  child: Center(
                                    child: Icon(
                                      FontAwesomeIcons.facebookMessenger,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Center(
                                  child: Icon(
                                    FontAwesomeIcons.phoneAlt,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0.5,
                      color: Theme.of(context).dividerColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 14, left: 14, top: 10, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              ConstanceData.user1,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              ConstanceData.user2,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              ConstanceData.user3,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            AppLocalizations.of('25 Recommended'),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).textTheme.title.color,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0.5,
                      color: Theme.of(context).disabledColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 14, left: 14, top: 10, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.car,
                            size: 24,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: 32,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('DISTANCE'),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.4),
                                    ),
                              ),
                              Text(
                                AppLocalizations.of('0.2 km'),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .title
                                          .color,
                                    ),
                              )
                            ],
                          ),
                          Expanded(child: SizedBox()),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('TIME'),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.4),
                                    ),
                              ),
                              Text(
                                AppLocalizations.of('0.2 km'),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .title
                                          .color,
                                    ),
                              )
                            ],
                          ),
                          Expanded(child: SizedBox()),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('PRICE'),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.4),
                                    ),
                              ),
                              Text(
                                AppLocalizations.of('\$25.00'),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .title
                                          .color,
                                    ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16, top: 8),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(24.0)),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(24.0)),
                            highlightColor: Colors.transparent,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(
                                          Icons.check_circle,
                                          size: 80,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        Text(
                                          AppLocalizations.of(
                                              'Booking Succsessful'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subhead
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .subhead
                                                    .color,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16, left: 16, bottom: 16),
                                          child: Text(
                                            AppLocalizations.of(
                                                'Your booking has been confirmed. Driver will pickup you in 2 minutes.'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Divider(
                                          height: 0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16, left: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  AppLocalizations.of('Cancel'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .disabledColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                              Container(
                                                color: Theme.of(context)
                                                    .dividerColor,
                                                width: 0.5,
                                                height: 48,
                                              ),
                                              InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  child: Text(
                                                    AppLocalizations.of('Done'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    contentPadding: EdgeInsets.only(top: 16),
                                  );
                                },
                              );
                            },
                            child: Center(
                              child: Text(
                                AppLocalizations.of('Confirm'),
                                style: Theme.of(context)
                                    .textTheme
                                    .subhead
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
