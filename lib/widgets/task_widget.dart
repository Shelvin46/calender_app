import 'package:calender_app/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../core/const_widgets/widgets.dart';
import '../presentation/calender_view.dart';
import '../presentation/details_view.dart';

class TaskWidget extends StatefulWidget {
  final DateTime selected;
  final List<Event> events;

  const TaskWidget({Key? key, required this.selected, required this.events})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  List<Event> _eventsOnSelectedDate = [];

  @override
  void initState() {
    setState(() {
      _filterEventsBySelectedDate();
    });
    super.initState();
  }

  void _filterEventsBySelectedDate() {
    _eventsOnSelectedDate = widget.events.where((event) {
      return (event.from.year == widget.selected.year &&
              event.from.month == widget.selected.month &&
              event.from.day == widget.selected.day) ||
          (event.to.year == widget.selected.year &&
              event.to.month == widget.selected.month &&
              event.to.day == widget.selected.day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Events on ${DateFormat('dd MMM yyyy').format(widget.selected)}'),
      ),
      body: SfCalendarTheme(
        data: SfCalendarThemeData(),
        child: Column(
          children: [
            Expanded(
              child: SfCalendar(
                initialDisplayDate: widget.selected,
                view: CalendarView.timelineDay,
                dataSource: _getCalendarDataSource(_eventsOnSelectedDate),
                onTap: (CalendarTapDetails details) {
                  if (details.appointments != null &&
                      details.appointments!.isNotEmpty) {
                    final event = details.appointments!.first;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsOfEachEvent(
                          dateTime: event.startTime!,
                          from: event.startTime!,
                          to: event.endTime!,
                          title: event.subject!,
                          // event: event,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _eventsOnSelectedDate.length,
                itemBuilder: (BuildContext context, int index) {
                  final event = _eventsOnSelectedDate[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsOfEachEvent(
                            dateTime: event.from,
                            from: event.from,
                            to: event.to,
                            title: event.title,
                            // event: event,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        event.title,
                        style: detailTitle,
                      ),
                      subtitle: Text(
                        '${DateFormat('dd MMM yyyy, HH:mm').format(event.from)} - ${DateFormat('dd MMM yyyy, HH:mm').format(event.to)}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataSource _getCalendarDataSource(List<Event> events) {
    final List<Appointment> appointments = [];
    for (final event in events) {
      appointments.add(Appointment(
        startTime: event.from,
        endTime: event.to,
        subject: event.title,
        notes: event.description,
        color: Colors.blue,
        isAllDay: event.isAllDay,
      ));
    }
    return DataSource(appointments);
  }
}
