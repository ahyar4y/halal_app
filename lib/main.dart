import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halal_app/services/db.dart';
import 'package:halal_app/services/auth.dart';
import 'package:halal_app/screens/detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:halal_app/screens/home/home.dart';
import 'package:halal_app/models/imageModel.dart';
import 'package:halal_app/models/ingredientModel.dart';

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
        ChangeNotifierProvider<ImageModel>(create: (_) => ImageModel()),
        StreamProvider<List<IngredientModel>>.value(
            value: DatabaseService().ingredients),
        StreamProvider<User>.value(
          value: AuthService().user,
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          // brightness: Brightness.dark,
          primaryColor: Color(0xFF02c39a),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/detail': (context) => Detail(),
        },
      ),
    );
  }
}
