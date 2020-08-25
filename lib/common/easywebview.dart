import 'package:flutter/material.dart';
import '../ui/ui.dart';
import 'package:webview_flutter/webview_flutter.dart';
import './LoadingDialog.dart';
import '../page/config/config.dart';
class Easywebview extends StatefulWidget {
  final Map arguments;
  Easywebview({Key key, this.arguments}) : super(key: key);
  @override
  _EasywebviewState createState() => _EasywebviewState();
}

class _EasywebviewState extends State<Easywebview> {
  WebViewController _controller;
  bool isloading = false;
  
  @override
  Widget build(BuildContext context) {
    print('${Config.weblink}${widget.arguments['url']}');
    Ui.init(context);
    return Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
          ),
          preferredSize: Size.fromHeight(0),
        ),
        body: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              border: Border(
                  bottom:
                      BorderSide(color: Color(0XFFFFFFFF), width: Ui.width(0))),
            ),
            child:  Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: WebView(
                          initialUrl: '${Config.weblink}${widget.arguments['url']}', // 加载的url
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
                                onMessageReceived: (JavascriptMessage message) {
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
            )
      )
    );
  }
}
