import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import './widgets/TopContainer.dart';
import './widgets/BusCard.dart';
import './widgets/BusInfo.dart';
import './BusPage.dart';
import 'dart:convert';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarIconBrightness: Brightness.dark, // status bar icons' color
    systemNavigationBarIconBrightness:
        Brightness.dark, //navigation bar icons' color // transparent status bar
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      theme: ThemeData.light(),
    );
  }
}

class BusData {
  final String status;
  final String cur;
  final Map<dynamic, dynamic> result;

  BusData({Key key, this.status, this.cur, this.result});

  factory BusData.fromJson(Map<String, dynamic> json) {
    return BusData(
      status: json['status'],
      cur: json['cur'],
      result: json['result'],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<BusData> busData;

  Future<BusData> _fetch1() async {
    try {
      print("future 실행!");
      http.Response response =
          await http.get('https://us-central1-kmouin-62d7f.cloudfunctions.net/api/bus');
      if (response.statusCode == 200) {
        // final busInfo = json.decode(response.body);
        return BusData.fromJson(json.decode(response.body));
      } else {
        throw Exception("Failed to load data");
      }
    } catch (err) {
      print("error!");
      return BusData.fromJson({
        "status": "error",
        "cur": "error",
        "result": {
          "bus190": {
            "week": [
              {"min": "", "content": ""},
              {"min": "", "content": ""},
              {"min": "", "content": ""}
            ],
            "saturday": [
              {"min": "", "content": ""},
              {"min": "", "content": ""},
              {"min": "", "content": ""}
            ],
            "weekend": [
              {"min": "", "content": ""},
              {"min": "", "content": ""},
              {"min": "", "content": ""}
            ]
          },
          "shuttle": {
            "week": [
              {"min": "", "content": ""},
              {"min": "", "content": ""},
              {"min": "", "content": ""}
            ],
            "vacation": [
              {"min": "", "content": ""},
              {"min": "", "content": ""},
              {"min": "", "content": ""}
            ],
            "exam": [
              {"min": "", "content": ""},
              {"min": "", "content": ""},
              {"min": "", "content": ""}
            ]
          }
        }
      });
    }
  }

  void initState() {
    super.initState();
    busData = _fetch1();
  }

  @override
  Widget build(BuildContext context) {
    double rate = 1 / 375.0;
    double fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Center(child: Icon(Icons.arrow_back_ios)),
        titleSpacing: -15,
        title: Text(
          "메인",
          style: const TextStyle(
            color: const Color(0xffffffff),
            fontWeight: FontWeight.w300,
            fontFamily: "NotoSansKR",
            fontStyle: FontStyle.normal,
            // fontSize: 16.0,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(),
          TopContainer(
            child: Image.asset('images/BusPage/TopContainer.png'),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Text(
                    "버스 정보",
                    style: const TextStyle(
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w500,
                      fontFamily: "NotoSansKR",
                      fontStyle: FontStyle.normal,
                      fontSize: 32.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "실시간 위치를 알 수 있어요",
                    style: const TextStyle(
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w300,
                      fontFamily: "NotoSansKR",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  buildFutureBuilder(fullWidth, rate),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          backgroundColor: Color(0xff842fb5),
          onPressed: () async {
            // await _fetch1();
            setState(() {
              busData = _fetch1();
            });
          }),
    );
  }

  FutureBuilder<BusData> buildFutureBuilder(double fullWidth, double rate) {
    return FutureBuilder(
        future: busData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // print(snapshot.connectionState != ConnectionState.active);
          if (snapshot.hasData == false) {
            return Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("error");
          } else {
            print(snapshot.data);
            return Column(
              children: <Widget>[
                Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Chip(
                              backgroundColor:
                                  Colors.deepPurple.withOpacity(0.8),
                              label: Text(snapshot.data.cur,
                                  style: const TextStyle(
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "NotoSansKR",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20.0,
                                  )),
                            ),
                            SizedBox(height: 43.0),
                            BusCard(
                                title: '셔틀 버스',
                                width: 355 * fullWidth * rate,
                                children: <Widget>[
                                  BusInfo(
                                    width: 100 * fullWidth * rate,
                                    title: "평일",
                                    timeTable: snapshot.data.result
                                        ["shuttle"]["week"],
                                  ),
                                  SizedBox(height: 14.0),
                                  BusInfo(
                                    width: 100 * fullWidth * rate,
                                    title: "방학 / 주말",
                                    timeTable: snapshot.data.result
                                        ["shuttle"]["vacation"],
                                  ),
                                  SizedBox(height: 14.0),
                                  BusInfo(
                                    width: 100 * fullWidth * rate,
                                    title: "시험기간",
                                    timeTable: snapshot.data.result
                                        ["shuttle"]["exam"],
                                  ),
                                ]),
                            SizedBox(height: 30.0),
                            BusCard(
                                title: '190번 버스',
                                width: 355 * fullWidth * rate,
                                children: <Widget>[
                                  BusInfo(
                                    width: 100 * fullWidth * rate,
                                    title: "평일",
                                    timeTable: snapshot.data.result["bus190"]
                                        ["week"],
                                  ),
                                  SizedBox(height: 14.0),
                                  BusInfo(
                                    width: 100 * fullWidth * rate,
                                    title: "토요일",
                                    timeTable: snapshot.data.result["bus190"]
                                        ["saturday"],
                                  ),
                                  SizedBox(height: 14.0),
                                  BusInfo(
                                    width: 100 * fullWidth * rate,
                                    title: "일요일 / 공휴일",
                                    timeTable: snapshot.data.result["bus190"]
                                        ["weekend"],
                                  ),
                                ]),
                            SizedBox(height: 39.0),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BusPage()));
                              },
                              child: Container(
                                width: 355 * fullWidth * rate,
                                height: 100,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "통근 버스 정보",
                                      style: const TextStyle(
                                        color: const Color(0xff131415),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "NotoSansKR",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 28.0,
                                      ),
                                    ),
                                    SizedBox(width: 22 * fullWidth * rate),
                                    SizedBox(
                                      width: 62,
                                      height: 44,
                                      child: Image.asset(
                                          "images/BusPage/commuterbus.png"),
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                  border: Border.all(
                                    color: const Color(0xff842fb5),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0x80cacaca),
                                        offset: Offset(0, -1),
                                        blurRadius: 16,
                                        spreadRadius: 2)
                                  ],
                                  color: const Color(0xffffffff),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              "학교 홈페이지 버스 시간표를 기준으로 만들었습니다.",
                              style: const TextStyle(
                                color: const Color(0xff131415),
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansKR",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(height: 20.0),
                          ],
                        ),
                      ]),
                ),
              ],
            );
          }
        });
  }
}
