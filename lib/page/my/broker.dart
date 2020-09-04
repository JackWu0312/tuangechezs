import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/ui.dart';
import '../../common/Unit.dart';
import '../../http/index.dart';
import '../../common/LoadingDialog.dart';
import '../../common/Storage.dart';
import 'package:provider/provider.dart';
import '../../provider/Orderback.dart';

class Broker extends StatefulWidget {
  Broker({Key key}) : super(key: key);

  @override
  _BrokerState createState() => _BrokerState();
}

class _BrokerState extends State<Broker> {
  var name = new TextEditingController();
  var mobile = new TextEditingController();
  var desc = new TextEditingController();
  var wechat = new TextEditingController();
  var data;
  var isloading = false;
  var timer;
  var names;
  var mobiles;
  var descs;
  var wechats;
  FocusNode _focusNodemobiles = FocusNode();
  FocusNode _focusNodedescs = FocusNode();
  FocusNode _focusNodenames = FocusNode();
   FocusNode _focusNodewechats = FocusNode();
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
    _focusNodemobiles.addListener(() {
      // print(_focusNodemobiles.hasFocus);
      if (_focusNodemobiles.hasFocus) {
        name.text = names;
        desc.text = descs;
        wechat.text =wechats;
      }
    });
    _focusNodedescs.addListener(() {
      // print(_focusNodedescs.hasFocus);
      if (_focusNodedescs.hasFocus) {
        mobile.text = mobiles;
      }
    });
    _focusNodenames.addListener(() {
      // print(_focusNodenames.hasFocus);
      if (_focusNodenames.hasFocus) {
        mobile.text = mobiles;
      }
    });
     _focusNodewechats.addListener(() {
      // print(_focusNodewechats.hasFocus);
      if (_focusNodewechats.hasFocus) {
        mobile.text = mobiles;
      }
    });
  }

  getData() async {
    await HttpUtlis.get('third/user/info', success: (value) async {
      if (value['errno'] == 0) {
        setState(() {
          data = value['data'];
          name.text = value['data']['name'];
          mobile.text = value['data']['mobile'];
          desc.text = value['data']['desc'];
          wechat.text = value['data']['wechat'];
        });
        await Storage.setString('userInfo', json.encode(value['data']));
      }
    }, failure: (error) {
      Unit.setToast('${error}', context);
    });
    setState(() {
      isloading = true;
    });
  }

  submit() async {
    if (!RegExp(r"^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$")
        .hasMatch(mobile.text)) {
      Unit.setToast("请输入正确的手机号码", context);
      return;
    }
    await HttpUtlis.post('third/user/watermark',
        params: {"name": name.text, "mobile": mobile.text, "desc": desc.text, "wechat":wechat.text},
        success: (value) async {
      if (value['errno'] == 0) {
        Unit.setToast('提交成功～', context);
        final counter = Provider.of<Orderback>(context);
        counter.increment(true);
        timer = new Timer(new Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      } else {
        Unit.setToast('提交失败～', context);
      }
    }, failure: (error) {
      Unit.setToast(error, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Ui.init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
            onTap: () {
              name.text = names;
              desc.text = descs;
              mobile.text = mobiles;
               wechat.text=wechats;
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
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
                                  '水印管理',
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
                        color: Color(0xFFFBFCFF),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding:
                                  EdgeInsets.fromLTRB(0, 0, 0, Ui.width(90)),
                              child: ListView(
                                children: <Widget>[
                                  Container(
                                    width: Ui.width(750),
                                    height: Ui.width(130),
                                    padding: EdgeInsets.fromLTRB(
                                        Ui.width(30), 0, Ui.width(30), 0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Color(0xffEEF3F9)))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '经纪人名称',
                                          style: TextStyle(
                                              color: Color(0XFF111F37),
                                              fontSize: Ui.setFontSizeSetSp(28),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                        ),
                                        Container(
                                          width: Ui.width(500),
                                          height: Ui.width(80),
                                          padding: EdgeInsets.fromLTRB(
                                              Ui.width(20), 0, Ui.width(20), 0),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF6F8FC),
                                            borderRadius: BorderRadius.circular(
                                                Ui.width(10)),
                                          ),
                                          child: TextField(
                                            autofocus: false,
                                            // maxLines: 4,
                                            focusNode: _focusNodenames,
                                            controller: TextEditingController
                                                .fromValue(TextEditingValue(
                                                    // 设置内容
                                                    text: name.text,
                                                    // 保持光标在最后
                                                    selection: TextSelection
                                                        .fromPosition(TextPosition(
                                                            affinity:
                                                                TextAffinity
                                                                    .downstream,
                                                            offset: name.text
                                                                .length)))),
                                            // controller: name,
                                            keyboardAppearance:
                                                Brightness.light,
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(
                                                color: Color(0XFF111F37),
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    Ui.setFontSizeSetSp(32)),
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        0, 0, 0, Ui.width(20)),
                                                border: InputBorder.none,
                                                hintText: '',
                                                hintStyle: TextStyle(
                                                    color: Color(0xFFC4C9D3),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Helvetica',
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(
                                                            28.0))),

                                            onChanged: (value) {
                                              names = value;
                                            },
                                            onSubmitted: (value) {
                                              names = value;
                                              setState(() {
                                                name.text = value;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: Ui.width(750),
                                    height: Ui.width(130),
                                    padding: EdgeInsets.fromLTRB(
                                        Ui.width(30), 0, Ui.width(30), 0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Color(0xffEEF3F9)))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '电话',
                                          style: TextStyle(
                                              color: Color(0XFF111F37),
                                              fontSize: Ui.setFontSizeSetSp(28),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                        ),
                                        Container(
                                          width: Ui.width(500),
                                          height: Ui.width(80),
                                          padding: EdgeInsets.fromLTRB(
                                              Ui.width(20), 0, Ui.width(20), 0),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF6F8FC),
                                            borderRadius: BorderRadius.circular(
                                                Ui.width(10)),
                                          ),
                                          child: TextField(
                                            autofocus: false,
                                            // maxLines: 4,
                                            focusNode: _focusNodemobiles,
                                            controller: TextEditingController
                                                .fromValue(TextEditingValue(
                                                    // 设置内容
                                                    text: mobile.text,
                                                    // 保持光标在最后
                                                    selection: TextSelection
                                                        .fromPosition(TextPosition(
                                                            affinity:
                                                                TextAffinity
                                                                    .downstream,
                                                            offset: mobile.text
                                                                .length)))),
                                            // controller: ,
                                            keyboardAppearance:
                                                Brightness.light,
                                            keyboardType: TextInputType.phone,
                                            style: TextStyle(
                                                color: Color(0XFF111F37),
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    Ui.setFontSizeSetSp(32)),
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        0, 0, 0, Ui.width(20)),
                                                border: InputBorder.none,
                                                hintText: '',
                                                hintStyle: TextStyle(
                                                    color: Color(0xFFC4C9D3),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Helvetica',
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(
                                                            28.0))),
                                            onChanged: (value) {
                                              mobiles = value;
                                            },
                                            onSubmitted: (value) {
                                              mobiles = value;
                                              setState(() {
                                                mobile.text = value;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: Ui.width(750),
                                    height: Ui.width(130),
                                    padding: EdgeInsets.fromLTRB(
                                        Ui.width(30), 0, Ui.width(30), 0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Color(0xffEEF3F9)))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '描述',
                                          style: TextStyle(
                                              color: Color(0XFF111F37),
                                              fontSize: Ui.setFontSizeSetSp(28),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                        ),
                                        Container(
                                          width: Ui.width(500),
                                          height: Ui.width(80),
                                          padding: EdgeInsets.fromLTRB(
                                              Ui.width(20), 0, Ui.width(20), 0),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF6F8FC),
                                            borderRadius: BorderRadius.circular(
                                                Ui.width(10)),
                                          ),
                                          child: TextField(
                                            autofocus: false,
                                            // maxLines: 4,
                                            focusNode: _focusNodedescs,
                                            controller: TextEditingController
                                                .fromValue(TextEditingValue(
                                                    // 设置内容
                                                    text: desc.text,
                                                    // 保持光标在最后
                                                    selection: TextSelection
                                                        .fromPosition(TextPosition(
                                                            affinity:
                                                                TextAffinity
                                                                    .downstream,
                                                            offset: desc.text
                                                                .length)))),
                                            keyboardAppearance:
                                                Brightness.light,
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(
                                                color: Color(0XFF111F37),
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    Ui.setFontSizeSetSp(32)),
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        0, 0, 0, Ui.width(20)),
                                                border: InputBorder.none,
                                                hintText: '',
                                                hintStyle: TextStyle(
                                                    color: Color(0xFFC4C9D3),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Helvetica',
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(
                                                            28.0))),
                                            onChanged: (value) {
                                              descs = value;
                                            },
                                            onSubmitted: (value) {
                                              descs = value;
                                              setState(() {
                                                desc.text = value;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: Ui.width(750),
                                    height: Ui.width(130),
                                    padding: EdgeInsets.fromLTRB(
                                        Ui.width(30), 0, Ui.width(30), 0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Color(0xffEEF3F9)))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '微信号',
                                          style: TextStyle(
                                              color: Color(0XFF111F37),
                                              fontSize: Ui.setFontSizeSetSp(28),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                        ),
                                        Container(
                                          width: Ui.width(500),
                                          height: Ui.width(80),
                                          padding: EdgeInsets.fromLTRB(
                                              Ui.width(20), 0, Ui.width(20), 0),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF6F8FC),
                                            borderRadius: BorderRadius.circular(
                                                Ui.width(10)),
                                          ),
                                          child: TextField(
                                            autofocus: false,
                                            // maxLines: 4,
                                            focusNode: _focusNodewechats,
                                            controller: TextEditingController
                                                .fromValue(TextEditingValue(
                                                    // 设置内容
                                                    text: wechat.text,
                                                    // 保持光标在最后
                                                    selection: TextSelection
                                                        .fromPosition(TextPosition(
                                                            affinity:
                                                                TextAffinity
                                                                    .downstream,
                                                            offset: wechat.text
                                                                .length)))),
                                            keyboardAppearance:
                                                Brightness.light,
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(
                                                color: Color(0XFF111F37),
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    Ui.setFontSizeSetSp(32)),
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        0, 0, 0, Ui.width(20)),
                                                border: InputBorder.none,
                                                hintText: '',
                                                hintStyle: TextStyle(
                                                    color: Color(0xFFC4C9D3),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Helvetica',
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(
                                                            28.0))),
                                            onChanged: (value) {
                                              wechats = value;
                                            },
                                            onSubmitted: (value) {
                                              wechats = value;
                                              setState(() {
                                                wechat.text = value;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: Ui.width(30),
                                left: Ui.width(30),
                                child: InkWell(
                                  onTap: () {
                                    name.text = names;
                                    desc.text = descs;
                                    mobile.text = mobiles;
                                    wechat.text=wechats;
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    submit();
                                  },
                                  child: Container(
                                    width: Ui.width(690),
                                    height: Ui.width(90),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF33AAF5),
                                        borderRadius:
                                            BorderRadius.circular(Ui.width(10)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0XFFADD3FF),
                                            offset: Offset(1, 1),
                                            blurRadius: Ui.width(10.0),
                                          ),
                                        ]),
                                    child: Text(
                                      '保存',
                                      style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontWeight: FontWeight.w500,
                                          fontFamily:
                                              'PingFangSC-Medium,PingFang SC',
                                          fontSize: Ui.setFontSizeSetSp(32.0)),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      )
                    : Container(
                        child: LoadingDialog(
                          text: "加载中…",
                        ),
                      ))));
  }
}
