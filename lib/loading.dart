import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wearable_intelligence/styles.dart';

class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.white,
      child: Center(
        child: SpinKitCircle(
          color: Colours.darkBlue,
          size: 50.0,
        ),
      ),
    );
  }
}