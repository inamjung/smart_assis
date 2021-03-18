import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_assis/components/Footer.dart';
import 'package:smart_assis/components/HosData.dart';

class LabPage extends StatefulWidget {
  final HosData hosData;

  const LabPage({Key key, this.hosData}) : super(key: key);

  @override
  _LabPageState createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  var _token;
  var _time;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _token = prefs.getString('token');
        _time = new DateTime.now().millisecondsSinceEpoch;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var link =
        "${widget.hosData.assis}/web_lab.php?token=${_token}&time=${_time}";
    print("link : ${link}");

    return WebviewScaffold(
      withJavascript: true,
      withZoom: false,
      withLocalStorage: true,
      hidden: true,
      url: link,
      appBar: AppBar(
        centerTitle: true,
        title: Text("ผลแล็บ"),
        leading: BackButton(color: Colors.white),
      ),
      bottomNavigationBar: Footer(widget.hosData.hosname),
    );
  }
}
