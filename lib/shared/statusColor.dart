import 'package:flutter/material.dart';

Color statusColor(String str) {
    if (str == 'halal')
      return Colors.green;
    else if (str == 'haram')
      return Colors.red;
    else if (str == 'doubtful')
      return Colors.yellow[700];
    else
      return Colors.black;
  }