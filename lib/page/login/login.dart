import 'dart:async';
import 'dart:convert';
import '../../common/Storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/ui.dart';
import '../../common/Unit.dart';
import '../../http/index.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _text = '获取验证码';
  String mobile = '';
  bool check = false;
  String code = '';
  int active = 1;
  int _countdownNum = 180;
  Timer _countdownTimer;
  Timer timer;
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Unit.setAgent('broker');
  }

  getCode() async {
   await HttpUtlis.post("third/auth/captcha", params: {'mobile': mobile},
        success: (value) {
      if (value['errno'] == 0) {
        Unit.setToast("发送成功～", context);
        setState(() {
          if (_countdownTimer != null) {
            return;
          }
          // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
          _text = '${_countdownNum--}S 重新获取';
          _countdownTimer =
              new Timer.periodic(new Duration(seconds: 1), (timer) {
            setState(() {
              if (_countdownNum > 0) {
                _text = '${_countdownNum--}S 重新获取';
              } else {
                _text = '获取验证码';
                _countdownNum = 180;
                _countdownTimer.cancel();
                _countdownTimer = null;
              }
            });
          });
        });
      } else {
        Unit.setToast('发送失败～', context);
      }
    }, failure: (error) {
      Unit.setToast(error, context);
    });
  }

  submit() {
    if (!RegExp(r"^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$")
        .hasMatch(mobile)) {
      Unit.setToast("请输入正确的手机号码", context);
      return;
    }
    if (this.code == '') {
      Unit.setToast("请输入验证码", context);
      return;
    }
    if (!check) {
      Unit.setToast("请勾选协议", context);
      return;
    }
    print('dsdsdsdsdsd');
    HttpUtlis.post("third/auth/loginByMobile", params: {
      'mobile': mobile,
      'code': code,
      'type':active
    }, success: (value) async {
      if (value['errno'] == 0) {
        print(value['data']['user']);
        await Storage.setString('userInfo', json.encode(value['data']['user']));
        Storage.setString('token', value['data']['token']);
        Unit.setToast('登陆成功～', context);
        timer = new Timer(new Duration(seconds: 1), () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
        });
      }
    }, failure: (error) {
      Unit.setToast(error, context);
    });
  }

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
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Container(
                        //   width: Ui.width(750),
                        //   height: Ui.width(392),
                        //   margin: EdgeInsets.fromLTRB(0, Ui.width(60), 0, 0),
                        //   decoration: BoxDecoration(
                        //     image: DecorationImage(
                        //       image: AssetImage('images/2.0x/login.png'),
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ),
                        // ),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              Ui.width(65), 0, Ui.width(65), 0),
                          margin: EdgeInsets.fromLTRB(0, Ui.width(50), 0, 0),
                          width: Ui.width(750),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '欢迎登录营销端!',
                                style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'PingFangSC-Medium,PingFang SC',
                                    fontSize: Ui.setFontSizeSetSp(62.0)),
                              ),
                              Text(
                                'Welcome to the marketing end...',
                                style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Helvetica',
                                    fontSize: Ui.setFontSizeSetSp(26.0)),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.fromLTRB(0, Ui.width(70), 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: Ui.width(50),
                              ),
                              InkWell(
                                onTap: () {
                                  Unit.setAgent('broker');
                                  setState(() {
                                    active = 1;
                                  });
                                },
                                child: Container(
                                  width: Ui.width(341),
                                  height: Ui.width(341),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: Ui.width(300),
                                          height: Ui.width(300),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(active == 1
                                                  ? 'images/2.0x/broker.png'
                                                  : 'images/2.0x/brokerselect.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: active == 1
                                            ? Container(
                                                width: Ui.width(82),
                                                height: Ui.width(82),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'images/2.0x/selectlogin.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : Text(''),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Unit.setAgent('agent');
                                  setState(() {
                                    active = 2;
                                  });
                                },
                                child: Container(
                                  width: Ui.width(341),
                                  height: Ui.width(341),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: Ui.width(300),
                                          height: Ui.width(300),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(active == 2
                                                  ? 'images/2.0x/agentselect.png'
                                                  : 'images/2.0x/agent.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: active == 2
                                              ? Container(
                                                  width: Ui.width(82),
                                                  height: Ui.width(82),
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'images/2.0x/selectlogin.png'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              : Text(''))
                                    ],
                                  ),
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
                                          fontSize: Ui.setFontSizeSetSp(28.0))),
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
                              Ui.height(50.0), Ui.width(65.0), 0),
                          // padding: EdgeInsets.fromLTRB(0, 0, 0, Ui.width(15.0)),
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
                              Image.asset('images/2.0x/mobile.png',
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
                                      hintText: '验证码',
                                      hintStyle: TextStyle(
                                          color: Color(0xFFC4C9D3),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Helvetica',
                                          fontSize: Ui.setFontSizeSetSp(28.0))),
                                  onChanged: (value) {
                                    setState(() {
                                      code = value;
                                    });
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (!RegExp(
                                          r"^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$")
                                      .hasMatch(mobile)) {
                                    Unit.setToast("请输入正确的手机号码", context);
                                    return;
                                  }
                                  getCode();
                                },
                                child: Container(
                                  // padding: EdgeInsets.fromLTRB(0, Ui.width(20), 0, 0),
                                  child: Text('${_text}',
                                      style: TextStyle(
                                          color: Color(0xFF397AF8),
                                          fontSize: Ui.setFontSizeSetSp(32),
                                          fontFamily:
                                              'PingFangSC-Regular,PingFang SC')),
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
                                  Navigator.pushNamed(context, '/easywebview',
                                      arguments: {'url': 'apprlue'});
                                },
                                child: Text(
                                  '我已阅读《用户协议》',
                                  style: TextStyle(
                                      color: Color(0XFFC4C9D3),
                                      fontSize: Ui.setFontSizeSetSp(26),
                                      fontWeight: FontWeight.w400,
                                      fontFamily:
                                          'PingFangSC-Regular,PingFang SC;'),
                                ),
                              ),
                              // SizedBox(
                              //   width: Ui.width(100),
                              // ),
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.pushNamed(context, '/register');
                              //   },
                              //   child: Text(
                              //     '注册',
                              //     style: TextStyle(
                              //         color: Color(0XFF397AF8),
                              //         fontSize: Ui.setFontSizeSetSp(32),
                              //         fontWeight: FontWeight.w400,
                              //         fontFamily:
                              //             'PingFangSC-Regular,PingFang SC;'),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            submit();
                          },
                          child: Container(
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
                        )
                      ],
                    ),
                  )),
                ))));
  }
}
