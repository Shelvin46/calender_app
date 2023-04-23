import 'package:calender_app/model/event_model.dart';
import 'package:hive/hive.dart';

late Box<Event> model;
openEvent() async {
  model = await Hive.openBox('events');
}
