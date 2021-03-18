import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  var _link = "";
  var _token;
  var _time;

  @override
  void initState() {

    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _token = prefs.getString('token');
        _time = new DateTime.now().millisecondsSinceEpoch;
        _link = "$_link?token=$_token&time=$_time";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("feed $_link");
    return WebviewScaffold(
      withJavascript: true,
      withZoom: false,
      withLocalStorage: true,
      hidden: true,
      url: _link,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Feed'),
        //leading: BackButton(color: Colors.white),
        /*actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.clear_all,
              size: 22,
              color: Colors.white,
            ),
            onPressed: () {
              print("clear notify");
            },
          ),
        ],*/
      ),
    );
  }
}
