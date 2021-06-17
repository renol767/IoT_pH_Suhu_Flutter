import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'package:monitoringsuhu/models/livewerkzeuge.dart';

class GraphPH extends StatefulWidget {
  @override
  _GraphPHState createState() => _GraphPHState();
}

class _GraphPHState extends State<GraphPH> {
  List listgraph = [];
  Timer timer;
  Future<String> getGraph() async {
    http.Response response =
        await http.get("http://192.168.1.3/dht11/api/sensorgraph");
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
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    Text(
                      "Grafik pH",
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
            charts.ColorUtil.fromDartColor(Colors.blue),
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
          ],
        ),
      ),
      barRendererDecorator: charts.BarLabelDecorator<String>(
          outsideLabelStyleSpec: charts.TextStyleSpec()),
      barGroupingType: charts.BarGroupingType.groupedStacked,
    );
  }
}
