import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ui/ui.dart';
import 'package:webview_flutter/webview_flutter.dart';
import './LoadingDialog.dart';
import '../page/config/config.dart';
import './ShareBottomSheet.dart';
class Driedwebview extends StatefulWidget {
  final Map arguments;
  Driedwebview({Key key, this.arguments}) : super(key: key);
  @override
  _DriedwebviewState createState() => _DriedwebviewState();
}

class _DriedwebviewState extends State<Driedwebview> {
  WebViewController _controller;
  bool isloading = false;
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
                        Positioned(
                          right: Ui.width(30),
                          top: Ui.width(20),
                          child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ShareBottomSheet(
                                        type: 'h5',
                                        h5Url: '${Config.weblink}appdried/${widget.arguments['id']}',
                                        openApp:true,
                                        title:'${widget.arguments['tag']}',
                                        description:'${widget.arguments['title']}',
                                        sharetype:4,
                                        dataId: widget.arguments['id'],
                                      );
                                    });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Image.asset('images/2.0x/share.png',
                                    width: Ui.width(42), height: Ui.width(42)),
                              )),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '软文详情',
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
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                border: Border(
                    bottom: BorderSide(
                        color: Color(0XFFFFFFFF), width: Ui.width(0))),
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: WebView(
                            initialUrl:
                                '${Config.weblink}appdried/${widget.arguments['id']}/1', // 加载的url
                            //JS执行模式 是否允许JS执行
                            javascriptMode: JavascriptMode.unrestricted,

                            onWebViewCreated: (controller) {
                              _controller = controller;
                            },
                            onPageFinished: (url) {
                              _controller.evaluateJavascript('').then((result) {
                                setState(() {
                                  isloading = true;
                                });
                              });
                            },
                            javascriptChannels: <JavascriptChannel>[
                              //js 调用flutter
                              JavascriptChannel(
                                  name: "back",
                                  onMessageReceived:
                                      (JavascriptMessage message) {
                                    // print("参数： ${message.message}");
                                    Navigator.pop(context);
                                  }),
                            ].toSet(),
                          ))
                    ],
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      child: isloading
                          ? null
                          : Container(
                              height: MediaQuery.of(context).size.height,
                              width: Ui.width(750),
                              decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Color(0XFFFFFFFF), width: 0.0),
                                    bottom: BorderSide(
                                        color: Color(0XFFFFFFFF), width: 0.0)),
                              ),
                              child: LoadingDialog(
                                text: "加载中…",
                              ),
                            ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
