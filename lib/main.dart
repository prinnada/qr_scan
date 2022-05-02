import 'package:flutter/material.dart';
import 'qr_code.dart';
import 'asset_detail.dart';
import 'welcome.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: WelcomePage(),
  ));
}
