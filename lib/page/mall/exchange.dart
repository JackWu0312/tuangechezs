import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../ui/ui.dart';
import '../../common/LoadingDialog.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../http/index.dart';
import '../../common/Nofind.dart';
import 'package:toast/toast.dart';

class Exchange extends StatefulWidget {
  Exchange({Key key}) : super(key: key);

  @override
  _ExchangeState createState() => _ExchangeState();
}

class _ExchangeState extends State<Exchange> {
  ScrollController _scrollController = new ScrollController();
  EasyRefreshController _controller;
  bool isloading = false;
  List list = [];
  int page = 1;
  int size = 10;
  bool isNolist = false;

  // List lists = [];
  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    getData();
  }

  getData() async {
    if (this.page == 1) {
      setState(() {
        this.list = []; //拼接
      });
    }
    await HttpUtlis.get(
        'third/points/orders?&page=${this.page}&limit=${this.size}',
        success: (value) {
      print(value);
      if (value['errno'] == 0) {
        List newlist = value['data']['list'];
        if (this.size > newlist.length) {
          setState(() {
            isNolist = true;
            list.addAll(newlist); //拼接
          });
        } else {
          setState(() {
            this.page++;
            this.isNolist = false;
            list.addAll(newlist); //拼接
          });
        }
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
                          '兑换记录',
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
        body: isloading
            ? list.length > 0
                ? EasyRefresh(
                    controller: _controller,
                    header: ClassicalHeader(
                      refreshText: '下拉刷新哦～',
                      refreshReadyText: '下拉刷新哦～',
                      refreshingText: '加载中～',
                      refreshedText: '加载完成',
                      infoText: "更新时间 %T",
                      infoColor: Color(0XFF111F37),
                      textColor: Color(0XFF111F37),
                    ),
                    footer: ClassicalFooter(
                      loadText: '',
                      loadReadyText: '',
                      loadingText: '加载中～',
                      loadedText: '加载中完成～',
                      loadFailedText: '',
                      noMoreText: '我是有底线的哦～',
                      infoText: "更新时间 %T",
                      bgColor: Color(0xFFFFFFFF),
                      infoColor: Color(0XFF111F37),
                      textColor: Color(0XFF111F37),
                    ),
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 2), () {
                        setState(() {
                          page = 1;
                        });
                        getData();
                        _controller.resetLoadState();
                      });
                    },
                    onLoad: () async {
                      await Future.delayed(Duration(seconds: 2), () {
                        if (!isNolist) {
                          getData();
                        }
                        _controller.finishLoad(noMore: this.isNolist);
                      });
                    },
                    child: ListView.builder(
                      itemCount: list.length,
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                            width: Ui.width(750),
                            padding: EdgeInsets.fromLTRB(Ui.width(30),
                                Ui.width(30), Ui.width(0), Ui.width(30)),
                            height: Ui.width(241),
                            decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xffEAEAEA)))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0, 0, Ui.width(30), 0),
                                    width: Ui.width(180),
                                    child: CachedNetworkImage(
                                        width: Ui.width(180),
                                        height: Ui.width(180),
                                        fit: BoxFit.fill,
                                        imageUrl:
                                            '${list[index]["goods"]["picUrl"]}')

                                    // AspectRatio(
                                    //   aspectRatio: 1 / 1,
                                    //   child: Image.network(
                                    //       '${list[index]["picUrl"]}'),
                                    // ),
                                    ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        //
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              '${list[index]["goods"]["goodsName"]}',
                                              style: TextStyle(
                                                  color: Color(0xFF111F37),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'PingFangSC-Medium,PingFang SC',
                                                  fontSize: Ui.setFontSizeSetSp(
                                                      28.0)),
                                            ),
                                            Container(
                                                width: Ui.width(165),
                                                height: Ui.width(46),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '${list[index]["order"]["payTime"].toString().substring(0, 10)}',
                                                  style: TextStyle(
                                                      color: Color(0xFF9398A5),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'PingFangSC-Medium,PingFang SC',
                                                      fontSize:
                                                          Ui.setFontSizeSetSp(
                                                              24.0)),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFF0F2F6),
                                                  borderRadius:
                                                      BorderRadius.horizontal(
                                                          left: Radius.circular(
                                                              Ui.width(23))),
                                                ))
                                          ],
                                        ),
                                      ),
//                                      Container(
//                                        // margin: EdgeInsets.fromLTRB(0, 0, 0, Ui.width(-12)),
//                                        child: Text(
//                                          '${list[index]["goods"]['goodsName']}',
//                                          style: TextStyle(
//                                              color: Color(0xFF111F37),
//                                              fontWeight: FontWeight.w400,
//                                              fontFamily:
//                                                  'PingFangSC-Medium,PingFang SC',
//                                              fontSize:
//                                                  Ui.setFontSizeSetSp(28.0)),
//                                        ),
//                                      ),
                                      Container(
                                        // margin: EdgeInsets.fromLTRB(0, Ui.width(35), 0, 0),
                                        child: Text(
                                          '${list[index]["order"]["integralPrice"]}积分',
                                          style: TextStyle(
                                              color: Color(0xFFD10123),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Medium,PingFang SC',
                                              fontSize:
                                                  Ui.setFontSizeSetSp(28.0)),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ));
                      },
                    ))
                : Nofind(
                    text: "暂无抽奖记录哦～",
                  )
            : Container(
                // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: LoadingDialog(
                  text: "加载中…",
                ),
              ));
  }
}
