import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_assis/components/HosData.dart';
import 'package:smart_assis/components/Footer.dart';

class DrugPage extends StatefulWidget {
  final HosData hosData;

  const DrugPage({Key key, this.hosData}) : super(key: key);

  @override
  _DrugPageState createState() => _DrugPageState();
}

class _DrugPageState extends State<DrugPage> {
  var _token;
  var _time;
  var _cid;
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _token = prefs.getString('token');
        _cid = prefs.getString('cid');
        _time = new DateTime.now().millisecondsSinceEpoch;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var link =
        "${widget.hosData.assis}/web_drug.php?token=${_token}&time=${_time}";
    print("link : ${link} : CID : ${_cid}");

    return WebviewScaffold(
      withJavascript: true,
      withZoom: false,
      withLocalStorage: true,
      hidden: true,
      url: link,
      appBar: AppBar(
        centerTitle: true,
        title: Text('รายการยา'),
        leading: BackButton(color: Colors.white),
      ),
      bottomNavigationBar: Footer(widget.hosData.hosname),
    );
  }
}
