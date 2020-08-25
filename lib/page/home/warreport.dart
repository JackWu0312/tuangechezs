import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../common/Unit.dart';
import '../../http/index.dart';
import '../../common/Nofind.dart';
import 'package:tuangechezs/common/LoadingDialog.dart';

// 战报详情页有
class Warreport extends StatefulWidget {
  Warreport({Key key}) : super(key: key);

  @override
  _WarreportState createState() => _WarreportState();
}

class _WarreportState extends State<Warreport> {
  bool isloading = false;
  var data;
  var active = 1;
  int isAgent = 1;
  @override
  void initState() {
    super.initState();
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
    await HttpUtlis.get('third/home/report?timeLevel=${this.active}',
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

  gettagsWidget() {
    List<Widget> list = [];
    Widget content;
    for (var item in data['customs']) {
      list.add(Container(
        height: Ui.width(90),
        width: Ui.width(690),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(width: Ui.width(1), color: Color(0xffE9ECF1)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: Ui.width(70),
                      height: Ui.width(70),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: '${item['avatar']}',
                        ),
                      )),
                  SizedBox(
                    width: Ui.width(20),
                  ),
                  Container(
                      child: Unit.text(
                          '${item['nickname'] != null ? item['nickname'].length == 15 ? item['nickname'].substring(0, 4) : item['nickname'] : ""}  ${item['mobile'] == null ? "" : item['mobile']}',
                          Color(0XFF111F37),
                          28.0,
                          4))
                ],
              ),
            ),
            Container(
                child: Unit.text('${item['addTime'].substring(0, 10)}',
                    Color(0XFF9398A5), 28.0, 4))
          ],
        ),
      ));
    }
    content = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
    return content;
  }

  @override
  Widget build(BuildContext context) {
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
                            child:
                                Unit.text('客户转化', Color(0XFFFFFFFF), 36.0, 5))
                      ],
                    ),
                  )),
              preferredSize:
                  Size(MediaQuery.of(context).size.width, Ui.width(90))),
          body: isloading
              ? Container(
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        width: Ui.width(750),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, Ui.width(50)),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: Ui.width(20),
                                    color: Color(0xffEEF3F9)))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  Ui.width(30), Ui.width(30), 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        active = 1;
                                         getData();
                                      });
                                    },
                                    child: Container(
                                        width: Ui.width(160),
                                        height: Ui.width(46),
                                        margin: EdgeInsets.fromLTRB(
                                            0, 0, Ui.width(20), 0),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Ui.width(45)),
                                          border: Border.all(
                                              width: Ui.width(1),
                                              color: active == 1
                                                  ? Color(0xFF2F8CFA)
                                                  : Color(0xFFB0B1BB)),
                                        ),
                                        child: Unit.text(
                                            '今日数据',
                                            active == 1
                                                ? Color(0xFF2F8CFA)
                                                : Color(0xFFB0B1BB),
                                            26.0,
                                            4)),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        active = 3;
                                         getData();
                                      });
                                    },
                                    child: Container(
                                        width: Ui.width(160),
                                        height: Ui.width(46),
                                        margin: EdgeInsets.fromLTRB(
                                            0, 0, Ui.width(20), 0),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Ui.width(45)),
                                          border: Border.all(
                                              width: Ui.width(1),
                                              color: active == 3
                                                  ? Color(0xFF2F8CFA)
                                                  : Color(0xFFB0B1BB)),
                                        ),
                                        child: Unit.text(
                                            '本月数据',
                                            active == 3
                                                ? Color(0xFF2F8CFA)
                                                : Color(0xFFB0B1BB),
                                            26.0,
                                            4)),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  Ui.width(20), 0, Ui.width(20), 0),
                              child: Wrap(
                                children: <Widget>[
                                  Container(
                                    width: Ui.width(177.5),
                                    margin: EdgeInsets.fromLTRB(
                                        0, Ui.width(60), 0, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Unit.text('${data['articles']}',
                                            Color(0xFF2F8CFA), 44.0, 5),
                                        SizedBox(
                                          height: Ui.width(20),
                                        ),
                                        Unit.text(
                                            '软文分享', Color(0xFF5E6578), 28.0, 4),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: Ui.width(177.5),
                                    margin: EdgeInsets.fromLTRB(
                                        0, Ui.width(60), 0, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Unit.text('${data['posters']}',
                                            Color(0xFF2F8CFA), 44.0, 5),
                                        SizedBox(
                                          height: Ui.width(20),
                                        ),
                                        Unit.text(
                                            '海报分享', Color(0xFF5E6578), 28.0, 4),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: Ui.width(177.5),
                                    margin: EdgeInsets.fromLTRB(
                                        0, Ui.width(60), 0, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Unit.text('${data['videos']}',
                                            Color(0xFF2F8CFA), 44.0, 5),
                                        SizedBox(
                                          height: Ui.width(20),
                                        ),
                                        Unit.text(
                                            '视频分享', Color(0xFF5E6578), 28.0, 4),
                                      ],
                                    ),
                                  ),
                                  isAgent == 1
                                      ? Container(
                                          width: Ui.width(177.5),
                                          margin: EdgeInsets.fromLTRB(
                                              0, Ui.width(60), 0, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Unit.text(
                                                  '${data['customs'].length}',
                                                  Color(0xFF2F8CFA),
                                                  44.0,
                                                  5),
                                              SizedBox(
                                                height: Ui.width(20),
                                              ),
                                              Unit.text('邀请客户',
                                                  Color(0xFF5E6578), 28.0, 4),
                                            ],
                                          ),
                                        )
                                      : SizedBox(),
                                  Container(
                                    width: Ui.width(177.5),
                                    margin: EdgeInsets.fromLTRB(
                                        0, Ui.width(60), 0, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Unit.text('${data['sales']}',
                                            Color(0xFF2F8CFA), 44.0, 5),
                                        SizedBox(
                                          height: Ui.width(20),
                                        ),
                                        Unit.text(
                                            '下单客户', Color(0xFF5E6578), 28.0, 4),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: Ui.width(90),
                        width: Ui.width(750),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: Ui.width(1),
                                    color: Color(0xffE9ECF1)))),
                        padding: EdgeInsets.fromLTRB(Ui.width(30), 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'images/2.0x/invitation.png',
                              width: Ui.width(42),
                              height: Ui.width(42),
                            ),
                            SizedBox(
                              width: Ui.width(20),
                            ),
                            Unit.text(isAgent == 1 ? '邀请客户' : '下单客户',
                                Color(0XFF111F37), 28.0, 4)
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              Ui.width(30), 0, Ui.width(30), Ui.width(20)),
                          child: gettagsWidget())
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
