/*
 * @Descripttion: 
 * @version: 
 * @Author: jackWu
 * @Date: 2020-09-04 11:39:08
 * @LastEditors: sueRimn
 * @LastEditTime: 2020-09-04 12:13:06
 */

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import '../../common/Unit.dart';
import '../../ui/ui.dart';
import '../../http/index.dart';
import '../../common/LoadingDialog.dart';
import '../../common/Nofind.dart';

class Pointlist extends StatefulWidget {
  Pointlist({Key key}) : super(key: key);
  @override
  _PointlistState createState() => _PointlistState();
}

class _PointlistState extends State<Pointlist> {
  ScrollController _scrollController = new ScrollController();
  var islogin = true;

  List list = [];
  bool nolist = true;
  bool isMore = true;
  int page = 1;
  int limit = 10;
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

  getData() async {
    if (isMore) {
      await HttpUtlis.get('third/points/logs?page=${page}&limit=${limit}',
          success: (value) {
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

  @override
  Widget build(BuildContext context) {
    Ui.init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '积分记录',
            style: TextStyle(
                color: Color(0xFF111F37),
                fontWeight: FontWeight.w500,
                fontFamily: 'PingFangSC-Medium,PingFang SC',
                fontSize: Ui.setFontSizeSetSp(36.0)),
          ),
          centerTitle: true,
          elevation: 0,
          brightness: Brightness.light,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.center,
              child: Image.asset(
                'images/2.0x/back.png',
                width: Ui.width(21),
                height: Ui.width(37),
              ),
            ),
          ),
        ),
        body: islogin
            ? Container(
                color: Colors.white,
                child: list.length > 0
                    ? ListView.builder(
                        controller: _scrollController,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.fromLTRB(Ui.width(30),
                                Ui.width(30), Ui.width(30), Ui.width(30)),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Color(0XFFF1F1F1), width: 1.0),
                              ),
                            ),
                            constraints: BoxConstraints(
                              minHeight: Ui.width(110),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: Ui.width(500),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Unit.text('${list[index]['remark']}',
                                          Color(0XFF111F37), 30.0, 4),
                                      SizedBox(
                                        height: Ui.width(20),
                                      ),
                                      Unit.text('${list[index]['addTime']}',
                                          Color(0XFF9fa2a8), 26.0, 4)
                                    ],
                                  ),
                                ),
                                Container(
                                    child: Unit.text(
                                        list[index]['points'] > 0
                                            ? '+${list[index]['points']}'
                                            : '${list[index]['points']}',
                                        Color(0XFF111F37),
                                        34.0,
                                        5)),
                              ],
                            ),
                          );
                        },
                      )
                    : Nofind(
                        text: "暂无数据哦～",
                      ))
            : Container(
                child: LoadingDialog(
                  text: "加载中...",
                ),
              ));
  }
}
