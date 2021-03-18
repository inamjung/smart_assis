import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class PolicyPage extends StatefulWidget {
  @override
  _PolicyPageState createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  @override
  Widget build(BuildContext context) {
    var link = "https://smartqplk.com/privacy/";
    return WebviewScaffold(
      withJavascript: true,
      withZoom: false,
      withLocalStorage: true,
      hidden: true,
      url: link,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("นโยบายความปลอดภัย"),
        // leading: BackButton(color: Colors.white),
      ),


      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(label: 'ยอมรับ',
            icon: Icon(Icons.check_box)),
        BottomNavigationBarItem(label: 'ไม่ยอมรับ',icon: Icon(Icons.remove_circle_outlined)),
      ],),
    );
  }
}
