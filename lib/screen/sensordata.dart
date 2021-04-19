import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:monitoringsuhu/models/datamodel.dart';
import 'package:monitoringsuhu/services/data_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class SensorData extends StatefulWidget {
  @override
  _SensorDataState createState() => _SensorDataState();
}

class _SensorDataState extends State<SensorData> {
  DataService get dataSensor => GetIt.I<DataService>();
  Sensor datas;
  @override
  void initState() {
    super.initState();
    this._sensordata();
  }

  void _sensordata() async {
    dataSensor.getData().then((value) {
      setState(() {
        datas = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Temperature",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text("${datas.temp} °C",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w300))
                        ],
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Humidity",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text("${datas.hum} RH",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w300))
                        ],
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "pH",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text("${datas.ph} pH",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w300))
                        ],
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "DateTime",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "(Waktu Terakhir Pengambilan Data)",
                            style: TextStyle(fontSize: 10),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text("${datas.datetime}",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300))
                        ],
                      ),
                    ),
                  ],
                );
              }),
    );
  }
}
