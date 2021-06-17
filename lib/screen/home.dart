import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:monitoringsuhu/screen/graph.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:monitoringsuhu/screen/sensordata.dart';
import 'package:monitoringsuhu/screen/timeline.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          children: <Widget>[SensorData(), Graph(), ProcessTimelinePage()],
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
              title: Text('Data'),
              icon: Icon(FlutterIcons.circular_graph_ent),
              activeColor: Colors.blue),
          BottomNavyBarItem(
              title: Text('Graph'),
              icon: Icon(FlutterIcons.bar_graph_ent),
              activeColor: Colors.green),
          BottomNavyBarItem(
              title: Text('Timeline'),
              icon: Icon(FlutterIcons.timer_sand_mco),
              activeColor: Colors.orangeAccent),
        ],
      ),
    );
  }
}
