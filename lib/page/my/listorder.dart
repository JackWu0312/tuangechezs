import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import '../../ui/ui.dart';
import '../../http/index.dart';
import 'package:toast/toast.dart';
import '../../common/LoadingDialog.dart';
import '../../common/Nofind.dart';
import '../../common/Storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
// import '../../common/Storage.dart';
import 'package:provider/provider.dart';

class Listorder extends StatefulWidget {
  Listorder({Key key}) : super(key: key);

  @override
  _ListorderState createState() => _ListorderState();
}

class _ListorderState extends State<Listorder> {
  bool isloading = false;
  String typeArray = '1,2,3,4';
  List list = [];
  Timer timer;
  bool isqianyue = true;
  var flag = false;
  var timers;
  Map status = {
    "0": "无效订单",
    "101": "未付款",
    "102": "已取消",
    "103": "已取消",
    "201": "待回访",
    "202": "退款中",
    "203": "已退款",
    "301": "已回访",
    "302": "已到账",
    "303": "已签约",
    "304": "已出库",
    "401": "已收货",
    "402": "已收货"
  };
  Map goodsstatus = {
    "0": "无效订单",
    "101": "未付款",
    "102": "已取消",
    "103": "已取消",
    "201": "待发货",
    "202": "退款中",
    "203": "已退款",
    "304": "待收货",
    "401": "已收货",
    "402": "已收货"
  };
  Map paid = {
    0: false,
    101: false,
    102: false,
    103: false,
    201: true,
    202: false,
    203: false,
    301: true,
    302: true,
    303: true,
    304: true,
    401: true,
    402: true
  };
  StreamSubscription<WeChatShareResponse> _wxlogin;
  @override
  void initState() {
    super.initState();
    fluwx.registerWxApi(
        appId: "wx234a903f1faba1f9",
        universalLink: "https://app.tuangeche.com.cn/");
    _wxlogin = fluwx.responseFromShare.listen((data) {
      print(data);
    });
    getData();
    timers = Timer.periodic(Duration(milliseconds: 3000), (timer) {
      // timers = timer;
      if (flag) {
        getData();
      }
    });
  }

  void dispose() {
    _wxlogin.cancel();
    timers.cancel();
    super.dispose();
  }

  getUserInfo() async {
    try {
      String userInfo = await Storage.getString('userInfo');
      return userInfo;
    } catch (e) {
      return '';
    }
  }

