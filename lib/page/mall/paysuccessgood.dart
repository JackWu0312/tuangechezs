import 'package:flutter/material.dart';
import '../../ui/ui.dart';

class Paysuccessgood extends StatefulWidget {
  final Map arguments;
  Paysuccessgood({Key key, this.arguments}) : super(key: key);
  @override
  _PaysuccessgoodState createState() => _PaysuccessgoodState();
}

class _PaysuccessgoodState extends State<Paysuccessgood> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.arguments['goods']);
    // print(widget.arguments['goods']=='goods');
  }

  @override
  Widget build(BuildContext context) {
    Ui.init(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
            '支付订单',
            style: TextStyle(
                color: Color(0xFF111F37),
                fontWeight: FontWeight.w500,
                fontFamily: 'PingFangSC-Medium,PingFang SC',
                fontSize: Ui.setFontSizeSetSp(36.0)),
          ),
          centerTitle: true,
          elevation: 0,
          brightness: Brightness.light,
          leading: Text('')),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, Ui.width(105), 0, Ui.width(65)),
              child: Image.asset(
                'images/2.0x/payuccess.png',
                width: Ui.width(280),
                height: Ui.width(280),
              ),
            ),
            Text(
              '恭喜您',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF111F37),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'PingFangSC-Medium,PingFang SC',
                  fontSize: Ui.setFontSizeSetSp(40.0)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, Ui.width(10), 0, Ui.width(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '订单支付成功 ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF111F37),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'PingFangSC-Medium,PingFang SC',
                        fontSize: Ui.setFontSizeSetSp(32.0)),
                  ),
                  Text(
                 widget.arguments['goods']=='goods'?'': '${widget.arguments['data']['order']['integralPrice']}积分+${widget.arguments['data']['order']['actualPrice']}元',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFFD10123),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'PingFangSC-Medium,PingFang SC',
                        fontSize: Ui.setFontSizeSetSp(32.0)),
                  ),
                ],
              ),
            ),
            Text(
              '48小时内商家按订单地址发货，请您手机保持畅通！',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF9398A5),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'PingFangSC-Medium,PingFang SC',
                  fontSize: Ui.setFontSizeSetSp(26.0)),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  Ui.width(80), Ui.width(90), Ui.width(80), 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/listorder');
                    },
                    child: Container(
                      width: Ui.width(280),
                      height: Ui.width(84),
                      alignment: Alignment.center,
                      child: Text(
                        '查看订单',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF111F37),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'PingFangSC-Medium,PingFang SC',
                            fontSize: Ui.setFontSizeSetSp(32.0)),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Ui.width(10)),
                          border: Border.all(
                              color: Color(0xFF111F37), width: Ui.width(1))),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    child: Container(
                      width: Ui.width(280),
                      height: Ui.width(84),
                      alignment: Alignment.center,
                      child: Text(
                        '继续逛逛',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFFD10123),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'PingFangSC-Medium,PingFang SC',
                            fontSize: Ui.setFontSizeSetSp(32.0)),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Ui.width(10)),
                          border: Border.all(
                              color: Color(0xFFD10123), width: Ui.width(1))),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
