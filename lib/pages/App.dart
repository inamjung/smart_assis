import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_assis/pages/SettingPage.dart';
import 'package:smart_assis/pages/QueuePage.dart';
import 'package:smart_assis/pages/ServicePage.dart';
import 'package:smart_assis/pages/NewsPage.dart';
import 'package:smart_assis/pages/BroadCastPage.dart';

import 'package:smart_assis/pages/AppointPage.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String _token = '';
  int _tabIndex = 0;

  final List<Widget> _children = [
    ServicePage(),
    SettingPage(),
  ];

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initFirebaseMessaging() {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        Map mapNotification = message["notification"];
        String title = mapNotification["title"];
        String body = mapNotification["body"];

        // showNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        Map mapData = message["data"];
        String screen = mapData['screen'];

        if (screen == null) {
          return;
        }
        if (screen == "QueuePage") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QueuePage(),
            ),
          );
          return;
        }
        if (screen == "NewsPage") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsPage(),
            ),
          );
          return;
        }
        if (screen == "BroadCastPage") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BroadCastPage(),
            ),
          );
          return;
        }

        if (screen == "AppointPage") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointPage(),
            ),
          );
          return;
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        Map mapData = message["data"];
        String screen = mapData['screen'];

        if (screen == null) {
          return;
        }
        if (screen == "QueuePage") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QueuePage(),
            ),
          );
          return;
        }
        if (screen == "NewsPage") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsPage(),
            ),
          );
          return;
        }

        if (screen == "BroadCastPage") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BroadCastPage(),
            ),
          );
          return;
        }

        if (screen == "AppointPage") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointPage(),
            ),
          );
          return;
        }
      },
    );
  }

  showNotification(Map<String, dynamic> message) async {
    Map mapNotification = message["notification"];
    String title = mapNotification['title'];
    String body = mapNotification['body'];

    Map mapData = message["data"];
    String screen = mapData['screen'];

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '10000', 'SMART_ASSIS', 'SMART_ASSIS_FCM',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      //largeIcon: "ic_launcher",
      //style: AndroidNotificationStyle.Messaging,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      9999,
      '$title',
      '$body',
      platformChannelSpecifics,
      payload: screen,
    );
  }

  Future onSelectNotification(String payload) async {
    print('click fcm payload: $payload');
    if (payload == null) {
      return;
    }
    if (payload == "QueuePage") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QueuePage(),
        ),
      );
      return;
    }
    if (payload == "NewsPage") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsPage(),
        ),
      );
      return;
    }

    if (payload == "BroadCastPage") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BroadCastPage(),
        ),
      );
      return;
    }

    if (payload == "AppointPage") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppointPage(),
        ),
      );
      return;
    }
  }

  @override
  void initState() {
    initFirebaseMessaging();

    var android = new AndroidInitializationSettings('drawable/ic_stat_nurse');
    var ios = new IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
      print("onDidReceiveLocalNotification called.");
    });
    var initPlatform = new InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(initPlatform,
        onSelectNotification: onSelectNotification);

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    super.initState();

    firebaseMessaging.getToken().then((token) {
      print("get token : $token");
      setState(() {
        _token = token;
      });
    });
  } // initState

  void onTabTapped(int index) {
    setState(() {
      _tabIndex = index;
    });

    SharedPreferences.getInstance().then((prefs) {
      String isToken = prefs.getString('token') ?? 'null';
      if (isToken == 'null') {
        prefs.setString('token', _token);
        print('token saved :$_token');
      } else {
        print('token exists :$_token');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _tabIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('บริการ'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('เชื่อมต่อ'),
          ),
        ],
      ),
    );
  }
}
