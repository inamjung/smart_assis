import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_assis/components/Footer.dart';

class TablePage extends StatefulWidget {
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
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
        _hosname = prefs.getString('hosname') ?? "ตารางแพทย์";
        _token = prefs.getString('token');
        _time = new DateTime.now().millisecondsSinceEpoch;
        _link = "${_a}/web_table.php?token=${_token}&time=${_time}";
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
        title: Text('ตารางแพทย์'),
        leading: BackButton(color: Colors.white),
      ),
      bottomNavigationBar: Footer("Table"),
    );
  }
}
