import 'package:autoservice_mobile/globals.dart';
import 'package:flutter/material.dart';
import 'tab_item.dart';

class BottomNavigation extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  const BottomNavigation({
    required this.currentTab,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: fontColor,
      selectedItemColor: secondaryColor,
      currentIndex: currentTab.index,
      onTap: (index) => onSelectTab(TabItem.values[index]),
      items: TabItem.values.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(tabIcon[item]),
          label: tabName[item],
        );
      }).toList(),
    );
  }
}