  getData() async {
    await HttpUtlis.get('wx/order/list?limit=1000&typeArray=${this.typeArray}',
        success: (value) {
      if (value['errno'] == 0) {
        var arr = value['data']['list'];
        if (this.typeArray == '5,6') {
          for (var i = 0, len = arr.length; i < len; i++) {
            if (arr[i]['order']['type']['value'] == 6) {
              var obj = arr[i]['orderGoods'][0]['specifications'];
              var specifica = '';
              for (var key in obj.keys) {
                specifica = specifica + obj['${key}'] + '/';
              }
              arr[i]['specifica'] =
                  specifica.substring(0, specifica.length - 1);
            }
          }
        }
        setState(() {
          list = value['data']['list'];
          this.isloading = true;
        });
      }
    }, failure: (error) {
      Toast.show('${error}', context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    });
    // Future.delayed(Duration(milliseconds: 200)).then((e) {
    //   setState(() {
    //     this.isloading = true;
    //   });
    // });
  }

  getsingn(id) async {
    await HttpUtlis.post("fdd/econtract/sign_contract", params: {
      'orderId': id,
    }, success: (val) async {
      if (val['errno'] == 0) {
        var url = '${val['data']['url']}';
        setState(() {
          isqianyue = true;
          flag = true;
        });
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          Toast.show('请求失败～', context,
              backgroundColor: Color(0xff5b5956),
              backgroundRadius: Ui.width(16),
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER);
        }
      }
    }, failure: (error) {
      Toast.show('${error}', context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    });
  }

  getbtn(item, showtosh) {
    if (paid[item['order']['status']['value']] &&
        item['order']['status']['value'] != 302) {
      return Container(
        child: Container(
          width: Ui.width(750),
          padding: EdgeInsets.fromLTRB(0, 0, Ui.width(20), 0),
          height: Ui.width(100),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      width: Ui.width(1), color: Color(0xFFE9ECF1)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  var tel = await Storage.getString('phone');
                  var url = 'tel:${tel.replaceAll(' ', '')}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw '拨打失败';
                  }
                },
                child: Container(
                  width: Ui.width(160),
                  height: Ui.width(60),
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 0, Ui.width(20), 0),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(Ui.width(6.0))),
                      border: Border.all(
                          width: Ui.width(1), color: Color(0xFFC4C9D3))),
                  child: Text(
                    '联系商家',
                    style: TextStyle(
                        color: Color(0xFF9398A5),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'PingFangSC-Medium,PingFang SC',
                        fontSize: Ui.setFontSizeSetSp(28.0)),
                  ),
                ),
              ),
              // InkWell(
              //   onTap: () async {
              //     var inviteCode = json.decode(await getUserInfo());
              //     // print(inviteCode['inviteCode']);
              //     // print('/pages/index/index?inviteCode=${inviteCode['inviteCode']}');
              //     var model = fluwx.WeChatShareMiniProgramModel(
              //         webPageUrl: "https://wx.qq.com/",
              //         miniProgramType: fluwx.WXMiniProgramType.RELEASE,
              //         userName: 'gh_368f695b400b',
              //         title: '我正在团个车，赶快帮我助力买车吧!',
              //         path:'/pages/index/index?inviteCode=${inviteCode['inviteCode']}',
              //         description: "分享",
              //         thumbnail:
              //             'https://litecarmall.oss-cn-beijing.aliyuncs.com/s76yp88qwelr2g6346p2.png');
              //     fluwx.shareToWeChat(model);
              //   },
              //   child: Container(
              //     width: Ui.width(160),
              //     height: Ui.width(60),
              //     alignment: Alignment.center,
              //     margin: EdgeInsets.fromLTRB(0, 0, Ui.width(20), 0),
              //     decoration: BoxDecoration(
              //         borderRadius:
              //             BorderRadius.all(Radius.circular(Ui.width(6.0))),
              //         border: Border.all(
              //             width: Ui.width(1), color: Color(0xFFC4C9D3))),
              //     child: Text(
              //       '立即分享',
              //       style: TextStyle(
              //           color: Color(0xFF9398A5),
              //           fontWeight: FontWeight.w400,
              //           fontFamily: 'PingFangSC-Medium,PingFang SC',
              //           fontSize: Ui.setFontSizeSetSp(28.0)),
              //     ),
              //   ),
              // ),
              Container(
                child: item['order']['status']['value'] == 304
                    ? InkWell(
                        onTap: () {
                          showtosh(item['order']['id']);
                        },
                        child: Container(
                          width: Ui.width(160),
                          height: Ui.width(60),
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(0, 0, Ui.width(20), 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Ui.width(6.0))),
                              border: Border.all(
                                  width: Ui.width(1),
                                  color: Color(0xFFD10123))),
                          child: Text(
                            '确认收货',
                            style: TextStyle(
                                color: Color(0xFFD10123),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'PingFangSC-Medium,PingFang SC',
                                fontSize: Ui.setFontSizeSetSp(28.0)),
                          ),
                        ),
                      )
                    : Text(''),
              )
            ],
          ),
        ),
      );
    } else if ((item['order']['status']['value'] == 0) &&
        item['order']['type']['value'] == 3) {
      return Container(
        child: Container(
          width: Ui.width(750),
          padding: EdgeInsets.fromLTRB(0, 0, Ui.width(20), 0),
          height: Ui.width(100),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      width: Ui.width(1), color: Color(0xFFE9ECF1)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: Container(
                width: Ui.width(160),
                height: Ui.width(60),
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0, 0, Ui.width(20), 0),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(Ui.width(6.0))),
                    border: Border.all(
                        width: Ui.width(1), color: Color(0xFFD10123))),
                child: Text(
                  '去下单',
                  style: TextStyle(
                      color: Color(0xFFD10123),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'PingFangSC-Medium,PingFang SC',
                      fontSize: Ui.setFontSizeSetSp(28.0)),
                ),
              ))
            ],
          ),
        ),
      );
    } else if (item['order']['status']['value'] == 101) {
      return Container(
        child: Container(
          width: Ui.width(750),
          padding: EdgeInsets.fromLTRB(0, 0, Ui.width(20), 0),
          height: Ui.width(100),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      width: Ui.width(1), color: Color(0xFFE9ECF1)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  print(item['order']['type']['value']);
                  if (item['order']['type']['value'] == 5 ||
                      item['order']['type']['value'] == 6) {
                    Navigator.pushNamed(context, '/goodspayment',
                        arguments: {'id': item['order']['id']});
                  } else {
                    Navigator.pushNamed(context, '/sure',
                        arguments: {'id': item['order']['id']});
                  }
                },
                child: Container(
                    child: Container(
                  width: Ui.width(160),
                  height: Ui.width(60),
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 0, Ui.width(20), 0),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(Ui.width(6.0))),
                      border: Border.all(
                          width: Ui.width(1), color: Color(0xFFD10123))),
                  child: Text(
                    '去付款',
                    style: TextStyle(
                        color: Color(0xFFD10123),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'PingFangSC-Medium,PingFang SC',
                        fontSize: Ui.setFontSizeSetSp(28.0)),
                  ),
                )),
              )
            ],
          ),
        ),
      );
    } else if (item['order']['status']['value'] == 102 ||
        item['order']['status']['value'] == 103) {
      return Container(
        child: Container(
          width: Ui.width(750),
          padding: EdgeInsets.fromLTRB(0, 0, Ui.width(20), 0),
          height: Ui.width(100),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      width: Ui.width(1), color: Color(0xFFE9ECF1)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  delorder(item['order']['id']);
                },
                child: Container(
                  width: Ui.width(160),
                  height: Ui.width(60),
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 0, Ui.width(20), 0),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(Ui.width(6.0))),
                      border: Border.all(
                          width: Ui.width(1), color: Color(0xFFC4C9D3))),
                  child: Text(
                    '删除',
                    style: TextStyle(
                        color: Color(0xFF9398A5),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'PingFangSC-Medium,PingFang SC',
                        fontSize: Ui.setFontSizeSetSp(28.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (item['order']['status']['value'] == 302) {
      //
      return Container(
        child: Container(
          width: Ui.width(750),
          padding: EdgeInsets.fromLTRB(0, 0, Ui.width(20), 0),
          height: Ui.width(100),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      width: Ui.width(1), color: Color(0xFFE9ECF1)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  // var url =
                  //     'https://realnameverify-test.fadada.com/fddAuthenticationService/v1/api/synsAuthentication.action?transaction_no=491D2B8B10860B59D5FC3DA37030EC9A20D011212B2B9CF6D4A63346AF79FEC858DF9ADEECC86A80&sign=MkFDRTYzODYwRjEzQTg5NzY5NjRCNzcwNkVBM0M4NzA1ODFGNjUzRQ==&app_id=402627&timestamp=1577248755601';
                  // if (await canLaunch(url)) {
                  //   await launch(url);
                  // } else {
                  //   Toast.show('请求失败～', context,
                  //       backgroundColor: Color(0xff5b5956),
                  //       backgroundRadius: Ui.width(16),
                  //       duration: Toast.LENGTH_SHORT,
                  //       gravity: Toast.CENTER);
                  // }
                  if (isqianyue) {
                    setState(() {
                      isqianyue = false;
                    });
                    getsingn(item['order']['id']);
                  }
                },
                child: Container(
                    child: Container(
                  width: Ui.width(160),
                  height: Ui.width(60),
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 0, Ui.width(20), 0),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(Ui.width(6.0))),
                      border: Border.all(
                          width: Ui.width(1), color: Color(0xFFD10123))),
                  child: Text(
                    '去签约',
                    style: TextStyle(
                        color: Color(0xFFD10123),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'PingFangSC-Medium,PingFang SC',
                        fontSize: Ui.setFontSizeSetSp(28.0)),
                  ),
                )),
              )
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  delorder(id) {
    HttpUtlis.post("wx/order/delete/${id}", params: {}, success: (value) async {
      if (value['errno'] == 0) {
        Toast.show('删除成功～', context,
            backgroundColor: Color(0xff5b5956),
            backgroundRadius: Ui.width(16),
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);

        timer = new Timer(new Duration(seconds: 1), () {
          getData();
        });
        // Navigator.pop(context);
      }
    }, failure: (error) {
      Toast.show('${error}', context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    });
  }

  takeover(id) {
    HttpUtlis.post("wx/order/confirm", params: {'id': id},
        success: (value) async {
      if (value['errno'] == 0) {
        Toast.show('确认成功～', context,
            backgroundColor: Color(0xff5b5956),
            backgroundRadius: Ui.width(16),
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
        getData();
      }
    }, failure: (error) {
      Toast.show('${error}', context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    });
  }

  @override
  Widget build(BuildContext context) {
    showtosh(id) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Center(
              child: Container(
                  width: Ui.width(600),
                  height: Ui.width(300),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.all(Radius.circular(Ui.width(20.0))),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: Ui.width(600),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: Ui.width(30),
                            ),
                            Text('温馨提示',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Color(0xFF111F37),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'PingFangSC-Medium,PingFang SC',
                                    fontSize: Ui.setFontSizeSetSp(36.0))),
                            SizedBox(
                              height: Ui.width(40),
                            ),
                            Text('是否确认收货～',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Color(0xFF111F37),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'PingFangSC-Medium,PingFang SC',
                                    fontSize: Ui.setFontSizeSetSp(30.0))),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: Ui.width(600),
                          height: Ui.width(92),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(
                                                  Ui.width(20)))),
                                      child: Text('取消',
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              color: Color(0xFF3895FF),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Medium,PingFang SC',
                                              fontSize:
                                                  Ui.setFontSizeSetSp(36.0))),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            width: Ui.width(2),
                                            color: Color(0xffEAEAEA)),
                                        right: BorderSide(
                                            width: Ui.width(2),
                                            color: Color(0xffEAEAEA))),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                      onTap: () {
                                        takeover(id);
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(
                                                bottom: Radius.circular(
                                                    Ui.width(20)))),
                                        child: Text('确认',
                                            style: TextStyle(
                                                decoration: TextDecoration.none,
                                                color: Color(0xFF3895FF),
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    'PingFangSC-Medium,PingFang SC',
                                                fontSize:
                                                    Ui.setFontSizeSetSp(36.0))),
                                      )),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            width: Ui.width(2),
                                            color: Color(0xffEAEAEA))),
                                  ),
                                ),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(Ui.width(20))),
                          ),
                        ),
                      )
                    ],
                  )),
            );
          });
    }

