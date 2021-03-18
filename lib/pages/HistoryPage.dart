import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import 'package:permission_handler/permission_handler.dart';

import 'package:smart_assis/components/HosData.dart';
import 'package:smart_assis/components/Footer.dart';

class HistoryPage extends StatefulWidget {
  final HosData hosData;

  const HistoryPage({Key key, this.hosData}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  //SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";

  // void initSpeechRecognizer() {
  //   _speechRecognition = SpeechRecognition();

  //   _speechRecognition.setAvailabilityHandler(
  //     (bool result) => setState(() => _isAvailable = result),
  //   );

  //   _speechRecognition.setRecognitionStartedHandler(
  //     () => setState(() => _isListening = true),
  //   );

  //   _speechRecognition.setRecognitionResultHandler(
  //       //(String speech) => setState(() => resultText = speech),
  //       (String speech) {
  //     //print("result = $speech");

  //     setState(() {
  //       _cc = speech;
  //     });
  //     _textCc.text = speech;
  //   });

  //   _speechRecognition.setRecognitionCompleteHandler(
  //       //() => setState(() => _isListening = false),
  //       () {
  //     setState(() {
  //       _isListening = false;
  //       //_cc = _cc.substring(0, 50);
  //     });
  //     _textCc.text = _cc;
  //   });

  //   _speechRecognition.activate().then(
  //         (result) => setState(() => _isAvailable = result),
  //       );
  // }

  ////  end  speech /////

  // final PermissionHandler _permissionHandler = PermissionHandler();

  //// end permission ////

  final _textCc = new TextEditingController();
  final _textDays = new TextEditingController();
  final _textBw = new TextEditingController();
  final _textBh = new TextEditingController();

  var _cc = "";
  var _days = "";
  num _bw;
  num _bh;
  var _bmi = "";

  var _link;
  var _token;

  void clearState() {
    _textCc.clear();
    _textDays.clear();
    _textBw.clear();
    _textBh.clear();
    setState(() {
      _cc = "";
      _days = "";
      _bw = null;
      _bh = null;
      _bmi = "";
    });
  }

  Future<Response> _post(String link, String token, String cc, String days,
      String bw, String bh, String bmi) async {
    return await http.post(Uri.parse(link), body: {
      'token': token,
      'cc': cc,
      'days': days,
      'bw': bw,
      'bh': bh,
      'bmi': bmi
    });
  }

  @override
  void initState() {
    super.initState();
    // initSpeechRecognizer();
    //clearState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _link = "${widget.hosData.assis}/post_history.php";
        _token = prefs.getString('token');
      });
    });

