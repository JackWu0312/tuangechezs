import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:tuangechezs/page/config/config.dart';
import '../../ui/ui.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../http/index.dart';
import '../../common/LoadingDialog.dart';
import '../../common/Storage.dart';
import 'package:provider/provider.dart';
import '../../provider/Addressselect.dart';
import 'dart:io';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluwx/fluwx.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import '../../common/CommonBottomSheet.dart';

// import 'package:toast/toast.dart';
class Goodsdetail extends StatefulWidget {
  final Map arguments;

  Goodsdetail({Key key, this.arguments}) : super(key: key);

  @override
  _GoodsdetailState createState() => _GoodsdetailState();
}

class _GoodsdetailState extends State<Goodsdetail>
    with SingleTickerProviderStateMixin {
  var _initKeywordsController = new TextEditingController();
  TabController _tabController;
  bool isloading = false;
  String nums = '1';
  List listAllimage = [];
  List list = [];
  int points = 0;
  double retailPrice = 0;
  int style = 1; //1 ios 2安卓
  var data;
  StreamSubscription<WeChatShareResponse> _wxlogin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._initKeywordsController.text = nums;
    _tabController = TabController(length: 2, vsync: this);
    getData();
    // calculate();
    getstyle();
    fluwx.registerWxApi(
        appId: "wx234a903f1faba1f9",
        universalLink: "https://app.tuangeche.com.cn/");
    _wxlogin = fluwx.responseFromShare.listen((data) {
      if (data.errCode == 0) {
        print('分享成功！');
        getShare();
      }
    });
  }

  getShare() {
    HttpUtlis.post("wx/share/callback",
        params: {'dataId': widget.arguments['id'], 'type': 2, 'platform': 1},
        success: (value) async {
      if (value['errno'] == 0) {
        print('分享成功～');
      }
    }, failure: (error) {
      Toast.show('${error}', context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    });
  }

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

  calculate(setBottomState) async {
    if (nums == '') {
      setState(() {
        nums = '1';
      });
    }
    await HttpUtlis.post('third/points/goods/calculate',
        params: {'id': data['product']['id'], 'number': int.parse(nums)},
        success: (value) {
      if (value['errno'] == 0) {
        setBottomState(() {
          points = value['data']['points'];
          retailPrice = value['data']['price'];
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

  getData() async {
    print(widget.arguments['id']);
    await HttpUtlis.get('third/points/goods/${widget.arguments['id']}',
        success: (value) {
      if (value['errno'] == 0) {
        setState(() {
          listAllimage = value['data']['gallery']['images'];
          data = value['data'];
          // obj = value['data'];
          list = value['data']["attributes"];
          points = data['goods']['points']; // int
          retailPrice = data['goods']['retailPrice'];
        });
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

  getToken() async {
    try {
      String token = await Storage.getString('token');
      return token;
    } catch (e) {
      return '';
    }
  }

  List<Widget> getlist() {
    return list.map((val) {
      return Container(
        margin: EdgeInsets.fromLTRB(0, Ui.width(50), 0, 0),
        width: Ui.width(750),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: Ui.width(200),
              child: Text(
                '${val['label']}',
                style: TextStyle(
                    color: Color(0xFF9398A5),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'PingFangSC-Medium,PingFang SC',
                    fontSize: Ui.setFontSizeSetSp(28.0)),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Text(
                  val['value'] == null ? '' : '${val['value']}',
                  style: TextStyle(
                      color: Color(0xFF111F37),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'PingFangSC-Medium,PingFang SC',
                      fontSize: Ui.setFontSizeSetSp(28.0)),
                ),
              ),
            )
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    _attrBottomSheet(showtosh, counters) {
      showModalBottomSheet(
          context: context,
          builder: (contex) {
            return StatefulBuilder(
              builder: (BuildContext context, setBottomState) {
                return GestureDetector(
                  //解决showModalBottomSheet点击消失的问题
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    return false;
                  },
                  child: Container(
                    height: Ui.width(440) +
                        MediaQuery.of(context).viewInsets.bottom,
                    color: Color(0xFFFFFFFF),
                    width: Ui.width(750),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: Ui.width(750),
                          margin: EdgeInsets.fromLTRB(
                              Ui.width(40), Ui.width(40), 0, 0),
                          height: Ui.width(40),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '购买数量',
                            style: TextStyle(
                                color: Color(0xFF111F37),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'PingFangSC-Medium,PingFang SC',
                                fontSize: Ui.setFontSizeSetSp(28.0)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Ui.width(40), Ui.width(110), 0, 0),
                          child: RichText(
                            text: TextSpan(
                              text: '${points}',
                              style: TextStyle(
                                  color: Color(0xFFD10123),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'PingFangSC-Medium,PingFang SC',
                                  fontSize: Ui.setFontSizeSetSp(42.0)),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' 积分',
                                    style: TextStyle(
                                        color: Color(0xFFD10123),
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Medium,PingFang SC',
                                        fontSize: Ui.setFontSizeSetSp(24.0))),
//                                TextSpan(
//                                    text: ' +${retailPrice}元',
//                                    style: TextStyle(
//                                        color: Color(0xFFD10123),
//                                        fontWeight: FontWeight.w400,
//                                        fontFamily:
//                                            'PingFangSC-Medium,PingFang SC',
//                                        fontSize: Ui.setFontSizeSetSp(28.0))),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: Ui.width(750),
                          padding: EdgeInsets.fromLTRB(
                              Ui.width(40), 0, Ui.width(45), 0),
                          margin: EdgeInsets.fromLTRB(0, Ui.width(185), 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  '数量:',
                                  style: TextStyle(
                                      color: Color(0xFF111F37),
                                      fontWeight: FontWeight.w400,
                                      fontFamily:
                                          'PingFangSC-Medium,PingFang SC',
                                      fontSize: Ui.setFontSizeSetSp(26.0)),
                                ),
                              ),
                              Container(
                                // width: Ui.width(750),
                                height: Ui.width(56),
                                // margin:
                                //     EdgeInsets.fromLTRB(0, Ui.width(110), 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      data['product']['limit'] == 0
                                          ? '不限购'
                                          : '限购${data['product']['limit']}件',
                                      style: TextStyle(
                                          color: Color(0xFFD10123),
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              'PingFangSC-Medium,PingFang SC',
                                          fontSize: Ui.setFontSizeSetSp(24.0)),
                                    ),
                                    SizedBox(
                                      width: Ui.width(30),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (int.parse(nums) > 1) {
                                          setBottomState(() {
                                            nums = (int.parse(nums) - 1)
                                                .toString();
                                          });
                                        } else {
                                          setBottomState(() {
                                            nums = '1';
                                          });
                                        }
                                        setBottomState(() {
                                          _initKeywordsController.text = nums;
                                        });
                                        calculate(setBottomState);
                                      },
                                      child: Container(
                                        width: Ui.width(35),
                                        height: Ui.width(35),
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: Ui.width(35),
                                          height: Ui.width(3),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      'images/2.0x/reduce.png'))),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        width: Ui.width(100),
                                        height: Ui.width(60),
                                        color: Color(0xFFF4F4F4),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(
                                            Ui.width(27), 0, Ui.width(27), 0),
                                        child: TextField(
                                          controller:
                                              TextEditingController.fromValue(
                                            TextEditingValue(
                                                // 设置内容
                                                text: _initKeywordsController
                                                    .text,
                                                // 保持光标在最后
                                                selection: TextSelection
                                                    .fromPosition(TextPosition(
                                                        affinity: TextAffinity
                                                            .downstream,
                                                        offset:
                                                            _initKeywordsController
                                                                .text.length))),
                                          ),

                                          // controller: this._initKeywordsController,
                                          autofocus: false,
                                          textAlign: TextAlign.center,
                                          keyboardAppearance: Brightness.light,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              color: Color(0XFF111F37),
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                                  Ui.setFontSizeSetSp(32)),
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      0,
                                                      Ui.width(16),
                                                      0,
                                                      style == 1
                                                          ? Ui.width(26)
                                                          : Ui.width(30))),
                                          onChanged: (value) {
                                            if (int.parse(value) < 1) {
                                              setBottomState(() {
                                                nums = '1';
                                              });
                                              Toast.show("数量不能低于1哦～", context,
                                                  backgroundColor:
                                                      Color(0xff5b5956),
                                                  backgroundRadius: Ui.width(8),
                                                  duration: Toast.LENGTH_SHORT,
                                                  gravity: Toast.CENTER);
                                              // Toast(context,msg:'数量不能低于1哦～');
                                            } else if (int.parse(value) >
                                                    data['product']['limit'] &&
                                                data['product']['limit'] != 0) {
                                              setBottomState(() {
                                                nums = data['product']['limit']
                                                    .toString();
                                              });
                                              // Toast.info(`超过限购数量哦～`);
                                              Toast.show("超过限购数量哦～", context,
                                                  backgroundColor:
                                                      Color(0xff5b5956),
                                                  backgroundRadius: Ui.width(8),
                                                  duration: Toast.LENGTH_SHORT,
                                                  gravity: Toast.CENTER);
                                            } else if (value == '') {
                                              setBottomState(() {
                                                nums = '';
                                              });
                                            } else {
                                              setBottomState(() {
                                                nums = value;
                                              });
                                            }
                                            // if (1 <= int.parse(value)) {
                                            //   setBottomState(() {
                                            //     nums = value;
                                            //   });
                                            // } else {
                                            //   setBottomState(() {
                                            //     nums = '1';
                                            //   });
                                            // }
                                            setBottomState(() {
                                              _initKeywordsController.text =
                                                  nums;
                                            });
                                            this.calculate(setBottomState);
                                          },
                                        )),
                                    InkWell(
                                      onTap: () {
                                        if (int.parse(nums) >=
                                                data['product']['limit'] &&
                                            data['product']['limit'] != 0) {
                                          setBottomState(() {
                                            nums = data['product']['limit']
                                                .toString();
                                          });
                                        } else {
                                          setBottomState(() {
                                            nums = (int.parse(nums) + 1)
                                                .toString();
                                          });
                                        }
                                        setBottomState(() {
                                          _initKeywordsController.text = nums;
                                        });

                                        calculate(setBottomState);
                                      },
                                      child: Container(
                                        width: Ui.width(35),
                                        height: Ui.width(35),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    'images/2.0x/add.png'))),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, Ui.width(270), 0, 0),
                          padding: EdgeInsets.fromLTRB(
                              Ui.width(40), 0, Ui.width(40), 0),
                          child: Text.rich(new TextSpan(
                              text: '*',
                              style: new TextStyle(
                                color: Color(0xFFD10123),
                                fontSize: Ui.setFontSizeSetSp(22),
                                fontFamily: 'PingFangSC-Regular,PingFang SC',
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                              children: <TextSpan>[
                                new TextSpan(
                                  text:
                                      '划线价:是指品牌专柜价、商品吊牌价、正品零售价、厂商指导价或该产品曾经展示过的销售价等，并非原价、仅供参考',
                                  style: new TextStyle(
                                    color: Color(0xFF9398A5),
                                    fontSize: Ui.setFontSizeSetSp(22),
                                    fontFamily:
                                        'PingFangSC-Regular,PingFang SC',
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ])),
                        ),
                        Positioned(
                            right: Ui.width(20),
                            top: Ui.width(20),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: Ui.width(30),
                                height: Ui.width(30),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'images/2.0x/clonse.png'))),
                              ),
                            )),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            child: InkWell(
                              onTap: () async {
                                if (await getToken() != null) {
                                  counters.increment({});
                                  Navigator.pushNamed(context, '/ordercom',
                                      arguments: {
                                        "num": nums,
                                        "id": widget.arguments['id']
                                      });
                                } else {
                                  showtosh();
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: Ui.width(750),
                                height: Ui.width(90),
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
                                  '确认',
                                  style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w400,
                                      fontFamily:
                                          'PingFangSC-Medium,PingFang SC',
                                      fontSize: Ui.setFontSizeSetSp(32.0)),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                );
              },
            );
          });
    }

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

    final counters = Provider.of<Addressselect>(context);

    Ui.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          child: Container(
              padding:
                  new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
              child: Column(
                children: <Widget>[
                  Container(
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
                            '商品详情',
                            style: TextStyle(
                                color: Color(0XFFFFFFFF),
                                fontSize: Ui.setFontSizeSetSp(36),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'PingFangSC-Regular,PingFang SC'),
                          ),
                        )
                      ],
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    unselectedLabelColor: Color(0xFFffffff),
                    labelColor: Color(0xFFD10123),
                    indicatorColor: Color(0xFFD10123),
                    indicatorPadding:
                    EdgeInsets.fromLTRB(Ui.width(145), 0, Ui.width(145), 0),
                    unselectedLabelStyle: new TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'PingFangSC-Medium,PingFang SC',
                        fontSize: Ui.setFontSizeSetSp(30.0)),
                    labelStyle: new TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'PingFangSC-Medium,PingFang SC',
                        fontSize: Ui.setFontSizeSetSp(30.0)),
                    tabs: <Widget>[
                      Tab(
                        text: '商品',
                      ),
                      Tab(
                        text: '详情',
                      ),
                    ],
                  ),

                ],
              )),
          preferredSize: Size(MediaQuery.of(context).size.width, Ui.width(210))
      ),
