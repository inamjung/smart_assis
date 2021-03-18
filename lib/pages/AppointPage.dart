import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_assis/components/Footer.dart';
import 'package:smart_assis/components/HosData.dart';

class AppointPage extends StatefulWidget {
  final HosData hosData;
  const AppointPage({Key key, this.hosData}) : super(key: key);

  @override
  _AppointPageState createState() => _AppointPageState();
}

class _AppointPageState extends State<AppointPage> {
  var _token;
  var _time;
  String _link;
  String _hosname;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      String _a = prefs.getString('assis') ?? null;
      setState(() {
        _hosname = prefs.getString('hosname') ?? "การนัด";
        _token = prefs.getString('token');
        _time = new DateTime.now().millisecondsSinceEpoch;
        _link = "${_a}/web_appoint.php?token=${_token}&time=${_time}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("link : ${_link}");

    return WebviewScaffold(
      withJavascript: true,
      withZoom: false,
      withLocalStorage: true,
      hidden: true,
      url: _link,
      appBar: AppBar(
        centerTitle: true,
        title: Text("การนัด"),
        leading: BackButton(color: Colors.white),
      ),
      bottomNavigationBar: Footer(_hosname),
    );
  }
}
