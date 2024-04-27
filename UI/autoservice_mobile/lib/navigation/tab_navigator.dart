import 'package:flutter/material.dart';
import 'tab_item.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;
  final String userId;
  const TabNavigator({
    super.key,
    required this.navigatorKey,
    required this.tabItem,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(
              builder: (context) => tabItem == TabItem.home
                  ? HomeScreen(userId: userId)
                  : const ProfileScreen(),
            );
          default:
            return null;
        }
      },
    );
  }
}
