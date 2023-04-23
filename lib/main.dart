import 'package:calender_app/model/db_functio.dart';
import 'package:calender_app/model/event_model.dart';
import 'package:calender_app/presentation/calender_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/adapters.dart';

late MediaQueryData myMediaQueryData;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
  Hive.registerAdapter(EventAdapter());
  await openEvent();
  myMediaQueryData = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const CalenderView(),
    );
  }
}
