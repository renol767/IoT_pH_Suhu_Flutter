import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:monitoringsuhu/models/datamodel.dart';
import 'package:monitoringsuhu/services/data_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

class SensorData extends StatefulWidget {
  @override
  _SensorDataState createState() => _SensorDataState();
}

class _SensorDataState extends State<SensorData> {
  Sensor datas;

  @override
  void initState() {
    super.initState();
    this._sensordata();
  }

  DataService get dataSensor => GetIt.I<DataService>();

  void _sensordata() async {
    dataSensor.getData().then((value) {
      setState(() {
        datas = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text("Monitoring System"),
      ),
      body: datas == null
          ? CircularProgressIndicator()
          : StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 4))
                  .asyncMap((event) => _sensordata()),
              builder: (context, snapshot) {
                return GridView.count(
                  crossAxisCount: 2,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 13.0,
                        progressColor: Colors.orange,
                        animation: true,
                        percent: double.parse(datas.temp) / 40,
                        center: new Text(
                          "${datas.temp} °C",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 20.0),
                        ),
                        footer: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Temperature : ${datas.temp}/40 °C",
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 13.0,
                        animation: true,
                        progressColor: Colors.green,
                        percent: double.parse(datas.hum) / 100,
                        center: new Text(
                          "${datas.hum} RH",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 20.0),
                        ),
                        footer: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Humidity : ${datas.hum}/100 RH",
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 13.0,
                        animation: true,
                        progressColor: Colors.blueAccent,
                        percent: double.parse(datas.ph) / 14,
                        center: new Text(
                          "${datas.ph} pH",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 20.0),
                        ),
                        footer: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "pH : ${datas.ph}/14 pH",
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: now.hour >= 18 && now.hour <= 6
                            ? CircularPercentIndicator(
                                radius: 120.0,
                                lineWidth: 13.0,
                                animation: true,
                                progressColor: Colors.blueAccent,
                                percent: now.hour / 24,
                                center: new Text(
                                  "${now.hour} :",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20.0),
                                ),
                              )
                            // ? Container(
                            //     margin: EdgeInsets.all(16.0),
                            //     child: Column(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       crossAxisAlignment: CrossAxisAlignment.center,
                            //       children: [
                            //         Text(
                            //           "${now.hour} : ${now.minute}",
                            //           style: TextStyle(
                            //               fontSize: 20,
                            //               fontWeight: FontWeight.bold),
                            //         ),
                            //         SizedBox(
                            //           height: 30,
                            //         ),
                            //         Text(
                            //             "Pemberian Pakan Otomatis Selanjutnya Jam 6 Sore",
                            //             style: TextStyle(
                            //                 fontSize: 15,
                            //                 fontWeight: FontWeight.w300))
                            //       ],
                            //     ),
                            //   )
                            : CircularPercentIndicator(
                                radius: 120.0,
                                lineWidth: 13.0,
                                animation: true,
                                progressColor: Colors.blueAccent,
                                percent: now.hour / 24,
                                center: new Text(
                                  "${now.hour} : ${now.minute}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20.0),
                                ),
                              ))
                  ],
                );
              }),
    );
  }
}
