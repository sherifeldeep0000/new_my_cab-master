import 'dart:io';
import 'package:my_cab/controllers/FCM_service.dart';
import 'package:my_cab/controllers/chat_provider.dart';
import 'package:my_cab/controllers/user_data_provider.dart';
import 'package:my_cab/helper_providers/client_providers/client_info_provider.dart';
import 'package:my_cab/helper_providers/maps/destination_info.dart';
import 'package:my_cab/helper_providers/maps/my_location_info.dart';
import 'package:my_cab/models/notification_model.dart';
import 'package:my_cab/modules/auth/login_screen.dart';
import 'package:my_cab/modules/home/requset_view.dart';
import 'package:my_cab/modules/splash/language_screen.dart';
import 'package:my_cab/test.dart';
import 'package:my_cab/widgets/dialog.dart';
import 'package:provider/provider.dart';
import 'Language/appLocalizations.dart';
import 'constance/constance.dart' as constance;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_cab/constance/themes.dart';
import 'package:my_cab/modules/home/home_screen.dart';
import 'package:my_cab/modules/splash/SplashScreen.dart';
import 'package:my_cab/modules/splash/introductionScreen.dart';
import 'package:my_cab/constance/global.dart' as globals;
import 'package:my_cab/constance/routes.dart';
import 'controllers/current_trip_provider.dart';
import 'helper_providers/maps/directionStorage.dart';
import 'modules/home/insideAndOutSide.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(new MyApp()));
}

class MyApp extends StatefulWidget {
  static changeTheme(BuildContext context) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.changeTheme();
  }

  static setCustomLanguage(BuildContext context, String languageCode) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLanguage(languageCode);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PushNotificationsServices _fcm;

  Key key = new UniqueKey();

  void changeTheme() {
    this.setState(() {
      globals.isLight = !globals.isLight;
    });
  }

  String locale = "en";

  setLanguage(String languageCode) {
    setState(() {
      locale = languageCode;
      constance.locale = languageCode;
    });
  }

  @override
  void initState() {
    this._fcm = new PushNotificationsServices();
    this._fcm.registerOnFirebaseAndGetToken();

    super.initState();
  }

  bool _fcmInit = false;
  final navigatorKey = GlobalKey<NavigatorState>();

  void show(NotificationModel model) {
    final context = navigatorKey.currentState.overlay.context;

    showNotificationAlert(context, model);
  }

  @override
  didChangeDependencies() {
    if (!this._fcmInit) {
      this._fcmInit = true;
      this._fcm.initAndGetMessage(show);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    constance.locale = locale;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black26,
      statusBarIconBrightness:
          globals.isLight ? Brightness.dark : Brightness.light,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: CoustomTheme.getThemeData().cardColor,
      systemNavigationBarDividerColor:
          CoustomTheme.getThemeData().disabledColor,
      systemNavigationBarIconBrightness:
          globals.isLight ? Brightness.dark : Brightness.light,
    ));
    return Container(
      key: key,
      color: CoustomTheme.getThemeData().backgroundColor,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CoustomTheme.getThemeData().backgroundColor,
              CoustomTheme.getThemeData().backgroundColor,
              CoustomTheme.getThemeData().backgroundColor.withOpacity(0.8),
              CoustomTheme.getThemeData().backgroundColor.withOpacity(0.7)
            ],
          ),
        ),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => MyLocationInfo()),
            ChangeNotifierProvider(create: (context) => DstinationInfo()),
            ChangeNotifierProvider(create: (context) => DirectionStorage()),
            ChangeNotifierProvider(create: (context) => ClientInfoProvider()),
            ChangeNotifierProvider(create: (context) => UserDataProvider()),
            ChangeNotifierProvider(create: (context) => ChatProvider()),
            ChangeNotifierProvider(create: (context) => CurrentTripProvider()),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            //builder: DevicePreview.appBuilder,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en'), // English
              const Locale('ar'), // Arabic
            ],
            debugShowCheckedModeBanner: false,
            title: AppLocalizations.of('My Cab'),
            routes: routes,
            theme: CoustomTheme.getThemeData(),
            builder: (BuildContext context, Widget child) {
              return Builder(
                builder: (BuildContext context) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: child,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  var routes = <String, WidgetBuilder>{
    Routes.SPLASH: (BuildContext context) => SplashScreen(),
    Routes.INTRODUCTION: (BuildContext context) => IntroductionScreen(),
    Routes.HOME: (BuildContext context) => HomeScreen(),
    Routes.Languages: (context) => LanguageScreen(),
    Routes.SelectDistrict: (context) => InsideAndOutSide(),
  };
}

// keytool -list -v -keystore "C:\Users\Shehab\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
// SHA1: 59:8B:9E:90:F0:B6:C3:84:E2:14:50:3F:E8:81:49:16:C1:DA:C9:C4
// SHA256: 62:6D:CC:1B:76:6C:7F:7D:BC:DB:D4:12:83:2C:4B:35:0B:1F:9D:A0:AC:7B:28:8A:7F:48:B0:86:AB:34:70:B2


//I/flutter ( 3314): On Messageasd : {notification: {title: Garden taxi New Tripe Approved, body: {"massage":"the driver mahmoud has approved your tripe and he on his way to you"}}, data: {id: 278, name: mahmoud, phone: 01000621823}}
// I/flutter ( 3314): Notification Model : {notification: {title: Garden taxi New Tripe Approved, body: {"massage":"the driver mahmoud has approved your tripe and he on his way to you"}}, data: {id: 278, name: mahmoud, phone: 01000621823}}
// I/flutter ( 3314): ////////////////////////
