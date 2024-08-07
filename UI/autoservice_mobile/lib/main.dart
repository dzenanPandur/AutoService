import 'dart:io';
import 'package:flutter/material.dart';
import 'package:autoservice_mobile/providers/AuthProvider.dart';
import 'package:autoservice_mobile/screens/login_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '.env';
import 'navigation/bottom_navigation.dart';
import 'navigation/tab_item.dart';
import 'navigation/tab_navigator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  late String stripePk;
  stripePk = const String.fromEnvironment("stripePublishableKey",
      defaultValue: stripePublishableKey);
  Stripe.publishableKey = stripePk;
  final AuthProvider authProvider = AuthProvider();
  const String userId = "";
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(authProvider: authProvider, userId: userId));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;
  final String userId;
  const MyApp({Key? key, required this.authProvider, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'GB'),
      ],
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(authProvider: authProvider),
        '/home': (context) => MyHomePage(
              authProvider: authProvider,
              userId: userId,
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final AuthProvider authProvider;
  final String userId;

  MyHomePage({Key? key, required this.authProvider, required this.userId})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>()
  };
  TabItem _currentTab = TabItem.home;

  void _selectTab(TabItem tabItem) {
    if (_currentTab == tabItem) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = tabItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await _navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: Scaffold(
        body: Stack(
          children: [
            _buildOffstageNavigator(TabItem.home),
            _buildOffstageNavigator(TabItem.profile)
          ],
        ),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem]!,
        tabItem: tabItem,
        userId: widget.userId,
      ),
    );
  }
}
