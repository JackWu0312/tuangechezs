import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/ui.dart';
import '../../common/Unit.dart';
import '../../http/index.dart';
import '../../common/Storage.dart';
import '../../common/LoadingDialog.dart';
import 'package:provider/provider.dart';
import '../../provider/Orderback.dart';

class Authentication extends StatefulWidget {
  Authentication({Key key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  var name = new TextEditingController();
  var idcard = new TextEditingController();
  var bankNo = new TextEditingController();
  var address = new TextEditingController();
  // var wechat = new TextEditingController();
  int isAgent = 1;
  bool isloading = false;
  var names;
  var idcards;
  var bankNos;
  var addresss;
  var data;
  // var wechats;
  var timer;
  FocusNode _focusNodename = FocusNode();
  FocusNode _focusNodeidcard = FocusNode();
  FocusNode _focusNodebankNo = FocusNode();
  FocusNode _focusNodeaddress = FocusNode();
  // FocusNode _focusNodewechat = FocusNode();
  void initState() {
    super.initState();
    getisAgent();
    getData();

    _focusNodename.addListener(() {
      if (_focusNodename.hasFocus) {
        bankNo.text = bankNos;
      }
    });
    _focusNodeidcard.addListener(() {
      if (_focusNodeidcard.hasFocus) {
        bankNo.text = bankNos;
      }
    });
    _focusNodeaddress.addListener(() {
      if (_focusNodeaddress.hasFocus) {
        bankNo.text = bankNos;
      }
    });
    // _focusNodewechat.addListener(() {
    //   if (_focusNodewechat.hasFocus) {
    //     bankNo.text = bankNos;
    //   }
    // });

    _focusNodebankNo.addListener(() {
      if (_focusNodebankNo.hasFocus) {
        name.text = names;
        idcard.text = idcards;
        // wechat.text = wechats;
        address.text = addresss;
      }
    });
  }

  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  getisAgent() async {
    if (await Unit.isAgent() == 'broker') {
      setState(() {
        isAgent = 1;
      });
    } else {
      setState(() {
        isAgent = 2;
      });
    }
  }

  getData() async {
    await HttpUtlis.get('third/user/info', success: (value) {
      if (value['errno'] == 0) {
        setState(() {
          data = value['data'];
          name.text = value['data']['name'];
          print(name.text);
          idcard.text = value['data']['idcard'];
          bankNo.text = value['data']['bankNo'];
          address.text = value['data']['address'];
        });
      }
    }, failure: (error) {
      Unit.setToast('${error}', context);
    });
    setState(() {
      isloading = true;
    });
  }

  submit() async {
    if (!Unit.isCardId(idcard.text)) {
      Unit.setToast('请输入正确的身份证号码', context);
      return;
    }
    if (!Unit.isCard(bankNo.text)) {
      Unit.setToast('请输入正确的银行卡号', context);
      return;
    }
    await HttpUtlis.post('third/user/auth', params: {
      "name": name.text,
      "idcard": idcard.text,
      "bankNo": bankNo.text,
      "address": address.text
    }, success: (value) async {
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
              idcard.text = idcards;
              bankNo.text = bankNos;
              address.text = addresss;
              // wechat.text = wechats;
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
                                  left: 0,
                                  top: Ui.width(30),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: Ui.width(80),
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          'images/2.0x/back.png',
                                          width: Ui.width(20),
                                          height: Ui.width(36),
                                        ),
                                      ))),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '我的认证',
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
                                  // Container(
                                  //   width: Ui.width(750),
                                  //   height: Ui.width(130),
                                  //   padding: EdgeInsets.fromLTRB(
                                  //       Ui.width(30), 0, Ui.width(30), 0),
                                  //   decoration: BoxDecoration(
                                  //       border: Border(
                                  //           bottom: BorderSide(
                                  //               width: 1,
                                  //               color: Color(0xffEEF3F9)))),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.center,
                                  //     children: <Widget>[
                                  //       Text(
                                  //         '代理商名称',
                                  //         style: TextStyle(
                                  //             color: Color(0XFF111F37),
                                  //             fontSize: Ui.setFontSizeSetSp(28),
                                  //             fontWeight: FontWeight.w400,
                                  //             fontFamily:
                                  //                 'PingFangSC-Regular,PingFang SC'),
                                  //       ),
                                  //       Container(
                                  //         width: Ui.width(500),
                                  //         height: Ui.width(80),
                                  //         alignment: Alignment.centerLeft,
                                  //         padding: EdgeInsets.fromLTRB(
                                  //             Ui.width(20), 0, Ui.width(20), 0),
                                  //         decoration: BoxDecoration(
                                  //           color: Color(0xFFF6F8FC),
                                  //           borderRadius: BorderRadius.circular(
                                  //               Ui.width(10)),
                                  //         ),
                                  //         child: Text(
                                  //           data['company'] == null
                                  //               ? ''
                                  //               : '${data['company']}',
                                  //           maxLines: 2,
                                  //           overflow: TextOverflow.ellipsis,
                                  //           style: TextStyle(
                                  //               color: Color(0XFF111F37),
                                  //               fontSize:
                                  //                   Ui.setFontSizeSetSp(28),
                                  //               fontWeight: FontWeight.w400,
                                  //               fontFamily:
                                  //                   'PingFangSC-Regular,PingFang SC'),
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
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
                                          '联系人',
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
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.fromLTRB(
                                              Ui.width(20), 0, Ui.width(20), 0),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF6F8FC),
                                            borderRadius: BorderRadius.circular(
                                                Ui.width(10)),
                                          ),
                                          child: isAgent == 1
                                              ? TextField(
                                                  autofocus: false,
                                                  // maxLines: 4,
                                                  focusNode: _focusNodename,
                                                  keyboardAppearance:
                                                      Brightness.light,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  //  controller: new TextEditingController(text: name.text),
                                                  controller: TextEditingController.fromValue(
                                                      TextEditingValue(
                                                          // 设置内容
                                                          text: name.text,
                                                          // 保持光标在最后
                                                          selection: TextSelection
                                                              .fromPosition(TextPosition(
                                                                  affinity:
                                                                      TextAffinity
                                                                          .downstream,
                                                                  offset: name
                                                                      .text
                                                                      .length)))),
                                                  style: TextStyle(
                                                      color: Color(0XFF111F37),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          Ui.setFontSizeSetSp(
                                                              32)),
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              0,
                                                              0,
                                                              0,
                                                              Ui.width(20)),
                                                      border: InputBorder.none,
                                                      hintText: '',
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Color(0xFFC4C9D3),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'Helvetica',
                                                          fontSize: Ui
                                                              .setFontSizeSetSp(
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
                                                )
                                              : Text(
                                                  data['name'] == null
                                                      ? ''
                                                      : '${data['name']}',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Color(0XFF111F37),
                                                      fontSize:
                                                          Ui.setFontSizeSetSp(
                                                              28),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          'PingFangSC-Regular,PingFang SC'),
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
                                          '身份证',
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
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.fromLTRB(
                                              Ui.width(20), 0, Ui.width(20), 0),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF6F8FC),
                                            borderRadius: BorderRadius.circular(
                                                Ui.width(10)),
                                          ),
                                          child: isAgent == 1
                                              ? TextField(
                                                  autofocus: false,
                                                  // maxLines: 4,
                                                  focusNode: _focusNodeidcard,
                                                  controller: TextEditingController.fromValue(
                                                      TextEditingValue(
                                                          // 设置内容
                                                          text: idcard.text,
                                                          // 保持光标在最后
                                                          selection: TextSelection
                                                              .fromPosition(TextPosition(
                                                                  affinity:
                                                                      TextAffinity
                                                                          .downstream,
                                                                  offset: idcard
                                                                      .text
                                                                      .length)))),
                                                  keyboardAppearance:
                                                      Brightness.light,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  style: TextStyle(
                                                      color: Color(0XFF111F37),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          Ui.setFontSizeSetSp(
                                                              32)),
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              0,
                                                              0,
                                                              0,
                                                              Ui.width(20)),
                                                      border: InputBorder.none,
                                                      hintText: '',
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Color(0xFFC4C9D3),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'Helvetica',
                                                          fontSize: Ui
                                                              .setFontSizeSetSp(
                                                                  28.0))),
                                                  onChanged: (value) {
                                                    idcards = value;
                                                  },
                                                  onSubmitted: (value) {
                                                    idcards = value;
                                                    setState(() {
                                                      idcard.text = value;
                                                    });
                                                  },
                                                )
                                              : Text(
                                                  data['idcard'] == null
                                                      ? ''
                                                      : '${data['idcard']}',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Color(0XFF111F37),
                                                      fontSize:
                                                          Ui.setFontSizeSetSp(
                                                              28),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          'PingFangSC-Regular,PingFang SC'),
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
                                          '银行卡',
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
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.fromLTRB(
                                              Ui.width(20), 0, Ui.width(20), 0),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF6F8FC),
                                            borderRadius: BorderRadius.circular(
                                                Ui.width(10)),
                                          ),
                                          child: isAgent == 1
                                              ? TextField(
                                                  autofocus: false,
                                                  // maxLines: 4,
                                                  focusNode: _focusNodebankNo,
                                                  controller: TextEditingController.fromValue(
                                                      TextEditingValue(
                                                          // 设置内容
                                                          text: bankNo.text,
                                                          // 保持光标在最后
                                                          selection: TextSelection
                                                              .fromPosition(TextPosition(
                                                                  affinity:
                                                                      TextAffinity
                                                                          .downstream,
                                                                  offset: bankNo
                                                                      .text
                                                                      .length)))),
                                                  keyboardAppearance:
                                                      Brightness.light,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  style: TextStyle(
                                                      color: Color(0XFF111F37),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          Ui.setFontSizeSetSp(
                                                              32)),
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              0,
                                                              0,
                                                              0,
                                                              Ui.width(20)),
                                                      border: InputBorder.none,
                                                      hintText: '',
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Color(0xFFC4C9D3),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'Helvetica',
                                                          fontSize: Ui
                                                              .setFontSizeSetSp(
                                                                  28.0))),

                                                  onChanged: (value) {
                                                    bankNos = value;
                                                  },
                                                  onSubmitted: (value) {
                                                    bankNos = value;
                                                    setState(() {
                                                      bankNo.text = value;
                                                    });
                                                  },
                                                )
                                              : Text(
                                                  data['bankNo'] == null
                                                      ? ''
                                                      : '${data['bankNo']}',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Color(0XFF111F37),
                                                      fontSize:
                                                          Ui.setFontSizeSetSp(
                                                              28),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          'PingFangSC-Regular,PingFang SC'),
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
                                          '详细地址',
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
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.fromLTRB(
                                              Ui.width(20), 0, Ui.width(20), 0),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF6F8FC),
                                            borderRadius: BorderRadius.circular(
                                                Ui.width(10)),
                                          ),
                                          child: isAgent == 1
                                              ? TextField(
                                                  autofocus: false,
                                                  // maxLines: 4,
                                                  focusNode: _focusNodeaddress,
                                                  controller: TextEditingController.fromValue(
                                                      TextEditingValue(
                                                          // 设置内容
                                                          text: address.text,
                                                          // 保持光标在最后
                                                          selection: TextSelection
                                                              .fromPosition(TextPosition(
                                                                  affinity:
                                                                      TextAffinity
                                                                          .downstream,
                                                                  offset: address
                                                                      .text
                                                                      .length)))),
                                                  keyboardAppearance:
                                                      Brightness.light,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  style: TextStyle(
                                                      color: Color(0XFF111F37),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          Ui.setFontSizeSetSp(
                                                              32)),
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              0,
                                                              0,
                                                              0,
                                                              Ui.width(20)),
                                                      border: InputBorder.none,
                                                      hintText: '',
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Color(0xFFC4C9D3),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'Helvetica',
                                                          fontSize: Ui
                                                              .setFontSizeSetSp(
                                                                  28.0))),

                                                  onChanged: (value) {
                                                    addresss = value;
                                                  },
                                                  onSubmitted: (value) {
                                                    addresss = value;
                                                    setState(() {
                                                      address.text = value;
                                                    });
                                                  },
                                                )
                                              : Text(
                                                  data['address'] == null
                                                      ? ''
                                                      : '${data['address']}',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Color(0XFF111F37),
                                                      fontSize:
                                                          Ui.setFontSizeSetSp(
                                                              28),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          'PingFangSC-Regular,PingFang SC'),
                                                ),
                                        )
                                      ],
                                    ),
                                  ),

                                  // Container(
                                  //   width: Ui.width(750),
                                  //   height: Ui.width(130),
                                  //   padding: EdgeInsets.fromLTRB(
                                  //       Ui.width(30), 0, Ui.width(30), 0),
                                  //   decoration: BoxDecoration(
                                  //       border: Border(
                                  //           bottom: BorderSide(
                                  //               width: 1,
                                  //               color: Color(0xffEEF3F9)))),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.center,
                                  //     children: <Widget>[
                                        // Text(
                                        //   '微信号',
                                        //   style: TextStyle(
                                        //       color: Color(0XFF111F37),
                                        //       fontSize: Ui.setFontSizeSetSp(28),
                                        //       fontWeight: FontWeight.w400,
                                        //       fontFamily:
                                        //           'PingFangSC-Regular,PingFang SC'),
                                        // ),
                                        // Container(
                                        //   width: Ui.width(500),
                                        //   height: Ui.width(80),
                                        //   alignment: Alignment.centerLeft,
                                        //   padding: EdgeInsets.fromLTRB(
                                        //       Ui.width(20), 0, Ui.width(20), 0),
                                        //   decoration: BoxDecoration(
                                        //     color: Color(0xFFF6F8FC),
                                        //     borderRadius: BorderRadius.circular(
                                        //         Ui.width(10)),
                                        //   ),
                                        //   child: isAgent == 1
                                        //       ? TextField(
                                        //           autofocus: false,
                                        //           // maxLines: 4,
                                        //           focusNode: _focusNodewechat,
                                        //           controller: TextEditingController.fromValue(
                                        //               TextEditingValue(
                                        //                   // 设置内容
                                        //                   text: wechat.text,
                                        //                   // 保持光标在最后
                                        //                   selection: TextSelection
                                        //                       .fromPosition(TextPosition(
                                        //                           affinity:
                                        //                               TextAffinity
                                        //                                   .downstream,
                                        //                           offset: wechat
                                        //                               .text
                                        //                               .length)))),
                                        //           keyboardAppearance:
                                        //               Brightness.light,
                                        //           keyboardType:
                                        //               TextInputType.text,
                                        //           style: TextStyle(
                                        //               color: Color(0XFF111F37),
                                        //               fontWeight:
                                        //                   FontWeight.w400,
                                        //               fontSize:
                                        //                   Ui.setFontSizeSetSp(
                                        //                       32)),
                                        //           decoration: InputDecoration(
                                        //               contentPadding:
                                        //                   EdgeInsets.fromLTRB(
                                        //                       0,
                                        //                       0,
                                        //                       0,
                                        //                       Ui.width(20)),
                                        //               border: InputBorder.none,
                                        //               hintText: '',
                                        //               hintStyle: TextStyle(
                                        //                   color:
                                        //                       Color(0xFFC4C9D3),
                                        //                   fontWeight:
                                        //                       FontWeight.w400,
                                        //                   fontFamily:
                                        //                       'Helvetica',
                                        //                   fontSize: Ui
                                        //                       .setFontSizeSetSp(
                                        //                           28.0))),

                                        //           onChanged: (value) {
                                        //             wechats = value;
                                        //           },
                                        //           onSubmitted: (value) {
                                        //             wechats = value;
                                        //             setState(() {
                                        //               wechat.text = value;
                                        //             });
                                        //           },
                                        //         )
                                        //       : Text(
                                        //           data['wechat'] == null
                                        //               ? ''
                                        //               : '${data['wechat']}',
                                        //           maxLines: 2,
                                        //           overflow:
                                        //               TextOverflow.ellipsis,
                                        //           style: TextStyle(
                                        //               color: Color(0XFF111F37),
                                        //               fontSize:
                                        //                   Ui.setFontSizeSetSp(
                                        //                       28),
                                        //               fontWeight:
                                        //                   FontWeight.w400,
                                        //               fontFamily:
                                        //                   'PingFangSC-Regular,PingFang SC'),
                                        //         ),
                                        // )
                                      // ],
                                    // ),
                                  // ),
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: Ui.width(30),
                                left: Ui.width(30),
                                child: isAgent != 1
                                    ? Text('')
                                    : InkWell(
                                        onTap: () {
                                          name.text = names;
                                          idcard.text = idcards;
                                          bankNo.text = bankNos;
                                          address.text = addresss;
                                          // wechat.text = wechats;
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
                                                  BorderRadius.circular(
                                                      Ui.width(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0XFFADD3FF),
                                                  offset: Offset(1, 1),
                                                  blurRadius: Ui.width(10.0),
                                                ),
                                              ]),
                                          child: Text(
                                            '提交认证',
                                            style: TextStyle(
                                                color: Color(0xFFFFFFFF),
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    'PingFangSC-Medium,PingFang SC',
                                                fontSize:
                                                    Ui.setFontSizeSetSp(32.0)),
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