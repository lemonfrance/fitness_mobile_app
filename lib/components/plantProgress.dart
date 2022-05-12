import 'package:flutter/material.dart';
import 'package:wearable_intelligence/utils/styles.dart';
import 'package:wearable_intelligence/utils/globals.dart' as global;
import 'package:wearable_intelligence/utils/globals.dart';

class PlantProgress extends StatelessWidget {

  PlantProgress();

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 75) / 2;
    return
      new GestureDetector(
          child: new Container(
            width: width,
            height: width * 1.1,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/plantdesign.png'),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5,
                  offset: Offset(3, 3), // changes position of shadow
                ),
              ],
            ),
          ),
      );
  }
}
