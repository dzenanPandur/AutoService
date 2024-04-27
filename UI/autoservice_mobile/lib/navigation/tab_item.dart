import 'package:flutter/material.dart';

enum TabItem { home, profile }

const Map<TabItem, String> tabName = {
  TabItem.home: 'Home',
  TabItem.profile: 'Profile'
};

const Map<TabItem, IconData> tabIcon = {
  TabItem.home: Icons.home,
  TabItem.profile: Icons.person
};
