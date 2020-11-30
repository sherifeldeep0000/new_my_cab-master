import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/themes.dart';
import 'package:my_cab/constant_styles/styles.dart';
import 'package:my_cab/controllers/user_data_provider.dart';
import 'package:my_cab/models/history_model.dart';
import 'package:my_cab/modules/rating/rating_screen.dart';
import 'package:my_cab/modules/widgets/cardWidget.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static HistoryModel _model;
  UserDataProvider _userDataProvider;
  bool _providerInit = false;

  final String _url = "https://gardentaxi.net/Back_End/public/api/user/tripe";

  Future<void> _getTrips() async {
    print("Get Trips Called : ${{
      "api_token": "${this._userDataProvider.apiToken}"
    }}");
    http.Response res = await http.post("${this._url}",
        body: {"api_token": "${this._userDataProvider.apiToken}"});
    Map<String, dynamic> data =
        Map<String, dynamic>.from(json.decode(res.body));

    setState(() => _model = new HistoryModel.fromMap(data));
  }

  @override
  void didChangeDependencies() {
    this._userDataProvider = Provider.of<UserDataProvider>(context);
    if (!this._providerInit) {
      this._providerInit = true;
      if (_model == null) this._getTrips();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColors,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.blue,
            ),
            Text(
              "${AppLocalizations.of("History")}",
              style: headLineStyle.copyWith(
                  color: Colors.black, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          Image.asset(
            "assets/images/setting_effect.PNG",
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: (_model == null)
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              itemCount: _model.trips.length,
              itemBuilder: (BuildContext context, int index) {
                return CardWidget(
                  fromAddress:
                      AppLocalizations.of('${_model.trips[index].from}'),
                  toAddress: AppLocalizations.of('${_model.trips[index].to}'),
                  price: "Le ${_model.trips[index].price}",
                  status: AppLocalizations.of('Completed'),
                  statusColor: HexColor("#3638FE"),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
            ),
    );
  }

  gotorating() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RatingScreen(),
      ),
    );
  }
}
