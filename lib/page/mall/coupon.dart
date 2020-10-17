import 'package:flutter/material.dart';
import '../../ui/ui.dart';
import '../../http/index.dart';
import 'package:toast/toast.dart';
import '../../common/LoadingDialog.dart';
import '../../common/Nofind.dart';

class Coupon extends StatefulWidget {
  Coupon({Key key}) : super(key: key);

  @override
  _CouponState createState() => _CouponState();
}

class _CouponState extends State<Coupon> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 60) {
        if (nolist) {
          getData();
        }
        setState(() {
          isMore = false;
        });
      }
    });
  }

  bool nolist = true;
  bool isMore = true;
  int page = 1;
  int limit = 10;
  List list = [];
  var islogin = false;
  getData() async {
    if (isMore) {
      await HttpUtlis.get('third/coupon/list?&page=${page}&limit=${limit}',
          success: (value) {
        if (value['errno'] == 0) {
          var listdata = value['data']['list'];
          // print(listdata);
          for (var i = 0, len = listdata.length; i < len; i++) {
            listdata[i]['select'] = false;
          }
          if (value['data']['list'].length < limit) {
            setState(() {
              nolist = false;
              this.isMore = true;
              list.addAll(listdata);
            });
          } else {
            setState(() {
              page++;
              nolist = true;
              this.isMore = true;
              list.addAll(listdata);
            });
            // setState(() {
            //   list = listdata;
            // });
          }
          setState(() {
            islogin = true;
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
  }

  getreceive(id) async {
    await HttpUtlis.get("third/coupon/receive/$id",
        success: (value) async {
      if (value['errno'] == 0) {
        Toast.show('领取成功', context,
            backgroundColor: Color(0xff5b5956),
            backgroundRadius: Ui.width(16),
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
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
    Ui.init(context);
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
                          '领券中心',
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
        body: islogin
            ? Container(
                color: Color(0xFFF8F9FB),
                child: list.length > 0
                    ? ListView.builder(
                        itemCount: list.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return Container(
                              margin: EdgeInsets.fromLTRB(
                                  Ui.width(24), Ui.width(20), Ui.width(24), 0),
                              width: Ui.width(690),
                              constraints:
                                  BoxConstraints(minHeight: Ui.width(230)),
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Ui.width(10.0)))),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        0, Ui.width(20), 0, Ui.width(20)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          width: Ui.width(460),
                                          height: Ui.width(190),
                                          padding: EdgeInsets.fromLTRB(
                                              Ui.width(26), 0, 0, 0),
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
                                                    Text(
                                                      '${list[index]['name']}',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF111F37),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'PingFangSC-Medium,PingFang SC',
                                                          fontSize: Ui
                                                              .setFontSizeSetSp(
                                                                  32.0)),
                                                    ),
                                                    SizedBox(
                                                      height: Ui.width(12),
                                                    ),
                                                    Text(
                                                      list[index]['tag']!=null?'${list[index]['tag']}':"",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF9398A5),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'PingFangSC-Medium,PingFang SC',
                                                          fontSize: Ui
                                                              .setFontSizeSetSp(
                                                                  24.0)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      list[index]['startDate'] !=
                                                              null
                                                          ? '${list[index]['startDate']}-${list[index]['endDate']}'
                                                          : '自领取之日起${list[index]['days']}天内有效',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF9398A5),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'PingFangSC-Medium,PingFang SC',
                                                          fontSize: Ui
                                                              .setFontSizeSetSp(
                                                                  24.0)),
                                                    ),
                                                    SizedBox(
                                                      width: Ui.width(30),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          list[index]
                                                                  ['select'] =
                                                              !list[index]
                                                                  ['select'];
                                                        });
                                                      },
                                                      child: Container(
                                                        width: Ui.width(105),
                                                        height: Ui.width(40),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              width:
                                                                  Ui.width(1),
                                                              color: Color(
                                                                  0xff8D551B)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text(
                                                              '详情',
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF8D551B),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      'PingFangSC-Medium,PingFang SC',
                                                                  fontSize: Ui
                                                                      .setFontSizeSetSp(
                                                                          24.0)),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  Ui.width(4),
                                                            ),
                                                            Image.asset(
                                                              list[index]
                                                                      ['select']
                                                                  ? 'images/2.0x/upper.png'
                                                                  : 'images/2.0x/lower.png',
                                                              width:
                                                                  Ui.width(15),
                                                              height:
                                                                  Ui.width(15),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: Ui.width(230),
                                          height: Ui.width(190),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: AssetImage(
                                                'images/2.0x/coupon.png'),
                                            fit: BoxFit.fill,
                                          )),
                                          child: Stack(
                                            children: <Widget>[
                                              Positioned(
                                                top: Ui.width(40),
                                                child: Container(
                                                  width: Ui.width(230),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        '¥ ',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF8F541B),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'PingFangSC-Medium,PingFang SC',
                                                            fontSize: Ui
                                                                .setFontSizeSetSp(
                                                                    36.0)),
                                                      ),
                                                      Text(
                                                        '${list[index]['discount']}',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF8F541B),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                'PingFangSC-Medium,PingFang SC',
                                                            fontSize: Ui
                                                                .setFontSizeSetSp(
                                                                    52.0)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // Positioned(
                                              //   top: Ui.width(89),
                                              //   child: Container(
                                              //     width: Ui.width(230),
                                              //     alignment: Alignment.center,
                                              //     child: Text(
                                              //       '满${list[index]['min']}元使用',
                                              //       maxLines: 1,
                                              //       overflow: TextOverflow.ellipsis,
                                              //       style: TextStyle(
                                              //           color: Color(0xFF8E541C),
                                              //           fontWeight: FontWeight.w400,
                                              //           fontFamily:
                                              //               'PingFangSC-Medium,PingFang SC',
                                              //           fontSize: Ui.setFontSizeSetSp(
                                              //               22.0)),
                                              //     ),
                                              //   ),
                                              // ),
                                              Positioned(
                                                  top: Ui.width(135),
                                                  left: Ui.width(45),
                                                  child: InkWell(
                                                    onTap: () {
                                                      getreceive(
                                                          list[index]['id']);
                                                    },
                                                    child: Container(
                                                      width: Ui.width(140),
                                                      height: Ui.width(45),
                                                      color: Color(0xFF8D551B),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        list[index]['points']>0?'${list[index]['points']}积分':'立即领取',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFF4CF71),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                'PingFangSC-Medium,PingFang SC',
                                                            fontSize: Ui
                                                                .setFontSizeSetSp(
                                                                    22.0)),
                                                      ),
                                                    ),
                                                  ))
                                              // Positioned(
                                              //   top: Ui.width(0),
                                              //   left: Ui.width(0),
                                              //   child: Container(
                                              //     width: Ui.width(45),
                                              //     height: Ui.width(45),
                                              //     decoration: BoxDecoration(
                                              //         image: DecorationImage(
                                              //       image: AssetImage(
                                              //           'images/2.0x/selecttask.png'),
                                              //       // 'unselecttask'
                                              //       fit: BoxFit.fill,
                                              //     )),
                                              //   ),
                                              // )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: list[index]['select']
                                        ? Container(
                                            padding: EdgeInsets.fromLTRB(
                                                Ui.width(24),
                                                0,
                                                Ui.width(24),
                                                Ui.width(20)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  list[index]['desc']!= null?'${list[index]['desc']}':"",
                                                  style: TextStyle(
                                                      color: Color(0xFF111F37),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          'PingFangSC-Medium,PingFang SC',
                                                      fontSize:
                                                          Ui.setFontSizeSetSp(
                                                              24.0)),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  )
                                ],
                              ));
                        },
                      )
                    : Nofind(
                        text: "暂无优惠券哦～",
                      ))
            : Container(
                child: LoadingDialog(
                  text: "加载中...",
                ),
              ));
  }
}
