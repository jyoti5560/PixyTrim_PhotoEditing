import 'package:flutter/material.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/screens/login_screen/login_screen_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          MainBackgroundWidget(),

          SafeArea(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  welcomeText(),

                  socialLogin()
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}
