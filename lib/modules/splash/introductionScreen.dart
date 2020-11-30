import 'dart:async';
import 'package:flutter/material.dart';

import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/routes.dart';
import 'package:my_cab/constant_styles/styles.dart';
import 'package:my_cab/modules/splash/nice_introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  var pageController = PageController(initialPage: 0);
  var pageViewModelData = List<PageViewData>();

  Timer sliderTimer;
  var currentShowIndex = 0;
  void _getPrefrences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginToken = prefs.getString("userToken");
    var signUpToken = prefs.getString("registerToken");
    if (loginToken != null || signUpToken != null) {
      Navigator.pushNamedAndRemoveUntil(context, Routes.HOME, (route) => false);
    }
  }

  @override
  void initState() {
    _getPrefrences();
    pageViewModelData.add(PageViewData(
      titleText: AppLocalizations.of('Confirm your Driver'),
      subText: AppLocalizations.of(
          'Huge drivers network helps you find a\ncomfortable and cheap ride'),
      assetsImage: 'assets/splash/intro1.PNG',
    ));

    pageViewModelData.add(PageViewData(
      titleText: AppLocalizations.of('Request Ride'),
      subText: AppLocalizations.of(
          'Request a ride gets picked up by a\nnearby community driver'),
      assetsImage: 'assets/splash/intro2.PNG',
    ));

    pageViewModelData.add(PageViewData(
      titleText: AppLocalizations.of('Track your ride'),
      subText: AppLocalizations.of(
          'Know your driver in advance and be\nable to view current location in real-time\non the map'),
      assetsImage: 'assets/splash/intro3.PNG',
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                pageSnapping: true,
                onPageChanged: (index) {
                  currentShowIndex = index;
                },
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  PagePopup(imageData: pageViewModelData[0]),
                  PagePopup(imageData: pageViewModelData[1]),
                  PagePopup(imageData: pageViewModelData[2]),
                ],
              ),
            ),
            SmoothPageIndicator(
              effect: ExpandingDotsEffect(
                  activeDotColor: staticGreenColor, dotHeight: 10.0),
              controller: pageController,
              count: 3,
            ),
            Padding(
              padding: EdgeInsets.only(left: 48, right: 48, bottom: 8, top: 32),
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
                  color: staticGreenColor,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NiceIntroductionScreen()),
                      );
                    },
                    child: Center(
                      child: Text(
                        AppLocalizations.of('Get Started!'),
                        style: buttonsText,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16 + MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }
}

class PagePopup extends StatelessWidget {
  final PageViewData imageData;

  const PagePopup({Key key, this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14, left: 14),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 120,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    imageData.assetsImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: <Widget>[
                Text(
                  imageData.titleText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  imageData.subText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subhead,
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}

class PageViewData {
  final String titleText;
  final String subText;
  final String assetsImage;

  PageViewData({this.titleText, this.subText, this.assetsImage});
}
