import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halal_app/screens/home.dart';
import 'package:halal_app/screens/detail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:halal_app/models/imageModel.dart';
import 'package:halal_app/services/dbService.dart';
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
        Provider<ImageModel>(create: (_) => ImageModel()),
        StreamProvider<List<IngredientModel>>.value(value: DatabaseService().ingredients),
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
