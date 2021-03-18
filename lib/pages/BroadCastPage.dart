import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_assis/components/Footer.dart';

class BroadCastPage extends StatefulWidget {
  @override
  _BroadCastPageState createState() => _BroadCastPageState();
}

class _BroadCastPageState extends State<BroadCastPage> {
  var _token;
  var _time;
  String _link;
  final String _a = 'http://www.smartqplk.com/web/broadcast.php';

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _token = prefs.getString('token');
        _time = new DateTime.now().millisecondsSinceEpoch;
        _link = "${_a}?token=${_token}&time=${_time}";
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
        title: Text('ข่าวสารน่าสนใจ'),
        leading: BackButton(color: Colors.white),
      ),
      bottomNavigationBar: Footer("News"),
    );
  }
}
