import 'package:flutter/material.dart';
import 'package:wearable_intelligence/pages/rewardsPage.dart';

class PlantProgress extends StatelessWidget {
  PlantProgress();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return new GestureDetector(
      child:Image.asset('assets/images/plantdesign.png',height:width*0.5,width:width*0.4),
      onTap: () => (Navigator.push(context,
        MaterialPageRoute(builder: (context) => rewardsPage()))
    ));
  }
}
