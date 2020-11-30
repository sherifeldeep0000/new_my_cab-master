import 'package:flutter/material.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constant_styles/styles.dart';

class PromoCodeView extends StatefulWidget {
  @override
  _PromoCodeViewState createState() => _PromoCodeViewState();
}

class _PromoCodeViewState extends State<PromoCodeView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Card(
          elevation: 16,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                color: Theme.of(context).dividerColor.withOpacity(0.03),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('   Promo Code'),
                              style: describtionStyle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.close),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).disabledColor,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(38)),
                    border: Border.all(
                        color: Theme.of(context).dividerColor, width: 0.6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Container(
                      height: 48,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.loyalty,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextField(
                              // controller: emailController,
                              maxLines: 1,

                              cursorColor: staticGreenColor,
                              decoration: InputDecoration(
                                errorText: null,
                                border: InputBorder.none,
                                hintText:
                                    AppLocalizations.of('Input promo code'),
                                hintStyle: TextStyle(color: Colors.black38),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: staticGreenColor,
                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      highlightColor: Colors.transparent,
                      onTap: () {},
                      child: Center(
                        child: Text(
                          AppLocalizations.of('Apply'),
                          style: buttonsText,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ),
      ],
    );
  }
}
