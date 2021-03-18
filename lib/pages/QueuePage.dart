import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_assis/components/Footer.dart';
import 'package:smart_assis/components/HosData.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:package_info/package_info.dart';

class QueuePage extends StatefulWidget {
  final HosData hosData;

  const QueuePage({Key key, this.hosData}) : super(key: key);

  @override
  _QueuePageState createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {
  String _assis;

  var _version;
  var _buildNumber;

  Future<List<Data>> getData(String url) async {
    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Accept": "application/json"});
      print(response.body);
      if (response.statusCode == 200) {
        List<Data> list = parseJson(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  List<Data> parseJson(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Data>((json) => Data.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      String _a = prefs.getString('assis') ?? null;
      String _token = prefs.getString('token') ?? null;
      if (_a != null && _a != "" && _a.length > 5) {
        setState(() {
          _assis = "${_a}/json_queue.php?token=$_token";
        });
      }
    });

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print("assis $_assis");
    return TimerBuilder.periodic(Duration(seconds: 8), builder: (context) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('คิวของท่าน'),
          leading: BackButton(color: Colors.white),
        ),
        //backgroundColor: ,
        body: SingleChildScrollView(
          child: Center(
            child: _assis != null
                ? FutureBuilder(
                    future: getData(_assis),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          // TODO: Handle this case.
                          return Center();
                          break;
                        case ConnectionState.waiting:
                          // TODO: Handle this case.
                          return Center(
                              //child: CircularProgressIndicator(),
                              );
                          break;
                        case ConnectionState.active:
                          // TODO: Handle this case.
                          return Center();
                          break;
                        case ConnectionState.done:
                          //print("snapshot ${snapshot.connectionState}");
                          print("snapshot: ${snapshot.data}");
                          if (snapshot.data == null) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 100),
                                  child: Center(
                                    child: Text(
                                      'พบข้อผิดพลาด',
                                      style: TextStyle(
                                          color: Colors.black45, fontSize: 22),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return Padding(
                            padding: EdgeInsets.only(top: 35),
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(12),
                              padding: EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(11)),
                                child: Container(
                                  height: 300,
                                  width: 320,
                                  color: Colors.white,
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "HN : ${snapshot.data[0].hn}",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Text(""),
                                      Text(
                                        "หมายเลข : ${snapshot.data[0].number}",
                                        style: TextStyle(fontSize: 35),
                                      ),
                                      Text(""),
                                      Text(
                                        "${snapshot.data[0].message}",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(""),
                                      Text("กรุณาไปรอที่บริเวณ"),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${snapshot.data[0].location}",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Text(""),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                            "เวลา : ${snapshot.data[0].server_time}",
                                            style: TextStyle(fontSize: 14)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                          break;
                      }
                    },
                  )
                : Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Center(
                          child: Text(
                            'เชื่อมต่อไม่ได้',
                            style:
                                TextStyle(color: Colors.black45, fontSize: 22),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        bottomNavigationBar: Footer("อัพเดท 10 วินาที"),
      );
    });
  }
}

class Data {
  String server_time, hn, number, location, message;

  Data({this.server_time, this.hn, this.number, this.location, this.message});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      server_time: json['server_time'] as String,
      hn: json['hn'] as String,
      number: json['number'] as String,
      location: json['location'] as String,
      message: json['message'] as String,
    );
  }
}
