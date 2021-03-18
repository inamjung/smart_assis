import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_assis/components/Footer.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
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
        _hosname = prefs.getString('hosname') ?? "News";
        _token = prefs.getString('token');
        _time = new DateTime.now().millisecondsSinceEpoch;
        _link = "${_a}/web_news.php?token=${_token}&time=${_time}";
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
        title: Text('ข่าวสารจากโรงพยาบาล'),
        leading: BackButton(color: Colors.white),
      ),
      bottomNavigationBar: Footer("News"),
    );
  }
}
