import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wearable_intelligence/components/drawer_state.dart';
import 'package:wearable_intelligence/components/progressCircle.dart';

import '../styles.dart';

class CalenderPage extends StatefulWidget {
  CalenderPage(this.title, this.percentage) : super();

  final String title;
  final double percentage;

  @override
  _CalenderPageState createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.white,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
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
          TableCalendar<Event>(
            // NOTE: In the complex example predict holiday can be used to style future events. Might not be best call though
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            //selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: CalendarFormat.month, // NOTE: This is where I would fix the style of the calendar
            weekendDays: [], // NOTE: Having this empty means all text is same color
            availableCalendarFormats: const {
              // NOTE: This is to force it to only have 1 type.
              CalendarFormat.month: 'Month',
            },
            rangeSelectionMode: RangeSelectionMode.disabled, // NOTE: we want this disabled
            sixWeekMonthsEnforced: true, // NOTE: forces consistent size
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(markerBuilder: (context, date, events) {
              List<Event> event = _getEventsForDay(date);
              if (event.length > 0) {
                if (date.day == DateTime.now().day && date.month == DateTime.now().month && date.year == DateTime.now().year) {
                  return Container(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colours.darkBlue,
                      ),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
                if (date.isBefore(DateTime.now())) {
                  return Container(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colours.lightBlue,
                      ),
                      child: Text(
                        date.day.toString(),
                      ),
                    ),
                  );
                }
                if (date.isAfter(DateTime.now())) {
                  return Container(
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colours.lightBlue,
                        width: 2,
                      ),
                    ),
                  );
                }
              }
            }),
          ),
          ProgressCircle(70.0, Colours.lightBlue),
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
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
