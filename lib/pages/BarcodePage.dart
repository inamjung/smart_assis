import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_assis/components/Footer.dart';
import 'package:smart_assis/components/HosData.dart';

class BarcodePage extends StatefulWidget {
  final HosData hosData;
  const BarcodePage({Key key, this.hosData}) : super(key: key);
  @override
  _BarcodePageState createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
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
        "${widget.hosData.assis}/web_qr.php?token=${_token}&time=${_time}";
    print("link : ${link}");

    return WebviewScaffold(
      withJavascript: true,
      withZoom: false,
      withLocalStorage: true,
      hidden: true,
      url: link,
      appBar: AppBar(
        centerTitle: true,
        title: Text('รหัสแถบ'),
        leading: BackButton(color: Colors.white),
      ),
      bottomNavigationBar: Footer(widget.hosData.hosname),
    );
  }
}
