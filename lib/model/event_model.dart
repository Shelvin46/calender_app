import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'event_model.g.dart';

@HiveType(typeId: 1)
class Event {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final DateTime from;
  @HiveField(3)
  final DateTime to;

  @HiveField(4)
  final bool isAllDay;
  @HiveField(5)
  final bool isAllWeek;
  @HiveField(6)
  final bool isAllMonth;
  const Event(
      {required this.title,
      required this.description,
      required this.from,
      required this.to,

      required this.isAllDay,
      required this.isAllMonth,
      required this.isAllWeek});
}


