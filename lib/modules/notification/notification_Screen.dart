import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/themes.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 150,
                color: Theme.of(context).primaryColor,
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
                        color: Colors.white,
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
                          AppLocalizations.of('Notifications'),
                          style: Theme.of(context).textTheme.headline.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        CircleAvatar(
                          backgroundColor: Theme.of(context).disabledColor.withOpacity(0.2),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Theme.of(context).disabledColor.withOpacity(0.1),
                          radius: 24,
                          child: Icon(
                            Icons.check_circle,
                            color: HexColor("#4252FF"),
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('System'),
                              style: Theme.of(context).textTheme.subtitle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.title.color,
                                  ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              AppLocalizations.of('Booking #1234 has been succsess.'),
                              style: Theme.of(context).textTheme.subtitle.copyWith(
                                    color: Theme.of(context).textTheme.title.color,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Theme.of(context).disabledColor.withOpacity(0.1),
                          radius: 24,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: Icon(
                                FontAwesomeIcons.ticketAlt,
                                size: 22,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('Promotion'),
                                style: Theme.of(context).textTheme.subtitle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.title.color,
                                    ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                AppLocalizations.of('Invite friends-GEt 3 coupens each!'),
                                style: Theme.of(context).textTheme.subtitle.copyWith(
                                      color: Theme.of(context).textTheme.title.color,
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
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Theme.of(context).disabledColor.withOpacity(0.1),
                          radius: 24,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: Icon(
                                FontAwesomeIcons.ticketAlt,
                                size: 22,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('Promotion'),
                                style: Theme.of(context).textTheme.subtitle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.title.color,
                                    ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                AppLocalizations.of('Invite friends-GEt 3 coupens each!'),
                                style: Theme.of(context).textTheme.subtitle.copyWith(
                                      color: Theme.of(context).textTheme.title.color,
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
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Theme.of(context).disabledColor.withOpacity(0.1),
                          radius: 24,
                          child: Center(
                            child: CircleAvatar(
                              backgroundColor: HexColor("#F52C56"),
                              radius: 12,
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: Theme.of(context).backgroundColor,
                              ),
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
                              AppLocalizations.of('System'),
                              style: Theme.of(context).textTheme.subtitle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.title.color,
                                  ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              AppLocalizations.of('Booking #156 has been cancelled.'),
                              style: Theme.of(context).textTheme.subtitle.copyWith(
                                    color: Theme.of(context).textTheme.title.color,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Theme.of(context).disabledColor.withOpacity(0.1),
                          radius: 24,
                          child: Center(
                            child: Icon(
                              FontAwesomeIcons.wallet,
                              size: 22,
                              color: Colors.black,
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
                              AppLocalizations.of('System'),
                              style: Theme.of(context).textTheme.subtitle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.title.color,
                                  ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              AppLocalizations.of('Thank you Your transaction is done'),
                              style: Theme.of(context).textTheme.subtitle.copyWith(
                                    color: Theme.of(context).textTheme.title.color,
                                  ),
                              overflow: TextOverflow.clip,
                            ),
                          ],
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
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Theme.of(context).disabledColor.withOpacity(0.1),
                          radius: 24,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: Icon(
                                FontAwesomeIcons.ticketAlt,
                                size: 22,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('Promotion'),
                                style: Theme.of(context).textTheme.subtitle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.title.color,
                                    ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                AppLocalizations.of('Invite friends-GEt 3 coupens each!'),
                                style: Theme.of(context).textTheme.subtitle.copyWith(
                                      color: Theme.of(context).textTheme.title.color,
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
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 16,
          )
        ],
      ),
    );
  }
}
