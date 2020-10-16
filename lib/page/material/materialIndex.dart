import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:tuangechezs/common/Nofind.dart';
import 'package:tuangechezs/common/ShareBottomSheet.dart';
import 'package:tuangechezs/common/StoreImage.dart';
import 'package:tuangechezs/common/Unit.dart';
import 'package:tuangechezs/page/material/ExpandableText.dart';
import 'package:tuangechezs/ui/ui.dart';

class MaterialIndex extends StatefulWidget {
  MaterialIndex({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MaterialIndexState();
}

class _MaterialIndexState extends State<MaterialIndex> {
  List list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMaterialData();
  }

  getMaterialData() async {
    List list = [];
    list.add(1);
    list.add(2);
    list.add(3);
    setState(() {
      this.list.addAll(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    Ui.init(context);

    return Scaffold(
        appBar: PreferredSize(
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF5BBEFF),
                    Color(0xFF466EFF),
                  ],
                ),
              ),
              child: Container(
                  height: Ui.width(90),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color(0xFF5BBEFF),
                    Color(0xFF466EFF),
                  ])),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      '素材库',
                      style: TextStyle(
                        color: Color(0xffffffff),
                        fontSize: Ui.setFontSizeSetSp(36),
                      ),
                    ),
                  )),
            ),
            preferredSize: Size(MediaQuery.of(context).size.width, 90)),
        body: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Container(
                width: Ui.width(750),
                padding: EdgeInsets.fromLTRB(0, Ui.width(90), 0, 0),
                child: list.length > 0
                    ? ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: Ui.width(750),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: Ui.width(750),
                                  height: Ui.width(100),
                                  padding: EdgeInsets.fromLTRB(Ui.width(30),
                                      Ui.width(30), Ui.width(30), 0),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Positioned(
                                        top: Ui.width(5),
                                        left: Ui.width(0),
                                        child: Container(
                                          width: Ui.width(62),
                                          height: Ui.width(62),
                                          color: Color(0xFFD8D8D8),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl: '',
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: Ui.width(75),
                                        top: Ui.width(0),
                                        child: Text(
                                          '团个车',
                                          style: TextStyle( color: Color(0xFF111F37),
                                              fontSize: Ui.setFontSizeSetSp(28)),
                                        ),
                                      ),
                                      Positioned(
                                        bottom:Ui.width(0),
                                        left: Ui.width(75),
                                        child: Text(
                                          '2020.09.15 12:27',
                                          style: TextStyle( color: Color(0xFFC4C9D3),
                                              fontSize: Ui.setFontSizeSetSp(24)),
                                        ),
                                      ),
                                      Positioned(
                                        right:Ui.width(0),
                                        top: Ui.width(0),
                                        child: Text(
                                          '热度：1002',
                                          style: TextStyle( color: Color(0xFF111F37),
                                              fontSize: Ui.setFontSizeSetSp(24)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(Ui.width(30),
                                      Ui.width(30), Ui.width(30), 0),
                                  child:  ExpandableText(
                                    '这4个驾驶习惯最费油，超过3个，开什么车都是油老虎这4个驾驶习惯最费油，超过3个，开什么车都是油老虎,这4个驾驶习惯最费油，超过3个，开什么车都是油老虎这4个驾驶习惯最费油，超过3个，开什么车都是油老虎',
                                    style: TextStyle(
                                        color: Color(0xFF111F37),
                                        fontSize: Ui.setFontSizeSetSp(32)),
                                    expandText: '全文',
                                    collapseText: '收起',
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(Ui.width(30),
                                      Ui.width(30), Ui.width(30), 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: Ui.width(222),
                                        height: Ui.width(222),
                                        color: Color(0xFFD8D8D8),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: '',
                                        ),
                                      ),
                                      SizedBox(width:Ui.width(12)),
                                      Container(
                                        width: Ui.width(222),
                                        height: Ui.width(222),
                                        color: Color(0xFFD8D8D8),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: '',
                                        ),
                                      ),
                                      SizedBox(width:Ui.width(12)),
                                      Container(
                                        width: Ui.width(222),
                                        height: Ui.width(222),
                                        color: Color(0xFFD8D8D8),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: '',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ShareBottomSheet(
                                                type: 'image',
                                                sharetype: 8,
//                                                imageurl: widget.arguments['imgurl'],
//                                                dataId: widget.arguments['id'],
                                              );
                                            });
                                      },
                                      child: Container(
                                        width: Ui.width(200),
                                        height: Ui.width(90),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              'images/2.0x/forward.png',
                                              width: Ui.width(35),
                                              height: Ui.width(35),
                                            ),
                                            SizedBox(
                                              width: Ui.width(17),
                                            ),
                                            Text(
                                              '转发',
                                              style: TextStyle(
                                                  color: Color(0xFF5E6578),
                                                  fontSize: Ui.setFontSizeSetSp(30),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                            ),


                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
//                                        var response = await Dio().get("${list[index]}",
//                                            options: Options(responseType: ResponseType.bytes));
//                                        var result = await ImageGallerySaver.saveImage(
//                                            Uint8List.fromList(response.data));
//                                        if (Platform.isAndroid) {
//                                          result = result is String;
//                                        }
//                                        if (result) {
//                                          Unit.setToast('已保存系统相册', context);
//                                        } else {
//                                          Unit.setToast('保存失败', context);
//                                        }
                                      },
                                      child: Container(
                                        width: Ui.width(200),
                                        height: Ui.width(90),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              'images/2.0x/download.png',
                                              width: Ui.width(35),
                                              height: Ui.width(35),
                                            ),
                                            SizedBox(
                                              width: Ui.width(17),
                                            ),
                                            Text(
                                              '下载素材',
                                              style: TextStyle(
                                                  color: Color(0xFF5E6578),
                                                  fontSize: Ui.setFontSizeSetSp(30),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(text: '复制到剪切板'));
                                        Unit.setToast('复制成功！', context);
                                      },
                                      child: Container(
                                        width: Ui.width(200),
                                        height: Ui.width(90),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              'images/2.0x/icon_copy.png',
                                              width: Ui.width(35),
                                              height: Ui.width(35),
                                            ),
                                            SizedBox(
                                              width: Ui.width(17),
                                            ),
                                            Text(
                                              '复制文案',
                                              style: TextStyle(
                                                  color: Color(0xFF5E6578),
                                                  fontSize: Ui.setFontSizeSetSp(30),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                  'PingFangSC-Regular,PingFang SC'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Offstage(
                                  offstage: index == list.length-1,
                                  child:Container(
                                    height: Ui.width(30),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEEF3f9),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Nofind(
                        text: '暂无素材~',
                      ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white,boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0xFFe9ECF1)
                    )
                  ]

                  ),
                  width: Ui.width(750),
                  height: Ui.width(90),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {},
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '发布时间',
                                style: TextStyle(
                                    color: Color(0xFF5E6578),
                                    fontSize: Ui.setFontSizeSetSp(30),
                                    fontWeight: FontWeight.w400,
                                    fontFamily:
                                        'PingFangSC-Regular,PingFang SC'),
                              ),
                              SizedBox(
                                width: Ui.width(17),
                              ),
                              Image.asset(
                                'images/2.0x/arrow_down.png',
                                width: Ui.width(15),
                                height: Ui.width(28),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '素材类型',
                              style: TextStyle(
                                  color: Color(0xFF5E6578),
                                  fontSize: Ui.setFontSizeSetSp(30),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'PingFangSC-Regular,PingFang SC'),
                            ),
                            SizedBox(
                              width: Ui.width(17),
                            ),
                            Image.asset(
                              'images/2.0x/arrow_down.png',
                              width: Ui.width(15),
                              height: Ui.width(28),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
