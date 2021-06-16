import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:monitoringsuhu/models/graphmodel.dart';
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  List listgraph = [];
  Timer timer;
  Future<String> getGraph() async {
    http.Response response =
        await http.get("http://192.168.1.6/dht11/api/sensorgraph");
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
        appBar: AppBar(
          title: Text("Graph"),
        ),
        body: listgraph == null
            ? CircularProgressIndicator()
            : Column(
                children: [
                  SizedBox(height: 40),
                  Text(
                    "Grafik pH",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    height: 500,
                    child: createChart(),
                  )
                ],
              ));
  }

  charts.Series<LiveWerkzeuge, String> createSeries(String id, int i) {
    return charts.Series<LiveWerkzeuge, String>(
        id: id,
        colorFn: (LiveWerkzeuge wear, _) =>
            charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (LiveWerkzeuge wear, _) => '${listgraph[i]['ph']}',
        domainFn: (LiveWerkzeuge wear, _) => wear.wsp,
        measureFn: (LiveWerkzeuge wear, _) => wear.belastung,
        data: [
          LiveWerkzeuge(listgraph[i]['datetime'].toString().substring(11, 19),
              int.parse(listgraph[i]['ph'])),
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
            charts.TickSpec<num>(2),
            charts.TickSpec<num>(4),
            charts.TickSpec<num>(6),
            charts.TickSpec<num>(8),
            charts.TickSpec<num>(10),
            charts.TickSpec<num>(12),
            charts.TickSpec<num>(14),
          ],
        ),
      ),
      barRendererDecorator: charts.BarLabelDecorator<String>(
          outsideLabelStyleSpec: charts.TextStyleSpec()),
      barGroupingType: charts.BarGroupingType.groupedStacked,
    );
  }
}

class LiveWerkzeuge {
  final String wsp;
  final int belastung;

  LiveWerkzeuge(this.wsp, this.belastung);
}
