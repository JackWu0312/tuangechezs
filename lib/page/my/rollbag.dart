import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/Unit.dart';
import '../../ui/ui.dart';
import '../../http/index.dart';
import 'package:toast/toast.dart';
import '../../common/LoadingDialog.dart';
import '../../common/Nofind.dart';

class Rollbag extends StatefulWidget {
  Rollbag({Key key}) : super(key: key);

  @override
  _RollbagState createState() => _RollbagState();
}

class _RollbagState extends State<Rollbag> {
  ScrollController _scrollController = new ScrollController();
  var _initKeywordsController = new TextEditingController();
  var islogin = false;
  bool isShow = false;

  void initState() {
    super.initState();
    getstyle();
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

  List list = [];
  bool nolist = true;
  bool isMore = true;
  int page = 1;
  int limit = 10;

  getData() async {
    if (isMore) {
      await HttpUtlis.get('third/coupon/mine?page=${page}&limit=${limit}',
          success: (value) {
        print(value);
        if (value['errno'] == 0) {
          var listdata = value['data']['list'];
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
          }
        }
        setState(() {
          islogin = true;
        });
      }, failure: (error) {
        Toast.show('$error', context,
            backgroundColor: Color(0xff5b5956),
            backgroundRadius: Ui.width(16),
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      });
    }
  }

  var style = 1;
  // var userMobile = '';
  // var userName = '';
  var listUser = [];
  var active = null;

  getstyle() {
    if (Platform.isIOS) {
      setState(() {
        style = 1;
      });
    } else if (Platform.isAndroid) {
      setState(() {
        style = 2;
      });
    }
  }

  getUserSearch(searchPhone, state) async {
    await HttpUtlis.get('third/user/search?mobile=$searchPhone',
        success: (value) {
      if (value['errno'] == 0) {
        state(() {
          listUser = value['data'];
        });
      }
    }, failure: (error) {
      Toast.show('$error', context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    });
  }
transfer(id,userId,state)async{
  await HttpUtlis.post("/third/coupon/transfer", params: {
      'id': id,
      'userId':userId
    }, success: (val) async {
      if (val['errno'] == 0) {
        Unit.setToast('转发成功～', context);
        state(() {
         list = [];
          nolist = true;
          isMore = true;
          page = 1;
        });
        getData();
        Navigator.pop(context, true);
      }
    }, failure: (error) {
      Toast.show('${error}', context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    });
}
  showDialogForRoll(id) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return SimpleDialog(
                children: <Widget>[
                  Center(
                    child: Container(
                        width: Ui.width(600),
                        height: Ui.width(600),
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
                                  Text('搜索朋友',
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Color(0xFF111F37),
                                          fontWeight: FontWeight.w500,
                                          fontFamily:
                                              'PingFangSC-Medium,PingFang SC',
                                          fontSize: Ui.setFontSizeSetSp(36.0))),
                                  SizedBox(
                                    height: Ui.width(40),
                                  ),
                                  Container(
                                    width: Ui.width(600),
                                    height: Ui.width(80),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xFFEEEEEE),
                                              width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0))),
                                      child: TextField(
                                        keyboardAppearance: Brightness.light,
                                        maxLines: 1,
                                        keyboardType: TextInputType.phone,
                                        textInputAction: TextInputAction.done,
                                        controller: _initKeywordsController,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(6),
                                          hintText: '请输入手机号',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        onChanged: (value) {
                                          // if (_initKeywordsController.text.length ==11) {
                                          getUserSearch(value, state);
                                          state(() {
                                            active = null;
                                          });
                                          // }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Ui.width(40),
                                  ),
                                  Container(
                                      height: Ui.width(200),
                                      width: Ui.width(600),
                                      padding: EdgeInsets.fromLTRB(
                                          Ui.width(30), 0, Ui.width(30), 0),
                                      child: ListView.builder(
                                        itemCount: listUser.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              state(() {
                                                active = index;
                                              });
                                            },
                                            child: Container(
                                              height: Ui.width(80),
                                              decoration: BoxDecoration(
                                                color: active == index
                                                    ? Color(0xFF5BBEFF)
                                                    : Color(0xFFFFFFFF),
                                                border: Border(
                                                  bottom: BorderSide(
                                                      color: Color(0XFFF1F1F1),
                                                      width: 1.0),
                                                ),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0,
                                                              0,
                                                              Ui.width(30),
                                                              0),
                                                      child: Text(
                                                        listUser[index]
                                                                    ['name'] ==
                                                                null
                                                            ? '手机用户'
                                                            : '${listUser[index]['name']}',
                                                        style: TextStyle(
                                                            color: active == index
                                                    ? Color(0xFFFFFFFF)
                                                    :Color(0xFF111F37),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                'PingFangSC-Medium,PingFang SC',
                                                            fontSize: Ui
                                                                .setFontSizeSetSp(
                                                                    30.0)),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${listUser[index]['mobile']}',
                                                      style: TextStyle(
                                                           color: active == index
                                                    ? Color(0xFFFFFFFF)
                                                    :Color(0xFF111F37),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'PingFangSC-Medium,PingFang SC',
                                                          fontSize: Ui
                                                              .setFontSizeSetSp(
                                                                  30.0)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )),
                                  SizedBox(
                                    height: Ui.width(40),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if(active==null){
                                        Unit.setToast('请选择用户~', context);
                                            return;
                                      }else{
                                       transfer(id,listUser[active]['id'],state);
                                      }
                                    },
                                    child: Container(
                                      width: Ui.width(450),
                                      height: Ui.width(80),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF33AAF5),
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(Ui.width(6.0))),
                                      ),
                                      child: Text(
                                        '确认转发',
                                        style: TextStyle(
                                            color: Color(0xFFFFFFFF),
                                            fontWeight: FontWeight.w400,
                                            fontFamily:
                                                'PingFangSC-Medium,PingFang SC',
                                            fontSize:
                                                Ui.setFontSizeSetSp(28.0)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              );
            },
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _initKeywordsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    final counter = Provider.of<Backhome>(context);
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
                          '券包',
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
                                                      '${list[index]['coupon']['name']}',
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
                                                      '${list[index]['coupon']['tag']}',
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
                                                      '${list[index]['startTime']}-${list[index]['endTime']}',
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
                                                top: Ui.width(60),
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
                                                        '${list[index]['coupon']['discount']}',
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
//                                              Positioned(
//                                                  top: Ui.width(135),
//                                                  left: Ui.width(45),
//                                                  child: InkWell(
//                                                    onTap: () {
////                                                      counter.increment(1);
//                                                      Navigator.popAndPushNamed(
//                                                          context, '/');
//                                                      // getreceive(list[index]['id']);
//                                                    },
//                                                    child: Container(
//                                                      width: Ui.width(140),
//                                                      height: Ui.width(45),
//                                                      color: Color(0xFF8D551B),
//                                                      alignment:
//                                                          Alignment.center,
//                                                      child: Text(
//                                                        '立即使用',
//                                                        maxLines: 1,
//                                                        overflow: TextOverflow
//                                                            .ellipsis,
//                                                        style: TextStyle(
//                                                            color: Color(
//                                                                0xFFF4CF71),
//                                                            fontWeight:
//                                                                FontWeight.w400,
//                                                            fontFamily:
//                                                                'PingFangSC-Medium,PingFang SC',
//                                                            fontSize: Ui
//                                                                .setFontSizeSetSp(
//                                                                    22.0)),
//                                                      ),
//                                                    ),
//                                                  ))
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
                                                  '${list[index]['coupon']['desc']}',
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
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        listUser=[];
                                        _initKeywordsController.clear();
                                      });
                                      showDialogForRoll(
                                          list[index]['couponUserId']);
                                    },
                                    child: Container(
                                      width: Ui.width(750),
                                      height: Ui.height(80),
                                      padding: EdgeInsets.fromLTRB(
                                          Ui.width(24),
                                          Ui.width(20),
                                          Ui.width(24),
                                          Ui.width(20)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text('转发给朋友'),
                                          Image.asset(
                                            'images/2.0x/rightmore.png',
                                            width: Ui.width(15),
                                            height: Ui.height(28),
                                          )
                                        ],
                                      ),
                                    ),
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
