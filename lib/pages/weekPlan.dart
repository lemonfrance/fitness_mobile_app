import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wearable_intelligence/Services/auth.dart';
import 'package:wearable_intelligence/components/exercisePlanTile.dart';
import 'package:wearable_intelligence/pages/tracker.dart';
import 'package:wearable_intelligence/utils/globals.dart';
import 'package:wearable_intelligence/utils/styles.dart';

class ExercisePlan extends StatefulWidget {
  ExercisePlan() : super();

  @override
  _ExercisePlanState createState() => _ExercisePlanState();
}

class _ExercisePlanState extends State<ExercisePlan> {
  final AuthService _auth = AuthService();
  late final ValueNotifier<List<Event>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  //Future<dynamic>? _workout;
  int? _weekID;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _weekID = (_focusedDay.weekday - 1);

    // _workout = DatabaseService(uid: 'qln9sdoy6DOfJRxOVTO3HJ5AprA3').getExercise(weekID);
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  Widget weekCalendar() {
    return Container(
      child: TableCalendar<Event>(
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: _focusedDay,
        onDaySelected: _onDaySelected,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        calendarFormat: CalendarFormat.week, // NOTE: This is where I would fix the style of the calendar
        weekendDays: [], // NOTE: Having this empty means all text is same color
        availableCalendarFormats: const {
          // NOTE: This is to force it to only have 1 type.
          CalendarFormat.week: 'Week',
        },
        rangeSelectionMode: RangeSelectionMode.disabled, // NOTE: we want this disabled
        eventLoader: _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: CalendarStyle(
          // Use `CalendarStyle` to customize the UI
          outsideDaysVisible: false,
          selectedDecoration: BoxDecoration(color: Colours.darkBlue, shape: BoxShape.circle),
          todayDecoration: BoxDecoration(color: Colours.fadedDarkBlue, shape: BoxShape.circle),
        ),
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarBuilders: CalendarBuilders(markerBuilder: (context, date, events) {
          List<Event> event = _getEventsForDay(date);
          if (event.length > 0) {
            return Container();
          }
        }),
      ),
    );
  }

  /// This widget creates 1 individual date for the top navigation of the screen.
  Widget date(String date, String weekday, bool selected) {
    return Container(
      height: 60,
      width: 40,
      decoration: BoxDecoration(
        color: selected ? Colours.darkBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            weekday,
            style: TextStyle(color: selected ? Colours.white : Colours.black),
          ),
          Text(
            date,
            style: TextStyle(fontWeight: FontWeight.bold, color: selected ? Colours.white : Colours.black),
          ),
        ],
      ),
    );
  }

  Widget education(String title, String body) {
    TextStyle headerStyle = TextStyle(color: Colours.darkBlue, fontSize: 18, fontWeight: FontWeight.bold, height: 1);
    TextStyle bodyStyle = TextStyle(color: Colours.darkBlue, fontSize: 18, height: 1);
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: headerStyle),
          Text(body, style: bodyStyle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.theme.backgroundColor,
      body: Stack(
        children: [
          ListView(
            children: [
              weekCalendar(),
              // This might need to change since they can click on the dates.
              Padding(
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text((_getEventsForDay(_selectedDay!).length > 0) ? (_getEventsForDay(_selectedDay!).first.toString()) : "Rest Day",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colours.black, fontSize: 18)),
                ),
                // This might need to change since they can click on the dates.
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: SvgPicture.asset(
                  'assets/images/walking.svg',
                  width: width - 40,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: exercisePlan(75, 30),
              ),
              education(
                //exercise id get intensity
                "Low impact",
                "It causes less strain and injuries than most other forms of exercise.",
              ),
              education(
                //get workout name
                "Muscle workout",
                "cycling uses all of the major muscle groups as you pedal.",
              ),
              education(
                //get workout type
                "Strength and stamina",
                "cycling increases stamina, strength and aerobic fitness.",
              ),
              Container(height: 80)
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () async {
                  // Line doenst work
                  //final value = await DatabaseService(uid: 'qln9sdoy6DOfJRxOVTO3HJ5AprA3').getExercise(_weekID);
                  elapsedTime = exerciseMode ? elapsedTime : 0;
                  exerciseMode = true;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Tracker('Timer', totalTime, elapsedTime)),
                  );
                },
                child: Text(exerciseMode ? "TIMER" : "BEGIN", style: TextStyle(fontWeight: FontWeight.bold, color: Colours.white, fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  primary: Colours.highlight,
                  onPrimary: Colours.white,
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

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({
    kToday: [
      Event('Walk 1km'),
    ],
    DateTime.utc(kToday.year, kToday.month, kToday.day + 1): [
      Event("Light Running"),
    ]
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
