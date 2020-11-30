import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Widget topWidget;
  final VoidCallback onClick;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.topWidget,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: (topWidget != null ? 50 : 0)),
          child: Card(
            color: Theme.of(context).backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 24,
            child: Padding(
              padding: EdgeInsets.only(
                top: (topWidget != null ? 50 : 0),
                bottom: 12,
                left: 16,
                right: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // To make the card compact
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.0),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        try {
                          onClick();
                        } catch (e) {}
                        Navigator.of(context).pop(); // To close the dialog
                      },
                      child: Text(buttonText),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        topWidget != null
            ? Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      elevation: 6,
                      child: ClipRRect(
                        borderRadius: new BorderRadius.circular(50.0),
                        child: topWidget,
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
