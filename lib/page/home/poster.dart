import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuangechezs/common/Storage.dart';
import 'package:tuangechezs/ui/ui.dart';
import '../../http/index.dart';
import '../../common/Unit.dart';
import '../../common/Nofind.dart';
// import 'package:photo_view/photo_view.dart';
import '../../common/FadeRoute.dart';
import '../../common/PhotoViewGalleryScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Poster extends StatefulWidget {
  Poster({Key key}) : super(key: key);

  @override
  _PosterState createState() => _PosterState();
}

class _PosterState extends State<Poster> {
  var active = 0;
  bool synthesis = false;
  bool isDel = false;
  var mergerid = '';
  List imgs = [];
  var isselect = 0;

  getlistselect() {
    for (var i = 0, len = list.length; i < len; i++) {
      list[i]['select'] = false;
    }
  }

  ScrollController _scrollController = new ScrollController();
  List list = [];
  List listtag = [];
  bool nolist = true;
  bool isMore = true;
  int page = 1;
  int limit = 10;
  var tag = '';
  void initState() {
    super.initState();
    gettags();
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

  getimgs() {
    setState(() {
      imgs = [];
    });
    for (var i = 0, len = list.length; i < len; i++) {
      imgs.add(list[i]['picUrl']);
    }
  }

  gettags() async {
    await HttpUtlis.get('third/poster/tags', success: (value) {
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
    // print(this.tag);
    if (isMore) {
      await HttpUtlis.get(
          'third/poster/list?page=${this.page}&limit=${this.limit}&tag=${this.tag}&merged=${this.active}',
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
          getimgs();
          getlistselect();
        }
      }, failure: (error) {
        Unit.setToast('${error}', context);
      });
    }
  }

  del(listid) async {
    await HttpUtlis.post('third/poster/delete/${listid}', success: (value) {
      if (value['errno'] == 0) {
        getlistselect();
        Unit.setToast('删除成功～', context);
        setState(() {
          list = [];
          nolist = true;
          isMore = true;
          page = 1;
          isDel = false;
        });
        getData();
      } else {
        Unit.setToast('删除失败～', context);
      }
    }, failure: (error) {
      Unit.setToast(error, context);
    });
  }

  getmerge() async {
    await HttpUtlis.post('third/poster/merge/${this.mergerid}',
        success: (value) {
      if (value['errno'] == 0) {
        getlistselect();
        Unit.setToast('合并成功～', context);
        setState(() {
          synthesis = false;
        });
      } else {
        Unit.setToast('合并失败～', context);
      }
    }, failure: (error) {
      Unit.setToast(error, context);
    });
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
                            right: Ui.width(30),
                            top: Ui.width(25),
                            child: active == 1
                                ? isDel
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            isDel = false;
                                          });
                                        },
                                        child: Container(
                                          width: Ui.width(60),
                                          child: Text(
                                            '取消',
                                            style: TextStyle(
                                                color: Color(0XFFFFFFFF),
                                                fontSize:
                                                    Ui.setFontSizeSetSp(28),
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    'PingFangSC-Regular,PingFang SC'),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            isDel = true;
                                          });
                                        },
                                        child: Container(
                                          width: Ui.width(60),
                                          child: Text(
                                            '选择',
                                            style: TextStyle(
                                                color: Color(0XFFFFFFFF),
                                                fontSize:
                                                    Ui.setFontSizeSetSp(28),
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    'PingFangSC-Regular,PingFang SC'),
                                          ),
                                        ),
                                      )
                                : Text(''),
                          ),
                          Positioned(
                              left: 0,
                              top: Ui.width(30),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: Ui.width(80),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'images/2.0x/back.png',
                                      width: Ui.width(20),
                                      height: Ui.width(36),
                                    ),
                                  ))),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '海报列表',
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
                        ? ListView(
                            controller: _scrollController,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    Ui.width(30), Ui.width(10), 0, 0),
                                child: Wrap(
                                    runSpacing: Ui.width(30),
                                    spacing: Ui.width(20),
                                    children: list.asMap().keys.map((index) {
                                      return InkWell(
                                        onTap: () async {
                                          String token =
                                              await Storage.getString(
                                                  'userInfo');
                                          Navigator.pushNamed(
                                              context, '/preview', arguments: {
                                            'detail': list[index],
                                            'id': json.decode(token)['id']
                                          });

                                          // if (active == 1) {
                                          //   Navigator.pushNamed(
                                          //       context, '/preview',
                                          //       arguments: {
                                          //         'detail': list[index]
                                          //       });
                                          // } else {
                                          //   Navigator.of(context).push(
                                          //       new FadeRoute(
                                          //           page:
                                          //               PhotoViewGalleryScreen(
                                          //     images: imgs, //传入图片list
                                          //     index: index, //传入当前点击的图片的index
                                          //   )));
                                          // }
                                        },
                                        child: Container(
                                          width: Ui.width(335),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              // Container(
                                              //   width: Ui.width(335),
                                              //   height: Ui.width(410),
                                              //   decoration: BoxDecoration(
                                              //     image: DecorationImage(
                                              //       image: NetworkImage(
                                              //           '${list[index]['picUrl']}'),
                                              //       fit: BoxFit.fill,
                                              //     ),
                                              //   ),
                                              //   child: Stack(
                                              //     children: <Widget>[
                                              //       Positioned(
                                              //         top: Ui.width(20),
                                              //         right: Ui.width(20),
                                              //         child: synthesis || isDel
                                              //             ? InkWell(
                                              //                 onTap: () {
                                              //                   if (active ==
                                              //                       0) {
                                              //                     getlistselect();
                                              //                     mergerid =
                                              //                         list[index]
                                              //                             [
                                              //                             'id'];
                                              //                   }
                                              //                   setState(() {
                                              //                     list[index][
                                              //                         'select'] = !list[
                                              //                             index]
                                              //                         [
                                              //                         'select'];
                                              //                   });
                                              //                 },
                                              //                 child: Container(
                                              //                   width: Ui.width(
                                              //                       44),
                                              //                   height:
                                              //                       Ui.width(
                                              //                           44),
                                              //                   decoration:
                                              //                       BoxDecoration(
                                              //                     image:
                                              //                         DecorationImage(
                                              //                       image: AssetImage(list[index]
                                              //                               [
                                              //                               'select']
                                              //                           ? 'images/2.0x/selectposter.png'
                                              //                           : 'images/2.0x/unselect.png'),
                                              //                       fit: BoxFit
                                              //                           .fill,
                                              //                     ),
                                              //                   ),
                                              //                 ),
                                              //               )
                                              //             : Text(''),
                                              //       )
                                              //     ],
                                              //   ),
                                              // ),

                                              Container(
                                                width: Ui.width(335),
                                                height: Ui.width(410),
                                                child: CachedNetworkImage(
                                                    fit: BoxFit.fill,
                                                    imageUrl:
                                                        '${list[index]['picUrl']}'),
                                              ),

                                              Container(
                                                width: Ui.width(335),
                                                margin: EdgeInsets.fromLTRB(
                                                    0, Ui.width(10), 0, 0),
                                                child: Text(
                                                  '${list[index]['title']}',
                                                  style: TextStyle(
                                                      color: Color(0XFF111F37),
                                                      fontSize:
                                                          Ui.setFontSizeSetSp(
                                                              30),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          'PingFangSC-Regular,PingFang SC'),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList()),
                              )
                            ],
                          )
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
                                  isselect = index;
                                  tag = listtag[index]['value'];
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
                        )

                        //  ListView(
                        //   scrollDirection: Axis.horizontal,
                        //   children: <Widget>[
                        //     Container(
                        //       height: Ui.width(54),
                        //       alignment: Alignment.center,
                        //       margin: EdgeInsets.fromLTRB(0, 0, Ui.width(30), 0),
                        //       padding: EdgeInsets.fromLTRB(
                        //           Ui.width(20), 0, Ui.width(20), 0),
                        //       child: Text(
                        //         '汽车资讯',
                        //         style: TextStyle(
                        //             color: Color(0XFF5E6578),
                        //             fontSize: Ui.setFontSizeSetSp(28),
                        //             fontWeight: FontWeight.w400,
                        //             fontFamily: 'PingFangSC-Regular,PingFang SC'),
                        //       ),
                        //     ),
                        //       Container(
                        //       height: Ui.width(54),
                        //       alignment: Alignment.center,
                        //       margin: EdgeInsets.fromLTRB(0, 0, Ui.width(30), 0),
                        //       padding: EdgeInsets.fromLTRB(
                        //           Ui.width(20), 0, Ui.width(20), 0),
                        //       decoration: BoxDecoration(
                        //         color: Color(0xFFEAEAEC),
                        //          borderRadius: new BorderRadius.all(
                        //           new Radius.circular(Ui.width(30.0))),
                        //       ),
                        //       child: Text(
                        //         '汽车资讯汽车资讯',
                        //         style: TextStyle(
                        //             color: Color(0XFF5E6578),
                        //             fontSize: Ui.setFontSizeSetSp(28),
                        //             fontWeight: FontWeight.w400,
                        //             fontFamily: 'PingFangSC-Regular,PingFang SC'),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        ),
                  )
                  // Positioned(
                  //   top: -1,
                  //   left: 0,
                  //   child: Container(
                  //     width: Ui.width(750),
                  //     height: Ui.width(90),
                  //     decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //         begin: Alignment.centerLeft,
                  //         end: Alignment.centerRight,
                  //         colors: [
                  //           Color(0xFF5BBEFF),
                  //           Color(0xFF466EFF),
                  //         ],
                  //       ),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: <Widget>[
                  //         InkWell(
                  //           onTap: () {
                  //             setState(() {
                  //               active = 0;
                  //               isDel = false;
                  //               list = [];
                  //               nolist = true;
                  //               isMore = true;
                  //               page = 1;
                  //             });
                  //             getData();
                  //             // getlistselect();
                  //           },
                  //           child: Container(
                  //             width: Ui.width(100),
                  //             height: Ui.width(90),
                  //             child: Stack(
                  //               children: <Widget>[
                  //                 Container(
                  //                   width: Ui.width(100),
                  //                   height: Ui.width(90),
                  //                   alignment: Alignment.center,
                  //                   child: Text(
                  //                     '未合成',
                  //                     style: TextStyle(
                  //                         color: Color(0XFFFFFFFF),
                  //                         fontSize: Ui.setFontSizeSetSp(30),
                  //                         fontWeight: FontWeight.w400,
                  //                         fontFamily:
                  //                             'PingFangSC-Regular,PingFang SC'),
                  //                   ),
                  //                 ),
                  //                 Positioned(
                  //                   left: 0,
                  //                   bottom: 0,
                  //                   child: Container(
                  //                     width: Ui.width(100),
                  //                     height: Ui.width(6),
                  //                     decoration: BoxDecoration(
                  //                       color: active == 0
                  //                           ? Colors.white
                  //                           : Colors.transparent,
                  //                       borderRadius:
                  //                           BorderRadius.circular(Ui.width(6)),
                  //                     ),
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //         InkWell(
                  //           onTap: () {
                  //             setState(() {
                  //               active = 1;
                  //               synthesis = false;
                  //               list = [];
                  //               nolist = true;
                  //               isMore = true;
                  //               page = 1;
                  //             });
                  //             getData();
                  //             // getlistselect();
                  //           },
                  //           child: Container(
                  //             width: Ui.width(100),
                  //             height: Ui.width(90),
                  //             child: Stack(
                  //               children: <Widget>[
                  //                 Container(
                  //                   width: Ui.width(100),
                  //                   height: Ui.width(90),
                  //                   alignment: Alignment.center,
                  //                   child: Text(
                  //                     '已合成',
                  //                     style: TextStyle(
                  //                         color: Color(0XFFFFFFFF),
                  //                         fontSize: Ui.setFontSizeSetSp(30),
                  //                         fontWeight: FontWeight.w400,
                  //                         fontFamily:
                  //                             'PingFangSC-Regular,PingFang SC'),
                  //                   ),
                  //                 ),
                  //                 Positioned(
                  //                   left: 0,
                  //                   bottom: 0,
                  //                   child: Container(
                  //                     width: Ui.width(100),
                  //                     height: Ui.width(6),
                  //                     decoration: BoxDecoration(
                  //                       color: active == 1
                  //                           ? Colors.white
                  //                           : Colors.transparent,
                  //                       borderRadius:
                  //                           BorderRadius.circular(Ui.width(6)),
                  //                     ),
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Positioned(
                  //     bottom: Ui.width(30),
                  //     left: Ui.width(30),
                  //     child: active == 0
                  //         ? synthesis
                  //             ? InkWell(
                  //                 onTap: () {
                  //                   if (mergerid != '') {
                  //                     getmerge();
                  //                   } else {
                  //                     Unit.setToast('请选择一张海报进行合成', context);
                  //                   }
                  //                 },
                  //                 child: Container(
                  //                   width: Ui.width(690),
                  //                   height: Ui.width(90),
                  //                   alignment: Alignment.center,
                  //                   decoration: BoxDecoration(
                  //                       color: Color(0xFF33AAF5),
                  //                       borderRadius:
                  //                           BorderRadius.circular(Ui.width(10)),
                  //                       boxShadow: [
                  //                         BoxShadow(
                  //                           color: Color(0XFFADD3FF),
                  //                           offset: Offset(1, 1),
                  //                           blurRadius: Ui.width(10.0),
                  //                         ),
                  //                       ]),
                  //                   child: Text(
                  //                     '海报合成',
                  //                     style: TextStyle(
                  //                         color: Color(0xFFFFFFFF),
                  //                         fontWeight: FontWeight.w500,
                  //                         fontFamily:
                  //                             'PingFangSC-Medium,PingFang SC',
                  //                         fontSize: Ui.setFontSizeSetSp(32.0)),
                  //                   ),
                  //                 ),
                  //               )
                  //             : InkWell(
                  //                 onTap: () {
                  //                   setState(() {
                  //                     synthesis = true;
                  //                   });
                  //                 },
                  //                 child: Container(
                  //                   width: Ui.width(690),
                  //                   height: Ui.width(90),
                  //                   alignment: Alignment.center,
                  //                   decoration: BoxDecoration(
                  //                       color: Color(0xFF33AAF5),
                  //                       borderRadius:
                  //                           BorderRadius.circular(Ui.width(10)),
                  //                       boxShadow: [
                  //                         BoxShadow(
                  //                           color: Color(0XFFADD3FF),
                  //                           offset: Offset(1, 1),
                  //                           blurRadius: Ui.width(10.0),
                  //                         ),
                  //                       ]),
                  //                   child: Text(
                  //                     '选择海报合成',
                  //                     style: TextStyle(
                  //                         color: Color(0xFFFFFFFF),
                  //                         fontWeight: FontWeight.w500,
                  //                         fontFamily:
                  //                             'PingFangSC-Medium,PingFang SC',
                  //                         fontSize: Ui.setFontSizeSetSp(32.0)),
                  //                   ),
                  //                 ),
                  //               )
                  //         : isDel
                  //             ? InkWell(
                  //                 onTap: () {
                  //                   var listid = [];
                  //                   for (var i = 0, len = list.length;
                  //                       i < len;
                  //                       i++) {
                  //                     if (list[i]['select']) {
                  //                       listid.add(list[i]['id']);
                  //                     }
                  //                   }
                  //                   del(listid.join(','));
                  //                 },
                  //                 child: Container(
                  //                   width: Ui.width(690),
                  //                   height: Ui.width(90),
                  //                   alignment: Alignment.center,
                  //                   decoration: BoxDecoration(
                  //                       color: Color(0xFF33AAF5),
                  //                       borderRadius:
                  //                           BorderRadius.circular(Ui.width(10)),
                  //                       boxShadow: [
                  //                         BoxShadow(
                  //                           color: Color(0XFFADD3FF),
                  //                           offset: Offset(1, 1),
                  //                           blurRadius: Ui.width(10.0),
                  //                         ),
                  //                       ]),
                  //                   child: Text(
                  //                     '删除',
                  //                     style: TextStyle(
                  //                         color: Color(0xFFFFFFFF),
                  //                         fontWeight: FontWeight.w500,
                  //                         fontFamily:
                  //                             'PingFangSC-Medium,PingFang SC',
                  //                         fontSize: Ui.setFontSizeSetSp(32.0)),
                  //                   ),
                  //                 ),
                  //               )
                  //             : Text(''))
                ],
              ),
            )));
  }
}
