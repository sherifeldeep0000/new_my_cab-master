import 'package:flutter/material.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/constance.dart';
import 'package:my_cab/modules/inviteFriends/selectFriends_Screen.dart';

class InviteFriendsScreen extends StatefulWidget {
  @override
  _InviteFriendsScreenState createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              SizedBox(
                height: 100,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: -100,
                      right: -100,
                      top: -800,
                      bottom: 50,
                      child: SizedBox(
                        height: 500,
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
                      left: -500,
                      right: 110,
                      top: -200,
                      bottom: 0,
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
                    Padding(
                      padding: EdgeInsets.only(right: 14, left: 14, top: MediaQuery.of(context).padding.top + 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            AppLocalizations.of('Invite Friends'),
                            style: Theme.of(context).textTheme.headline.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                ConstanceData.gift,
                height: 200,
                width: 200,
              ),
            ],
          ),
          Text(
            AppLocalizations.of('Invite Friends\nGet 3 Coupons each!'),
            style: Theme.of(context).textTheme.headline.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.only(right: 14, left: 14),
            child: Text(
              AppLocalizations.of('When your friend sign up with your referral code, you will both get 3.0 coupons'),
              style: Theme.of(context).textTheme.subhead.copyWith(
                    color: Colors.white,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
          Container(
            color: Theme.of(context).backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        AppLocalizations.of('Share Your Invite Code'),
                        style: Theme.of(context).textTheme.subhead.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "T637UY",
                        style: Theme.of(context).textTheme.headline.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Icon(
                        Icons.file_upload,
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).textTheme.title.color,
                    thickness: 1.2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
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
                          borderRadius: BorderRadius.all(Radius.circular(24.0)),
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectFriendScreen(),
                              ),
                            );
                          },
                          child: Center(
                            child: Text(
                              AppLocalizations.of('Invite Friends'),
                              style: Theme.of(context).textTheme.subhead.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
