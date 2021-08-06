import 'package:flutter/material.dart';
import 'package:wearable_intelligence/styles.dart';

class ProgressTile extends StatelessWidget {
  String title = "";
  int? data = 0;

  ProgressTile(this.title, this.data);

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 75) / 2;
    return Container(
      width: width,
      height: width * 1.1,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            offset: Offset(3, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            data.toString(),
            style: TextStyle(fontSize: 72, color: Colours.darkBlue),
            textAlign: TextAlign.center,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colours.darkBlue,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
