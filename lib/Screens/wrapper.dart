import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wearable_intelligence/Screens/Home/home.dart';
import 'package:wearable_intelligence/Screens/authenticate/authenticate.dart';
import 'package:wearable_intelligence/models/user.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<Users>(context);

    // return either home or authenticate widget
    if(user == null){
      return Authenticate();
    } else {
      return Home();
    }
  }
}
