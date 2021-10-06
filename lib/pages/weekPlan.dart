import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wearable_intelligence/Services/auth.dart';
import 'package:wearable_intelligence/components/exercisePlanTile.dart';
import 'package:wearable_intelligence/models/exercisePlan.dart' as model;
import 'package:wearable_intelligence/pages/tracker.dart';
import 'package:wearable_intelligence/utils/styles.dart';

import '../utils/globals.dart';

class ExercisePlan extends StatefulWidget {
  ExercisePlan() : super();

  @override
  _ExercisePlanState createState() => _ExercisePlanState();
}

class _ExercisePlanState extends State<ExercisePlan> {
  final AuthService _auth = AuthService();
  late ValueNotifier<List<model.ExercisePlan>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay));
  }

  bool showButton() {
    // Uncomment if you want to test the timer without restrictions
    // return true;

    return (((_focusedDay.day == DateTime.now().day) &&
            (_focusedDay.month == DateTime.now().month) &&
            (_focusedDay.year == DateTime.now().year) &&
            (DateTime.now().weekday < 6)) &&
        !exercisedToday);
  }

  List<model.ExercisePlan> _getEventsForDay(DateTime day) {
    List<model.ExercisePlan> event = [];
    event.add(weekPlan[day.weekday - 1]);
    return event;
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
      child: TableCalendar<model.ExercisePlan>(
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
          List<model.ExercisePlan> event = _getEventsForDay(date);
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
          Container(height: 5),
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
      body: ListView(
        children: [
          weekCalendar(),
          // This might need to change since they can click on the dates.
          Padding(
            padding: EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text((_getEventsForDay(_selectedDay!).length > 0) ? (_getEventsForDay(_selectedDay!)[0].getType) : "Rest Day",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colours.black, fontSize: 24)),
            ),
            // This might need to change since they can click on the dates.
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10, left: 50, right: 50),
            child: showButton()
                ? ElevatedButton(
                    onPressed: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Tracker()));
                    },
                    child: Text("BEGIN", style: TextStyle(fontWeight: FontWeight.bold, color: Colours.white, fontSize: 24)),
                    style: ElevatedButton.styleFrom(
                      primary: Colours.highlight,
                      onPrimary: Colours.white,
                      minimumSize: Size(width - 100, 45),
                      shape: StadiumBorder(),
                      elevation: 10,
                    ),
                  )
                : Container(),
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
            child: exercisePlan((_getEventsForDay(_selectedDay!)[0].getHeartRate), (_getEventsForDay(_selectedDay!)[0].getReps)),
          ),
          education(
            "Heart Rate",
            "Where appropriate, we wish for the heart rate to reach 77-95% of your maximum heart rate while participating in vigorous-intensity aerobic exercise.\n"
                "\nIf vigorous-intensity exercise is not recommended we aim to reach 64-76% of your maximum heart rate.\n\nThese target heart rate ranges are"
                " used to help reduce HbA1c levels and improve your cardiovascular health",
          ),
          Container(height: 5),
          education(
            "Exercise Plans",
            "The recommended exercise plans are geared at exercising 5 days a week, with a goal of 30 minutes each day. As you exercise Wearable Intelligence "
                "will adapt to your needs.",
          ),
          Container(height: 20),
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
