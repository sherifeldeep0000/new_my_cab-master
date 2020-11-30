import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:http/http.dart' as http;
import 'package:my_cab/constant_styles/styles.dart';
import 'package:my_cab/controllers/navigators.dart';
import 'package:my_cab/controllers/shared_preference.dart';
import 'package:my_cab/controllers/upload_image.dart';
import 'package:my_cab/controllers/user_data_provider.dart';
import 'package:my_cab/helper_providers/client_providers/client_info_provider.dart';
import 'package:my_cab/models/auth_model/user_info.dart';
import 'package:my_cab/views/image_view.dart';
import 'package:my_cab/widgets/change_image_bottom_sheet.dart';
import 'package:my_cab/widgets/exception_dialog.dart';
import 'package:my_cab/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  UserDataProvider _userDataProvider;

  @override
  void didChangeDependencies() {
    this._userDataProvider = Provider.of<UserDataProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<ClientInfoProvider>(context);
    return Scaffold(
      backgroundColor: backGroundColors,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 160,
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
                        Text(AppLocalizations.of('My Account'),
                            style: headLineStyle.copyWith(color: Colors.white)),
                        this._userImage(),
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
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                MyAccountInfo(
                  headText: AppLocalizations.of('Level'),
                  subtext: AppLocalizations.of('Gold member'),
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
                  headText: AppLocalizations.of('Name'),
                  subtext: "${this._userDataProvider.name}",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                // MyAccountInfo(
                //   headText: AppLocalizations.of('Email'),
                //   subtext: AppLocalizations.of('account@gmail.com'),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                MyAccountInfo(
                  headText: AppLocalizations.of('Gender'),
                  subtext: AppLocalizations.of(
                      '${this._userDataProvider.nativeGender}'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     showCupertinoModalPopup<void>(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return _buildBottomPicker(
                //           CupertinoDatePicker(
                //             use24hFormat: true,
                //             mode: CupertinoDatePickerMode.date,
                //             initialDateTime: DateTime.now(),
                //             onDateTimeChanged: (DateTime newDateTime) {},
                //             maximumYear: 2021,
                //             minimumYear: 1995,
                //           ),
                //         );
                //       },
                //     );
                //   },
                //   child: MyAccountInfo(
                //     headText: AppLocalizations.of('Birthday'),
                //     subtext: AppLocalizations.of('April 16, 1988'),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                MyAccountInfo(
                  headText: AppLocalizations.of('Phone Number'),
                  subtext:
                      AppLocalizations.of('${this._userDataProvider.phone}'),
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

  Widget _userImage() {
    ImageProvider image = (this._userDataProvider.imageUrl == null)
        ? AssetImage("assets/profile_icon.png")
        : NetworkImage("${this._userDataProvider.imageUrl}");
    return GestureDetector(
      onTap: () {
        changeImageBottomSheet(
          context,
          (bool changePhotoSelected) async {
            if (changePhotoSelected) {
              print("Called");
              Map<String, dynamic> imageData =
                  await selectAndGetImageData(context);
              if (imageData != null) {
                final String url =
                    "https://gardentaxi.net/Back_End/public/api/user/upload_img";
                try {
                  loadingDialog(context);
                  print("Data Shehab: ${{
                    "api_token": "${this._userDataProvider.apiToken}",
                    "acconut_img": "${imageData['original']}"
                  }}");
                  http.Response res = await http.post(url, body: {
                    "api_token": "${this._userDataProvider.apiToken}",
                    "acconut_img": "${imageData['original']}"
                  });
                  if (res.statusCode == 200) {
                    print("Done : ${res.body}");
                    Map<String, dynamic> data = json.decode(res.body);
                    this._userDataProvider.imageUrl = data['data']['img_url'];
                    SharedPreferenceService prefs =
                        new SharedPreferenceService();
                    prefs.setUserData(this._userDataProvider.toMap());
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    exceptionDialog(context);
                  }
                } catch (e) {
                  print("Exception in Upload User Image");
                  Navigator.pop(context);
                  exceptionDialog(context);
                }
              }
              print(imageData);
            } else
              pushNavigator(context, ImageView(image));
          },
        );
      },
      child: Hero(
        tag: "image",
        child: Container(
          height: 50.0,
          width: 50.0,
          decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.cover, image: image),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 240,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }
}

class MyAccountInfo extends StatelessWidget {
  final String headText;
  final String subtext;

  const MyAccountInfo({Key key, this.headText, this.subtext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
        child: Row(
          children: <Widget>[
            Text(
              headText,
              style: headLineStyle.copyWith(fontSize: 16.0),
            ),
            Expanded(child: SizedBox()),
            Text(
              subtext,
              style: describtionStyle.copyWith(
                color: Colors.black38,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 2,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: staticGreenColor,
            ),
          ],
        ),
      ),
    );
  }
}
