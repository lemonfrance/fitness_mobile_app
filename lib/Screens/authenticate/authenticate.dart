import 'package:flutter/material.dart';
import 'package:wearable_intelligence/Screens/authenticate/register.dart';
import 'package:wearable_intelligence/Screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: showSignIn ? SignIn(toggleView: toggleView) : Register(toggleView: toggleView),
    );
  }
}
