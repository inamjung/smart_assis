import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:splashscreen/splashscreen.dart';
import 'App.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var _version;
  var _buildNumber;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: new App(),
      title: Text(
        'Smart Assis ${_version}',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black),
      ),
      image: Image.asset('assets/images/splash.png'),
      gradientBackground: LinearGradient(
        colors: [Colors.white, Colors.amber],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 75.0,
      onClick: () => print("Smart Assis"),
      loaderColor: Colors.white,
    );
  }
}
