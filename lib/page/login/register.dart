import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/ui.dart';
import 'package:toast/toast.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _text = '获取验证码';
  String mobile = '';
  bool check = false;
  @override
  Widget build(BuildContext context) {
    Ui.init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
                appBar: PreferredSize(
                    child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).padding.top,
                      child: SafeArea(child: Text("")),
                    ),
                    preferredSize: Size(0, 0)),
                body: Container(
                    color: Colors.white,
                    height: double.infinity,
                    width: double.infinity,
                    child: SingleChildScrollView(
                        child: Container(
                      width: double.infinity,
                      // height: double.infinity,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: Ui.width(750),
                            height: Ui.width(392),
                            margin: EdgeInsets.fromLTRB(0, Ui.width(60), 0, 0),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/2.0x/login.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(Ui.width(65.0),
                                Ui.height(30.0), Ui.width(65.0), 0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Color(0XFFF1F1F1), width: 1.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset('images/2.0x/name.png',
                                    width: Ui.width(35.0),
                                    height: Ui.height(37.0)),
                                SizedBox(
                                  width: Ui.width(20.0),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    autofocus: false,
                                    // textInputAction: TextInputAction.none,
                                    keyboardAppearance: Brightness.light,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        color: Color(0XFF111F37),
                                        fontWeight: FontWeight.w400,
                                        fontSize: Ui.setFontSizeSetSp(32)),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '姓名',
                                        hintStyle: TextStyle(
                                            color: Color(0xFFC4C9D3),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Helvetica',
                                            fontSize:
                                                Ui.setFontSizeSetSp(28.0))),
                                    onChanged: (value) {
                                      mobile = value;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(Ui.width(65.0),
                                Ui.height(30.0), Ui.width(65.0), 0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Color(0XFFF1F1F1), width: 1.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset('images/2.0x/phone.png',
                                    width: Ui.width(26.0),
                                    height: Ui.height(40.0)),
                                SizedBox(
                                  width: Ui.width(20.0),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    autofocus: false,
                                    // textInputAction: TextInputAction.none,
                                    keyboardAppearance: Brightness.light,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                        color: Color(0XFF111F37),
                                        fontWeight: FontWeight.w400,
                                        fontSize: Ui.setFontSizeSetSp(32)),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '手机号',
                                        hintStyle: TextStyle(
                                            color: Color(0xFFC4C9D3),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Helvetica',
                                            fontSize:
                                                Ui.setFontSizeSetSp(28.0))),
                                    onChanged: (value) {
                                      mobile = value;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(Ui.width(65.0),
                                Ui.height(30.0), Ui.width(65.0), 0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Color(0XFFF1F1F1), width: 1.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset('images/2.0x/idcard.png',
                                    width: Ui.width(38.0),
                                    height: Ui.height(30.0)),
                                SizedBox(
                                  width: Ui.width(20.0),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    autofocus: false,
                                    // textInputAction: TextInputAction.none,
                                    keyboardAppearance: Brightness.light,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        color: Color(0XFF111F37),
                                        fontWeight: FontWeight.w400,
                                        fontSize: Ui.setFontSizeSetSp(32)),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '身份证',
                                        hintStyle: TextStyle(
                                            color: Color(0xFFC4C9D3),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Helvetica',
                                            fontSize:
                                                Ui.setFontSizeSetSp(28.0))),
                                    onChanged: (value) {
                                      mobile = value;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(Ui.width(95),
                                Ui.width(70), Ui.width(65), Ui.width(25)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      check = !check;
                                    });
                                  },
                                  child: Container(
                                    width: Ui.width(30),
                                    height: Ui.width(30),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: check
                                            ? AssetImage(
                                                'images/2.0x/agreementselect.png')
                                            : AssetImage(
                                                'images/2.0x/agreement.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Ui.width(10),
                                ),
                                InkWell(
                                  onTap: () {
                                    // Navigator.pushNamed(context, '/easywebview',
                                    //     arguments: {'url': 'apprlue'});
                                  },
                                  child: Text(
                                    '我已阅读《注册协议》',
                                    style: TextStyle(
                                        color: Color(0XFFC4C9D3),
                                        fontSize: Ui.setFontSizeSetSp(26),
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Regular,PingFang SC;'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(
                                  Ui.width(65), Ui.width(16), 0, 0),
                              width: Ui.width(630),
                              height: Ui.height(90),
                              decoration: BoxDecoration(
                                color: Color(0XFF33AAF5),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Ui.width(90.0))),
                              ),
                              child: Center(
                                child: Text(
                                  '登陆',
                                  style: TextStyle(
                                      color: Color(0XFFFFFFFF),
                                      fontSize: Ui.setFontSizeSetSp(32),
                                      fontWeight: FontWeight.w400,
                                      fontFamily:
                                          'PingFangSC-Regular,PingFang SC'),
                                ),
                              )),
                        ],
                      ),
                    ))))));
  }
}
