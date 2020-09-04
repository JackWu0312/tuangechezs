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
import 'package:tuangechezs/page/mall/test.dart';
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
  List pointtags = [];
  var item;
  bool flages = true;

  @override
  void initState() {
    super.initState();
//    initdata();
    getPoint();
    getGoodList();
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

  getGoodList() async {
    await HttpUtlis.get('third/points/goods', success: (value) async {
     
      if (value['errno'] == 0) {
        setState(() {
          listAll.addAll(value['data']['list']);
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

  getData() async {
    await HttpUtlis.get('wx/mall/index', success: (value) async {
      if (value['errno'] == 0) {
        setState(() {
          banners = value['data']['banners'];
          tags = value['data']['tags'];
          listAll = [];
          isScolln = 0.0;
          this.isloading = true;
        });
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

/*获取积分和banner*/
  getPoint() async {
    await HttpUtlis.get('third/points/index', success: (value) async {
      if (value['errno'] == 0) {
        setState(() {
          item = value['data'];
          banners = value['data']['banners'];
          isloading = true;
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
      getPoint();
    }
    Ui.init(context);

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
                            padding: EdgeInsets.fromLTRB(
                                Ui.width(24), Ui.width(0), Ui.width(24), 0),
                            child: ListView(
                              controller: _scrollController,
                              children: <Widget>[
                                Container(
                                  width: Ui.width(702),
                                  height: Ui.width(300),
                                  margin: EdgeInsets.fromLTRB(
                                      0, Ui.width(20), 0, 0),
                                  alignment: Alignment.center,
                                  child: Swiper(
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/bannerwebview',
                                                arguments: {
                                                  "url": banners[index]
                                                      ['link'],
                                                  "title": banners[index]
                                                      ['name']
                                                });
                                          },
                                          child: CachedNetworkImage(
                                            width: Ui.width(390),
                                            height: Ui.width(220),
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                "${banners[index]['url']}",
                                          ),
                                          //     Image.network(
                                          //   "${pointbanner[index]['url']}",
                                          //   fit: BoxFit.cover,
                                          // ),
                                        );
                                      },
                                      itemCount: banners.length,
                                      autoplay:
                                          banners.length > 1 ? true : false,
//                                      pagination: SwiperPagination(
//                                        alignment: Alignment.bottomCenter,
//                                        builder: new SwiperCustomPagination(
//                                            builder: (BuildContext context,
//                                                SwiperPluginConfig config) {
//                                          return new PageIndicator(
//                                            layout: PageIndicatorLayout.NIO,
//                                            size: 8.0,
//                                            space: 15.0,
//                                            count: pointbanner.length,
//                                            color: Color.fromRGBO(
//                                                255, 255, 255, 0.4),
//                                            activeColor: Color(0XFF111F37),
//                                            controller: config.pageController,
//                                          );
//                                        }),
//                                      )
                                  ),
                                ),
                                Container(
                                  width: Ui.width(702.0),
                                  height: Ui.width(108.0),
                                  color: Color(0XFFFFFFFF),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child:InkWell(
                                          onTap: (){

                                            Navigator.pushNamed(
                                            context,
                                            '/pointlist');

                                          },
                                          child:  Container(
                                            // alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                                        color: Color(0xFF111F37),
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        fontFamily:
                                                        'PingFangSC-Medium,PingFang SC',
                                                        fontSize:
                                                        Ui.setFontSizeSetSp(
                                                            30.0)),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: item["points"] ==
                                                              null
                                                              ? '0'
                                                              : '${item["points"]}',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFFD10123),
                                                              fontWeight:
                                                              FontWeight.w400,
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
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () async {
                                              if (await getToken() != null) {
                                                Navigator.pushNamed(
                                                    context, '/exchange');
                                              } else {
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Image.asset(
                                                    'images/2.0x/exchange.png',
                                                    width: Ui.width(29.0),
                                                    height: Ui.width(32.0),
                                                  ),
                                                  SizedBox(
                                                    width: Ui.width(20),
                                                  ),
                                                  Text('兑换记录',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF111F37),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'PingFangSC-Medium,PingFang SC',
                                                          fontSize: Ui
                                                              .setFontSizeSetSp(
                                                                  30.0))),
                                                ],
                                              ),
                                            ),
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () async {
                                              if (await getToken() != null) {
                                                Navigator.pushNamed(
                                                    context, '/coupon');
                                              } else {
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Image.asset(
                                                    'images/2.0x/rollbag.png',
                                                    width: Ui.width(29.0),
                                                    height: Ui.width(32.0),
                                                  ),
                                                  SizedBox(
                                                    width: Ui.width(20),
                                                  ),
                                                  Text('领券',
                                                      style: TextStyle(
                                                          color:
                                                          Color(0xFF111F37),
                                                          fontWeight:
                                                          FontWeight.w400,
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
                                    margin: EdgeInsets.fromLTRB(
                                        0, Ui.width(10), 0, 0),
                                    child: listAll.length > 0
                                        ? Container(
                                            child: Wrap(
                                                runSpacing: Ui.width(10),
                                                spacing: Ui.width(10),
                                                children: listAll.map((val) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          '/goodsdetail',
                                                          arguments: {
                                                            "id": val['id'],
                                                          });
                                                    },
                                                    child: Container(
                                                      width: Ui.width(346),
                                                      height: Ui.width(480),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Container(
                                                            width:
                                                                Ui.width(346),
                                                            height:
                                                                Ui.width(346),
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    AssetImage(
                                                                  'images/2.0x/pointbg.png',
                                                                ),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                            child: CachedNetworkImage(
                                                                width: Ui.width(
                                                                    346),
                                                                height:
                                                                    Ui.width(
                                                                        346),
                                                                fit:
                                                                    BoxFit.fill,
                                                                imageUrl:
                                                                    '${val['picUrl']}'),

                                                            //  AspectRatio(aspectRatio: 1 / 1, child: Image.network('${val['picUrl']}')),
                                                          ),
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
                                                                SizedBox(
                                                                  height:
                                                                      Ui.width(
                                                                          20),
                                                                ),
                                                                Text(
                                                                  '${val['name']}',
                                                                  maxLines: 1,
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
                                                                SizedBox(
                                                                  height:
                                                                      Ui.width(
                                                                          10),
                                                                ),
                                                                Text(
//                                                                  '${val['points']}积分+${val['retailPrice']}${val['unit']}',
                                                                  '${val['points']}积分',
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
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
                                                                              28.0)),
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
