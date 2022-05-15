// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:wearable_intelligence/utils/styles.dart';


class rewardsPage extends StatefulWidget {
  rewardsPage();

  @override
  State<rewardsPage> createState() => _rewardsPageState();
}

class _rewardsPageState extends State<rewardsPage> {
  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 75) / 2;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('My Rewards'),
      ),
      body: new Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50, right: 30, left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Divider(
                    height: 10,
                    color: Colors.transparent,
                  ),
                  Text(
                    "Awesome Work!",
                    style: AppTheme.theme.textTheme.headline2!.copyWith(
                        color: Colours.black, fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    height: 50,
                    color: Colors.transparent,
                  ),
                  Container(
                    width: width,
                    height: width * 1.1,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage('assets/images/plantdesign.png'),
                      ),
                    ),
                  ),
                  Divider(
                    height: 80,
                    color: Colors.transparent,
                  ),
                  Text(
                    "_ solar orbs left to collect!",
                    style: AppTheme.theme.textTheme.headline4!
                        .copyWith(color: Colours.black),
                  ),
                  Divider(
                    height: 60,
                    color: Colors.transparent,
                  ),
                  Container(
                      child: Row(
                    children: List.generate(
                        3,
                        (index) => Expanded(
                            child: Image.asset('assets/images/unfilledorb.png',
                                height: 80, width: 80))),
                  )),
                  Divider(
                    height: 10,
                    color: Colors.transparent,
                  ),
                  Container(
                      child: Row(
                    children: List.generate(
                        3,
                        (index) => Expanded(
                            child: Image.asset('assets/images/unfilledorb.png',
                                height: 80, width: 80))),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
