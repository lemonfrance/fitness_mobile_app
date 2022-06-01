import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wearable_intelligence/components/progressCircle.dart';
import 'package:wearable_intelligence/utils/styles.dart';

class ProgressTile extends StatelessWidget {
  String measureUnit;
  String icon;
  int data;
  bool hasIndicator = true;
  bool improved = true;
  double _percentage=0.0;

  ProgressTile(this.measureUnit, this.icon, this.data, this.hasIndicator, this.improved, this._percentage);

  @override
  Widget build(BuildContext context) {
    double percentage = 100;
    ProgressCircle progressIndicator = ProgressCircle(_percentage, improved ? Colors.green : Colors.pink);

    double width = MediaQuery.of(context).size.width;
    Container progressTile = Container(
      padding: hasIndicator ? EdgeInsets.fromLTRB(width * 0.03, width * 0.03, 0, width * 0.03 ) : EdgeInsets.fromLTRB(width * 0.03, width * 0.05 , 0, width * 0.01 ),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: Colors.transparent,
            height: width*0.1,
            width: width*0.1,
            child: Stack(
              children: [
                hasIndicator
                    ? Align(alignment:Alignment.center, child: progressIndicator)
                    : Divider(height:0,color:Colors.transparent),
                Align(
                    alignment:Alignment.center,
                    child: SvgPicture.asset(icon,
                        width: hasIndicator ? width*0.06 : width*0.07,
                        height: hasIndicator ? width*0.06 : width*0.07,
                        color: Colors.purple)
                )
              ]
            )
          ),
          VerticalDivider(width:15,color:Colors.transparent),
          Text(
            data.toString()+" "+measureUnit,
            style: TextStyle(fontSize: 20, color: Colours.darkBlue),
            textAlign: TextAlign.center,
          )
        ]
      )
    );

    return hasIndicator
    ? new Tooltip(
        message:_percentage.toString() + "% progress",
        triggerMode: TooltipTriggerMode.tap,
        child: progressTile
      )
    : progressTile;
  }
}
