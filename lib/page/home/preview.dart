import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/ui.dart';
import '../config/config.dart';
import '../../common/ShareBottomSheet.dart';
import '../../common/StoreImage.dart';

class Preview extends StatefulWidget {
  final Map arguments;
  Preview({Key key, this.arguments}) : super(key: key);
  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  @override
  void initState() {
    super.initState();
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
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ShareBottomSheet(
                                          type: 'image',
                                          imageurl:
                                              '${Config.url}third/poster/${widget.arguments['id']}/${widget.arguments['detail']['id']}',
                                          dataId: widget.arguments['id'],
                                          sharetype: 7,
                                        );
                                      });
                                },
                                child: Container(
                                  width: Ui.width(60),
                                  child: Text(
                                    '分享',
                                    style: TextStyle(
                                        color: Color(0XFFFFFFFF),
                                        fontSize: Ui.setFontSizeSetSp(28),
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Regular,PingFang SC'),
                                  ),
                                ),
                              )),
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
                              '海报预览',
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
            body: InkWell(
              onLongPress: () async {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext contexts) {
                      return StoreImage(
                        context: context,
                        imgUrl:
                            "${Config.url}third/poster/${widget.arguments['id']}/${widget.arguments['detail']['id']}",
                      );
                    });
              },
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          '${Config.url}third/poster/${widget.arguments['id']}/${widget.arguments['detail']['id']}'),
                      fit: BoxFit.fill,
                    ),
                  )),
            )));
  }
}
