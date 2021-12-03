import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/screens/splash_screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Lemon Jelly"
      ),
      home: SplashScreen(),
    );
  }
}

