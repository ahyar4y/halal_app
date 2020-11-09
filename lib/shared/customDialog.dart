import 'package:flutter/material.dart';


class CustomDialog extends StatelessWidget {
  final String title;
  final Widget child;
  const CustomDialog({Key key, @required this.title, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Builder(builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          height: 300.0,
          child: child,
        );
      }),
    );
  }
}