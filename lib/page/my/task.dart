import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuangechezs/common/Unit.dart';
import 'package:tuangechezs/provider/Share.dart';
import 'package:tuangechezs/provider/TaskEvent.dart';
import '../../ui/ui.dart';
import 'package:toast/toast.dart';
import '../../http/index.dart';
import 'package:provider/provider.dart';
import '../../provider/Taskback.dart';
import '../../provider/Backhome.dart';
import '../../provider/Backshare.dart';
import '../../provider/Lovecar.dart';
import '../../common/LoadingDialog.dart';

class Task extends StatefulWidget {
  Task({Key key}) : super(key: key);

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  bool isloading = false;
  var point = 0;
  var status = 2;
  var continuousDays = 1;
  var signPoints = 0;
  List list = [];
  @override
  void initState() {
    super.initState();
//    getlog();
    // signIn();
    getUserInfo();
    gettasks();
  }

  void dispose() {
    super.dispose();
  }

  gettasks() async {
    await HttpUtlis.get('third/user/tasks', success: (value) {
      print(value);
      if (value['errno'] == 0) {
        setState(() {
          list = value['data'];
        });
      }
    }, failure: (error) {
      Toast.show('${error}', context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    });
    setState(() {
      this.isloading = true;
    });
  }

  getUserInfo() async{
    await HttpUtlis.get('third/user/info', success: (value) {
      print('个人信息 = $value');
      if (value['errno'] == 0) {
        setState(() {
//          status = value['data']['status'];
          point = value['data']['freePoints'];
        });
      }
    }, failure: (error) {
      Toast.show('${error}', context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    });
  }

  getlog() async {
    await HttpUtlis.get('wx/user/signIn/log', success: (value) {
      if (value['errno'] == 0) {
        setState(() {
          status = value['data']['status'];
          point = value['data']['freePoints'];
        });
      }
    }, failure: (error) {
      Toast.show('${error}', context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    });
  }

//  signIn() async {
//    await HttpUtlis.post('wx/user/signIn', success: (value) {
//      if (value['errno'] == 0) {
//        setState(() {
//          continuousDays = value['data']['continuousDays'];
//          signPoints = value['data']['signPoints'];
//        });
//        getlog();
//        final counter = Provider.of<Taskback>(context);
//        counter.increment(true);
//      }
//    }, failure: (error) {
//      Toast.show('${error}', context,
//          backgroundColor: Color(0xff5b5956),
//          backgroundRadius: Ui.width(16),
//          duration: Toast.LENGTH_SHORT,
//          gravity: Toast.CENTER);
//    });
//  }

  getdom() {
    List<Widget> listwidget = [];
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for (var item in list) {
      listwidget.add(
        Container(
          padding: EdgeInsets.fromLTRB(0, Ui.width(30), 0, Ui.width(30)),
          margin: EdgeInsets.fromLTRB(Ui.width(30), 0, Ui.width(30), 0),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: Ui.width(1), color: Color(0xFFEAEAEA)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: Ui.width(510),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'images/2.0x/loginnew.png',
                      width: Ui.width(80),
                      height: Ui.width(80),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(Ui.width(20), 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${item['label']}',
                            style: TextStyle(
                                color: Color(0xFF111F37),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'PingFangSC-Medium,PingFang SC',
                                fontSize: Ui.setFontSizeSetSp(30.0)),
                          ),
                          SizedBox(
                            height: Ui.width(5),
                          ),
                          Container(
                            width: Ui.width(410),
                            child: Text(
                              '${item['remark']}',
                              style: TextStyle(
                                  color: Color(0xFF9398A5),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'PingFangSC-Medium,PingFang SC',
                                  fontSize: Ui.setFontSizeSetSp(24.0)),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              item['extra']['btnText'] == '已完成'
                  ? InkWell(
                    onTap: (){
//                        if (item['extra']['link'] == '/1') {
//                           Navigator.pushNamed(context, '/recommend');
//                         } else if (item['extra']['link'] == '/2') {
//                           Navigator.pushNamed(context, '/registerwebview',
//                               arguments: {'url': 'apprecommend'});
//                         } else if (item['extra']['link'] == '/3') {
//                           Navigator.pushNamed(context, '/tokenwebview',
//                               arguments: {'url': 'applovecar'});
//                         } else if (item['extra']['link'] == '/4') {
//                           final counterback = Provider.of<Backhome>(context);
//                           final countershare = Provider.of<Backshare>(context);
//                           counterback.increment(3);
//                           countershare.increment(2);
//                           Navigator.pop(context);
//                         }
//                    print(item['extra']['link']);
//                      Navigator.pushNamed(context, item['extra']['link']);
                    },
                    child: Container(
                      width: Ui.width(150),
                      height: Ui.width(60),
                      alignment: Alignment.center,
                      color: Color(0xFFF5F5F5),
                      child: Text(
                        '已完成',
                        style: TextStyle(
                            color: Color(0xFF9398A5),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'PingFangSC-Medium,PingFang SC',
                            fontSize: Ui.setFontSizeSetSp(26.0)),
                      )),
                  )
                  : InkWell(
                      onTap: () {
//                        if (item['extra']['link'] == '/1') {
//                          Navigator.pushNamed(context, '/recommend');
//                        } else if (item['extra']['link'] == '/2') {
//                          Navigator.pushNamed(context, '/registerwebview',
//                              arguments: {'url': 'apprecommend'});
//                        } else if (item['extra']['link'] == '/3') {
//                          Navigator.pushNamed(context, '/tokenwebview',
//                              arguments: {'url': 'applovecar'});
//                        } else if (item['extra']['link'] == '/4') {
//                          final counterback = Provider.of<Backhome>(context);
//                          final countershare = Provider.of<Backshare>(context);
//                          counterback.increment(3);
//                          countershare.increment(2);
//                          Navigator.pop(context);
//                        }
                        print(item['extra']['link']);
                        if(item['extra']['link']== '/qrcode'){
                          if ( Unit.isAgent() == 'broker') {
                            Navigator.pushNamed(context, '/brokercard',
                                arguments: {'user': null});
                          } else {
                            Navigator.pushNamed(context, '/agentcard',
                                arguments: {'user': null});
                          }
                        }else if(item['extra']['link']== '/poster'){
                          Navigator.pushNamed(context, '/poster',arguments: {'index':0});
                        }else {
                          Navigator.pushNamed(context, item['extra']['link']);
                        }
                      },
                      child: Container(
                          width: Ui.width(150),
                          height: Ui.width(60),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: Ui.width(1), color: Color(0xFF111F37)),
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              )),
                          child: Text(
                            '${item['extra']['btnText']}',
                            style: TextStyle(
                                color: Color(0xFF111F37),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'PingFangSC-Medium,PingFang SC',
                                fontSize: Ui.setFontSizeSetSp(26.0)),
                          )),
                    )
            ],
          ),
        ),
      );
    }

    content = new Column(
      children: listwidget,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<TaskEvent>(context);
    if (counter.count) {
       Future.delayed(Duration(milliseconds: 200)).then((e) {
        counter.increment(false);
      });
      gettasks();
      getUserInfo();
    }
    Ui.init(context);
    showtosh(continuousDays, signPoints) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: Container(
                  width: Ui.width(500),
                  height: Ui.width(694),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(Ui.width(20.0))),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: Ui.width(490),
                        height: Ui.width(588),
                        margin: EdgeInsets.fromLTRB(Ui.width(5), 0, 0, 0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/2.0x/signing.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin:
                                  EdgeInsets.fromLTRB(0, Ui.width(200), 0, 0),
                              child: Text(
                                '连续签到${continuousDays}天',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'PingFangSC-Medium,PingFang SC',
                                    fontSize: Ui.setFontSizeSetSp(34.0)),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.fromLTRB(0, Ui.width(110), 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '+',
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Color(0xFFFFE1A5),
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Medium,PingFang SC',
                                        fontSize: Ui.setFontSizeSetSp(40.0)),
                                  ),
                                  SizedBox(
                                    width: Ui.width(10),
                                  ),
                                  Text(
                                    '${signPoints}',
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Color(0xFFFFE1A5),
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Medium,PingFang SC',
                                        fontSize: Ui.setFontSizeSetSp(90.0)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          left: Ui.width(215),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: Ui.width(56),
                              height: Ui.width(56),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage('images/2.0x/closesing.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ))
                    ],
                  )),
            );
          });
    }

    return Scaffold(
      appBar: PreferredSize(
          child: Container(
              padding: new EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF5BBEFF),
                    Color(0xFF466EFF),
                  ],
                ),
              ),
              child: Container(
                height: Ui.height(90),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF5BBEFF),
                      Color(0xFF466EFF),
                    ],
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        left: Ui.width(30),
                        top: Ui.width(30),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            'images/2.0x/back.png',
                            width: Ui.width(20),
                            height: Ui.width(36),
                          ),
                        )),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        '任务中心',
                        style: TextStyle(
                            color: Color(0XFFFFFFFF),
                            fontSize: Ui.setFontSizeSetSp(36),
                            fontWeight: FontWeight.w500,
                            fontFamily:
                            'PingFangSC-Regular,PingFang SC'),
                      ),
                    )
                  ],
                ),
              )),
          preferredSize:
          Size(MediaQuery.of(context).size.width, Ui.width(90))),
      body: isloading
          ? Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Container(
                    width: Ui.width(750),
                    height: Ui.width(280),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('images/2.0x/taskbg.png'),
                      fit: BoxFit.fill,
                    )),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: Ui.width(30),
                          top: Ui.width(90),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '   我的积分：',
                                  style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w400,
                                      fontFamily:
                                          'PingFangSC-Medium,PingFang SC',
                                      fontSize: Ui.setFontSizeSetSp(28.0)),
                                ),
                                SizedBox(
                                  height: Ui.width(10),
                                ),
                                Text(
                                  '${this.point}',
                                  style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w400,
                                      fontFamily:
                                          'PingFangSC-Medium,PingFang SC',
                                      fontSize: Ui.setFontSizeSetSp(44.0)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            left: Ui.width(250),
                            top: Ui.width(15),
                            child: status == 0
                                ? Text('')
                                : InkWell(
                                    onTap: () async {
//                                      if (status == 2) {
//                                        await signIn();
//                                        showtosh(continuousDays, signPoints);
//                                      }
                                    },
                                    child: Container(
                                      width: Ui.width(250),
                                      height: Ui.width(250),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: status == 2
                                            ? AssetImage('images/2.0x/sign.png')
                                            : AssetImage(
                                                'images/2.0x/check.png'),
                                        fit: BoxFit.fill,
                                      )),
                                    ),
                                  ))
                      ],
                    ),
                  ),
                  Container(
                    width: Ui.width(750),
                    height: Ui.width(90),
                    padding: EdgeInsets.fromLTRB(Ui.width(40), 0, 0, 0),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: Ui.width(1), color: Color(0xFFEAEAEA)))),
                    child: Text(
                      '完成任务领积分',
                      style: TextStyle(
                          color: Color(0xFF111F37),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'PingFangSC-Medium,PingFang SC',
                          fontSize: Ui.setFontSizeSetSp(26.0)),
                    ),
                  ),
                  Container(
                    width: Ui.width(750),
                    child: getdom(),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.pushNamed(context, '/registerwebview',
                  //         arguments: {'url': 'apprecommend'});
                  //   },
                  //   child: Container(
                  //     padding:
                  //         EdgeInsets.fromLTRB(0, Ui.width(30), 0, Ui.width(30)),
                  //     margin: EdgeInsets.fromLTRB(Ui.width(30), 0, Ui.width(30), 0),
                  //     decoration: BoxDecoration(
                  //         border: Border(
                  //             bottom: BorderSide(
                  //                 width: Ui.width(1), color: Color(0xFFEAEAEA)))),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: <Widget>[
                  //         Container(
                  //           width: Ui.width(510),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             crossAxisAlignment: CrossAxisAlignment.center,
                  //             children: <Widget>[
                  //               Image.asset(
                  //                 'images/2.0x/loginnew.png',
                  //                 width: Ui.width(80),
                  //                 height: Ui.width(80),
                  //               ),
                  //               Container(
                  //                 margin:
                  //                     EdgeInsets.fromLTRB(Ui.width(20), 0, 0, 0),
                  //                 child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: <Widget>[
                  //                     Text(
                  //                       '成为经纪人',
                  //                       style: TextStyle(
                  //                           color: Color(0xFF111F37),
                  //                           fontWeight: FontWeight.w400,
                  //                           fontFamily:
                  //                               'PingFangSC-Medium,PingFang SC',
                  //                           fontSize: Ui.setFontSizeSetSp(30.0)),
                  //                     ),
                  //                     SizedBox(
                  //                       height: Ui.width(5),
                  //                     ),
                  //                     Container(
                  //                       width: Ui.width(410),
                  //                       child: Text(
                  //                         '注册成功+10积分+推荐购车奖金',
                  //                         style: TextStyle(
                  //                             color: Color(0xFF9398A5),
                  //                             fontWeight: FontWeight.w400,
                  //                             fontFamily:
                  //                                 'PingFangSC-Medium,PingFang SC',
                  //                             fontSize: Ui.setFontSizeSetSp(24.0)),
                  //                       ),
                  //                     )
                  //                   ],
                  //                 ),
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //         Container(
                  //             width: Ui.width(150),
                  //             height: Ui.width(60),
                  //             alignment: Alignment.center,
                  //             decoration: BoxDecoration(
                  //                 border: Border.all(
                  //                     width: Ui.width(1), color: Color(0xFF111F37)),
                  //                 borderRadius: BorderRadius.all(
                  //                   Radius.circular(3),
                  //                 )),
                  //             child: Text(
                  //               '去注册',
                  //               style: TextStyle(
                  //                   color: Color(0xFF111F37),
                  //                   fontWeight: FontWeight.w400,
                  //                   fontFamily: 'PingFangSC-Medium,PingFang SC',
                  //                   fontSize: Ui.setFontSizeSetSp(26.0)),
                  //             ))
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.pushNamed(context, '/tokenwebview',
                  //         arguments: {'url': 'applovecar'});
                  //   },
                  //   child: Container(
                  //     padding:
                  //         EdgeInsets.fromLTRB(0, Ui.width(30), 0, Ui.width(30)),
                  //     margin: EdgeInsets.fromLTRB(Ui.width(30), 0, Ui.width(30), 0),
                  //     decoration: BoxDecoration(
                  //         border: Border(
                  //             bottom: BorderSide(
                  //                 width: Ui.width(1), color: Color(0xFFEAEAEA)))),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: <Widget>[
                  //         Container(
                  //           width: Ui.width(510),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             crossAxisAlignment: CrossAxisAlignment.center,
                  //             children: <Widget>[
                  //               Image.asset(
                  //                 'images/2.0x/loginnew.png',
                  //                 width: Ui.width(80),
                  //                 height: Ui.width(80),
                  //               ),
                  //               Container(
                  //                 margin:
                  //                     EdgeInsets.fromLTRB(Ui.width(20), 0, 0, 0),
                  //                 child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: <Widget>[
                  //                     Text(
                  //                       '爱车信息',
                  //                       style: TextStyle(
                  //                           color: Color(0xFF111F37),
                  //                           fontWeight: FontWeight.w400,
                  //                           fontFamily:
                  //                               'PingFangSC-Medium,PingFang SC',
                  //                           fontSize: Ui.setFontSizeSetSp(30.0)),
                  //                     ),
                  //                     SizedBox(
                  //                       height: Ui.width(5),
                  //                     ),
                  //                     Container(
                  //                       width: Ui.width(410),
                  //                       child: Text(
                  //                         '完善已有爱车信息可+50积分',
                  //                         style: TextStyle(
                  //                             color: Color(0xFF9398A5),
                  //                             fontWeight: FontWeight.w400,
                  //                             fontFamily:
                  //                                 'PingFangSC-Medium,PingFang SC',
                  //                             fontSize: Ui.setFontSizeSetSp(24.0)),
                  //                       ),
                  //                     )
                  //                   ],
                  //                 ),
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //         Container(
                  //             width: Ui.width(150),
                  //             height: Ui.width(60),
                  //             alignment: Alignment.center,
                  //             color: Color(0xFFF5F5F5),
                  //             child: Text(
                  //               '已完成',
                  //               style: TextStyle(
                  //                   color: Color(0xFF9398A5),
                  //                   fontWeight: FontWeight.w400,
                  //                   fontFamily: 'PingFangSC-Medium,PingFang SC',
                  //                   fontSize: Ui.setFontSizeSetSp(26.0)),
                  //             ))
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     counterback.increment(3);
                  //     countershare.increment(2);
                  //     Navigator.pop(context);
                  //   },
                  //   child: Container(
                  //     padding:
                  //         EdgeInsets.fromLTRB(0, Ui.width(30), 0, Ui.width(30)),
                  //     margin: EdgeInsets.fromLTRB(Ui.width(30), 0, Ui.width(30), 0),
                  //     decoration: BoxDecoration(
                  //         border: Border(
                  //             bottom: BorderSide(
                  //                 width: Ui.width(1), color: Color(0xFFEAEAEA)))),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: <Widget>[
                  //         Container(
                  //           width: Ui.width(510),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             crossAxisAlignment: CrossAxisAlignment.center,
                  //             children: <Widget>[
                  //               Image.asset(
                  //                 'images/2.0x/loginnew.png',
                  //                 width: Ui.width(80),
                  //                 height: Ui.width(80),
                  //               ),
                  //               Container(
                  //                 margin:
                  //                     EdgeInsets.fromLTRB(Ui.width(20), 0, 0, 0),
                  //                 child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: <Widget>[
                  //                     Text(
                  //                       '资讯分享',
                  //                       style: TextStyle(
                  //                           color: Color(0xFF111F37),
                  //                           fontWeight: FontWeight.w400,
                  //                           fontFamily:
                  //                               'PingFangSC-Medium,PingFang SC',
                  //                           fontSize: Ui.setFontSizeSetSp(30.0)),
                  //                     ),
                  //                     SizedBox(
                  //                       height: Ui.width(5),
                  //                     ),
                  //                     Container(
                  //                       width: Ui.width(410),
                  //                       child: Text(
                  //                         '每天可分享3次资讯信息,每次+10积分',
                  //                         style: TextStyle(
                  //                             color: Color(0xFF9398A5),
                  //                             fontWeight: FontWeight.w400,
                  //                             fontFamily:
                  //                                 'PingFangSC-Medium,PingFang SC',
                  //                             fontSize: Ui.setFontSizeSetSp(24.0)),
                  //                       ),
                  //                     )
                  //                   ],
                  //                 ),
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //         Container(
                  //             width: Ui.width(150),
                  //             height: Ui.width(60),
                  //             alignment: Alignment.center,
                  //             decoration: BoxDecoration(
                  //                 border: Border.all(
                  //                     width: Ui.width(1), color: Color(0xFF111F37)),
                  //                 borderRadius: BorderRadius.all(
                  //                   Radius.circular(3),
                  //                 )),
                  //             child: Text(
                  //               '1/3',
                  //               style: TextStyle(
                  //                   color: Color(0xFF111F37),
                  //                   fontWeight: FontWeight.w400,
                  //                   fontFamily: 'PingFangSC-Medium,PingFang SC',
                  //                   fontSize: Ui.setFontSizeSetSp(26.0)),
                  //             ))
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
            )
          : Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: LoadingDialog(
                text: "加载中…",
              ),
            ),
    );
  }
}
