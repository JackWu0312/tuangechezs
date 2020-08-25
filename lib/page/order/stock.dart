import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/ui.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../http/index.dart';
import '../../common/Unit.dart';
import '../../common/LoadingDialog.dart';
import 'package:provider/provider.dart';
import '../../provider/Orderback.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/Storage.dart';

class Stock extends StatefulWidget {
  final Map arguments;
  Stock({Key key, this.arguments}) : super(key: key);
  @override
  _StockState createState() => _StockState();
}

class _StockState extends State<Stock> {
  bool isloading = false;
  var data;
  var takeSn = '';
  var message = '';
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await HttpUtlis.get('third/order/${widget.arguments['id']}',
        success: (value) {
      if (value['errno'] == 0) {
        setState(() {
          data = value['data'];
        });
      }
    }, failure: (error) {
      Unit.setToast('${error}', context);
    });
    setState(() {
      isloading = true;
    });
  }

  var timer;
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  submit() async {
    if (takeSn == '' || takeSn.length != 6) {
      Unit.setToast("请输入6位取货码～", context);
      return;
    }
    if (message == '') {
      Unit.setToast("请输入出库备注～", context);
      return;
    }
    await HttpUtlis.post('third/order/ship/${widget.arguments['id']}',
        params: {"message": message, "takeSn": takeSn}, success: (value) async {
      if (value['errno'] == 0) {
        Unit.setToast('出库成功～', context);
        final counter = Provider.of<Orderback>(context);
        counter.increment(true);
        timer = new Timer(new Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      } else {
        Unit.setToast('出库失败～', context);
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
                                  '订单出库',
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
                        width: Ui.width(750),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              padding:
                                  EdgeInsets.fromLTRB(0, 0, 0, Ui.width(90)),
                              child: ListView(
                                children: <Widget>[
                                  Container(
                                    width: Ui.width(750),
                                    height: Ui.width(400),
                                    child: Swiper(
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {},
                                          child: Image.network(
                                            "${data['goods'][0]['picUrl']}",
                                            fit: BoxFit.fill,
                                          ),
                                        );
                                      },
                                      itemCount: 1,
                                      autoplay: false,
                                    ),
                                  ),
                                  Container(
                                    width: Ui.width(750),
                                    height: Ui.width(90),
                                    margin: EdgeInsets.fromLTRB(
                                        0, Ui.width(30), 0, 0),
                                    padding: EdgeInsets.fromLTRB(
                                        Ui.width(30), 0, Ui.width(30), 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '客户姓名',
                                          style: TextStyle(
                                              color: Color(0XFF111F37),
                                              fontSize: Ui.setFontSizeSetSp(28),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                        ),
                                        Text(
                                          '${data['order']['consignee']}',
                                          style: TextStyle(
                                              color: Color(0XFF6A7182),
                                              fontSize: Ui.setFontSizeSetSp(28),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: Ui.width(750),
                                    height: Ui.width(90),
                                    padding: EdgeInsets.fromLTRB(
                                        Ui.width(30), 0, Ui.width(30), 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '客户电话',
                                          style: TextStyle(
                                              color: Color(0XFF111F37),
                                              fontSize: Ui.setFontSizeSetSp(28),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                        ),
                                        Text(
                                          '${data['order']['mobile']}',
                                          style: TextStyle(
                                              color: Color(0XFF6A7182),
                                              fontSize: Ui.setFontSizeSetSp(28),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: Ui.width(750),
                                    height: Ui.width(90),
                                    padding: EdgeInsets.fromLTRB(
                                        Ui.width(30), 0, Ui.width(30), 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: Ui.width(200),
                                          child: Text(
                                            data['order']['type']['value'] == 1
                                                ? '订购车型'
                                                : '订购商品',
                                            style: TextStyle(
                                                color: Color(0XFF111F37),
                                                fontSize:
                                                    Ui.setFontSizeSetSp(28),
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    'PingFangSC-Regular,PingFang SC'),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              '${data['goods'][0]['goodsName']}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  color: Color(0XFF6A7182),
                                                  fontSize:
                                                      Ui.setFontSizeSetSp(28),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      'PingFangSC-Regular,PingFang SC'),
                                            ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: Ui.width(750),
                                    height: Ui.width(90),
                                    padding: EdgeInsets.fromLTRB(
                                        Ui.width(30), 0, Ui.width(30), 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '订单日期',
                                          style: TextStyle(
                                              color: Color(0XFF111F37),
                                              fontSize: Ui.setFontSizeSetSp(28),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                        ),
                                        Text(
                                          '${data['order']['addTime'].substring(0, 10)}',
                                          style: TextStyle(
                                              color: Color(0XFF6A7182),
                                              fontSize: Ui.setFontSizeSetSp(28),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: Ui.width(750),
                                    height: Ui.width(90),
                                    padding: EdgeInsets.fromLTRB(
                                        Ui.width(30), 0, Ui.width(30), 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: Ui.width(200),
                                          child: Text(
                                            '客户地址',
                                            style: TextStyle(
                                                color: Color(0XFF111F37),
                                                fontSize:
                                                    Ui.setFontSizeSetSp(28),
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    'PingFangSC-Regular,PingFang SC'),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              data['order']['address'] == null
                                                  ? ''
                                                  : '${data['order']['address']}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  color: Color(0XFF6A7182),
                                                  fontSize:
                                                      Ui.setFontSizeSetSp(28),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      'PingFangSC-Regular,PingFang SC'),
                                            ))
                                      ],
                                    ),
                                  ),
                                  // Container(
                                  //   width: Ui.width(750),
                                  //   height: Ui.width(200),
                                  //   padding: EdgeInsets.fromLTRB(
                                  //       Ui.width(30), 0, Ui.width(30), 0),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //     crossAxisAlignment: CrossAxisAlignment.center,
                                  //     children: <Widget>[
                                  //       Container(
                                  //         child: Row(
                                  //           mainAxisAlignment: MainAxisAlignment.start,
                                  //           crossAxisAlignment: CrossAxisAlignment.start,
                                  //           children: <Widget>[
                                  //             Text(
                                  //               '*',
                                  //               style: TextStyle(
                                  //                   color: Color(0XFFD92818),
                                  //                   fontSize: Ui.setFontSizeSetSp(28),
                                  //                   fontWeight: FontWeight.w400,
                                  //                   fontFamily:
                                  //                       'PingFangSC-Regular,PingFang SC'),
                                  //             ),
                                  //             Text(
                                  //               '核销备注',
                                  //               style: TextStyle(
                                  //                   color: Color(0XFF111F37),
                                  //                   fontSize: Ui.setFontSizeSetSp(28),
                                  //                   fontWeight: FontWeight.w400,
                                  //                   fontFamily:
                                  //                       'PingFangSC-Regular,PingFang SC'),
                                  //             )
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       Container(
                                  //         width: Ui.width(530),
                                  //         height: Ui.width(150),
                                  //         padding: EdgeInsets.fromLTRB(
                                  //             Ui.width(20), 0, Ui.width(20), 0),
                                  //         decoration: BoxDecoration(
                                  //           color: Color(0xFFF6F8FC),
                                  //           borderRadius:
                                  //               BorderRadius.circular(Ui.width(10)),
                                  //         ),
                                  //         child: TextField(
                                  //           autofocus: false,
                                  //           maxLines: 4,
                                  //           keyboardAppearance: Brightness.light,
                                  //           keyboardType: TextInputType.text,
                                  //           style: TextStyle(
                                  //               color: Color(0XFF111F37),
                                  //               fontWeight: FontWeight.w400,
                                  //               fontSize: Ui.setFontSizeSetSp(32)),
                                  //           decoration: InputDecoration(
                                  //               border: InputBorder.none,
                                  //               hintText: '',
                                  //               hintStyle: TextStyle(
                                  //                   color: Color(0xFFC4C9D3),
                                  //                   fontWeight: FontWeight.w400,
                                  //                   fontFamily: 'Helvetica',
                                  //                   fontSize: Ui.setFontSizeSetSp(28.0))),
                                  //           onChanged: (value) {},
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  Container(
                                    width: Ui.width(750),
                                    height: Ui.width(90),
                                    padding: EdgeInsets.fromLTRB(
                                        Ui.width(30), 0, Ui.width(30), 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '核销日期',
                                          style: TextStyle(
                                              color: Color(0XFF111F37),
                                              fontSize: Ui.setFontSizeSetSp(28),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                        ),
                                        Text(
                                          data['order']['checktime'] != null
                                              ? '${data['order']['checktime'].substring(0, 10)}'
                                              : '',
                                          style: TextStyle(
                                              color: Color(0XFF6A7182),
                                              fontSize: Ui.setFontSizeSetSp(28),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: Ui.width(750),
                                    height: Ui.width(100),
                                    padding: EdgeInsets.fromLTRB(
                                        Ui.width(30), 0, Ui.width(30), 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '*',
                                                style: TextStyle(
                                                    color: Color(0XFFD92818),
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(28),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'PingFangSC-Regular,PingFang SC'),
                                              ),
                                              Text(
                                                '取车码',
                                                style: TextStyle(
                                                    color: Color(0XFF111F37),
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(28),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'PingFangSC-Regular,PingFang SC'),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: Ui.width(530),
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
                                            keyboardAppearance:
                                                Brightness.light,
                                            keyboardType: TextInputType.number,
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
                                              setState(() {
                                                takeSn = value;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: Ui.width(750),
                                    height: Ui.width(200),
                                    padding: EdgeInsets.fromLTRB(
                                        Ui.width(30), 0, Ui.width(30), 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '*',
                                                style: TextStyle(
                                                    color: Color(0XFFD92818),
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(28),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'PingFangSC-Regular,PingFang SC'),
                                              ),
                                              Text(
                                                '出库备注',
                                                style: TextStyle(
                                                    color: Color(0XFF111F37),
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(28),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'PingFangSC-Regular,PingFang SC'),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: Ui.width(530),
                                          height: Ui.width(150),
                                          padding: EdgeInsets.fromLTRB(
                                              Ui.width(20), 0, Ui.width(20), 0),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF6F8FC),
                                            borderRadius: BorderRadius.circular(
                                                Ui.width(10)),
                                          ),
                                          child: TextField(
                                            autofocus: false,
                                            maxLines: 4,
                                            keyboardAppearance:
                                                Brightness.light,
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(
                                                color: Color(0XFF111F37),
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    Ui.setFontSizeSetSp(32)),
                                            decoration: InputDecoration(
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
                                              setState(() {
                                                message = value;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: Ui.width(750),
                                    height: Ui.width(90),
                                    padding: EdgeInsets.fromLTRB(
                                        Ui.width(30), 0, Ui.width(30), 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '出库日期',
                                          style: TextStyle(
                                              color: Color(0XFF111F37),
                                              fontSize: Ui.setFontSizeSetSp(28),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                        ),
                                        Text(
                                          data['order']['shiptime'] != null
                                              ? '${data['order']['shiptime'].substring(0, 10)}'
                                              : '',
                                          style: TextStyle(
                                              color: Color(0XFF6A7182),
                                              fontSize: Ui.setFontSizeSetSp(28),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: Ui.width(50),)
                                ],
                              ),
                            ),
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: Container(
                                width: Ui.width(750),
                                height: Ui.width(120),
                                padding: EdgeInsets.fromLTRB(
                                    Ui.width(30), 0, Ui.width(30), 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0XFFE6E6E6),
                                        offset: Offset(0, 1),
                                        blurRadius: Ui.width(6.0),
                                      ),
                                    ]),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () async {
                                       var tel =await Storage.getString('phone');
                                      //  print(tel);
                                      //  var tel ='400 9655 778';
                                       var url ='tel:${tel.replaceAll(' ', '')}';
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          // print('拨打失败');
                                         throw '拨打失败';
                                        }
                                      },
                                      child: Container(
                                        width: Ui.width(190),
                                        height: Ui.width(85),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Ui.width(10)),
                                            border: Border.all(
                                                width: Ui.width(1),
                                                color: Color(0xFF2F8CFA))),
                                        child: Text(
                                          '联系客服',
                                          style: TextStyle(
                                              color: Color(0XFF2F8CFA),
                                              fontSize: Ui.setFontSizeSetSp(32),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        submit();
                                      },
                                      child: Container(
                                        width: Ui.width(480),
                                        height: Ui.width(85),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF2F8CFA),
                                          borderRadius: BorderRadius.circular(
                                              Ui.width(10)),
                                        ),
                                        child: Text(
                                          '确认出库',
                                          style: TextStyle(
                                              color: Color(0XFFFFFFFF),
                                              fontSize: Ui.setFontSizeSetSp(32),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
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
