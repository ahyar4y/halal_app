import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:halal_app/services/dbservice.dart';
import 'package:provider/provider.dart';
import 'package:halal_app/models/imageData.dart';
import 'package:halal_app/screens/home.dart';
import 'package:halal_app/screens/detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HalalApp());
}

class HalalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ImageData>(create: (_) => ImageData()),
        StreamProvider<List<DBIngredient>>.value(value: DatabaseService().ingredients),
        Provider<DatabaseService>(create: (_) => DatabaseService()),
      ],
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
