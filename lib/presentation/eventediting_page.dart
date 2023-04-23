// import 'dart:html';

import 'dart:developer';
import 'package:calender_app/core/const_widgets/widgets.dart';
import 'package:calender_app/main.dart';
// import 'package:calender_app/methods/methods_one.dart';
import 'package:calender_app/model/db_functio.dart';
import 'package:calender_app/model/event_model.dart';
// import 'package:calender_app/model/event_model.dart';
import 'package:calender_app/model/utils.dart';
import 'package:calender_app/presentation/calender_view.dart';
import 'package:calender_app/widgets/description_detail.dart';
import 'package:calender_app/widgets/titile_formfied.dart';
import 'package:flutter/material.dart';

class EventEditingPage extends StatefulWidget {
  const EventEditingPage({
    super.key,
  });

  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  bool _isAllDay = false;
  bool _isAllWeek = false;
  bool _isAllMonth = false;
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // setState(() {});

    from = DateTime.now();
    to = DateTime.now().add(const Duration(hours: 2));
  }

  @override
  Widget build(BuildContext context) {
    log(to.toString());
    return Scaffold(
      appBar: AppBar(
        // leading: const CloseButton(),
        actions: editingButton(),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TitleFormfield(titleController: titleController),
              ),
              SizedBox(
                height: myMediaQueryData.size.height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: myMediaQueryData.size.width * 0.04,
                ),
                child: fromText,
              ),
              buildFrom(),
              Padding(
                padding: EdgeInsets.only(
                  left: myMediaQueryData.size.width * 0.04,
                ),
                child: toText,
              ),
              buildTo(),
              CheckboxListTile(
                title: const Text('All Day'),
                value: _isAllDay,
                onChanged: (bool? value) {
                  setState(() {
                    _isAllDay = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('All Week'),
                value: _isAllWeek,
                onChanged: (bool? value) {
                  setState(() {
                    _isAllWeek = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('All Month'),
                value: _isAllMonth,
                onChanged: (bool? value) {
                  setState(() {
                    _isAllMonth = value ?? false;
                  });
                },
              ),
              DescriptionFormField(descriptionController: controller)
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> editingButton() => [
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(shadowColor: Colors.transparent),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // log("ndknvdknv");

                setState(() {});
                final values = Event(
                    title: titleController.text.trim(),
                    description: controller.text.trim(),
                    from: from,
                    to: to,
                    // backgroundColor: Colors.green,
                    isAllDay: _isAllDay,
                    isAllMonth: _isAllMonth,
                    isAllWeek: _isAllWeek);
                model.add(values);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.blue,
                    content: Text("Event Added Successfully")));
                // setState(() {})
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return const CalenderView();
                  },
                )).then((value) {
                  setState(() {});
                });

                // setState(() {});
              }
            },
            icon: rightIcon,
            label: textSave)
      ];

  Widget buildFrom() {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: buildDropDownbField(
              text: Utils.toDate(from),
              onClicked: () {
                pickFromDateTime(
                  pickDate: true,
                );
              },
            )),
        Expanded(
          child: buildDropDownbField(
            text: Utils.toTime(from),
            onClicked: () {
              pickFromDateTime(
                pickDate: false,
              );
            },
          ),
        )
      ],
    );
  }

  Widget buildTo() {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: buildDropDownbField(
              text: Utils.toDate(to),
              onClicked: () {
                pickFromDateTimeTo(
                  pickDate: true,
                );
              },
            )),
        Expanded(
          child: buildDropDownbField(
            text: Utils.toTime(to),
            onClicked: () {
              pickFromDateTimeTo(
                pickDate: false,
              );
            },
          ),
        )
      ],
    );
  }

  Widget buildDropDownbField({
    required String text,
    required VoidCallback onClicked,
  }) {
    return ListTile(
      title: Text(text),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: onClicked,
    );
  }

  Future pickFromDateTime({
    required bool pickDate,
  }) async {
    final date = await pickDateTime(from,
        pickDate: pickDate, firstDate: pickDate ? from : null);
    if (date == null) {
      return;
    }
    // this will take the first date not nullable
    if (date.isAfter(to)) {
      to = DateTime(date.year, date.month, date.day, date.hour, date.minute);
    }

    setState(() {
      from = date;
    });
  }

  Future pickFromDateTimeTo({
    required bool pickDate,
  }) async {
    final date = await pickDateTime(to,
        pickDate: pickDate, firstDate: pickDate ? from : null);
    if (date == null) {
      return;
    }

    setState(() {
      to = date;
    });
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2022, 10),
        lastDate: DateTime(2100),
      );
      if (date == null) {
        return null;
      }
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeofDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
      if (timeofDay == null) {
        return null;
      }
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeofDay.hour, minutes: timeofDay.minute);
      return date.add(time);
    }
  }
  //<--------------------------------------------------------------------From Date------------------------------------------------------------------------------------->
}
