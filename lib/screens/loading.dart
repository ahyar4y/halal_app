import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: SpinKitFadingCircle(
          size: 80.0,
          color: Color(0xFF02c39a),
        ),
      ),
    );
  }
}