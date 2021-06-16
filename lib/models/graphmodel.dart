import 'dart:convert';

List<GraphData> GraphDataFromJson(String str) =>
    List<GraphData>.from(json.decode(str).map((x) => GraphData.fromJson(x)));

class GraphData {
  GraphData({
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

  factory GraphData.fromJson(Map<String, dynamic> json) => GraphData(
        id: json["id"],
        temp: json["temp"],
        hum: json["hum"],
        ph: json["ph"],
        datetime: DateTime.parse(json["datetime"]),
      );
}
