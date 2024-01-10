// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import '../screens.dart';

void main() {
  runApp(const TabBarTopScreen());
}

class TabBarTopScreen extends StatelessWidget {
  const TabBarTopScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    List<TabData> tabs = [
      TabData(
        index: 1,
        title: const Tab(
          text: 'Paso 1',
        ),
        content: const PersonalDataScreen(),
      ),
      TabData(
        index: 2,
        title: const Tab(
          text: 'Paso 2',
        ),
        content: const Icon(Icons.directions_transit),
      ),
      TabData(
        index: 3,
        title: const Tab(
          text: 'Paso 3',
        ),
        content: const Icon(Icons.directions_bike),
      ),
    ];

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: DynamicTabBarWidget(
              dynamicTabs: tabs,
              isScrollable: true, // Customize as needed
              onTabChanged: (index) {
                // Handle tab change events here
                print('Tab changed to: $index');
                // ignore: avoid_types_as_parameter_names
              },
              onTabControllerUpdated: (TabController) {},
            ),
          ),
        ],
      ),
    );
  }
}
