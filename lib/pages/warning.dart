import 'dart:core';

import 'package:flutter/material.dart';
import 'package:wearable_intelligence/utils/styles.dart';

import '../wearableIntelligence.dart';

class Warning extends StatefulWidget {
  String message;
  // ignore: prefer_const_constructors_in_immutables
  Warning(this.message) : super();

  @override
  _Warning createState() => _Warning();
}

class _Warning extends State<Warning> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colours.white,
      body: Container(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: width - 50,
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), color: Colours.highlight),
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 80.0,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: 250,
              width: width - 50,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.message,
                    style: TextStyle(color: Colours.black, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WearableIntelligence("Wearable Intelligence")),
                      );
                    },
                    child: Text("Finished", style: TextStyle(fontWeight: FontWeight.bold, color: Colours.white, fontSize: 24)),
                    style: ElevatedButton.styleFrom(
                      primary: Colours.highlight,
                      minimumSize: Size(150, 45),
                      shape: StadiumBorder(),
                      elevation: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
