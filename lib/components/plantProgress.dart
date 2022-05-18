import 'package:flutter/material.dart';
import 'package:wearable_intelligence/pages/rewardsPage.dart';

class PlantProgress extends StatelessWidget {
  PlantProgress();

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 75) / 2;
    return new
      IconButton(
        icon: Image.asset('assets/images/plantdesign.png'),
        iconSize: width,
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(
          builder: (context) => rewardsPage()));
        }
      );
    }
}
