// import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_assis/components/HosData.dart';
import 'package:smart_assis/pages/TablePage.dart';

import 'AppointPage.dart';
import 'BarcodePage.dart';
import 'BookingPage.dart';
import 'ChargePage.dart';
import 'DrugPage.dart';
import 'HistoryPage.dart';
import 'LabPage.dart';
import 'NewsPage.dart';
import 'ProfilePage.dart';
import 'QueuePage.dart';
import 'SitPage.dart';
//import 'package:smart_assis/callveiws/Admincall.dart';
//
//import 'package:smart_assis/callveiws/Requestcall.dart';

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  var _token;
  bool _con = false;
  String _title = '';

  var hosData;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _token = prefs.getString('token') ?? 'null';
        _con = prefs.getBool('connected') ?? false;
        _title = prefs.getString('hosname') ?? "นโยบายความปลอดภัย";

        hosData = HosData(
          prefs.getString('hoscode'),
          prefs.getString('hosname'),
          prefs.getString('assis'),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var link = "https://smartqplk.com/privacy/";
    print("link : ${link}");
    var gridView = GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      children: <Widget>[
        MyMenu(
          "ข้อมูลส่วนตัว",
          FontAwesomeIcons.addressCard,
          Colors.amber,
          ProfilePage(
            hosData: hosData,
          ),
        ),
        MyMenu(
          "บอกอาการ",
          FontAwesomeIcons.stethoscope,
          Colors.amber,
          HistoryPage(
            hosData: hosData,
          ),
        ),
        MyMenu(
          "เตือนคิว",
          Icons.notifications_active,
          Colors.amber,
          QueuePage(
            hosData: hosData,
          ),
        ),
        MyMenu(
          "ผลแล็บ",
          Icons.local_hospital,
          Colors.amber,
          LabPage(
            hosData: hosData,
          ),
        ),
        MyMenu(
          "ประวัติ",
          FontAwesomeIcons.prescription,
          Colors.amber,
          DrugPage(
            hosData: hosData,
          ),
        ),
        MyMenu(
          "ค่าใช้จ่าย",
          Icons.monetization_on,
          Colors.amber,
          ChargePage(
            hosData: hosData,
          ),
        ),
        MyMenu(
          "วันนัด",
          Icons.calendar_today,
          Colors.amber,
          AppointPage(
            hosData: hosData,
          ),
        ),
        MyMenu(
          "จองคิว",
          FontAwesomeIcons.calendarCheck,
          Colors.amber,
          BookingPage(
            hosData: hosData,
          ),
        ),
        MyMenu(
          "รหัสแถบ",
          FontAwesomeIcons.qrcode,
          Colors.amber,
          BarcodePage(
            hosData: hosData,
          ),
        ),
        MyMenu(
          "สิทธิรักษา",
          FontAwesomeIcons.checkCircle,
          Colors.amber,
          SitPage(
            hosData: hosData,
          ),
        ),
        MyMenu(
          "ข่าวสาร",
          Icons.message,
          Colors.amber,
          NewsPage(),
        ),
        MyMenu(
          "ตารางแพทย์",
          Icons.table_view,
          Colors.amber,
          TablePage(),
        ),
        // MyMenu(
        //   "สื่อสุขภาพ",
        //   FontAwesomeIcons.heart,
        //   Colors.amber,
        //   MediaPage(hosData: hosData),
        // ),
        // MyMenu("พึงพอใจ", FontAwesomeIcons.star, Colors.amber,
        //     StarPage(hosData: hosData)),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_title),
      ),
      backgroundColor: Colors.black12,
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: _con
            ? gridView
            :
            // Navigator.push(context,
            // MaterialPageRoute(builder: (BuildContext context) => PolicyPage())),
            WebviewScaffold(
                withJavascript: true,
                withZoom: false,
                withLocalStorage: true,
                hidden: true,
                url: link,
                // appBar: AppBar(
                //   centerTitle: true,
                //   title: Text("นโยบายความปลอดภัย"),
                //   leading: BackButton(color: Colors.white),
                // ),
                // bottomNavigationBar: BottomNavigationBar(items: [
                //   BottomNavigationBarItem(label: 'ยอมรับ',
                //       icon: Icon(Icons.check_box)),
                //   BottomNavigationBarItem(label: 'ไม่ยอมรับ',icon: Icon(Icons.remove_circle_outlined)),
                // ],),
              ),
      ),
    );
  }
}

class MyMenu extends StatelessWidget {
  MyMenu(this.title, this.icon, this.warna, this.page);

  final String title;
  final IconData icon;
  final MaterialColor warna;

  final page;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        splashColor: Colors.amberAccent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                size: 40.0,
                color: warna,
              ),
              Text(
                "",
                style: TextStyle(fontSize: 1.5),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
