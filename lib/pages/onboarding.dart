import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wearable_intelligence/Services/database.dart';
import 'package:wearable_intelligence/utils/onboardingQuestions.dart';
import 'package:wearable_intelligence/utils/styles.dart';
import 'package:wearable_intelligence/wearableIntelligence.dart';
import 'package:wearable_intelligence/utils/globals.dart' as globals;

Future setLevel(int level) async {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  await DatabaseService(uid: mAuth.currentUser!.uid).setLevel(level);
}

class Onboarding extends StatefulWidget {
  Onboarding() : super();

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int _widgetIndex = 0;
  final ScrollController scrollController = ScrollController();

  // List of level 1 questions
  List levelOneQuestions = [
    {"question": walkBlock, "selected": false, "type": "expandedPain", "pain": 0.0},
    {"question": climbStairs, "selected": false, "type": "expandedPain", "pain": 0.0},
    {"question": preferredExercise, "selected": false, "type": "exercise"},
  ];

  // List of level 2 questions
  List levelTwoQuestions = [
    {"question": runBlock, "selected": false, "type": "expandedPain", "pain": 0.0}
  ];

  // List of level 3 questions
  List levelThreeQuestions = [
    {"question": runDistance, "selected": false, "type": "expandedDistance", "distance": 0.0},
    {"question": swimDistance, "selected": false, "type": "expandedDistance", "distance": 0.0},
    {"question": bikeDistance, "selected": false, "type": "expandedDistance", "distance": 0.0},
  ];

  // This is used for boolean answers
  Widget boolButton(String question, int index, List list) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: MaterialButton(
        onPressed: () {
          setState(() {
            list[index]["selected"] = !list[index]["selected"];
          });
        },
        minWidth: double.infinity,
        height: 60,
        elevation: 10,
        shape: StadiumBorder(),
        color: list[index]["selected"] ? Colours.darkBlue : Colours.white,
        child: Text(
          question,
          style: TextStyle(color: list[index]["selected"] ? Colours.white : Colours.black),
        ),
      ),
    );
  }

  // This button is used when we would like to know a pain tolerance or distance.
  // When selected, the user will be prompted with a slider
  Widget expandingButton(String question, int index, List list, bool painQuestion) {
    return list[index]["selected"]
        ? Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: MaterialButton(
              onPressed: () {
                setState(() {
                  list[index]["selected"] = !list[index]["selected"];
                });
              },
              minWidth: double.infinity,
              height: 150,
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              color: list[index]["selected"] ? Colours.darkBlue : Colours.white,
              child: Container(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      question,
                      style: TextStyle(color: Colours.white, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        painQuestion
                            ? Text(
                                pain,
                                style: TextStyle(color: Colours.white),
                              )
                            : Text(
                                "Distance: " + list[index]["distance"].round().toString() + "km",
                                style: TextStyle(color: Colours.white),
                              ),
                        Slider(
                          value: painQuestion ? list[index]["pain"] : list[index]["distance"],
                          min: 0,
                          max: 10,
                          divisions: 10,
                          activeColor: Colours.white,
                          inactiveColor: Colours.white,
                          label: painQuestion ? list[index]["pain"].round().toString() : (list[index]["distance"].round().toString() + "km"),
                          onChanged: (double value) {
                            setState(() {
                              painQuestion ? list[index]["pain"] = value : list[index]["distance"] = value;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        : boolButton(question, index, list);
  }

  // This displays the types of exercises in level 1
  Widget exerciseList() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, bottom: 16),
          child: Text(
            "What are your preferred types of exercise",
            textAlign: TextAlign.start,
            style: AppTheme.theme.textTheme.headline3!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ListView.separated(
          clipBehavior: Clip.none,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: exerciseTypes.length,
          itemBuilder: (context, index) {
            return boolButton(exerciseTypes[index]["type"], index, exerciseTypes);
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }

  Widget levelOne() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListView.separated(
          clipBehavior: Clip.none,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: levelOneQuestions.length,
          itemBuilder: (context, index) {
            switch (levelOneQuestions[index]["type"]) {
              case "expandedPain":
                return expandingButton(levelOneQuestions[index]["question"], index, levelOneQuestions, true);
              case "exercise":
                return exerciseList();
              default:
                return Container();
            }
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }

  Widget levelTwo() {
    return expandingButton(levelTwoQuestions[0]["question"], 0, levelTwoQuestions, true);
  }

  Widget levelThree() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListView.separated(
          clipBehavior: Clip.none,
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: levelThreeQuestions.length,
          itemBuilder: (context, index) {
            switch (levelThreeQuestions[index]["type"]) {
              case "expandedDistance":
                return expandingButton(levelThreeQuestions[index]["question"], index, levelThreeQuestions, false);
              default:
                return Container();
            }
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool finished = false;
    return Scaffold(
      backgroundColor: AppTheme.theme.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 130,
            child: ListView(
              controller: scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 32, top: 50),
                  child: Text(
                    "Select what is applicable to you",
                    textAlign: TextAlign.start,
                    style: AppTheme.theme.textTheme.headline3!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(color: Colors.transparent),
                IndexedStack(
                  index: _widgetIndex,
                  children: [
                    levelOne(),
                    levelTwo(),
                    levelThree(),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Container(
                color: Colours.white,
                height: 130,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: MaterialButton(
                  onPressed: () {
                    scrollController.animateTo(
                      0.0,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 300),
                    );

                    setState(() {
                      switch (_widgetIndex) {
                        case 0:
                          // Make sure that they can both walk 1k and climb a flight of stairs
                          // Make sure they are not in unnecessary pain
                          if (levelOneQuestions[0]["selected"] == true &&
                              levelOneQuestions[1]["selected"] == true &&
                              levelOneQuestions[0]["pain"] < 6 &&
                              levelOneQuestions[1]["pain"] < 6) {
                            _widgetIndex = 1;
                          } else {
                            finished = true;
                            globals.level = 1;
                          }
                          break;
                        case 1:
                          if (levelTwoQuestions[0]["selected"] == true && levelTwoQuestions[0]["pain"] < 6) {
                            _widgetIndex = 2;
                          } else {
                            finished = true;
                            globals.level = 2;
                          }
                          break;
                        case 2:
                          finished = true;
                          globals.level = 3;
                          break;
                      }
                    });
                    if (finished) {
                      setLevel(globals.level);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => WearableIntelligence('Wearable Intelligence')),
                      );
                    }
                  },
                  minWidth: double.infinity,
                  height: 60,
                  elevation: 10,
                  shape: StadiumBorder(),
                  color: Colours.highlight,
                  child: Text("NEXT"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
