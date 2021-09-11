import 'package:flutter/material.dart';
import 'package:wearable_intelligence/components/heartrateGraph.dart';
import 'package:wearable_intelligence/utils/styles.dart';
import 'package:wearable_intelligence/wearableIntelligence.dart';

class PostExercise extends StatefulWidget {
  PostExercise(this.title) : super();

  final String title;

  @override
  _PostExerciseState createState() => _PostExerciseState();
}

class _PostExerciseState extends State<PostExercise> {
  double _difficulty = 0.0;
  double _pain = 0.0;

  Widget slider(String title, bool difficulty) {
    return Container(
      width: double.infinity,
      height: 150,
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
            title,
            style: TextStyle(color: Colours.black, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: difficulty ? _difficulty : _pain,
            min: 0,
            max: 10,
            divisions: 10,
            label: difficulty ? _difficulty.toString() : _pain.toString(),
            activeColor: Colours.highlight,
            inactiveColor: Colours.white,
            onChanged: (double value) {
              setState(() {
                if (difficulty) {
                  _difficulty = value;
                } else {
                  _pain = value;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.theme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: EdgeInsets.only(left: 30),
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colours.grey,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: AppTheme.theme.backgroundColor,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: height * 0.75,
            child: ListView(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              children: [
                Text("Workout Over", style: TextStyle(fontWeight: FontWeight.bold, color: Colours.black, fontSize: 24)),
                Container(height: 20),
                HeartrateGraph(), // Can we have a 30min window?
                Container(height: 20),
                slider("How hard did you find the exercise?", true),
                Container(height: 20),
                slider("How much pain did you have?", false),
              ],
            ),
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
              onPrimary: Colours.white,
              minimumSize: Size(width - 50, 45),
              shape: StadiumBorder(),
              elevation: 10,
            ),
          ),
        ],
      ),
    );
  }
}
