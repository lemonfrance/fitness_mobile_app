import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wearable_intelligence/utils/styles.dart';

class ProgressTile extends StatelessWidget {
  String measureUnit;
  String icon;
  int data;

  ProgressTile(this.measureUnit, this.icon, this.data);

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 75) / 2;
    return Container(
      width: width,
      height: width * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(icon, width:width*0.12, height:width*0.12, color: Colors.pink),
          VerticalDivider(width:15,color:Colors.transparent),
          Text(
            data.toString()+" "+measureUnit,
            style: TextStyle(fontSize: 20, color: Colours.darkBlue),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
