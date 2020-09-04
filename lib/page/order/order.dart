import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/ui.dart';
import '../../http/index.dart';
import '../../common/Unit.dart';
import '../../common/Nofind.dart';
import 'package:provider/provider.dart';
import '../../provider/Orderback.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ColorsUtil {
  /// 十六进制颜色，
  /// hex, 十六进制值，例如：0xffffff,
  /// alpha, 透明度 [0.0,1.0]
  static Color hexColor(int hex, {double alpha = 1}) {
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    return Color.fromRGBO((hex & 0xFF0000) >> 16, (hex & 0x00FF00) >> 8,
        (hex & 0x0000FF) >> 0, alpha);
  }
}

class Order extends StatefulWidget {
  Order({Key key}) : super(key: key);

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  int active = 1;
  Map colors = {"1": 0xFF6CB82A};

  String statusArray = '101,201,301,302,303,304';

  ScrollController _scrollController = new ScrollController();
  List list = [];
  bool nolist = true;
  bool isMore = true;
  int page = 1;
  int limit = 10;
  int isAgent = 1;
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 100) {
        if (nolist) {
          getData();
        }
        setState(() {
          isMore = false;
        });
      }
    });
    getData();
    getisAgent();
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
    if (isMore) {
      await HttpUtlis.get(
          'third/order/list?page=${this.page}&limit=${this.limit}&statusArray=${statusArray}',
          success: (value) {
        if (value['errno'] == 0) {
          if (value['data']['list'].length < limit) {
            setState(() {
              nolist = false;
              this.isMore = true;
              list.addAll(value['data']['list']);
            });
          } else {
            setState(() {
              page++;
              nolist = true;
              this.isMore = true;
              list.addAll(value['data']['list']);
            });
          }
        }
      }, failure: (error) {
        Unit.setToast('${error}', context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Orderback>(context);
    if (counter.count) {
      list = [];
      nolist = true;
      isMore = true;
      page = 1;
      statusArray = '101,201,301,302,303,304';
      getData();
      Future.delayed(Duration(milliseconds: 200)).then((e) {
        counter.increment(false);
      });
    }
    Ui.init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
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
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '订单',
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
            body: Container(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: Ui.width(750),
                    padding: EdgeInsets.fromLTRB(0, Ui.width(90), 0, 0),
                    child: list.length > 0
                        ? ListView.builder(
                            controller: _scrollController,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/orderdetail',
                                      arguments: {
                                        'id': list[index]['order']['id']
                                      });
                                },
                                child: Container(
                                  width: Ui.width(750),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: Ui.width(15),
                                              color: Color(0xFFFBFCFF)))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: Ui.width(750),
                                        height: Ui.width(225),
                                        padding: EdgeInsets.fromLTRB(
                                            Ui.width(30),
                                            Ui.width(30),
                                            Ui.width(30),
                                            0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: Ui.width(220),
                                              height: Ui.width(165),
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, Ui.width(20), 0),
                                              // decoration: BoxDecoration(
                                              //   borderRadius:
                                              //       new BorderRadius.all(
                                              //           new Radius.circular(
                                              //               Ui.width(4.0))),
                                              //   // image: DecorationImage(
                                              //   //   image: NetworkImage(
                                              //   //       '${list[index]['goods'][0]['picUrl']}'),
                                              //   //   fit: BoxFit.fill,
                                              //   // )
                                              // ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        new Radius.circular(
                                                            Ui.width(4.0))),
                                                child:CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl:
                                                      '${list[index]['goods'][0]['picUrl']}'),)
                                              // child: Stack(
                                              //   children: <Widget>[
                                              //     Positioned(
                                              //       left: 0,
                                              //       bottom: 0,
                                              //       child: Container(
                                              //         width: Ui.width(220),
                                              //         height: Ui.width(36),
                                              //         alignment: Alignment.center,
                                              //         decoration: BoxDecoration(
                                              //           color: ColorsUtil.hexColor(
                                              //               colors['1'],
                                              //               alpha: 0.79),
                                              //           borderRadius:
                                              //               BorderRadius.vertical(
                                              //                   bottom: Radius.circular(
                                              //                       Ui.width(4))),
                                              //         ),
                                              //         child: Text(
                                              //           '未付款',
                                              //           style: TextStyle(
                                              //               color: Color(0XFFFFFFFF),
                                              //               fontSize:
                                              //                   Ui.setFontSizeSetSp(26),
                                              //               fontWeight: FontWeight.w400,
                                              //               fontFamily:
                                              //                   'PingFangSC-Regular,PingFang SC'),
                                              //         ),
                                              //       ),
                                              //     )
                                              //   ],
                                              // ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                height: Ui.width(165),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      '${list[index]['goods'][0]['goodsName']}',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color:
                                                              Color(0XFF111F37),
                                                          fontSize: Ui
                                                              .setFontSizeSetSp(
                                                                  28),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'PingFangSC-Regular,PingFang SC'),
                                                    ),
                                                    Text(
                                                      '${list[index]['order']['consignee']} ${list[index]['order']['mobile']}',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0XFF9398A5),
                                                          fontSize: Ui
                                                              .setFontSizeSetSp(
                                                                  30),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'PingFangSC-Regular,PingFang SC'),
                                                    ),
                                                    Text(
                                                      '${list[index]['order']['addTime'].substring(0, 10)}',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color:
                                                              Color(0XFFC4C9D3),
                                                          fontSize: Ui
                                                              .setFontSizeSetSp(
                                                                  26),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'PingFangSC-Regular,PingFang SC'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  Ui.width(20), 0, 0, 0),
                                              child: Text(
                                                '${list[index]['order']['status']['label']}',
                                                style: TextStyle(
                                                    color: list[index]['order']
                                                                    ['status']
                                                                ['value'] ==
                                                            101
                                                        ? Color(0XFFD10123)
                                                        : Color(0XFF347AFF),
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(26),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'PingFangSC-Regular,PingFang SC'),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                          child: active == 1 &&
                                                  isAgent == 2 &&
                                                  list[index]['order']['status']
                                                          ['value'] ==
                                                      303 &&
                                                  list[index]['order']['type']
                                                          ['value'] ==
                                                      1
                                              ? Container(
                                                  width: Ui.width(750),
                                                  height: Ui.width(75),
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, Ui.width(10), 0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () async {
                                                          var tel = list[index]
                                                                  ['order']
                                                              ['mobile'];
                                                          var url =
                                                              'tel:${tel.replaceAll(' ', '')}';
                                                          if (await canLaunch(
                                                              url)) {
                                                            await launch(url);
                                                          } else {
                                                            throw '拨打失败';
                                                          }
                                                        },
                                                        child: Container(
                                                          width: Ui.width(160),
                                                          height: Ui.width(56),
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0,
                                                                  0,
                                                                  Ui.width(20),
                                                                  0),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          Ui.width(
                                                                              30)),
                                                              border: Border.all(
                                                                  width:
                                                                      Ui.width(
                                                                          1),
                                                                  color: Color(
                                                                      0xFFD8DCE4))),
                                                          child: Text(
                                                            '联系客户',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0XFF6A7182),
                                                                fontSize: Ui
                                                                    .setFontSizeSetSp(
                                                                        28),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    'PingFangSC-Regular,PingFang SC'),
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pushNamed(
                                                              context, '/stock',
                                                              arguments: {
                                                                'id': list[index]
                                                                        [
                                                                        'order']
                                                                    ['id']
                                                              });
                                                        },
                                                        child: Container(
                                                          width: Ui.width(160),
                                                          height: Ui.width(56),
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0,
                                                                  0,
                                                                  Ui.width(20),
                                                                  0),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          Ui.width(
                                                                              30)),
                                                              border: Border.all(
                                                                  width:
                                                                      Ui.width(
                                                                          1),
                                                                  color: Color(
                                                                      0xFF2F8CFA))),
                                                          child: Text(
                                                            '出库',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0XFF2F8CFA),
                                                                fontSize: Ui
                                                                    .setFontSizeSetSp(
                                                                        28),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    'PingFangSC-Regular,PingFang SC'),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  height: Ui.width(1),
                                                  child: Text(''),
                                                ))
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Nofind(
                            text: "暂无更多数据哦～",
                          ),
                  ),
                  Positioned(
                    top: -1,
                    left: 0,
                    child: Container(
                      width: Ui.width(750),
                      height: Ui.width(90),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                active = 1;
                                statusArray = '101,201,301,302,303,304';
                                list = [];
                                nolist = true;
                                isMore = true;
                                page = 1;
                              });
                              getData();
                            },
                            child: Container(
                              width: Ui.width(100),
                              height: Ui.width(90),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: Ui.width(100),
                                    height: Ui.width(90),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '未完成',
                                      style: TextStyle(
                                          color: Color(0XFFFFFFFF),
                                          fontSize: Ui.setFontSizeSetSp(30),
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              'PingFangSC-Regular,PingFang SC'),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: Ui.width(100),
                                      height: Ui.width(6),
                                      decoration: BoxDecoration(
                                        color: active == 1
                                            ? Colors.white
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(Ui.width(6)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                active = 2;
                                statusArray = '401,402';
                                list = [];
                                nolist = true;
                                isMore = true;
                                page = 1;
                              });
                              getData();
                            },
                            child: Container(
                              width: Ui.width(100),
                              height: Ui.width(90),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: Ui.width(100),
                                    height: Ui.width(90),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '已完成',
                                      style: TextStyle(
                                          color: Color(0XFFFFFFFF),
                                          fontSize: Ui.setFontSizeSetSp(30),
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              'PingFangSC-Regular,PingFang SC'),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: Ui.width(100),
                                      height: Ui.width(6),
                                      decoration: BoxDecoration(
                                        color: active == 2
                                            ? Colors.white
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(Ui.width(6)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
