import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:monitoringsuhu/screen/sensordata.dart';
import 'package:monitoringsuhu/services/data_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocaator();
  runApp(MyApp());
}

void setupLocaator() {
  GetIt.I.registerLazySingleton(() => DataService());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SensorData(),
    );
  }
}
