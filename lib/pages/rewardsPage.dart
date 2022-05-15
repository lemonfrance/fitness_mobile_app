// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:wearable_intelligence/utils/styles.dart';
import 'package:wearable_intelligence/utils/globals.dart';


class rewardsPage extends StatefulWidget {
  rewardsPage();

  @override
  State<rewardsPage> createState() => _rewardsPageState();
}

class _rewardsPageState extends State<rewardsPage> {
  int solarOrbsPerLevel=10; //Solar orbs you need to collect per level

  //what if solar orbs obtained exceed solarOrbsPerLevel?

  List<Widget> generateOrbsRows(){
    int numOfColumns = 5;
    int numOfRows = (solarOrbsPerLevel/numOfColumns).floor();
    int orbCounter = solarOrbsObtained;
    int filledOrbNum=0;

    List<Widget> rows = [];

    for (var i = 0; i < numOfRows; i++) {
      //produce 5 orbs in a row
      //if orbs obtained is larger than/equal to column count, produce %numOfColumns% amount of filled orbs
      if (orbCounter >= numOfColumns){
        filledOrbNum = numOfColumns;
        orbCounter-=numOfColumns;
      }
      //else produce %orbCounter% amount of filled orbs & %numOfColumns-orbCounter% amount of filled orbs
      else{
        filledOrbNum = orbCounter;
        orbCounter = 0;
      }

      rows.add(
          Container( child: Row(
          children: List.generate(
              numOfColumns,
                  (index) {
                      if(index < filledOrbNum) {
                        return Expanded(
                            child: Image.asset(
                                'assets/images/orbfill.png', height: 35, width: 35)
                        );
                      }
                      else{
                        return Expanded(
                            child: Image.asset(
                                'assets/images/unfilledorb.png', height: 35, width: 35)
                        );
                      }
                  }
          )
      ))
      );

      rows.add(Divider(
          height: 10,
          color: Colors.transparent));
    }

    return rows;
  }

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
                    "Awesome work!",
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
                    (solarOrbsPerLevel-solarOrbsObtained).toString()+" solar orbs left to collect",
                    style: AppTheme.theme.textTheme.headline4!
                        .copyWith(color: Colours.black),
                  ),
                  Divider(
                    height: 60,
                    color: Colors.transparent,
                  ),

                  //generateOrbsRows(): display filled and unfilled orbs
                  ListBody(
                    children: generateOrbsRows()
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
