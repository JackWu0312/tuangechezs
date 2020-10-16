import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuangechezs/common/HttpHelper.dart';
import 'package:tuangechezs/provider/TaskEvent.dart';
import '../../ui/ui.dart';
import '../../http/index.dart';
import '../../common/Unit.dart';
import '../../common/LoadingDialog.dart';
import '../../common/Storage.dart';
import 'package:provider/provider.dart';
import '../../provider/Share.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:talkingdata_appanalytics_plugin/talkingdata_appanalytics_plugin.dart';
import '../../video/full_video_page.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var data;
  bool isloading = false;
  int isAgent = 1;
  @override
  void initState() {
    super.initState();
    getData();
    getisAgent();
    TalkingDataAppAnalytics.onPageStart('home');  //埋点使用
    // TalkingDataAppAnalytics.setGlobalKV('进入首页',13113);
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
    await HttpUtlis.get('third/home/index', success: (value) async {
      if (value['errno'] == 0) {
        setState(() {
          data = value['data'];
        });
        await Storage.setString(
            'userinfohome', json.encode(value['data']['user']));
        await Storage.setString('phone', value['data']['hotline']);
      }
      setState(() {
        this.isloading = true;
      });
    }, failure: (error) {
      Unit.setToast(error, context);
    });
  }

  Widget borderwidth(height) {
    return Container(
      width: double.infinity,
      height: Ui.width(height),
      color: Color(0XFFF8F9FB),
    );
  }

  getitemlist() {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for (var i = 0, len = data['articles'].length; i < len; i++) {
      tiles.add(InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/driedwebview', arguments: {
            'id': data['articles'][i]['id'],
            'title': data['articles'][i]['title'],
            'tag': data['articles'][i]['tag']
          });
        },
        child: Container(
          height: Ui.width(246),
          width: Ui.width(702),
          padding: EdgeInsets.fromLTRB(0, Ui.width(20), 0, Ui.width(20)),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1,
                      color: i == data['articles'].length - 1
                          ? Color(0xffFFFFFF)
                          : Color(0xffEAEAEA)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text('${data['articles'][i]['title']}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Unit.textStyle(Color(0xFF111F37), 32.0, 5)),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'images/2.0x/loginnew.png',
                            width: Ui.width(36),
                            height: Ui.width(36),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(Ui.width(10), 0, 0, 0),
                            child: Text('来自团个车',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    Unit.textStyle(Color(0xFF9398A5), 24.0, 4)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  width: Ui.width(270),
                  height: Ui.width(207),
                  margin: EdgeInsets.fromLTRB(Ui.width(20), 0, 0, 0),
                  child: ClipRRect(
                    borderRadius: new BorderRadius.all(
                        new Radius.circular(Ui.width(10.0))),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: '${data['articles'][i]['picUrl']}',
                    ),
                  )),
            ],
          ),
        ),
      ));
    }
    content = new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: tiles);
    return content;
  }

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Share>(context);
    if (counter.count) {
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
                height: Ui.height(0),
              ),
              preferredSize: Size(0, 0)),
          body: isloading && data != null
              ? Container(
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        width: Ui.width(750),
                        height: Ui.width(240),
                        padding: EdgeInsets.fromLTRB(
                            Ui.width(30), Ui.width(135), Ui.width(40), 0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/2.0x/homebg.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Unit.text('HI，${data['user']['name']}',
                                            Color(0xFFFFFFFF), 36.0, 5),
                                        SizedBox(
                                          width: Ui.width(20),
                                        ),
                                        Container(
                                          width: Ui.width(80),
                                          height: Ui.width(30),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: Ui.width(1),
                                                color: Color(0xFFFFFFFF)),
                                          ),
                                          child: Text(
                                              isAgent == 1 ? '经纪人' : '代理商',
                                              textAlign: TextAlign.center,
                                              style: Unit.textStyle(
                                                  Color(0xFFFFFFFF), 20.0, 4)),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Ui.width(5),
                                  ),
                                  Container(
                                    child: Text(
                                        data['user']['company'] == null
                                            ? ''
                                            : '${data['user']['company']}',
                                        style: Unit.textStyle(
                                            Color(0xFFFFFFFF), 24.0, 4)),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (isAgent == 1) {
                                  Navigator.pushNamed(context, '/brokercard',
                                      arguments: {'user': data['user']});
                                } else {
                                  Navigator.pushNamed(context, '/agentcard',
                                      arguments: {'user': data['user']});
                                }
                              },
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'images/2.0x/card.png',
                                      width: Ui.width(46),
                                      height: Ui.width(35),
                                    ),
                                    SizedBox(
                                      height: Ui.width(10),
                                    ),
                                    Unit.text('名片', Color(0xFFFFFFFF), 20.0, 4)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/warreport');
                        },
                        child: Container(
                            padding: EdgeInsets.fromLTRB(
                                Ui.width(30), Ui.width(20), 0, Ui.width(30)),
                            child:
                                Unit.text('实时战报', Color(0xFF111F37), 34.0, 5)),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/warreport');
                        },
                        child: Container(
                          width: Ui.width(750),
                          height: Ui.width(150),
                          padding: EdgeInsets.fromLTRB(
                              Ui.width(30), 0, Ui.width(30), Ui.width(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Unit.text('${data['report']['topSales']}',
                                        Color(0xFF2F8CFA), 44.0, 5),
                                    SizedBox(
                                      height: Ui.width(20),
                                    ),
                                    Unit.text(
                                        '冠军销量', Color(0xFF111F37), 26.0, 4),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Unit.text('${data['report']['mySales']}',
                                        Color(0xFF2F8CFA), 44.0, 5),
                                    SizedBox(
                                      height: Ui.width(20),
                                    ),
                                    Unit.text(
                                        '我的销量', Color(0xFF111F37), 26.0, 4),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Unit.text('${data['report']['articles']}',
                                        Color(0xFF2F8CFA), 44.0, 5),
                                    SizedBox(
                                      height: Ui.width(20),
                                    ),
                                    Unit.text(
                                        '软文分享', Color(0xFF111F37), 26.0, 4),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Unit.text('${data['report']['posters']}',
                                        Color(0xFF2F8CFA), 44.0, 5),
                                    SizedBox(
                                      height: Ui.width(20),
                                    ),
                                    Unit.text(
                                        '海报分享', Color(0xFF111F37), 26.0, 4),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      borderwidth(16.0),
                      Container(
                        padding: EdgeInsets.fromLTRB(Ui.width(30.0),
                            Ui.width(30.0), Ui.width(24.0), Ui.width(44.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: Unit.text(
                                    '精选海报', Color(0XFF111F37), 34.0, 5)),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/poster',arguments: {'index':0});
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Unit.text('更多', Color(0XFF6A7182), 26.0, 4),
                                    SizedBox(
                                      width: Ui.width(10),
                                    ),
                                    Image.asset('images/2.0x/rightmore.png',
                                        width: Ui.width(13),
                                        height: Ui.width(26))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(Ui.width(30), 0, Ui.width(30), Ui.width(40)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                String token =
                                    await Storage.getString('userInfo');
                                Navigator.pushNamed(context, '/preview',
                                    arguments: {
                                      'detail': data['posters'][0],
                                      'id': json.decode(token)['id']
                                    });
                              },
                              child: Container(
                                width: Ui.width(337),
                                height: Ui.width(130),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF4F6FC),
                                  borderRadius: BorderRadius.circular(Ui.width(12))
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(width:Ui.width(28)),
                                    Image.asset(
                                      'images/2.0x/icon_every_day.png',
                                      width: Ui.width(60),
                                      height: Ui.width(60),
                                    ),
                                    SizedBox(width:Ui.width(22)),
                                    Text('每日分享',
                                      style: TextStyle(
                                        color: Color(0xFF111F37),
                                        fontSize: Ui.setFontSizeSetSp(30)
                                      ),
                                    ),
                                    SizedBox(width:Ui.width(30)),
                                    Image.asset(
                                      'images/2.0x/rightmy.png',
                                      width: Ui.width(13),
                                      height: Ui.width(26),
                                    ),
                                    SizedBox(width:Ui.width(40)),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.pushNamed(context, '/poster',arguments: {'index': 1});
                              },
                              child: Container(
                                width: Ui.width(337),
                                height: Ui.width(130),
                                decoration: BoxDecoration(
                                    color: Color(0xFFF4F6FC),
                                    borderRadius: BorderRadius.circular(Ui.width(12))
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(width:Ui.width(28)),
                                    Image.asset(
                                      'images/2.0x/icon_home_car.png',
                                      width: Ui.width(60),
                                      height: Ui.width(60),
                                    ),
                                    SizedBox(width:Ui.width(22)),
                                    Text('车型推荐',
                                      style: TextStyle(
                                          color: Color(0xFF111F37),
                                          fontSize: Ui.setFontSizeSetSp(30)
                                      ),
                                    ),
                                    SizedBox(width:Ui.width(30)),
                                    Image.asset(
                                      'images/2.0x/rightmy.png',
                                      width: Ui.width(13),
                                      height: Ui.width(26),
                                    ),
                                    SizedBox(width:Ui.width(40)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Offstage(
                        offstage: true,
                        child: Container(
                            width: Ui.width(750),
                            height: Ui.width(380),
                            padding: EdgeInsets.fromLTRB(Ui.width(30.0), 0, 0, 0),
                            child: ListView.builder(
                              itemCount: data['posters'].length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    String token =
                                    await Storage.getString('userInfo');
                                    Navigator.pushNamed(context, '/preview',
                                        arguments: {
                                          'detail': data['posters'][index],
                                          'id': json.decode(token)['id']
                                        });
                                  },
                                  child: Container(
                                    width: Ui.width(250),
                                    margin: EdgeInsets.fromLTRB(
                                        0, 0, Ui.width(16), 0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: Ui.width(250),
                                          height: Ui.width(304),
                                          child: CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              imageUrl:
                                              '${data['posters'][index]['picUrl']}'),
                                        ),
                                        SizedBox(
                                          height: Ui.width(10),
                                        ),
                                        Container(
                                          width: Ui.width(250),
                                          child: Text(
                                              '${data['posters'][index]['title']}',
                                              overflow: TextOverflow.ellipsis,
                                              style: Unit.textStyle(
                                                  Color(0XFF111F37), 30.0, 4)),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )),
                      ),

                      borderwidth(16.0),
                      Container(
                        padding: EdgeInsets.fromLTRB(Ui.width(30.0),
                            Ui.width(30.0), Ui.width(24.0), Ui.width(10.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: Unit.text(
                                    '软文分享', Color(0XFF111F37), 34.0, 5)),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/dried');
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Unit.text('更多', Color(0XFF6A7182), 26.0, 4),
                                    SizedBox(
                                      width: Ui.width(10),
                                    ),
                                    Image.asset('images/2.0x/rightmore.png',
                                        width: Ui.width(13),
                                        height: Ui.width(26))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: Ui.width(750),
                        padding: EdgeInsets.fromLTRB(
                            Ui.width(30), 0, Ui.width(30), 0),
                        child: getitemlist(),
                      ),
                      borderwidth(16.0),
                      Container(
                        padding: EdgeInsets.fromLTRB(Ui.width(30.0),
                            Ui.width(30.0), Ui.width(24.0), Ui.width(15.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: Unit.text(
                                    '汽车视频', Color(0XFF111F37), 34.0, 5)),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/videolist',
                                );
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Unit.text('更多', Color(0XFF6A7182), 26.0, 4),
                                    SizedBox(
                                      width: Ui.width(10),
                                    ),
                                    Image.asset('images/2.0x/rightmore.png',
                                        width: Ui.width(13),
                                        height: Ui.width(26))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          width: Ui.width(750),
                          height: Ui.width(300),
                          padding: EdgeInsets.fromLTRB(Ui.width(30.0), 0, 0, 0),
                          child: ListView.builder(
                            itemCount: data['videos'].length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  // String token =
                                  //     await Storage.getString('userInfo');
                                  // Navigator.pushNamed(
                                  //   context,
                                  //   '/videolist',
                                  // );
                                  //浏览软文足迹
                                  HttpHelper.saveFootprint(data['videos'][index]['title'],data['videos'][index]['id'], '5', context);
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (_) => FullVideoPage(
                                            playType: PlayType.network,
                                            titles:
                                                '${data['videos'][index]['title']}',
                                            dataSource:
                                                '${data['videos'][index]['url']}',
                                          )));
                                },
                                child: Container(
                                  width: Ui.width(390),
                                  margin: EdgeInsets.fromLTRB(
                                      0, 0, Ui.width(16), 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: Ui.width(390),
                                        height: Ui.width(220),
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              child: ClipRRect(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        new Radius.circular(
                                                            Ui.width(4.0))),
                                                child: CachedNetworkImage(
                                                    width: Ui.width(390),
                                                    height: Ui.width(220),
                                                    fit: BoxFit.fill,
                                                    imageUrl:
                                                        '${data['videos'][index]['picUrl']}'),
                                              ),
                                            ),
                                            Positioned(
                                                top: Ui.width(65),
                                                left: Ui.width(150),
                                                child: Image.asset(
                                                    'images/2.0x/play.png',
                                                    width: Ui.width(90),
                                                    height: Ui.width(90)))
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: Ui.width(10),
                                      ),
                                      Container(
                                        width: Ui.width(390),
                                        child: Text(
                                            '${data['videos'][index]['title']}',
                                            overflow: TextOverflow.ellipsis,
                                            style: Unit.textStyle(
                                                Color(0XFF111F37), 30.0, 4)),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
                    ],
                  ),
                )
              : Container(
                  child: LoadingDialog(
                    text: "加载中…",
                  ),
                ),
        ));
  }
}
