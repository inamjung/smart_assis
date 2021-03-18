import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_assis/components/HosData.dart';
import 'package:smart_assis/pages/App.dart';
import 'HolderPage.dart';
import 'dart:async';

class SettingPage extends StatefulWidget {
  final HosData hosData;

  const SettingPage({Key key, this.hosData}) : super(key: key);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _con = false;

  var _token;
  var _time;
  final _debouncer = Debouncer(milliseconds: 500);
  List<Hospital> hospitals = [];
  List<Hospital> filteredUsers = [];

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _con = prefs.getBool('connected') ?? false;
      });

      if (!_con) {
        MyApi.getData().then((usersFromServer) {
          setState(() {
            hospitals = usersFromServer;
            filteredUsers = hospitals;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getBack(value) async {
    print("getback...${value}");
    setState(() {
      _con = value == null ? false : value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: !_con ? Text('เชื่อมต่อ') : Text('เชื่อมต่อสำเร็จ'),
      ),
      body: !_con
          ? Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: 'ค้นหา',
                      prefixIcon: const Icon(Icons.search)),
                  onChanged: (string) {
                    _debouncer.run(() {
                      setState(() {
                        filteredUsers = hospitals
                            .where((h) => (h.hosname
                                    .toLowerCase()
                                    .contains(string.toLowerCase()) ||
                                h.province
                                    .toLowerCase()
                                    .contains(string.toLowerCase())))
                            .toList();
                      });
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: filteredUsers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            var hosData = HosData(
                              filteredUsers[index].hoscode,
                              filteredUsers[index].hosname,
                              filteredUsers[index].assis,
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return HolderPage(hosData: hosData);
                                },
                              ),
                            ).then((value) => _getBack(value));
                          },
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    filteredUsers[index].hosname,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    filteredUsers[index].province,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
                child: ListView(
                  children: [
                    Container(
                        width: 160,
                        height: 150,
                        child: Image(
                          image: AssetImage('assets/images/nurse.png'),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(1, 5, 10, 10),
                          child: Text(
                            'Smart Assis',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ผู้ช่วยเหลือ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1, 5, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'เมื่อท่านมาโรงพยาบาล',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => App()));
                          },
                          child: Text(
                            "เริ่มใช้งานผู้ช่วยของคุณ",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          color: const Color(0xFFff9800),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed: () {
                            setState(() {
                              _con = false;
                            });

                            if (!_con) {
                              MyApi.getData().then((dataFromServer) {
                                setState(() {
                                  hospitals = dataFromServer;
                                  filteredUsers = hospitals;
                                });
                              });
                            }

                            SharedPreferences.getInstance().then((prefs) {
                              prefs.clear();
                              setState(() {});
                              //exit(0);
                            });
                          },
                          child: Text(
                            "ยกเลิกการเชื่อมต่อ",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          color: Colors.deepOrange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class Hospital {
  //model
  String hoscode;
  String hosname;
  String province;
  String assis;

  Hospital({this.hoscode, this.hosname, this.province, this.assis});

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
        hoscode: json["hoscode"] as String,
        hosname: json["hosname"] as String,
        province: json["province"] as String,
        assis: json["assis"] as String);
  }
}

class MyApi {
  // api
  static const String url = "http://203.157.118.75:8000/list";
  // static const String url =
  //     "https://smartqplk.com/assis_index/web/index.php?r=hos/index";

  static Future<List<Hospital>> getData() async {
    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
      if (response.statusCode == 200) {
        List<Hospital> list = parseUsers(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception("Error");
    }
  }

  static List<Hospital> parseUsers(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Hospital>((json) => Hospital.fromJson(json)).toList();
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
