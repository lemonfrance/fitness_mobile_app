import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wearable_intelligence/Services/database.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/utils/globals.dart' as global;

import '../loading.dart';
import '../utils/styles.dart';

Future getDailyStats() async {
  await FitBitService().getDailyGoals();
  await FitBitService().getHeartRates();
}

class MyHomePage extends StatefulWidget {
  MyHomePage() : super();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  bool loading = false;
  late double height;
  late double width;

  Widget logInScreen() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/runner.png'),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            child: Column(
              children: [
                Text('Welcome', style: TextStyle(fontSize: 60, color: Colours.darkBlue, fontWeight: FontWeight.w700)),
                Text('Log in to Fitbit to get started', style: TextStyle(fontSize: 20, color: Colours.darkBlue, fontWeight: FontWeight.w300)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 60),
              child: ElevatedButton(
                onPressed: () async {
                  setState(() => loading = true);

                  await FitBitService().getCode();
                  await FitBitService().getAuthToken(global.accessToken!);

                  global.fitBitAccount = await FitBitService().getFitBitData(global.authToken, mAuth.currentUser!.uid);
                  global.name = await DatabaseService(uid: mAuth.currentUser!.uid).getFirstName();
                  await FitBitService().getDailyGoals();
                  await FitBitService().getHeartRates();

                  setState(() => {loading = false});
                },
                child: Text(
                  "Log into Fitbit",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colours.white, fontSize: 24),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colours.highlight,
                  onPrimary: Colours.white,
                  minimumSize: Size(MediaQuery.of(context).size.width, 60),
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

  Widget typeTile(bool selected) {
    return Container(
      height: (width - 120) / 3,
      width: (width - 120) / 4,
      decoration: BoxDecoration(
        color: selected ? Colours.darkBlue : Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            blurRadius: 4,
            offset: Offset(4, 4), // Shadow position
          ),
        ],
      ),
    );
  }

  Widget scheduleTile() {
    return Container(
      height: 80,
      width: (width - 60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            blurRadius: 4,
            offset: Offset(4, 4), // Shadow position
          ),
        ],
      ),
    );
  }

  Widget homeScreen() {
    return loading
        ? Loading()
        : Container(
            width: double.infinity,
            height: height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: (4.5 * height) / 9,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40)),
                          child: Container(
                            height: height / 2.5,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.01, 0.5],
                                colors: [
                                  Color.fromRGBO(252, 105, 140, 1),
                                  Color.fromRGBO(255, 148, 112, 1),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 130, left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome ${global.name}",
                                style: AppTheme.theme.textTheme.headline5!.copyWith(color: Colours.white),
                              ),
                              Divider(
                                height: 10,
                                color: Colors.transparent,
                              ),
                              Text(
                                "Lets get moving!",
                                style: AppTheme.theme.textTheme.headline2!.copyWith(color: Colours.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: height / 4,
                            width: width - 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                  blurRadius: 4,
                                  offset: Offset(4, 4), // Shadow position
                                ),
                              ],
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20, bottom: 20),
                                child: Text(
                                  "Today: 1.5km Walking",
                                  style: AppTheme.theme.textTheme.headline2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 70, left: 20),
                              child: SvgPicture.asset(
                                'assets/images/walking.svg',
                                width: width - 70,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 30),
                    child: Text(
                      "Preferred Forms of Exercise",
                      style: AppTheme.theme.textTheme.headline2!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        typeTile(true),
                        typeTile(false),
                        typeTile(true),
                        typeTile(true),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 30),
                    child: Text(
                      "Schedule",
                      style: AppTheme.theme.textTheme.headline2!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Divider(
                          height: 10,
                          color: Colors.transparent,
                        ),
                        scheduleTile(),
                        Divider(
                          height: 10,
                          color: Colors.transparent,
                        ),
                        scheduleTile(),
                        Divider(
                          height: 10,
                          color: Colors.transparent,
                        ),
                        scheduleTile(),
                        Divider(
                          height: 10,
                          color: Colors.transparent,
                        ),
                        scheduleTile(),
                        Divider(
                          height: 10,
                          color: Colors.transparent,
                        ),
                        scheduleTile(),
                        Divider(
                          height: 10,
                          color: Colors.transparent,
                        ),
                        scheduleTile(),
                        Divider(
                          height: 10,
                          color: Colors.transparent,
                        ),
                        scheduleTile(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppTheme.theme.backgroundColor,
      body: !(global.fitBitAccount == true) ? logInScreen() : homeScreen(),
    );
  }
}