//   _permissionHandler
//       .checkPermissionStatus(PermissionGroup.microphone)
//       .then((status) {
//     print("mic status = $status");
//     if (status != PermissionStatus.granted) {
//       _permissionHandler
//           .requestPermissions([PermissionGroup.microphone]).then((result) {
//         print(result);
//       });
//     }
//   });

    // Future<PermissionStatus> _permissionHandler() async {
    //   PermissionStatus permission = await PermissionHandler()
    //       .checkPermissionStatus(PermissionGroup.microphone);
    //   if (permission != PermissionStatus.granted) {
    //     Map<PermissionGroup, PermissionStatus> permissionStatus =
    //         await PermissionHandler()
    //             .requestPermissions([PermissionGroup.microphone]);
    //     return permissionStatus[PermissionGroup.microphone] ??
    //         PermissionStatus.denied;
    //   } else {
    //     return permission;
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    print("build ${_link}");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ประวัติเจ็บป่วย'),
        leading: BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(26),
              child: Column(
                children: <Widget>[
                  //Text(widget.hosData.hosname,style: TextStyle(fontSize: 16),),
                  Text(""),
                  TextFormField(
                    maxLines: 2,
                    autofocus: false,
                    controller: _textCc,
                    //initialValue: null,
                    onChanged: (text) {
                      print("cc : $text");
                      setState(() {
                        _cc = text;
                      });
                    },
                    maxLength: 50,
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)),
                      hintText: '',
                      helperText: '*ระบุอาการเจ็บป่วยที่ต้องมาโรงพยาบาลวันนี้',
                      labelText: 'วันนี้เป็นอะไรมา',
                      prefixIcon: const Icon(
                        Icons.accessible,
                        color: Colors.orangeAccent,
                      ),
                      suffixIcon: IconButton(
                        // icon: Icon(FontAwesomeIcons.microphone),
                        icon: Icon(FontAwesomeIcons.keyboard),
                        onPressed: () {
                          _cc = "";
                          //_textCc.text = "";
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => _textCc.clear());
                          setState(() {});
                          //// พูด
                          // if (_isAvailable && !_isListening) {
                          //   _speechRecognition
                          //       .listen(locale: "th_TH")
                          //       .then((result) => print('listen $result'));
                          // }

                          /// จบพูด
                        },
                      ),
                    ),
                  ),
                  Text("", style: TextStyle(fontSize: 18)),
                  TextFormField(
                    autofocus: false,
                    controller: _textDays,
                    //initialValue: null,
                    onChanged: (text) {
                      print("days : $text");
                      setState(() {
                        _days = text;
                      });
                    },
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)),
                      hintText: '',
                      helperText: '*จำนวนวันตั้งแต่เริ่มมีอาการจนถึงวันนี้',
                      labelText: 'เป็นมากี่วัน',
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: Colors.orangeAccent,
                      ),
                      suffixText: 'วัน',
                      suffixStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  Text("", style: TextStyle(fontSize: 18)),
                  TextFormField(
                    autofocus: false,
                    controller: _textBw,
                    //initialValue: "0",
                    onChanged: (text) {
                      print("bw : $text");
                      setState(() {
                        _bw = num.parse(text);
                      });
                    },
                    maxLength: 5,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)),
                      hintText: '',
                      helperText: '',
                      labelText: 'น้ำหนักร่างกาย',
                      prefixIcon: const Icon(
                        Icons.check,
                        color: Colors.orangeAccent,
                      ),
                      suffixText: 'กิโลกรัม',
                      suffixStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  Text("", style: TextStyle(fontSize: 18)),
                  TextFormField(
                    autofocus: false,
                    controller: _textBh,
                    //initialValue: "0",
                    onChanged: (text) {
                      print("bh : $text");
                      setState(() {
                        _bh = num.parse(text);
                      });

                      var _bmi_ =
                          ((_bw) / pow((_bh / 100), 2)).toStringAsFixed(2);
                      //bmi = bmi.toStringAsFixed(2);
                      print("BMI = ${_bmi_}");
                      setState(() {
                        _bmi = _bmi_;
                      });
                    },
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)),
                      hintText: '',
                      helperText: '',
                      labelText: 'ส่วนสูง',
                      prefixIcon: const Icon(
                        Icons.check,
                        color: Colors.orangeAccent,
                      ),
                      suffixText: 'เซนติเมตร',
                      suffixStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),

                  Text("", style: TextStyle(fontSize: 6)),
                  Text(
                    _bmi.isNotEmpty ? "ดัชนีมวลกาย ${_bmi}" : "",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.amber,
                    ),
                  ),
                  Text("", style: TextStyle(fontSize: 6)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.greenAccent,
                        child: Text("ส่งประวัติ"),
                        onPressed: () {
                          print("post ${_link}");
                          if (_cc == "" && _days == "") {
                            return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(
                                      "กรุณากรอกอาการ และจำนวนวันที่เป็นมา"),
                                );
                              },
                            );
                          }
                          _post(_link, _token, _cc, _days, _bw.toString(),
                                  _bh.toString(), _bmi)
                              .then((resp) {
                            print(resp.body);
                            Map<String, dynamic> _resp = jsonDecode(resp.body);
                            if (resp.statusCode == 200) {
                              print('OK');
                              clearState();
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text("ส่งข้อมูลสำเร็จ"),
                                  );
                                },
                              );
                            } else {
                              var err = resp.statusCode.toString();
                              print("respons ${err}");
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                        "ส่งข้อมูลไม่สำเร็จ (ผิดพลาด:${err})"),
                                  );
                                },
                              );
                            }
                          });
                        },
                      ),
                      Text("     "),
                      RaisedButton(
                        color: Colors.pinkAccent,
                        child: Text(
                          'ยกเลิก',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          clearState();
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(widget.hosData.hosname),
    );
  }
}

// class PermissionGroup {
//   static var microphone;
// }

// class PermissionHandler {
//   requestPermissions(List list) {}

//   checkPermissionStatus(microphone) {}
// }
