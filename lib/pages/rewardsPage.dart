// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:wearable_intelligence/utils/styles.dart';
import 'package:wearable_intelligence/utils/globals.dart';


class rewardsPage extends StatefulWidget {
  rewardsPage();
  String message="It seems you haven't fed me yet, bud...";

  @override
  State<rewardsPage> createState() => _rewardsPageState();
}

class _rewardsPageState extends State<rewardsPage> {
  int solarOrbsPerDay=5; //Solar orbs you need to collect per day
  int waterDropsPerDay=5; //Water drops you need to collect per day

  int numOfColumns = 5;

  void setRewardsMessage(){
    //if water drops collected less than half
    if(waterDropsGained<(waterDropsPerDay*0.5).ceil() && waterDropsGained>0){
      widget.message = "These snacks are pretty nice. Good effort, bud!";
    }
    //all water drops collected, incomplete solar orbs
    else if(solarOrbsGained>=0 && solarOrbsGained<solarOrbsPerDay && waterDropsGained==waterDropsPerDay){
      widget.message = "How hydrating and refreshing! There is always a next time, so we can still grind for more solar orbs. Thank you for your effort, bud!";
    }
    //water drops and solar orbs collected equal to/more than half but incomplete
    else if((solarOrbsGained>=(solarOrbsPerDay*0.5).ceil() || waterDropsGained>=(waterDropsPerDay*0.5).ceil()) && solarOrbsGained<solarOrbsPerDay && waterDropsGained<waterDropsPerDay){
      widget.message = "Hey, I think I'm pretty well-fed today! Let's keep grinding; you still need to meet the water drop quota!";
    }
    //all water drops and solar orbs collected
    else if(solarOrbsGained==solarOrbsPerDay && waterDropsGained==waterDropsPerDay){
      widget.message = "OMG, a warm, refreshing, full meal! Is this real? This is so awesome... let's celebrate, bud!";
    }
  }

  //a method for producing a row of filled/unfilled orbs
  Container rewardFiller(isOrb,filledObjNum){
    String filledImg;
    String unfilledImg;
    if(isOrb){
      filledImg = 'assets/images/orbfill.png';
      unfilledImg = 'assets/images/unfilledorb.png';
    }
    else{
      filledImg = 'assets/images/orbfill.png';
      unfilledImg = 'assets/images/unfilledorb.png';
    }

    return Container(
      color: isOrb ? Colors.greenAccent : Colors.lightBlue, //for better recognition; temporary only
        child:Row(
          children: List.generate(
            numOfColumns,
            (index) {
              if(index < filledObjNum) {
                return Expanded(
                  child: Image.asset(
                    filledImg, height: 35, width: 35)
                );
              }
              else{
                return Expanded(
                  child: Image.asset(
                    unfilledImg, height: 35, width: 35)
                );
              }
            }
          )
        ));
  }

  //producing multiple rows of unfilled/filled orbs
  List<Widget> generateRewardsRows(isOrb,numOfRows,counter,filledNum){
    List<Widget> rows = [];
    int rewardCounter = counter;
    int rewardsFilled = filledNum;

    //if orbs obtained is larger than/equal to column count, produce %numOfColumns% amount of filled orbs for current row
    for (var i = 0; i < numOfRows; i++) {
      if (rewardCounter >= numOfColumns){
        rewardsFilled += numOfColumns;
        rewardCounter-=numOfColumns;
      }
      //else produce %orbCounter% amount of filled orbs & %numOfColumns-orbCounter% amount of filled orbs
      else{
        rewardsFilled = rewardCounter;
        rewardCounter = 0;
      }
      rows.add(rewardFiller(isOrb,rewardsFilled));
      rows.add(Divider(height:10, color:Colors.transparent));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 75) / 2;

    //for solar orbs
    int numOfOrbRows = (solarOrbsPerDay/numOfColumns).ceil();
    int orbCounter = solarOrbsGained;
    int filledOrbNum = 0;

    //for water drops
    int numOfDropRows = (waterDropsPerDay/numOfColumns).ceil();
    int dropCounter = waterDropsGained;
    int filledDropNum = 0;

    setRewardsMessage();

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
                    widget.message,
                    textAlign: TextAlign.center,
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
                    (waterDropsPerDay-waterDropsGained).toString()+" water drops left to collect",
                    style: AppTheme.theme.textTheme.headline4!
                        .copyWith(color: Colours.black),
                  ),
                  Divider(
                    height: 10,
                    color: Colors.transparent,
                  ),
                  Text(
                    (solarOrbsPerDay-solarOrbsGained).toString()+" solar orbs left to collect",
                    style: AppTheme.theme.textTheme.headline4!
                        .copyWith(color: Colours.black),
                  ),
                  Divider(
                    height: 60,
                    color: Colors.transparent,
                  ),

                  //display multiple rows of filled and unfilled orbs and drops
                  ListBody(
                    children:
                      generateRewardsRows(false,numOfDropRows,dropCounter,filledDropNum)+
                      generateRewardsRows(true,numOfOrbRows,orbCounter,filledOrbNum)
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