//    final counter = Provider.of<Backhome>(context);
    Ui.init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '我的订单',
            style: TextStyle(
                color: Color(0xFF111F37),
                fontWeight: FontWeight.w500,
                fontFamily: 'PingFangSC-Medium,PingFang SC',
                fontSize: Ui.setFontSizeSetSp(36.0)),
          ),
          centerTitle: true,
          elevation: 0,
          brightness: Brightness.light,
          leading: InkWell(
            onTap: () {
              // counter.increment(2);
              Navigator.pop(context);
              // Navigator.popAndPushNamed(context, '/');
            },
            child: Container(
              alignment: Alignment.center,
              child: Image.asset(
                'images/2.0x/back.png',
                width: Ui.width(21),
                height: Ui.width(37),
              ),
            ),
          ),
        ),
        body: isloading
            ? Container(
                color: Color(0xFFF8F9FB),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        color: Colors.white,
                        height: Ui.width(90),
                        width: Ui.width(750),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      typeArray = '1,2,3,4';
                                      isloading = false;
                                    });
                                    getData();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '购车订单',
                                      style: TextStyle(
                                          color: typeArray == '1,2,3,4'
                                              ? Color(0xFFD10123)
                                              : Color(0xFF111F37),
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              'PingFangSC-Medium,PingFang SC',
                                          fontSize: Ui.setFontSizeSetSp(30.0)),
                                    ),
                                  ),
                                )),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    typeArray = '5,6';
                                    isloading = false;
                                  });
                                  getData();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '商城订单',
                                    style: TextStyle(
                                        color: typeArray == '5,6'
                                            ? Color(0xFFD10123)
                                            : Color(0xFF111F37),
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Medium,PingFang SC',
                                        fontSize: Ui.setFontSizeSetSp(30.0)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          Ui.width(24), Ui.width(90), Ui.width(24), 0),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, Ui.width(30)),
                      child: list.length > 0
                          ? ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    if (typeArray == '1,2,3,4') {
                                      Navigator.pushNamed(context, '/spell',
                                          arguments: {
                                            'id': list[index]['order']['id']
                                          });
                                    } else {
                                      Navigator.pushNamed(context, '/ordernew',
                                          arguments: {
                                            'id': list[index]['order']['id']
                                          });
                                    }
                                  },
                                  child: Container(
                                    width: Ui.width(702),
                                    margin: EdgeInsets.fromLTRB(
                                        0, Ui.width(16), 0, 0),
                                    padding: EdgeInsets.fromLTRB(
                                        Ui.width(20), 0, Ui.width(20), 0),
                                    constraints: BoxConstraints(
                                      minHeight: Ui.width(300),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(Ui.width(8.0))),
                                    ),
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            height: Ui.width(70),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 1,
                                                        color: Color(
                                                            0xffEAEAEA)))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  '${list[index]['order']['addTime'].substring(0, 10)}',
                                                  style: TextStyle(
                                                      color: Color(0xFF111F37),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          'PingFangSC-Medium,PingFang SC',
                                                      fontSize:
                                                          Ui.setFontSizeSetSp(
                                                              26.0)),
                                                ),
                                                Text(
                                                  list[index]['order']['status']
                                                              ['value'] ==
                                                          0
                                                      ? '${list[index]['order']['type']['label']}'
                                                      : typeArray != '5,6'
                                                          ? '${status["${list[index]["order"]["status"]["value"]}"]}'
                                                          : '${goodsstatus["${list[index]["order"]["status"]["value"]}"]}',
                                                  style: TextStyle(
                                                      color: Color(0xFF9398A5),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          'PingFangSC-Medium,PingFang SC',
                                                      fontSize:
                                                          Ui.setFontSizeSetSp(
                                                              26.0)),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: Ui.width(230),
                                            padding: EdgeInsets.fromLTRB(0,
                                                Ui.width(20), 0, Ui.width(30)),
                                            child: typeArray != '5,6'
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                        width: Ui.width(235),
                                                        height: Ui.width(180),
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0,
                                                                0,
                                                                Ui.width(30),
                                                                0),
                                                        // decoration:
                                                        //     BoxDecoration(
                                                        //   image:
                                                        //       DecorationImage(
                                                        //     image: NetworkImage(
                                                        //       '${list[index]['goods'][0]['picUrl']}?x-oss-process=image/resize,p_70',
                                                        //     ),
                                                        //     fit: BoxFit.fill,
                                                        //   ),
                                                        // ),
                                                        child: CachedNetworkImage(
                                                            width:
                                                                Ui.width(235),
                                                            height:
                                                                Ui.width(180),
                                                            fit: BoxFit.fill,
                                                            imageUrl:
                                                                '${list[index]['goods'][0]['picUrl']}'),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          height: Ui.width(180),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                child: Text(
                                                                  '${list[index]['goods'][0]['name']}',
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFF111F37),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontFamily:
                                                                          'PingFangSC-Medium,PingFang SC',
                                                                      fontSize:
                                                                          Ui.setFontSizeSetSp(
                                                                              28.0)),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  '小团集采价：${list[index]['goods'][0]['retailPrice']}${list[index]['goods'][0]['unit']}',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFF9398A5),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontFamily:
                                                                          'PingFangSC-Medium,PingFang SC',
                                                                      fontSize:
                                                                          Ui.setFontSizeSetSp(
                                                                              24.0)),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  '预定金 : ¥${list[index]['orderGoods'][0]['depositPrice']}',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFFD10123),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontFamily:
                                                                          'PingFangSC-Medium,PingFang SC',
                                                                      fontSize:
                                                                          Ui.setFontSizeSetSp(
                                                                              26.0)),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                        width: Ui.width(180),
                                                        height: Ui.width(180),
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0,
                                                                0,
                                                                Ui.width(30),
                                                                0),
                                                        // decoration:
                                                        //     BoxDecoration(
                                                        //   image:
                                                        //       DecorationImage(
                                                        //     image: NetworkImage(
                                                        //       '${list[index]['goods'][0]['picUrl']}?x-oss-process=image/resize,p_70',
                                                        //     ),
                                                        //     fit: BoxFit.fill,
                                                        //   ),
                                                        // ),
                                                        child: CachedNetworkImage(
                                                            width:
                                                                Ui.width(235),
                                                            height:
                                                                Ui.width(180),
                                                            fit: BoxFit.fill,
                                                            imageUrl:
                                                                '${list[index]['goods'][0]['picUrl']}'),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          height: Ui.width(180),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        '${list[index]['goods'][0]['name']}',
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            color: Color(
                                                                                0xFF111F37),
                                                                            fontWeight: FontWeight
                                                                                .w400,
                                                                            fontFamily:
                                                                                'PingFangSC-Medium,PingFang SC',
                                                                            fontSize:
                                                                                Ui.setFontSizeSetSp(28.0)),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: Ui
                                                                          .width(
                                                                              12),
                                                                    ),
                                                                    Container(
                                                                      child: list[index]['order']['type']['value'] ==
                                                                              6
                                                                          ? Text(
                                                                              '${list[index]['specifica']}',
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(color: Color(0xFF9398A5), fontWeight: FontWeight.w400, fontFamily: 'PingFangSC-Medium,PingFang SC', fontSize: Ui.setFontSizeSetSp(24.0)),
                                                                            )
                                                                          : SizedBox(),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                  child: Text(
                                                                list[index]['order']['type']
                                                                            [
                                                                            'value'] ==
                                                                        6
                                                                    ? '实付：￥${list[index]['order']['actualPrice']}'
                                                                    : '实付：${list[index]['order']['integralPrice']}积分 +${list[index]['order']['actualPrice']}元',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF111F37),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontFamily:
                                                                        'PingFangSC-Medium,PingFang SC',
                                                                    fontSize: Ui
                                                                        .setFontSizeSetSp(
                                                                            26.0)),
                                                              ))
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  Ui.width(10),
                                                                  0,
                                                                  0,
                                                                  0),
                                                          child: Text(
                                                            '${list[index]['orderGoods'][0]['number']}X',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF9398A5),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    'PingFangSC-Medium,PingFang SC',
                                                                fontSize: Ui
                                                                    .setFontSizeSetSp(
                                                                        28.0)),
                                                          ))
                                                    ],
                                                  ),
                                          ),

                                          // Container(
                                          //   padding: EdgeInsets.fromLTRB(
                                          //       Ui.width(30),
                                          //       0,
                                          //       0,
                                          //       Ui.width(30)),
                                          //   child: Row(
                                          //     children: <Widget>[
                                          //       Container(
                                          //         width: Ui.width(220),
                                          //         height: Ui.width(170),
                                          //         margin: EdgeInsets.fromLTRB(
                                          //             0, 0, Ui.width(30), 0),
                                          //         child: Column(
                                          //           children: <Widget>[
                                          //             Container(
                                          //               width: Ui.width(220),
                                          //               height: Ui.width(140),
                                          //               decoration:
                                          //                   BoxDecoration(
                                          //                       image:
                                          //                           DecorationImage(
                                          //                         image:
                                          //                             NetworkImage(
                                          //                           '${list[index]['goods'][0]['picUrl']}?x-oss-process=image/resize,p_70',
                                          //                         ),
                                          //                         fit: BoxFit
                                          //                             .fill,
                                          //                       ),
                                          //                       borderRadius: BorderRadius.vertical(
                                          //                           top: Radius.circular(
                                          //                               Ui.width(
                                          //                                   6)))),
                                          //             ),
                                          //             Container(
                                          //               width: Ui.width(220),
                                          //               height: Ui.width(30),
                                          //               decoration:
                                          //                   BoxDecoration(
                                          //                 borderRadius:
                                          //                     BorderRadius.vertical(
                                          //                         bottom: Radius
                                          //                             .circular(
                                          //                                 Ui.width(
                                          //                                     6))),
                                          //                 gradient:
                                          //                     LinearGradient(
                                          //                   begin: Alignment
                                          //                       .centerLeft,
                                          //                   end: Alignment
                                          //                       .centerRight,
                                          //                   colors: paid[list[index]
                                          //                                   [
                                          //                                   "order"]
                                          //                               [
                                          //                               "status"]
                                          //                           ["value"]]
                                          //                       ? [
                                          //                           Color(
                                          //                               0xFF69C7FF),
                                          //                           Color(
                                          //                               0xFF3895FF),
                                          //                         ]
                                          //                       : [
                                          //                           Color(
                                          //                               0xFFD92818),
                                          //                           Color(
                                          //                               0xFFEE6C35),
                                          //                         ],
                                          //                 ),
                                          //               ),
                                          //               alignment:
                                          //                   Alignment.center,
                                          //               child: Text(
                                          //                 list[index]['order'][
                                          //                                 'status']
                                          //                             [
                                          //                             'value'] ==
                                          //                         0
                                          //                     ? '${list[index]['order']['type']['label']}'
                                          //                     : typeArray !=
                                          //                             '5,6'
                                          //                         ? '${status["${list[index]["order"]["status"]["value"]}"]}'
                                          //                         : '${goodsstatus["${list[index]["order"]["status"]["value"]}"]}',
                                          //                 style: TextStyle(
                                          //                     color: Color(
                                          //                         0xFFFFFFFF),
                                          //                     fontWeight:
                                          //                         FontWeight
                                          //                             .w400,
                                          //                     fontFamily:
                                          //                         'PingFangSC-Medium,PingFang SC',
                                          //                     fontSize: Ui
                                          //                         .setFontSizeSetSp(
                                          //                             22.0)),
                                          //               ),
                                          //             )
                                          //           ],
                                          //         ),
                                          //       ),
                                          //       Expanded(
                                          //         flex: 1,
                                          //         child: Container(
                                          //           height: Ui.width(168),
                                          //           child: Column(
                                          //             mainAxisAlignment:
                                          //                 MainAxisAlignment
                                          //                     .start,
                                          //             crossAxisAlignment:
                                          //                 CrossAxisAlignment
                                          //                     .start,
                                          //             children: <Widget>[
                                          // Container(
                                          //   width:
                                          //       double.infinity,
                                          //   child:
                                          // Text(
                                          //     '${list[index]['goods'][0]['name']}',
                                          //     maxLines: 1,
                                          //     overflow:
                                          //         TextOverflow
                                          //             .ellipsis,
                                          //     style: TextStyle(
                                          //         color: Color(
                                          //             0xFF111F37),
                                          //         fontWeight:
                                          //             FontWeight
                                          //                 .w400,
                                          //         fontFamily:
                                          //             'PingFangSC-Medium,PingFang SC',
                                          //         fontSize: Ui
                                          //             .setFontSizeSetSp(
                                          //                 34.0)),
                                          //   ),
                                          // ),
                                          //               SizedBox(
                                          //                 height: Ui.width(18),
                                          //               ),
                                          //               // Container(
                                          //               //   width: double.infinity,
                                          //               //   margin:
                                          //               //       EdgeInsets.fromLTRB(
                                          //               //           0,
                                          //               //           0,
                                          //               //           Ui.width(10),
                                          //               //           0),
                                          //               //   child: Text(
                                          //               //     '小团集采价：fasdfsd',
                                          //               //     maxLines: 1,
                                          //               //     overflow: TextOverflow
                                          //               //         .ellipsis,
                                          //               //     style: TextStyle(
                                          //               //         color: Color(
                                          //               //             0xFF9398A5),
                                          //               //         fontWeight:
                                          //               //             FontWeight
                                          //               //                 .w400,
                                          //               //         fontFamily:
                                          //               //             'PingFangSC-Medium,PingFang SC',
                                          //               //         fontSize: Ui
                                          //               //             .setFontSizeSetSp(
                                          //               //                 26.0)),
                                          //               //   ),
                                          //               // ),
                                          //               // SizedBox(
                                          //               //   height: Ui.width(30),
                                          //               // ),
                                          //               Container(
                                          //                   width:
                                          //                       double.infinity,
                                          //                   margin: EdgeInsets
                                          //                       .fromLTRB(
                                          //                           0,
                                          //                           Ui.width(
                                          //                               10),
                                          //                           Ui.width(
                                          //                               10),
                                          //                           0),
                                          // child: Row(
                                          //   children: <
                                          //       Widget>[
                                          //     Text(
                                          //       typeArray ==
                                          //               '5,6'
                                          //           ? '总价：'
                                          //           : '小团集采价：',
                                          //       maxLines: 1,
                                          //       overflow:
                                          //           TextOverflow
                                          //               .ellipsis,
                                          //       style: TextStyle(
                                          //           color: Color(
                                          //               0xFF9398A5),
                                          //           fontWeight:
                                          //               FontWeight
                                          //                   .w400,
                                          //           fontFamily:
                                          //               'PingFangSC-Medium,PingFang SC',
                                          //           fontSize:
                                          //               Ui.setFontSizeSetSp(
                                          //                   28.0)),
                                          //     ),
                                          //     Text(
                                          //       typeArray ==
                                          //               '5,6'
                                          //           ? '${list[index]['order']['integralPrice']}积分 +${list[index]['order']['actualPrice']}元 '
                                          //           : '${list[index]['goods'][0]['retailPrice']}${list[index]['goods'][0]['unit']}',
                                          //       maxLines: 1,
                                          //       overflow:
                                          //           TextOverflow
                                          //               .ellipsis,
                                          //       style: TextStyle(
                                          //           color: Color(
                                          //               0xFFD10123),
                                          //           fontWeight:
                                          //               FontWeight
                                          //                   .w400,
                                          //           fontFamily:
                                          //               'PingFangSC-Medium,PingFang SC',
                                          //           fontSize:
                                          //               Ui.setFontSizeSetSp(
                                          //                   28.0)),
                                          //     )
                                          //   ],
                                          // )),
                                          //             ],
                                          //           ),
                                          //         ),
                                          //       )
                                          //     ],
                                          //   ),
                                          // ),
                                          getbtn(list[index], showtosh)
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Nofind(
                              text: "暂无订单～",
                            ),
                    )
                  ],
                ),
              )
            : Container(
                child: LoadingDialog(
                  text: "加载中…",
                ),
              ));
  }
}
