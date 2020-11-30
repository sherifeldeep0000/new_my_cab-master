import 'package:flutter/material.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/constance.dart';
import 'package:my_cab/constant_styles/styles.dart';
import 'package:my_cab/helper_providers/maps/my_location_info.dart';
import 'package:my_cab/modules/home/MapSelectionView.dart';
import 'package:provider/provider.dart';

class AddressSelectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var locationData = Provider.of<MyLocationInfo>(context);
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Card(
            elevation: 16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 100.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(left: 8, right: 8, bottom: 10.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Image.asset(ConstanceData.startPin),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 4, right: 8, top: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('Pickup'),
                                    style: describtionStyle.copyWith(
                                      color: Colors.black45,
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.8,
                                    margin: EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      locationData.addressName ?? "Loading",
                                      style: describtionStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 2.0),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapSelectionView(
                            lat: locationData.myLat,
                            long: locationData.myLong,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Image.asset(ConstanceData.endPin),
                        ),
                        SizedBox(width: 20.0),
                        Text(
                          AppLocalizations.of("Delivery of Place"),
                          style: headLineStyle,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
