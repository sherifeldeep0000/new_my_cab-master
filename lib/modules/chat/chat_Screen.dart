import 'package:flutter/material.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/constance.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
                          AppLocalizations.of('Gregory Smith'),
                          style: Theme.of(context).textTheme.headline.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        Card(
                          margin: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Container(
                            color: Theme.of(context).cardColor,
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                ConstanceData.userImage,
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ),
                        ),
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
                Padding(
                  padding: const EdgeInsets.only(right: 12, left: 12),
                  child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          AppLocalizations.of('Today at 5:03 PM'),
                          style: Theme.of(context).textTheme.subtitle.copyWith(
                                color: Theme.of(context).disabledColor,
                              ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Text(
                                  AppLocalizations.of('Hello,are you nearby?'),
                                  style: Theme.of(context).textTheme.subhead.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).dividerColor,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Text(
                                  AppLocalizations.of('Hello,are you nearby?'),
                                  style: Theme.of(context).textTheme.subhead.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Text(
                                  AppLocalizations.of('OK, Iam waiting at Vinmark\nStore'),
                                  style: Theme.of(context).textTheme.subhead.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          AppLocalizations.of('Today at 5:33 PM'),
                          style: Theme.of(context).textTheme.subtitle.copyWith(
                                color: Theme.of(context).disabledColor,
                              ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).dividerColor,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Text(
                                  AppLocalizations.of('Sorry, i am stuck in traffic.\nplease give me amoment'),
                                  style: Theme.of(context).textTheme.subhead.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ) ),
              ],
            ),
          ),
          Container(
            height: 40 + MediaQuery.of(context).padding.bottom,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Container(
              height: 40,
              padding: EdgeInsets.only(right: 14, left: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
                color: Theme.of(context).backgroundColor,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      autofocus: false,
                      style: Theme.of(context).textTheme.body1.copyWith(
                            color: Theme.of(context).textTheme.title.color,
                            fontWeight: FontWeight.bold,
                          ),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of('Type a message...'),
                        hintStyle: Theme.of(context).textTheme.body1.copyWith(
                              color: Theme.of(context).dividerColor,
                              fontWeight: FontWeight.bold,
                            ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
