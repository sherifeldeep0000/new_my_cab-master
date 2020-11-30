import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab/constance/constance.dart';
import 'package:my_cab/constant_styles/styles.dart';

class CardWidget extends StatelessWidget {
  final String fromAddress;
  final String toAddress;
  final String price;
  final String status;
  final Color statusColor;

  const CardWidget(
      {Key key,
      this.fromAddress,
      this.toAddress,
      this.price,
      this.status,
      this.statusColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: staticGreenColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        ConstanceData.startPin,
                        height: 32,
                        width: 32,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          fromAddress,
                          style: describtionStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 22,
                  ),
                  child: Container(
                    height: 16,
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        ConstanceData.endPin,
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          toAddress,
                          style: describtionStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 8, bottom: 8, top: 10.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: Text("LE"),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    price,
                    style: describtionStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      status,
                      style: describtionStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: staticGreenColor,
                    size: 16,
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
