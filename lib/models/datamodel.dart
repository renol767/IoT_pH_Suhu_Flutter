import 'dart:convert';

List<Sensor> sensorFromJson(String str) =>
    List<Sensor>.from(json.decode(str).map((x) => Sensor.fromJson(x)));

class Sensor {
  Sensor({
    this.id,
    this.temp,
    this.hum,
    this.ph,
    this.datetime,
  });

  String id;
  String temp;
  String hum;
  String ph;
  DateTime datetime;

  factory Sensor.fromJson(Map<String, dynamic> json) => Sensor(
        id: json["id"],
        temp: json["temp"],
        hum: json["hum"],
        ph: json["ph"],
        datetime: DateTime.parse(json["datetime"]),
      );
}
