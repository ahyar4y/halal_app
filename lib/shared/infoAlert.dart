import 'package:flutter/material.dart';

class InfoAlert extends StatelessWidget {
  final String alert;

  const InfoAlert({
    Key key,
    @required this.alert,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Information'),
      content: SingleChildScrollView(
        child: Text(this.alert),
      ),
      actions: [
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
