import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:tuangechezs/common/LoadingDialog.dart';
import 'package:tuangechezs/common/Nofind.dart';
import 'package:tuangechezs/common/Storage.dart';
import 'package:tuangechezs/http/index.dart';
import 'package:tuangechezs/provider/Integral.dart';
import '../../ui/ui.dart';

class Mall extends StatefulWidget {
  Mall({Key key}) : super(key: key);

  @override
  _MallState createState() => _MallState();
}

class _MallState extends State<Mall>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final int initPage = 0;
  PageController _pageController;


//  Stream<int> get currentPage$ => _currentPageSubject.stream;
//
//  Sink<int> get currentPageSink => _currentPageSubject.sink;
//  BehaviorSubject<int> _currentPageSubject;

  ScrollController _scrollController = new ScrollController();
  var isScolln = 0.0;
  bool isloading = false;
  List banners = [];
  List tags = [];
  var countshorping = 0;
  bool nolist = true;
  bool isMore = true;
  int page = 1;
  int limit = 1000000;
  List listAll = [];
  int count = 0;
  bool flage = false;
  List pointbanner = [];
  List bannersagin = [];
  List pointtags = [];
  var item;
  bool flages = true;

  @override
  void initState() {
    super.initState();
    initdata();
    _scrollController.addListener(() {
      // print(_scrollController.position.pixels); //获取滚动条下拉的距离
      // print(_scrollController.position.maxScrollExtent); //获取整个页面的高度
      getscollpoint(0, Ui.width(450));
      setState(() {
        isScolln = _scrollController.position.pixels;
      });
    });
  }

  getscollpoint(i, scoll) {
    if (i < pointtags.length) {
      if (_scrollController.position.pixels > scoll &&
          _scrollController.position.pixels <
              (scoll + Ui.width(pointtags[i]['nums']))) {
        setState(() {
          count = i;
        });
      }
      getscollpoint(i + 1, scoll + Ui.width(pointtags[i]['nums']));
    }
  }

  getscoll(i, scoll) {
    // print(tags[i]['nums']);
    if (i < tags.length) {
      if (_scrollController.position.pixels > scoll &&
          _scrollController.position.pixels <
              (scoll + Ui.width(tags[i]['nums']))) {
        setState(() {
          count = i;
        });
      }
      getscoll(i + 1, scoll + Ui.width(tags[i]['nums']) - Ui.width(200));
    }
  }

