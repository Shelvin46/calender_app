import 'dart:developer';
import 'package:calender_app/widgets/task_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../core/const_colors/colors.dart';
import '../model/event_model.dart';
import 'eventediting_page.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class CalenderView extends StatefulWidget {
  const CalenderView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalenderViewState createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  Future<List<Event>> _loadEvents() async {
    final eventBox = await Hive.openBox<Event>('events');
    return eventBox.values.toList();
  }

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // initState();
    return FutureBuilder(
      future: _loadEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final events = snapshot.data;
          log(events.toString());
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return const EventEditingPage();
                  },
                ));
              },
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              title: const Text("Calendar"),
            ),
            body: SafeArea(
              child: SfCalendarTheme(
                data: SfCalendarThemeData(),
                child: SfCalendar(
                  backgroundColor: calenderBackground,
                  view: CalendarView.month,
                  initialDisplayDate: DateTime.now(),
                  dataSource: _getCalendarDataSource(events!),
                  onTap: (calendarTapDetails) {
                    DateTime dateTime = calendarTapDetails.date!;
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return TaskWidget(
                          events: events,
                          selected: dateTime,
                        );
                      },
                    );
                  },
                  monthViewSettings: MonthViewSettings(
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.appointment),
                ),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  DataSource _getCalendarDataSource(List<Event> events) {
    final List<Appointment> appointments = [];
    for (final event in events) {
      if (event.isAllWeek) {
        final int daysUntilNextWeekday =
            (event.from.weekday - event.from.weekday) % 7;
        log(daysUntilNextWeekday.toString());
        final DateTime nextWeekday =
            event.from.add(Duration(days: daysUntilNextWeekday));
        log(event.to.add(nextWeekday.difference(event.from)).toString());
        final Appointment initialAppointment = Appointment(
          startTime: nextWeekday,
          endTime: event.to.add(nextWeekday.difference(event.from)),
          subject: event.title,
          color: Colors.blue,
          isAllDay: event.isAllDay,
        );
        final List<Appointment> weeklyAppointments = List.generate(
          50,
          (index) => Appointment(
            startTime:
                initialAppointment.startTime.add(Duration(days: index * 7)),
            endTime: initialAppointment.endTime.add(Duration(days: index * 7)),
            subject: initialAppointment.subject,
            color: initialAppointment.color,
            isAllDay: initialAppointment.isAllDay,
          ),
        );
        appointments.addAll(weeklyAppointments);
      } else if (event.isAllMonth) {
        final int daysInMonth =
            DateTime(event.from.year, event.from.month + 1, 0).day;
        final int dayOfMonth = event.from.day;
        final int daysUntilNextMonthDay = daysInMonth - dayOfMonth;
        DateTime nextMonthDay =
            event.from.add(Duration(days: daysUntilNextMonthDay));
        if (dayOfMonth > nextMonthDay.day) {
          // move the start date to the next month if necessary
          nextMonthDay = nextMonthDay.add(Duration(days: daysInMonth));
        }
        final Appointment initialAppointment = Appointment(
          startTime: nextMonthDay,
          endTime: event.to.add(nextMonthDay.difference(event.from)),
          subject: event.title,
          color: Colors.blue,
          isAllDay: event.isAllDay,
        );
        final List<Appointment> monthlyAppointments = List.generate(
          12,
          (index) => Appointment(
            startTime: DateTime(
              initialAppointment.startTime.year,
              initialAppointment.startTime.month + index,
              dayOfMonth,
              initialAppointment.startTime.hour,
              initialAppointment.startTime.minute,
            ),
            endTime: DateTime(
              initialAppointment.endTime.year,
              initialAppointment.endTime.month + index,
              dayOfMonth,
              initialAppointment.endTime.hour,
              initialAppointment.endTime.minute,
            ),
            subject: initialAppointment.subject,
            color: initialAppointment.color,
            isAllDay: initialAppointment.isAllDay,
          ),
        );
        appointments.addAll(monthlyAppointments);
      } else {
        appointments.add(Appointment(
          startTime: event.from,
          endTime: event.to,
          subject: event.title,
          color: Colors.blue,
          isAllDay: event.isAllDay,
        ));
      }
    }
    return DataSource(appointments);
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}
