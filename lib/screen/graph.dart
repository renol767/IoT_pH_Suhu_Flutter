import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:monitoringsuhu/models/livewerkzeuge.dart';
import 'package:monitoringsuhu/screen/graph/hum.dart';
import 'package:monitoringsuhu/screen/graph/ph.dart';
import 'package:monitoringsuhu/screen/graph/temp.dart';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[GraphTemp(), GraphHum(), GraphPH()],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text('Temperature'),
              icon: Icon(FlutterIcons.temperature_celsius_mco),
              activeColor: Colors.orangeAccent),
          BottomNavyBarItem(
              title: Text('Humadity'),
              icon: Icon(FlutterIcons.water_mco),
              activeColor: Colors.green),
          BottomNavyBarItem(
              title: Text(' pH'),
              icon: Icon(FlutterIcons.water_faw5s),
              activeColor: Colors.blue),
        ],
      ),
    );
  }
}
