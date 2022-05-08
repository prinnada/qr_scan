import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'qr_code.dart';
import 'asset_detail.dart';
import 'welcome.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: WelcomePage(),
  ));
}
