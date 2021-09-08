import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:wearable_intelligence/components/drawer_state.dart';

import '../styles.dart';

class Tracker extends StatefulWidget {
  Tracker(this.title, this._duration) : super();

  final String title;
  final int _duration; // In seconds
  var paused = false;
  var ended = false;

  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  CountDownController _controller = CountDownController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppTheme.theme.backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colours.grey,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colours.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: AppTheme.theme.backgroundColor,
      ),
      drawer: AppDrawer('Progress'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularCountDownTimer(
              duration: widget._duration,
              controller: _controller,
              width: width * 0.8,
              height: width * 0.8,
              ringColor: Colours.grey,
              fillColor: Colours.lightBlue,
              backgroundColor: Colours.white,
              strokeWidth: 15.0,
              strokeCap: StrokeCap.round,
              textStyle: TextStyle(fontSize: 33.0, color: Colours.grey),
              textFormat: CountdownTextFormat.HH_MM_SS,
              isReverse: true,
              isReverseAnimation: true,
              isTimerTextShown: true,
              autoStart: true,
              onStart: () {
                print('Countdown Started');
              },
              onComplete: () async {
                bool canVibrate = await Vibrate.canVibrate;
                print(canVibrate.toString());
                Vibrate.vibrate();
                setState(() {
                  widget.ended = true;
                });
              },
            ),
            widget.ended
                ? MaterialButton(
                    minWidth: width * 0.6,
                    height: 50,
                    elevation: 10,
                    shape: StadiumBorder(),
                    color: Colours.highlight,
                    child: Text(
                      "Show Stats",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colours.white),
                    ),
                    onPressed: () {
                      print("navigate to new page");
                    },
                  )
                : MaterialButton(
                    minWidth: width * 0.6,
                    height: 50,
                    elevation: 10,
                    shape: StadiumBorder(),
                    color: Colours.lightBlue,
                    child: Text(
                      widget.paused ? "Play" : "Pause",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colours.white),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.paused ? _controller.resume() : _controller.pause();
                        widget.paused = !widget.paused;
                      });
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
