import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_assis/components/HosData.dart';
import 'package:http/http.dart' as http;

class HolderPage extends StatefulWidget {
  final HosData hosData;

  const HolderPage({Key key, this.hosData}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HolderPageState();
  }
}

class _HolderPageState extends State<HolderPage> {
  String _link;
  String _token;
  String _cid;
  String _byear;
  bool connected;
  String _title = "ยืนยัน";

  @override
  void initState() {
    //setCid();
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _link = "${widget.hosData.assis}/post_register.php";
        _token = prefs.getString('token');
      });
    });
  }

  //บันทึกcidในเครื่อง
  Future<Response> _post(
      String link, String token, String cid, String byear) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cid', _cid);

    return await http.post(Uri.parse(link), body: {
      'token': token,
      'cid': cid,
      'byear': byear,
    });
  }

//  Future<Null> setCid() async {
//    // จำค่า CID
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.setString('cid', _cid);
//  }

  @override
  Widget build(BuildContext context) {
    print("assis_url : ${widget.hosData.assis}/post_register.php");

    if (widget.hosData.assis == null ||
        widget.hosData.assis.trim().length <= 10) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.hosData.hosname),
          leading: BackButton(color: Colors.white),
        ),
        body: Center(
          child: Text(
            "โรงพยาบาลนี้ยังไม่เปิด\nให้บริการบนแอพพลิเคชั่น",
            style: TextStyle(color: Colors.black45, fontSize: 22),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(_title),
        leading: BackButton(color: Colors.white),
      ),
      body: ListView(
        children: [
          Column(
            children: <Widget>[
              Text(""),
              Text(
                widget.hosData.hosname,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(26.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      onChanged: (text) {
                        print("CID : $text");

                        setState(() {
                          _cid = text;
                        });
                      },
                      maxLength: 13,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                        hintText: '',
                        helperText: '',
                        labelText: 'เลขบัตรประชาชน',
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                    Text(""),
                    TextField(
                      onChanged: (text) {
                        print("BYEAR : $text");
                        setState(() {
                          _byear = text;
                        });
                      },
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                        hintText: '',
                        helperText: '',
                        labelText: 'พ.ศ.เกิด',
                        prefixIcon: const Icon(
                          Icons.calendar_today,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      height: 60,
                      child: RaisedButton(
                        onPressed: () {
                          if (_cid == null || _byear == null) {
                            print("CID NULL");
                            return;
                          }

                          if (_cid == '18' && _byear == '19') {
                            // test
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.setBool('connected', true);

                              prefs.setString(
                                  'hoscode', widget.hosData.hoscode);
                              prefs.setString(
                                  'hosname', widget.hosData.hosname);
                              prefs.setString('assis', widget.hosData.assis);

                              Navigator.pop(context, true);
                            });
                            return;
                          } // end test

                          _post(_link, _token, _cid, _byear).then((res) async {
                            print("statusCode ${res.statusCode}");

                            if (res.statusCode == 200) {
                              print(res.body);

                              Map<String, dynamic> data = jsonDecode(res.body);

                              print("status = ${data['status']}");

                              setState(() {
                                _title = 'สำเร็จ';
                              });

                              switch (data['status']) {
                                case '0':
                                  break;
                                case '1':
                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.setBool('connected', true);

                                    prefs.setString(
                                        'hoscode', widget.hosData.hoscode);
                                    prefs.setString(
                                        'hosname', widget.hosData.hosname);
                                    prefs.setString(
                                        'assis', widget.hosData.assis);

                                    Navigator.pop(context, true);
                                  });
                                  break;
                                case '2':
                                  setState(() {
                                    _title = "ไม่พบประวัติ";
                                  });
                                  break;
                              }
                            } else {
                              setState(() {
                                _title = "เชื่อมต่อไม่สำเร็จ";
                              });
                            }
                          });
                        },
                        child: Text(
                          'เชื่อมต่อ',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        color: Colors.tealAccent,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
