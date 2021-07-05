import 'package:flutter/material.dart';
import 'package:wearable_intelligence/components/drawer.dart';

import '../styles.dart';

class Vitals extends StatefulWidget {
  Vitals({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _VitalsState createState() => _VitalsState();
}

class _VitalsState extends State<Vitals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.theme.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colours.darkBlue,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colours.darkBlue,
        ),
        elevation: 0,
        backgroundColor: AppTheme.theme.backgroundColor,
        foregroundColor: Colours.darkBlue,
      ),
      drawer: AppDrawer('Progress'),
      body: Center(),
    );
  }
}
