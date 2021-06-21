import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/services.dart';
import 'package:monitoringsuhu/screen/graph.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:monitoringsuhu/screen/sensordata.dart';
import 'package:monitoringsuhu/screen/timeline.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  DateTime currentBackPressTime;
  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Tekan Lagi Untuk Keluar");
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[SensorData(), Graph(), TimeLine()],
          ),
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
              title: Text('Schedule'),
              icon: Icon(FlutterIcons.schedule_mdi),
              activeColor: Colors.orangeAccent),
        ],
      ),
    );
  }
}
