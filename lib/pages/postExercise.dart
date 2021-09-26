import 'package:flutter/material.dart';
import 'package:wearable_intelligence/components/heartrateGraph.dart';
import 'package:wearable_intelligence/utils/styles.dart';
import 'package:wearable_intelligence/wearableIntelligence.dart';

class PostExercise extends StatefulWidget {
  PostExercise(this.title) : super();

  final String title;
  bool chestPain = false;
  bool coldSweats = false;

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

  Widget feedbackTile() {
    double width = (MediaQuery.of(context).size.width - 50);
    return Container(
      width: width,
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
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "You spent most of your workout in the desired heart rate zone",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Container(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 60,
                  width: (width - 80) / 2,
                  decoration: BoxDecoration(
                    color: Colours.highlight,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        offset: Offset(3, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colours.white,
                      ),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "Avg 98bpm",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colours.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  width: (width - 80) / 2,
                  decoration: BoxDecoration(
                    color: Colours.highlight,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        offset: Offset(3, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colours.white,
                      ),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "Max 108bpm",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colours.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.theme.backgroundColor,
      body: Stack(
        children: [
          Container(
            height: width / 2,
            decoration: BoxDecoration(
              color: Colours.darkBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: height,
            child: ListView(
              padding: EdgeInsets.fromLTRB(40, 0, 30, 0),
              children: [
                Container(height: 40),
                Text("Workout Complete, Great Work!", style: TextStyle(fontWeight: FontWeight.bold, color: Colours.white, fontSize: 24)),
                Container(height: 20),
                feedbackTile(),
                Container(height: 20),
                HeartrateGraph(true), // Can we have a 30min window?
                Container(height: 20),
                slider("How hard did you find the exercise?", true),
                Container(height: 20),
                slider("How much pain did you have?", false),
                Container(height: 20),
                Text("Select what is applicable", style: TextStyle(fontWeight: FontWeight.bold, color: Colours.black, fontSize: 18)),
                Container(height: 10),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      widget.chestPain = !widget.chestPain;
                    });
                  },
                  minWidth: double.infinity,
                  height: 60,
                  elevation: 10,
                  shape: StadiumBorder(),
                  color: widget.chestPain ? Colours.highlight : Colors.white,
                  child: Text(
                    "Did you experience any chest pain?",
                    style: TextStyle(color: widget.chestPain ? Colors.white : Colours.black),
                  ),
                ),
                Container(height: 10),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      widget.coldSweats = !widget.coldSweats;
                    });
                  },
                  minWidth: double.infinity,
                  height: 60,
                  elevation: 10,
                  shape: StadiumBorder(),
                  color: widget.coldSweats ? Colours.highlight : Colors.white,
                  child: Text(
                    "Did you experience any cold sweats?",
                    style: TextStyle(color: widget.coldSweats ? Colors.white : Colours.black),
                  ),
                ),
                Container(height: 100),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WearableIntelligence("Wearable Intelligence")),
                  );
                },
                child: Text("Finished", style: TextStyle(fontWeight: FontWeight.bold, color: Colours.white, fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  primary: Colours.highlight,
                  minimumSize: Size(width - 100, 45),
                  shape: StadiumBorder(),
                  elevation: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
