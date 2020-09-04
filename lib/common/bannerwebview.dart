import 'package:flutter/material.dart';
import '../ui/ui.dart';
import 'package:webview_flutter/webview_flutter.dart';
import './LoadingDialog.dart';

class Bannerwebview extends StatefulWidget {
  final Map arguments;
  Bannerwebview({Key key, this.arguments}) : super(key: key);

  // Bannerwebview({Key key}) : super(key: key);

  @override
  _BannerwebviewState createState() => _BannerwebviewState();
}

class _BannerwebviewState extends State<Bannerwebview> {
  @override
  void initState() {

    super.initState();
    // print(widget.arguments['url'])
  }

  @override
  void dispose() {
    super.dispose();
  }

  WebViewController _controller;
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    Ui.init(context);
    return Scaffold(
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
                        '${widget.arguments['title']}',
                        style: TextStyle(
                            color: Color(0XFFFFFFFF),
                            fontSize: Ui.setFontSizeSetSp(36),
                            fontWeight: FontWeight.w500,
                            fontFamily:
                            'PingFangSC-Regular,PingFang SC'),
                      ),
                    )
                  ],
                ),
              )),
          preferredSize:
          Size(MediaQuery.of(context).size.width, Ui.width(90))),
//        appBar: AppBar(
//          title: Text(
//            '${widget.arguments['title']}',
//            style: TextStyle(
//                color: Color(0xFF111F37),
//                fontWeight: FontWeight.w500,
//                fontFamily: 'PingFangSC-Medium,PingFang SC',
//                fontSize: Ui.setFontSizeSetSp(36.0)),
//          ),
//          centerTitle: true,
//          elevation: 0,
//          brightness: Brightness.light,
//          leading: InkWell(
//            onTap: (){
//               Navigator.pop(context);
//            },
//            child: Container(
//              alignment: Alignment.center,
//              child: Image.asset('images/2.0x/back.png',width: Ui.width(21),height: Ui.width(37),),
//            ),
//          ),
//        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: WebView(
                      initialUrl: '${widget.arguments['url']}', // 加载的url
                      //JS执行模式 是否允许JS执行
                      javascriptMode: JavascriptMode.unrestricted,

                      onWebViewCreated: (controller) {
                        _controller = controller;
                      },
                      onPageFinished: (url) {

                        _controller.evaluateJavascript('').then((result) {
                          print('result');
                          setState(() {
                            isloading = true;
                          });
                        });
                      },
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
        ));
  }
}
