import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'package:monitoringsuhu/models/livewerkzeuge.dart';

class GraphHum extends StatefulWidget {
  @override
  _GraphHumState createState() => _GraphHumState();
}

class _GraphHumState extends State<GraphHum> {
  List listgraph = [];
  Timer timer;
  Future<String> getGraph() async {
    http.Response response =
        await http.get("http://iotlobster.masuk.web.id/api/graph");
    setState(() {
      var body = json.decode(response.body.toString());
      listgraph = body;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getGraph();
    timer = new Timer.periodic(Duration(seconds: 2), (t) => getGraph());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: listgraph == null
            ? Center(
                child: SpinKitFadingCube(
                color: Colors.blue,
                size: 30,
              ))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    Text(
                      "Grafik Humadity",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(16),
                      height: 500,
                      child: createChart(),
                    )
                  ],
                ),
              ));
  }

  charts.Series<LiveWerkzeuge, String> createSeries(String id, int i) {
    return charts.Series<LiveWerkzeuge, String>(
        id: id,
        colorFn: (LiveWerkzeuge wear, _) =>
            charts.ColorUtil.fromDartColor(Colors.green),
        labelAccessorFn: (LiveWerkzeuge wear, _) => '${listgraph[i]['hum']}',
        domainFn: (LiveWerkzeuge wear, _) => wear.wsp,
        measureFn: (LiveWerkzeuge wear, _) => wear.belastung,
        data: [
          LiveWerkzeuge(listgraph[i]['datetime'].toString().substring(11, 19),
              int.parse(listgraph[i]['hum'])),
        ]);
  }

  Widget createChart() {
    List<charts.Series<LiveWerkzeuge, String>> seriesList = [];
    for (int i = 0; i < listgraph.length; i++) {
      String id = 'WZG${i + 1}';
      seriesList.add(createSeries(id, i));
    }
    return new charts.BarChart(
      seriesList.reversed.toList(),
      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.StaticNumericTickProviderSpec(
          <charts.TickSpec<num>>[
            charts.TickSpec<num>(0),
            charts.TickSpec<num>(20),
            charts.TickSpec<num>(40),
            charts.TickSpec<num>(60),
            charts.TickSpec<num>(80),
            charts.TickSpec<num>(100),
          ],
        ),
      ),
      barRendererDecorator: charts.BarLabelDecorator<String>(
          outsideLabelStyleSpec: charts.TextStyleSpec()),
      barGroupingType: charts.BarGroupingType.groupedStacked,
    );
  }
}
