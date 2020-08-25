import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../ui/ui.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';
import './Unit.dart';
import 'package:toast/toast.dart';

class StoreImage extends StatefulWidget {
  final imgUrl;
  final context;
  StoreImage({this.imgUrl,this.context});

  @override
  _StoreImageState createState() => _StoreImageState();
}

class _StoreImageState extends State<StoreImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Ui.width(750),
      height: Ui.width(183),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
              onTap: () async {
                Navigator.pop(context);
                var response = await Dio().get("${widget.imgUrl}",
                    options: Options(responseType: ResponseType.bytes));
                var result = await ImageGallerySaver.saveImage(
                    Uint8List.fromList(response.data));
                if (Platform.isAndroid) {
                  result = result is String;
                }
                if (result) {
                   Unit.setToast('已保存系统相册', widget.context);
                } else {
                  Unit.setToast('保存失败', widget.context);
                }
              },
              child: Container(
                width: Ui.width(750),
                height: Ui.width(90),
                alignment: Alignment.center,
                child: Text(
                  '保存',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0XFF111F37),
                      fontSize: Ui.setFontSizeSetSp(32),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'PingFangSC-Regular,PingFang SC'),
                ),
              )),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: Ui.width(750),
                height: Ui.width(90),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            width: Ui.width(3), color: Color(0xffEAEAEA)))),
                child: Text(
                  '取消',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0XFF111F37),
                      fontSize: Ui.setFontSizeSetSp(32),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'PingFangSC-Regular,PingFang SC'),
                ),
              ))
        ],
      ),
    );
  }
}
