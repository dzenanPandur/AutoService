import 'package:flutter/material.dart';
import 'tab_item.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;
  final String userId;
  const TabNavigator({
    Key? key,
    required this.navigatorKey,
    required this.tabItem,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        Widget screen;
        switch (tabItem) {
          case TabItem.home:
            screen = HomeScreen(userId: userId);
            break;
          case TabItem.profile:
            screen = ProfileScreen(userId: userId);
            break;
        }
        return MaterialPageRoute(
          builder: (context) {
            return KeyedSubtree(
              key: UniqueKey(),
              child: screen,
            );
          },
        );
      },
    );
  }
}
