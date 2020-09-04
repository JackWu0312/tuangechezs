import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../ui/ui.dart';
import '../../http/index.dart';
import '../../common/LoadingDialog.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import '../../provider/Addressselect.dart';

class Ordercom extends StatefulWidget {
  final Map arguments;
  Ordercom({Key key, this.arguments}) : super(key: key);
  @override
  _OrdercomState createState() => _OrdercomState();
}

class _OrdercomState extends State<Ordercom> {
  var _initKeywordsController = new TextEditingController();

  bool isloading = false;
  int points = 0;
  double retailPrice = 0;
  var item;
  var adress;
  var counter;
  var message;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getAdress();
  }

  calculate(id) async {
    print(int.parse(widget.arguments['num']));
    await HttpUtlis.post('third/points/goods/calculate',
        params: {'id': id, 'number': int.parse(widget.arguments['num'])},
        success: (value) {
      if (value['errno'] == 0) {
        setState(() {
          points = value['data']['points'];
          retailPrice = value['data']['price'];
        });
      }
    }, failure: (error) {
      print(error);
      Toast.show('${error}', context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    });
  }

  getData() async {
    await HttpUtlis.get('third/points/goods/${widget.arguments['id']}',
        success: (value) {
      if (value['errno'] == 0) {
        //  print(value['data']);
        setState(() {
          item = value['data'];
        });
        calculate(value['data']['product']['id']);
        // print(data['attributes']);
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

  getAdress() async {
    await HttpUtlis.get('third/address/default', success: (value) {
      if (value['errno'] == 0) {
        setState(() {
          adress = value['data'];
        });
        if (adress != null) {
          counter.increment(adress);
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

  submit() async {
    if (adress == null || json.encode(counter.count) == '{}') {
      Toast.show('请添加收货地址～', context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
      return;
    }

    await HttpUtlis.post('third/points/order/submit', params: {
      'goodsId': item['goods']['id'],
      'addressId': adress['id'],
      'number': int.parse(widget.arguments['num']),
      'message':message
    }, success: (value) {
      if (value['errno'] == 0) {
        Navigator.pushNamed(context, '/goodspayment',
            arguments: {'id': value['data']['id']});
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
    counter = Provider.of<Addressselect>(context);
    if (json.encode(counter.count) != '{}') {
      setState(() {
        adress = counter.count;
      });
    } else {
      if (adress != null) {
        getAdress();
      }
    }
    Ui.init(context);
    return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
         child: Scaffold(
      resizeToAvoidBottomInset: false,
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
                        '订单填写',
                        style: TextStyle(
                            color: Color(0XFFFFFFFF),
                            fontSize: Ui.setFontSizeSetSp(36),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'PingFangSC-Regular,PingFang SC'),
                      ),
                    )
                  ],
                ),
              )),
          preferredSize:
          Size(MediaQuery.of(context).size.width, Ui.width(90))),
      body: Stack(
        children: <Widget>[
          Container(
            width: Ui.width(750),
            color: Color(0xFFF8F9FB),
            child: isloading
                ? ListView(
                    children: <Widget>[
                      Container(
                        width: Ui.width(702),
                        margin: EdgeInsets.fromLTRB(Ui.width(24), Ui.width(20),
                            Ui.width(24), Ui.width(20)),
                        padding: EdgeInsets.fromLTRB(Ui.width(30), Ui.width(40),
                            Ui.width(0), Ui.width(30)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(Ui.width(8.0))),
                        ),
                        constraints: BoxConstraints(
                          minHeight: Ui.width(186),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: Ui.width(48),
                              margin:
                                  EdgeInsets.fromLTRB(0, 0, Ui.width(30), 0),
                              child: Image.asset('images/2.0x/adress.png',
                                  width: Ui.width(48), height: Ui.width(48)),
                            ),
                            Expanded(
                                flex: 1,
                                child: json.encode(counter.count) != '{}' &&
                                        adress != null
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/addresslistnew');
                                        },
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '${adress['name']}  ${adress['tel']}',
                                                style: TextStyle(
                                                    color: Color(0xFF111F37),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'PingFangSC-Medium,PingFang SC',
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(
                                                            32.0)),
                                              ),
                                              SizedBox(
                                                height: Ui.width(20),
                                              ),
                                              Text(
                                                '${adress['fullAddress']}',
                                                style: TextStyle(
                                                    color: Color(0xFF6A7182),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'PingFangSC-Medium,PingFang SC',
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(
                                                            28.0)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/addresslistnew');
                                        },
                                        child: Container(
                                          child: Text(
                                            '暂无收货地址，请点击添加哦～',
                                            style: TextStyle(
                                                color: Color(0xFF111F37),
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
                      ),
                      Container(
                        width: Ui.width(702),
                        constraints: BoxConstraints(
                          // minHeight: Ui.width(572),
                          minHeight: Ui.width(460),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(Ui.width(8.0))),
                        ),
                        margin: EdgeInsets.fromLTRB(
                            Ui.width(24), 0, Ui.width(24), 0),
                        padding: EdgeInsets.fromLTRB(Ui.width(20), Ui.width(30),
                            Ui.width(20), Ui.width(30)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: Ui.width(180),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: Ui.width(180),
                                    height: Ui.width(180),
                                    margin: EdgeInsets.fromLTRB(
                                        0, 0, Ui.width(30), 0),
                                    child: CachedNetworkImage(
                                                    width: Ui.width(180),
                                    height: Ui.width(180),
                                                    fit: BoxFit.fill,
                                                    imageUrl:
                                                        '${item['goods']['picUrl']}'),
                                    // decoration: BoxDecoration(
                                    //     image: DecorationImage(
                                    //         fit: BoxFit.fill,
                                    //         image: NetworkImage(
                                    //             '${item['goods']['picUrl']}'))),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: Ui.width(180),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    "[ ${item['brand']['name']} ] ${item['goods']['name']}",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF111F37),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            'PingFangSC-Medium,PingFang SC',
                                                        fontSize:
                                                            Ui.setFontSizeSetSp(
                                                                28.0)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                         Container(
                                            child: RichText(
                                              text: TextSpan(
                                                text:
                                                    '${item['goods']['points']}',
                                                style: TextStyle(
                                                    color: Color(0xFFD10123),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'PingFangSC-Medium,PingFang SC',
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(
                                                            34.0)),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: ' 积分',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFFD10123),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'PingFangSC-Medium,PingFang SC',
                                                          fontSize: Ui
                                                              .setFontSizeSetSp(
                                                                  24.0))),
//                                                  TextSpan(
//                                                      text:
//                                                          '+${item['goods']['retailPrice']}',
//                                                      style: TextStyle(
//                                                          color:
//                                                              Color(0xFFD10123),
//                                                          fontWeight:
//                                                              FontWeight.w400,
//                                                          fontFamily:
//                                                              'PingFangSC-Medium,PingFang SC',
//                                                          fontSize: Ui
//                                                              .setFontSizeSetSp(
//                                                                  34.0))),
//                                                  TextSpan(
//                                                      text: '元',
//                                                      style: TextStyle(
//                                                          color:
//                                                              Color(0xFFD10123),
//                                                          fontWeight:
//                                                              FontWeight.w400,
//                                                          fontFamily:
//                                                              'PingFangSC-Medium,PingFang SC',
//                                                          fontSize: Ui
//                                                              .setFontSizeSetSp(
//                                                                  24.0))),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        Ui.width(30), 0, 0, 0),
                                    child: Text(
                                      'x${widget.arguments['num']}',
                                      style: TextStyle(
                                          color: Color(0xFF9398A5),
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              'PingFangSC-Medium,PingFang SC',
                                          fontSize: Ui.setFontSizeSetSp(28.0)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  Ui.width(80), Ui.width(40), 0, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0, 0, 0, Ui.width(30)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 0, Ui.width(30), 0),
                                          child: Text(
                                            '订单备注',
                                            style: TextStyle(
                                                color: Color(0xFF111F37),
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    'PingFangSC-Medium,PingFang SC',
                                                fontSize:
                                                    Ui.setFontSizeSetSp(26.0)),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: TextField(
                                            controller:
                                                this._initKeywordsController,
                                            style: TextStyle(
                                                color: Color(0XFF111F37),
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    Ui.setFontSizeSetSp(26)),
                                            textAlign: TextAlign.left,
                                            keyboardAppearance:
                                                Brightness.light,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              hintText: '选填，可以告知商家您的需求',
                                              hintStyle: TextStyle(
                                                color: Color(0xFF9398A5),
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    'PingFangSC-Medium,PingFang SC',
                                                fontSize:
                                                    Ui.setFontSizeSetSp(26.0),
                                              ),
                                              border: InputBorder.none,
                                              // filled: true,
                                              // fillColor: Color(0xFFF8F9FB),
                                              // // contentPadding: EdgeInsets.fromLTRB(
                                              // //     0, 0, 0, style==1?Ui.width(26):Ui.width(30)),
                                              // focusedBorder: OutlineInputBorder(
                                              //   borderSide: BorderSide(
                                              //       color: Color(0xFFF8F9FB)),
                                              //   borderRadius:
                                              //       BorderRadius.circular(Ui.width(7)),
                                              // ),
                                              // enabledBorder: UnderlineInputBorder(
                                              //   borderSide: BorderSide(
                                              //       color: Color(0xFFF8F9FB)),
                                              //   borderRadius:
                                              //       BorderRadius.circular(Ui.width(7)),
                                              // ),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                message = value;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '共${widget.arguments['num']}件',
                                    style: TextStyle(
                                        color: Color(0xFF9398A5),
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Medium,PingFang SC',
                                        fontSize: Ui.setFontSizeSetSp(26.0)),
                                  ),
                                  SizedBox(
                                    width: Ui.width(20),
                                  ),
                                  Text(
                                    '小计：',
                                    style: TextStyle(
                                        color: Color(0xFF111F37),
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Medium,PingFang SC',
                                        fontSize: Ui.setFontSizeSetSp(26.0)),
                                  ),
                                  SizedBox(
                                    width: Ui.width(10),
                                  ),
                                  Text(
                                    '${points}积分',
                                    style: TextStyle(
                                        color: Color(0xFFD10123),
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Medium,PingFang SC',
                                        fontSize: Ui.setFontSizeSetSp(26.0)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      // Container(
                      //   width: Ui.width(750),
                      //   height: Ui.width(240),
                      //   padding: EdgeInsets.fromLTRB(Ui.width(30), Ui.width(30),
                      //       Ui.width(30), Ui.width(30)),
                      //   color: Colors.white,
                      //   margin: EdgeInsets.fromLTRB(0, Ui.width(16), 0, 0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Container(
                      //         width: Ui.width(180),
                      //         height: Ui.width(180),
                      //         margin:
                      //             EdgeInsets.fromLTRB(0, 0, Ui.width(30), 0),
                      //         // color: Colors.red,
                      //         child: AspectRatio(
                      //           aspectRatio: 1 / 1,
                      //           child: Image.network(
                      //             '${item['goods']['picUrl']}',
                      //             fit: BoxFit.cover,
                      //           ),
                      //         ),
                      //       ),
                      //       Expanded(
                      //         flex: 1,
                      //         child: Container(
                      //           child: Column(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceBetween,
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: <Widget>[
                      //               Text(
                      //                 '${item['brand']['name']}',
                      //                 style: TextStyle(
                      //                     color: Color(0xFF111F37),
                      //                     fontWeight: FontWeight.w400,
                      //                     fontFamily:
                      //                         'PingFangSC-Medium,PingFang SC',
                      //                     fontSize: Ui.setFontSizeSetSp(30.0)),
                      //               ),
                      //               Container(
                      //                 child: Text(
                      //                   '${item['goods']['name']}',
                      //                   maxLines: 2,
                      //                   overflow: TextOverflow.ellipsis,
                      //                   style: TextStyle(
                      //                       color: Color(0xFF111F37),
                      //                       fontWeight: FontWeight.w400,
                      //                       fontFamily:
                      //                           'PingFangSC-Medium,PingFang SC',
                      //                       fontSize:
                      //                           Ui.setFontSizeSetSp(28.0)),
                      //                 ),
                      //               ),
                      //               Container(
                      //                 child: Row(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.spaceBetween,
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.end,
                      //                   children: <Widget>[
                      //                     Container(
                      //                       child: RichText(
                      //                         text: TextSpan(
                      //                           text:
                      //                               '${item['goods']['points']}',
                      //                           style: TextStyle(
                      //                               color: Color(0xFFD10123),
                      //                               fontWeight: FontWeight.w400,
                      //                               fontFamily:
                      //                                   'PingFangSC-Medium,PingFang SC',
                      //                               fontSize:
                      //                                   Ui.setFontSizeSetSp(
                      //                                       34.0)),
                      //                           children: <TextSpan>[
                      //                             TextSpan(
                      //                                 text: ' 积分',
                      //                                 style: TextStyle(
                      //                                     color:
                      //                                         Color(0xFFD10123),
                      //                                     fontWeight:
                      //                                         FontWeight.w400,
                      //                                     fontFamily:
                      //                                         'PingFangSC-Medium,PingFang SC',
                      //                                     fontSize: Ui
                      //                                         .setFontSizeSetSp(
                      //                                             24.0))),
                      //                             TextSpan(
                      //                                 text:
                      //                                     '+${item['goods']['retailPrice']}',
                      //                                 style: TextStyle(
                      //                                     color:
                      //                                         Color(0xFFD10123),
                      //                                     fontWeight:
                      //                                         FontWeight.w400,
                      //                                     fontFamily:
                      //                                         'PingFangSC-Medium,PingFang SC',
                      //                                     fontSize: Ui
                      //                                         .setFontSizeSetSp(
                      //                                             34.0))),
                      //                             TextSpan(
                      //                                 text: '元',
                      //                                 style: TextStyle(
                      //                                     color:
                      //                                         Color(0xFFD10123),
                      //                                     fontWeight:
                      //                                         FontWeight.w400,
                      //                                     fontFamily:
                      //                                         'PingFangSC-Medium,PingFang SC',
                      //                                     fontSize: Ui
                      //                                         .setFontSizeSetSp(
                      //                                             24.0))),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     ),
                      //                     Text(
                      //                       'x${widget.arguments['num']}',
                      //                       style: TextStyle(
                      //                           color: Color(0xFF9398A5),
                      //                           fontWeight: FontWeight.w400,
                      //                           fontFamily:
                      //                               'PingFangSC-Medium,PingFang SC',
                      //                           fontSize:
                      //                               Ui.setFontSizeSetSp(30.0)),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ],
                  )
                : Container(
                    margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                    child: LoadingDialog(
                      text: "加载中…",
                    ),
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: Ui.width(750),
              height: Ui.width(90),
              // alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Container(
                    width: Ui.width(450),
                    height: Ui.width(90),
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(Ui.width(35), 0, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        text: '合计：',
                        style: TextStyle(
                            color: Color(0xFF111F37),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'PingFangSC-Medium,PingFang SC',
                            fontSize: Ui.setFontSizeSetSp(26.0)),
                        children: <TextSpan>[
                          TextSpan(
                              text: '${points}',
                              style: TextStyle(
                                  color: Color(0xFFD10123),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'PingFangSC-Medium,PingFang SC',
                                  fontSize: Ui.setFontSizeSetSp(32.0))),
                          TextSpan(
                              text: '积分',
                              style: TextStyle(
                                  color: Color(0xFFD10123),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'PingFangSC-Medium,PingFang SC',
                                  fontSize: Ui.setFontSizeSetSp(24.0))),
//                          TextSpan(
//                              text: '+${retailPrice}',
//                              style: TextStyle(
//                                  color: Color(0xFFD10123),
//                                  fontWeight: FontWeight.w400,
//                                  fontFamily: 'PingFangSC-Medium,PingFang SC',
//                                  fontSize: Ui.setFontSizeSetSp(32.0))),
//                          TextSpan(
//                              text: '元',
//                              style: TextStyle(
//                                  color: Color(0xFFD10123),
//                                  fontWeight: FontWeight.w400,
//                                  fontFamily: 'PingFangSC-Medium,PingFang SC',
//                                  fontSize: Ui.setFontSizeSetSp(24.0))),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          submit();
                        },
                        child: Container(
                          height: Ui.width(90),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFEA4802),
                                Color(0xFFD10123),
                              ],
                            ),
                          ),
                          child: Text(
                            '立即支付',
                            style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'PingFangSC-Medium,PingFang SC',
                                fontSize: Ui.setFontSizeSetSp(32.0)),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
