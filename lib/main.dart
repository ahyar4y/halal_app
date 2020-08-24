import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halal_app/models/imageData.dart';
import 'package:halal_app/screens/home.dart';
import 'package:halal_app/screens/detail.dart';

void main() {
  runApp(HalalApp());
}

class HalalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<ImageData>(
      create: (context) => ImageData(),
      child: MaterialApp(
        theme: ThemeData(
          // brightness: Brightness.dark,
          primaryColor: Color(0xFF02c39a),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/' : (context) => Home(),
          '/detail' : (context) => Detail(),
        },
      ),
    );
  }
}
