import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:wearable_intelligence/components/drawer.dart';
import 'package:wearable_intelligence/components/progress.dart';

import '../styles.dart';

class CalenderPage extends StatefulWidget {
  CalenderPage(this.title, this.percentage) : super();

  final String title;
  final double percentage;

  @override
  _CalenderPageState createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  final Map<DateTime, List<NeatCleanCalendarEvent>> _events = {
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): [
      NeatCleanCalendarEvent('Event A',
          startTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 0),
          endTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 0),
          description: 'A special event',
          color: Colours.lightBlue),
    ],
    DateTime(DateTime.now().year, DateTime.now().month, 4): [
      NeatCleanCalendarEvent('Event B',
          startTime: DateTime(DateTime.now().year, DateTime.now().month, 4, 10, 0),
          endTime: DateTime(DateTime.now().year, DateTime.now().month, 4, 12, 0),
          color: Colours.lightBlue),
    ],
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 3): [
      NeatCleanCalendarEvent('Event B',
          startTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2, 10, 0),
          endTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2, 12, 0),
          color: Colours.lightBlue),
    ],
  };

  @override
  void initState() {
    super.initState();
    // Force selection of today on first load, so that the list of today's events gets shown.
    _handleNewDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colours.darkBlue,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colours.darkBlue,
        ),
        elevation: 0,
        backgroundColor: AppTheme.theme.backgroundColor,
        foregroundColor: Colours.darkBlue,
      ),
      drawer: AppDrawer('Calender'),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 350,
            child: Calendar(
              startOnMonday: true,
              events: _events,
              hideBottomBar: true,
              isExpandable: false,
              eventDoneColor: Colours.highlight,
              selectedColor: Colours.darkBlue,
              todayColor: Colours.darkBlue,
              eventColor: Colours.lightBlue,
              locale: 'en_US',
              todayButtonText: 'Today',
              isExpanded: true,
              dayOfWeekStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
            ),
          ),
          Progress(70.0, Colours.lightBlue),
        ],
      ),
    );
  }

  void _handleNewDate(date) {
    print('Date selected: $date');
  }
}