//  getcount(carnum) async {
//    await HttpUtlis.get('wx/cart/count', success: (value) {
//      if (value['errno'] == 0) {
//        if (value['data']['count'] != null) {
//          setState(() {
//            countshorping = value['data']['count'];
//          });
//        } else {
//          setState(() {
//            countshorping = 0;
//          });
//        }
//      }
//      carnum.increment(countshorping);
//    }, failure: (error) {
//      Toast.show('${error}', context,
//          backgroundColor: Color(0xff5b5956),
//          backgroundRadius: Ui.width(16),
//          duration: Toast.LENGTH_SHORT,
//          gravity: Toast.CENTER);
//    });
//  }

  getjumpTo(index) {
    var scoll = Ui.width(360); //Ui.width(510)
    for (var i = 0, len = tags.length; i < len; i++) {
      if (i < index) {
        scoll = scoll + Ui.width(tags[i]['nums']);
      }
    }
    return scoll;
  }

  getjumpTopoint(index) {
    var scoll = Ui.width(680); //Ui.width(510)
    for (var i = 0, len = pointtags.length; i < len; i++) {
      if (i < index) {
        scoll = scoll + Ui.width(pointtags[i]['nums']);
      }
    }
    return scoll;
  }

  getToken() async {
    try {
      String token = await Storage.getString('token');
      return token;
    } catch (e) {
      return '';
    }
  }

  void dispose() {
//    _currentPageSubject.close();
    _pageController.dispose();
    // _controller.dispose();
    super.dispose();
  }

  getData() async {
    await HttpUtlis.get('wx/mall/index', success: (value) async {
      if (value['errno'] == 0) {
        // List list = [];
        // for (var i = 0, len = value['data']['tags'].length; i < len; i++) {
        //   list.add(value['data']['tags'][i]['label']);
        // }
        // 草！！
        print('object');
        print(value['data']['banners']);
        setState(() {
          banners = value['data']['banners'];
          tags = value['data']['tags'];
          listAll = [];
          isScolln = 0.0;
          this.isloading = true;
        });
        print("数据 = "+value['data']['tags'].length);
        if (value['data']['tags'].length > 0) {
          for (var i = 0, len = value['data']['tags'].length; i < len; i++) {
            await getDatalist(value['data']['tags'][i]['extra']['query'], i);
          }
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

  getDatalist(data, index) async {
    var str = '';
    data.forEach((key, value) {
      str = str + '${key}=${value}&';
    });
    int type = 3;
    // if (isMore) {
    await HttpUtlis.get(
        'wx/goods/list?type=${type}&page=${page}&limit=${limit}&${str.substring(0, str.length - 1)}',
        success: (value) {
      if (value['errno'] == 0) {
        setState(() {
          setState(() {
            pointtags[index]['nums'] =
                (value['data']['list'].length / 2).ceil() * 480.0;
          });
          listAll.addAll(value['data']['list']);
        });
      }
    }, failure: (error) {
      Toast.show('${error}', context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    });
    // }
  }

  getpoint() async {
    await HttpUtlis.get('wx/points/index', success: (value) async {
      if (value['errno'] == 0) {
        setState(() {
          item = value['data'];
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

  initdata() async {
    await getData();
    setState(() {
      this.isloading = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    final integrals = Provider.of<Integral>(context);
    if (integrals.count) {
      Future.delayed(Duration(milliseconds: 200)).then((e) {
        //用延迟防止报错
        integrals.increment(false);
      });
//      getpoint();
    }
//    getcount(1);
//    getData();
    Ui.init(context);
    showtosh() {
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
                            Text('当前还未登陆，请登录～',
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
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(
                                                  Ui.width(20)))),
                                      alignment: Alignment.center,
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
                                        Navigator.popAndPushNamed(
                                            context, '/login');
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
                                        child: Text('去登陆',
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
                appBar: PreferredSize(
                    child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).padding.top,
                      child: SafeArea(child: Text("")),
                    ),
                    preferredSize: Size(0, 0)),
                body: isloading
                    ? Stack(
                        children: <Widget>[
                          Container(
                              color: Colors.white,
                              width: Ui.width(750),
                              padding: EdgeInsets.fromLTRB(
                                  Ui.width(0), Ui.width(90), Ui.width(0), 0),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(Ui.width(24),
                                        Ui.width(0), Ui.width(24), 0),
                                    child: ListView(
                                      controller: _scrollController,
                                      children: <Widget>[
                                        SizedBox(
                                          height: Ui.width(80),
                                        ),
                                        Container(
                                          width: Ui.width(702.0),
                                          height: Ui.width(108.0),
                                          color: Color(0XFFFFFFFF),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  // alignment: Alignment.center,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Image.asset(
                                                        'images/2.0x/integral.png',
                                                        width: Ui.width(29.0),
                                                        height: Ui.width(32.0),
                                                      ),
                                                      SizedBox(
                                                        width: Ui.width(20),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: '积分  ',
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
                                                                      30.0)),
                                                          children: <TextSpan>[
                                                            TextSpan(
//                                                                text: item["points"] ==
//                                                                        null
//                                                                    ? '0'
//                                                                    : '${item["points"]}',
                                                                text:'0',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFFD10123),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontFamily:
                                                                        'PingFangSC-Medium,PingFang SC',
                                                                    fontSize: Ui
                                                                        .setFontSizeSetSp(
                                                                            28.0))),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      if (await getToken() !=
                                                          null) {
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/exchange');
                                                      } else {
                                                        showtosh();
                                                      }
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[

                                                          Image.asset(
                                                            'images/2.0x/exchange.png',
                                                            width:
                                                                Ui.width(29.0),
                                                            height:
                                                                Ui.width(32.0),
                                                          ),
                                                          SizedBox(
                                                            width: Ui.width(20),
                                                          ),
                                                          Text('兑换记录',
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
                                                                          30.0))),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          color: Color(0xFFFFFFFF),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () async {
                                                  if (await getToken() !=
                                                      null) {
                                                    Navigator.pushNamed(context,
                                                        '/tokenwebview',
                                                        arguments: {
                                                          'url': 'applotterys'
                                                        });
                                                  } else {
                                                    showtosh();
                                                  }
                                                },
                                                child: Container(
                                                  width: Ui.width(346),
                                                  height: Ui.width(226),
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'images/2.0x/turntable.png'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Positioned(
                                                        top: Ui.width(35),
                                                        left: Ui.width(30),
                                                        child: Text(
                                                          '幸运大转盘',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFFFFFFFF),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'PingFangSC-Medium,PingFang SC',
                                                              fontSize: Ui
                                                                  .setFontSizeSetSp(
                                                                      34.0)),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: Ui.width(83),
                                                        left: Ui.width(30),
                                                        child: Text(
                                                          '积分“转”大奖',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFFFFFFFF),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  'PingFangSC-Medium,PingFang SC',
                                                              fontSize: Ui
                                                                  .setFontSizeSetSp(
                                                                      24.0)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, '/integral');
                                                },
                                                child: Container(
                                                  width: Ui.width(346),
                                                  height: Ui.width(226),
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'images/2.0x/explosive.png'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Positioned(
                                                        top: Ui.width(35),
                                                        left: Ui.width(30),
                                                        child: Text(
                                                          '1积分 抽爆品',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFFFFFFFF),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'PingFangSC-Medium,PingFang SC',
                                                              fontSize: Ui
                                                                  .setFontSizeSetSp(
                                                                      34.0)),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: Ui.width(83),
                                                        left: Ui.width(30),
                                                        child: Text(
                                                          '兑海量好礼',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFFFFFFFF),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  'PingFangSC-Medium,PingFang SC',
                                                              fontSize: Ui
                                                                  .setFontSizeSetSp(
                                                                      24.0)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0, Ui.width(100), 0, 0),
                                            child: listAll.length > 0
                                                ? Container(
                                                    child: Wrap(
                                                        runSpacing:
                                                            Ui.width(10),
                                                        spacing: Ui.width(10),
                                                        children:
                                                            listAll.map((val) {
                                                          return InkWell(
                                                            onTap: () {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  '/goodsdetail',
                                                                  arguments: {
                                                                    "id": val[
                                                                        'id'],
                                                                  });
                                                            },
                                                            child: Container(
                                                              width:
                                                                  Ui.width(346),
                                                              height:
                                                                  Ui.width(480),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: Ui
                                                                        .width(
                                                                            346),
                                                                    height: Ui
                                                                        .width(
                                                                            346),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            AssetImage(
                                                                          'images/2.0x/pointbg.png',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                    ),
                                                                    child: CachedNetworkImage(
                                                                        width: Ui.width(
                                                                            346),
                                                                        height: Ui.width(
                                                                            346),
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        imageUrl:
                                                                            '${val['picUrl']}'),

                                                                    //  AspectRatio(aspectRatio: 1 / 1, child: Image.network('${val['picUrl']}')),
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        SizedBox(
                                                                          height:
                                                                              Ui.width(20),
                                                                        ),
                                                                        Text(
                                                                          '${val['name']}',
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              color: Color(0xFF111F37),
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily: 'PingFangSC-Medium,PingFang SC',
                                                                              fontSize: Ui.setFontSizeSetSp(28.0)),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              Ui.width(10),
                                                                        ),
                                                                        Text(
                                                                          '${val['points']}积分+${val['retailPrice']}${val['unit']}',
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              color: Color(0xFFD10123),
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily: 'PingFangSC-Medium,PingFang SC',
                                                                              fontSize: Ui.setFontSizeSetSp(28.0)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }).toList()),
                                                  )
                                                : Container(
                                                    width: double.infinity,
                                                    height: Ui.width(500),
                                                    child: Center(
                                                      child: Nofind(
                                                        text: "没有更多商品哦～",
                                                      ),
                                                    ),
                                                  ))
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      top: (Ui.width(720) - isScolln) <
                                              Ui.width(60)
                                          ? Ui.width(60)
                                          : (Ui.width(720) - isScolln),
                                      left: Ui.width(24),
                                      child: Container(
                                        height: Ui.width(98),
                                        width: Ui.width(702),
                                        color: Colors.white,
                                        padding: EdgeInsets.fromLTRB(
                                            0, Ui.width(20), 0, Ui.width(20)),
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: pointtags.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  _scrollController.jumpTo(
                                                      getjumpTopoint(index));

                                                  setState(() {
                                                    count = index;
                                                  });
                                                },
                                                child: Container(
                                                  width: Ui.width(170),
                                                  height: Ui.width(60),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              Ui.width(30)),
                                                      color: count == index
                                                          ? Color(0xFFEAEAEC)
                                                          : Color(0xFFFFFFFF)),
                                                  child: Text(
                                                    '${pointtags[index]['label']}',
                                                    style: TextStyle(
                                                        color: count == index
                                                            ? Color(0xFF111F37)
                                                            : Color(0xFF5E6578),
                                                        fontWeight: count ==
                                                                index
                                                            ? FontWeight.w500
                                                            : FontWeight.w400,
                                                        fontFamily:
                                                            'PingFangSC-Medium,PingFang SC',
                                                        fontSize:
                                                            Ui.setFontSizeSetSp(
                                                                30.0)),
                                                  ),
                                                ),
                                              );
                                            }),
                                      )),
                                  Positioned(
                                    top: Ui.width(8),
                                    left: Ui.width(24),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/mallseach',
                                            arguments: {'type': '3'});
                                      },
                                      child: Container(
                                        height: Ui.width(62),
                                        width: Ui.width(702),
                                        // color: Color(0xFFf5f6fa),
                                        padding: EdgeInsets.fromLTRB(
                                            Ui.width(19), 0, 0, 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            // SizedBox(width: Ui.width(19)),
                                            Image.asset(
                                              'images/2.0x/searchnew.png',
                                              width: Ui.width(28),
                                              height: Ui.width(28),
                                            ),
                                            SizedBox(width: Ui.width(17)),
                                            Text(
                                              '您想购买什么车',
                                              style: TextStyle(
                                                  color: Color(0XFFC4C9D3),
                                                  fontSize:
                                                      Ui.setFontSizeSetSp(28),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      'PingFangSC-Regular,PingFang SC;'),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFf5f6fa),
                                            // color: Color(0XFFFFFFFF),
                                            borderRadius: new BorderRadius.all(
                                                new Radius.circular(
                                                    Ui.width(4.0))),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'images/2.0x/searchbgtop.png'),
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      )
                    : Container(
                        color: Colors.white,
                        child: LoadingDialog(
                          text: "加载中…",
                        ),
                      ))));
  }
}
