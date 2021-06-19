import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/datamodel.dart';

class DataService {
  Future<Sensor> getData() async {
    return http.get("http://iotlobster.masuk.web.id/api/sensor").then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return Sensor.fromJson(jsonData[0]);
      }
    });
  }
}
