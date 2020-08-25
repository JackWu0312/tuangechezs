import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/ui.dart';
import '../../http/index.dart';
import '../../common/Unit.dart';
import '../../common/Nofind.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Dried extends StatefulWidget {
  Dried({Key key}) : super(key: key);

  @override
  _DriedState createState() => _DriedState();
}

class _DriedState extends State<Dried> {
  ScrollController _scrollController = new ScrollController();
  List list = [];
  bool nolist = true;
  bool isMore = true;
  int page = 1;
  int limit = 10;
  var isselect = 0;
  List listtag = [];
  var tag = '';
  void initState() {
    super.initState();
    gettags();
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
  }

  gettags() async {
    await HttpUtlis.get('third/promote/article/tags', success: (value) {
      if (value['errno'] == 0) {
        setState(() {
          listtag = value['data'];
          tag = value['data'][0]['value'];
        });
        getData();
      }
    }, failure: (error) {
      Unit.setToast('${error}', context);
    });
  }

  getData() async {
    if (isMore) {
      await HttpUtlis.get(
          'third/promote/articles?page=${this.page}&limit=${this.limit}&tag=${this.tag}',
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
                            child: Text(
                              '软文分享',
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
            body: Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(0, Ui.width(100), 0, 0),
                  child: list.length > 0
                      ? Container(
                          color: Colors.white,
                          width: Ui.width(750),
                          padding: EdgeInsets.fromLTRB(
                              Ui.width(30), Ui.width(0), Ui.width(30), 0),
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/driedwebview',
                                      arguments: {
                                        'id': list[index]['id'],
                                        'title': list[index]['title'],
                                        'tag': list[index]['tag']
                                      });
                                },
                                child: Container(
                                  height: Ui.width(246),
                                  width: Ui.width(702),
                                  padding: EdgeInsets.fromLTRB(
                                      0, Ui.width(20), 0, Ui.width(20)),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: Color(0xffEAEAEA)))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                '${list[index]['title']}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Color(0xFF111F37),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'PingFangSC-Medium,PingFang SC',
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(
                                                            32.0)),
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Image.asset(
                                                    'images/2.0x/loginnew.png',
                                                    width: Ui.width(36),
                                                    height: Ui.width(36),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        Ui.width(10), 0, 0, 0),
                                                    child: Text(
                                                      '来自团个车',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                        margin: EdgeInsets.fromLTRB(
                                            Ui.width(20), 0, 0, 0),
                                        decoration: BoxDecoration(
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(
                                                  Ui.width(10.0))),
                                          // image: DecorationImage(
                                          //   image: NetworkImage(
                                          //       '${list[index]['picUrl']}'),
                                          //   fit: BoxFit.fill,
                                          // )
                                        ),
                                        child: ClipRRect(
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(
                                                  Ui.width(10.0))),
                                          child: CachedNetworkImage(
                                              width: Ui.width(270),
                                              height: Ui.width(207),
                                              fit: BoxFit.fill,
                                              imageUrl:
                                                  '${list[index]['picUrl']}'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ))
                      : Nofind(
                          text: "暂无更多数据哦～",
                        ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                      height: Ui.width(90),
                      width: Ui.width(750),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(Ui.width(24), Ui.width(18),
                          Ui.width(24), Ui.width(18)),
                      child: ListView.builder(
                        itemCount: listtag.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                list = [];
                                nolist = true;
                                isMore = true;
                                page = 1;
                                limit = 10;
                                tag = listtag[index]['value'];
                                isselect = index;
                              });
                              getData();
                            },
                            child: Container(
                              height: Ui.width(54),
                              alignment: Alignment.center,
                              margin:
                                  EdgeInsets.fromLTRB(0, 0, Ui.width(30), 0),
                              padding: EdgeInsets.fromLTRB(
                                  Ui.width(20), 0, Ui.width(20), 0),
                              decoration: BoxDecoration(
                                color: index == isselect
                                    ? Color(0xFFEAEAEC)
                                    : Color(0xFFFFFFFF),
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(Ui.width(30.0))),
                              ),
                              child: Text(
                                '${listtag[index]['label']}',
                                style: TextStyle(
                                    color: index == isselect
                                        ? Color(0xFF111F37)
                                        : Color(0XFF5E6578),
                                    fontSize: Ui.setFontSizeSetSp(30),
                                    fontWeight: FontWeight.w400,
                                    fontFamily:
                                        'PingFangSC-Regular,PingFang SC'),
                              ),
                            ),
                          );
                        },
                      )),
                )
              ],
            )));
  }
}