//      AppBar(
//        title: Text(
//          '商品详情',
//          style: TextStyle(
//              color: Color(0xFF111F37),
//              fontWeight: FontWeight.w500,
//              fontFamily: 'PingFangSC-Medium,PingFang SC',
//              fontSize: Ui.setFontSizeSetSp(36.0)),
//        ),
//        centerTitle: true,
//        elevation: 0,
//        brightness: Brightness.light,
//        bottom: TabBar(
//          controller: _tabController,
//          unselectedLabelColor: Color(0xFF111F37),
//          labelColor: Color(0xFFD10123),
//          indicatorColor: Color(0xFFD10123),
//          indicatorPadding:
//              EdgeInsets.fromLTRB(Ui.width(145), 0, Ui.width(145), 0),
//          unselectedLabelStyle: new TextStyle(
//              fontWeight: FontWeight.w500,
//              fontFamily: 'PingFangSC-Medium,PingFang SC',
//              fontSize: Ui.setFontSizeSetSp(30.0)),
//          labelStyle: new TextStyle(
//              fontWeight: FontWeight.w500,
//              fontFamily: 'PingFangSC-Medium,PingFang SC',
//              fontSize: Ui.setFontSizeSetSp(30.0)),
//          tabs: <Widget>[
//            Tab(
//              text: '商品',
//            ),
//            Tab(
//              text: '详情',
//            ),
//          ],
//        ),
//        leading: InkWell(
//          onTap: () {
//            Navigator.pop(context);
//          },
//          child: Container(
//            alignment: Alignment.center,
//            child: Image.asset(
//              'images/2.0x/back.png',
//              width: Ui.width(21),
//              height: Ui.width(37),
//            ),
//          ),
//        ),
//        actions: <Widget>[
//          InkWell(
//              onTap: () async {
//                showDialog(
//                    barrierDismissible: true, //是否点击空白区域关闭对话框,默认为true，可以关闭
//                    context: context,
//                    builder: (BuildContext context) {
//                      var list = List();
//                      list.add('发送给微信好友');
//                      list.add('分享到微信朋友圈');
//                      return CommonBottomSheet(
//                        list: list,
//                        onItemClickListener: (index) async {
//                          var model = fluwx.WeChatShareWebPageModel(
//                              webPage:
//                                  '${Config.weblink}appgoodpoint/${widget.arguments['id']}',
//                              title: '${data['brand']['name']}',
//                              description: '${data['goods']['name']}',
//                              thumbnail: "assets://images/loginnew.png",
//                              scene: index == 0
//                                  ? fluwx.WeChatScene.SESSION
//                                  : fluwx.WeChatScene.TIMELINE,
//                              transaction: "hh");
//                          fluwx.shareToWeChat(model);
//
//                          Navigator.pop(context);
//                        },
//                      );
//                    });
//              },
//              child: Container(
//                alignment: Alignment.center,
//                padding: EdgeInsets.fromLTRB(0, 0, Ui.width(40), 0),
//                child: Image.asset('images/2.0x/share.png',
//                    width: Ui.width(42), height: Ui.width(42)),
//              ))
//        ],
//      ),
      body: isloading
          ? Stack(
              children: <Widget>[
                TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    Container(
                      // height: double.infinity,
                      color: Color(0xFFFFFFFF),
                      child: ListView(
                        children: <Widget>[
                          Container(
                            width: Ui.width(750),
                            alignment: Alignment.center,
                            child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Swiper(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CachedNetworkImage(
                                        width: Ui.width(750),
                                        fit: BoxFit.fill,
                                        imageUrl: '${listAllimage[index]}');

                                    // new Image.network(
                                    //   '${listAllimage[index]}',
                                    //   fit: BoxFit.fill,
                                    // );
                                  },
                                  itemCount: listAllimage.length,
                                  autoplay:
                                      listAllimage.length > 1 ? true : false,
                                )),
                          ),
                          Container(
                            width: Ui.width(750),
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(Ui.width(40),
                                Ui.width(30), Ui.width(40), Ui.width(30)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Text(
                                //   '${data['brand']['name']}',
                                //   style: TextStyle(
                                //       color: Color(0xFF111F37),
                                //       fontWeight: FontWeight.w400,
                                //       fontFamily:
                                //           'PingFangSC-Medium,PingFang SC',
                                //       fontSize: Ui.setFontSizeSetSp(36.0)),
                                // ),
                                // SizedBox(height: Ui.width(30)),
                                Text(
                                  '${data['goods']['name']}',
                                  style: TextStyle(
                                      color: Color(0xFF111F37),
                                      fontWeight: FontWeight.w400,
                                      fontFamily:
                                          'PingFangSC-Medium,PingFang SC',
                                      fontSize: Ui.setFontSizeSetSp(34.0)),
                                ),
                                SizedBox(height: Ui.width(30)),
                                Row(
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                      text: TextSpan(
                                        text: '${data['goods']['points']}',
                                        style: TextStyle(
                                            color: Color(0xFFD10123),
                                            fontWeight: FontWeight.w400,
                                            fontFamily:
                                                'PingFangSC-Medium,PingFang SC',
                                            fontSize:
                                                Ui.setFontSizeSetSp(42.0)),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: ' 积分',
                                              style: TextStyle(
                                                  color: Color(0xFFD10123),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      'PingFangSC-Medium,PingFang SC',
                                                  fontSize: Ui.setFontSizeSetSp(
                                                      24.0))),
//                                          TextSpan(
//                                              text:
//                                                  ' +${data['goods']['retailPrice']}元',
//                                              style: TextStyle(
//                                                  color: Color(0xFFD10123),
//                                                  fontWeight: FontWeight.w400,
//                                                  fontFamily:
//                                                      'PingFangSC-Medium,PingFang SC',
//                                                  fontSize: Ui.setFontSizeSetSp(
//                                                      28.0))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: Ui.width(20),
                                    ),
                                    Text(
                                      '${data['goods']['counterPrice']}元',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Color(0xFF9398A5),
                                          fontWeight: FontWeight.w400,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontFamily:
                                              'PingFangSC-Medium,PingFang SC',
                                          fontSize: Ui.setFontSizeSetSp(24.0)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: Ui.width(750),
                            alignment: Alignment.centerLeft,
                            height: Ui.width(60),
                            color: Color(0xFFF8F9FB),
                            padding: EdgeInsets.fromLTRB(
                                Ui.width(40), 0, Ui.width(40), 0),
                            child: Text(
                              '规格',
                              style: TextStyle(
                                  color: Color(0xFF9398A5),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'PingFangSC-Medium,PingFang SC',
                                  fontSize: Ui.setFontSizeSetSp(28.0)),
                            ),
                          ),
                          Container(
                              width: Ui.width(750),
                              alignment: Alignment.centerLeft,
                              // height: Ui.width(176),
                              color: Color(0xFFFFFFFF),
                              padding: EdgeInsets.fromLTRB(
                                  Ui.width(40), 0, Ui.width(40), Ui.width(50)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: getlist(),
                              )),
                          Container(
                            width: Ui.width(750),
                            alignment: Alignment.centerLeft,
                            height: Ui.width(60),
                            color: Color(0xFFF8F9FB),
                            padding: EdgeInsets.fromLTRB(
                                Ui.width(40), 0, Ui.width(40), 0),
                            child: Text(
                              '兑换编号',
                              style: TextStyle(
                                  color: Color(0xFF9398A5),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'PingFangSC-Medium,PingFang SC',
                                  fontSize: Ui.setFontSizeSetSp(28.0)),
                            ),
                          ),
                          Container(
                              width: Ui.width(750),
                              alignment: Alignment.centerLeft,
                              // height: Ui.width(176),
                              color: Color(0xFFFFFFFF),
                              padding: EdgeInsets.fromLTRB(
                                  Ui.width(40), 0, Ui.width(40), Ui.width(30)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0, Ui.width(50), 0, 0),
                                    width: Ui.width(750),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: Ui.width(200),
                                          child: Text(
                                            '编号',
                                            style: TextStyle(
                                                color: Color(0xFF9398A5),
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    'PingFangSC-Medium,PingFang SC',
                                                fontSize:
                                                    Ui.setFontSizeSetSp(28.0)),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Text(
                                              '${data['goods']['goodsSn']}',
                                              style: TextStyle(
                                                  color: Color(0xFF111F37),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      'PingFangSC-Medium,PingFang SC',
                                                  fontSize: Ui.setFontSizeSetSp(
                                                      28.0)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0, Ui.width(50), 0, 0),
                                    width: Ui.width(750),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: Ui.width(200),
                                          child: Text(
                                            '价格',
                                            style: TextStyle(
                                                color: Color(0xFF9398A5),
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    'PingFangSC-Medium,PingFang SC',
                                                fontSize:
                                                    Ui.setFontSizeSetSp(28.0)),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Text(
                                              '${data['goods']['points']}积分',
                                              style: TextStyle(
                                                  color: Color(0xFF111F37),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      'PingFangSC-Medium,PingFang SC',
                                                  fontSize: Ui.setFontSizeSetSp(
                                                      28.0)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: Ui.width(100),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListView(
                        children: <Widget>[
                          // Container(
                          //   width: Ui.width(750),
                          //   alignment: Alignment.centerLeft,
                          //   height: Ui.width(60),
                          //   color: Color(0xFFF8F9FB),
                          //   padding: EdgeInsets.fromLTRB(
                          //       Ui.width(40), 0, Ui.width(40), 0),
                          //   child: Text(
                          //     '商品详情',
                          //     style: TextStyle(
                          //         color: Color(0xFF9398A5),
                          //         fontWeight: FontWeight.w400,
                          //         fontFamily: 'PingFangSC-Medium,PingFang SC',
                          //         fontSize: Ui.setFontSizeSetSp(28.0)),
                          //   ),
                          // ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                Ui.width(40), 0, Ui.width(40), 0),
                            // color: Colors.red,
                            child: data['goods']['detail'] != null
                                ? Html(
                                    data:
                                        '<div>${data['goods']['detail'].replaceAll('height="', '')}</div>',
                                  )
                                : Text(''),
                          ),
                          SizedBox(
                            height: Ui.width(120),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    child: InkWell(
                      onTap: () {
                        _attrBottomSheet(showtosh, counters);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: Ui.width(750),
                        height: Ui.width(90),
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
                          '立即兑换',
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'PingFangSC-Medium,PingFang SC',
                              fontSize: Ui.setFontSizeSetSp(32.0)),
                        ),
                      ),
                    ))
              ],
            )
          : Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: LoadingDialog(
                text: "加载中…",
              ),
            ),
    );
  }
}
