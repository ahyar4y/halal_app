import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final IconData icon;
  final Color iconColor;
  final Color fillColor;
  final dynamic callback;

  const CircleButton(
      {Key key,
      @required this.text,
      @required this.textColor,
      @required this.icon,
      @required this.iconColor,
      @required this.fillColor,
      @required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 80.0,
          height: 80.0,
          child: RawMaterialButton(
            onPressed: this.callback,
            shape: CircleBorder(),
            elevation: 0,
            fillColor: this.fillColor,
            child: Icon(
              this.icon,
              color: this.iconColor,
              size: 50.0,
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          this.text,
          style: TextStyle(
            color: this.textColor,
            fontSize: 20.0,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}