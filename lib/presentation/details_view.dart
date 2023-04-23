import 'dart:developer';

import 'package:calender_app/core/const_widgets/widgets.dart';
import 'package:calender_app/main.dart';
import 'package:calender_app/presentation/calender_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../model/event_model.dart';

class DetailsOfEachEvent extends StatefulWidget {
  const DetailsOfEachEvent({
    super.key,
    required this.dateTime,
    required this.from,
    required this.to,
    required this.title,
  });
  final DateTime dateTime;
  final DateTime from;
  final DateTime to;
  final String title;

  @override
  State<DetailsOfEachEvent> createState() => _DetailsOfEachEventState();
}

class _DetailsOfEachEventState extends State<DetailsOfEachEvent> {
  // final Event event;
  @override
  Widget build(BuildContext context) {
    // final eventBox = await Hive.openBox<Event>('events');
    return Scaffold(
      appBar: AppBar(
        title: Text("Details", style: detailTitle),
        actions: [
          IconButton(
              onPressed: () async {
                await deleteEvent(context);
              },
              icon: const Icon(
                Icons.delete,
                size: 35,
              ))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gap,
          ListTile(
            leading: fromDate,
            trailing: Text(
              DateFormat('dd MMM yyyy, HH:mm').format(widget.from),
              style: dateStyle,
            ),
          ),
          ListTile(
            leading: toDate,
            trailing: Text(DateFormat('dd MMM yyyy, HH:mm').format(widget.to),
                style: dateStyle),
          ),
          gap,
          Padding(
              padding:
                  EdgeInsets.only(left: myMediaQueryData.size.width * 0.03),
              child: Text(widget.title,
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }

  Future deleteEvent(BuildContext context) async {
    final eventBox = await Hive.openBox<Event>('events');
    final values = eventBox.values.toList();
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert!!'),
        content: const Text('Do you want to delete this event'),
        actions: [
          TextButton(
            onPressed: () {
              values.removeWhere((element) => element.title == widget.title);
              eventBox.delete(eventBox.keys.toList().firstWhere(
                  (key) => eventBox.get(key)?.title == widget.title));
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return const CalenderView();
                },
              )).then((value) {
                setState(() {});
              });
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              // Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    // log(values.length.toString());
  }
}
