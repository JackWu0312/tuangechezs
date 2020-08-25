import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuangechezs/common/Storage.dart';
import '../../ui/ui.dart';
import '../../common/CommonBottomSheet.dart';
import 'package:image_picker/image_picker.dart';
import '../../http/index.dart';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../../provider/Orderback.dart';
import '../config/config.dart';
import '../../common/Unit.dart';

class My extends StatefulWidget {
  My({Key key}) : super(key: key);

  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<My> {
  String qrcode = '';
  int isAgent = 1;
  var userinfo;
  var user;
  var imgurl;

  getToken() async {
    try {
      String token = await Storage.getString('token');
      return token;
    } catch (e) {
      return '';
    }
  }

  Dio _dio;
  BaseOptions _options;

  getoption() async {
    _options =
        new BaseOptions(connectTimeout: 50000, receiveTimeout: 3000, headers: {
      'Content-Type': 'multipart/form-data',
      'Third-Auth-Token': await getToken(),
      // 'Wechat-Auth-Token':'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTE4OTc4NTk2NDMyNTUyMzQ1OCwiaWF0IjoxNTczNzg5MDAzLCJwbGF0Zm9ybSI6M30.mBum3vEkVb1n_Rbt_OhDgPvYgksv_e0kYUaabcBQFgc'
    });
  }

  Dio buildDio() {
    _dio = new Dio(_options);

    return _dio;
  }

  uploadData(imageFile) async {
    String path = imageFile.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(path, filename: name),
    });
    await getoption();
    Dio dio = buildDio();
    var response =
        await dio.post("${Config.url}third/user/avatar/upload", data: formData);
    if (response.data['errno'] == 0) {
      await Storage.setString('userInfo', json.encode(response.data['data']));
      // print(response.data['data']);
      setState(() {
        imgurl = response.data['data']['avatar'];
      });
      Unit.setToast('上传成功～', context);
    } else {
      Unit.setToast('${response.data['errmsg']}', context);
    }
  }

  @override
  void initState() {
    super.initState();
    // init();
    getisAgent();
    getData();
  }

  // init() async {
  //   await getUserdetail();
  //   await getUserdetailhome();
  // }

  // getUserdetail() async {
  //   var userinfos = await getUser();
  //   if (userinfos != null) {
  //     setState(() {
  //       userinfo = json.decode(userinfos);
  //       imgurl = userinfo['avatar'];
  //       qrcode = '${Config.url}third/user/qrcode/${userinfo['id']}';
  //     });
  //   } else {
  //     setState(() {
  //       userinfo = null;
  //     });
  //   }
  // }

  // getUser() async {
  //   try {
  //     String token = await Storage.getString('userInfo');
  //     return token;
  //   } catch (e) {
  //     return '';
  //   }
  // }

  // getUserdetailhome() async {
  //   var users = await getUserhome();
  //   if (users != null) {
  //     setState(() {
  //       user = json.decode(users);
  //     });
  //   } else {
  //     setState(() {
  //       user = null;
  //     });
  //   }
  // }

  // getUserhome() async {
  //   try {
  //     String token = await Storage.getString('userinfohome');
  //     return token;
  //   } catch (e) {
  //     return '';
  //   }
  // }

  getisAgent() async {
    if (await Unit.isAgent() == 'broker') {
      setState(() {
        isAgent = 1;
      });
    } else {
      setState(() {
        isAgent = 2;
      });
    }
  }
  var data;
 getData() async {
    await HttpUtlis.get('third/user/info', success: (value) async {
      if (value['errno'] == 0) {
        setState(() {
          data = value['data'];
          imgurl = value['data']['avatar'];
          qrcode='${Config.url}third/user/qrcode/${data['id']}';
        });
        await Storage.setString('userInfo', json.encode(value['data']));
      }
    }, failure: (error) {
      Unit.setToast('${error}', context);
    });
  }
  @override
  Widget build(BuildContext context) {
     final counter = Provider.of<Orderback>(context);
    if (counter.count) {
      getData();
      Future.delayed(Duration(milliseconds: 200)).then((e) {
        counter.increment(false);
      });
    }
    Ui.init(context);
    showtosh() {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Center(
              child: Container(
                  width: Ui.width(600),
                  height: Ui.width(300),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.all(Radius.circular(Ui.width(20.0))),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: Ui.width(600),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: Ui.width(30),
                            ),
                            Text('温馨提示',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Color(0xFF111F37),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'PingFangSC-Medium,PingFang SC',
                                    fontSize: Ui.setFontSizeSetSp(36.0))),
                            SizedBox(
                              height: Ui.width(40),
                            ),
                            Text('确定是否退出登录～',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Color(0xFF111F37),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'PingFangSC-Medium,PingFang SC',
                                    fontSize: Ui.setFontSizeSetSp(30.0))),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: Ui.width(600),
                          height: Ui.width(92),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      child: Text('取消',
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              color: Color(0xFF3895FF),
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'PingFangSC-Medium,PingFang SC',
                                              fontSize:
                                                  Ui.setFontSizeSetSp(36.0))),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            width: Ui.width(2),
                                            color: Color(0xffEAEAEA)),
                                        right: BorderSide(
                                            width: Ui.width(2),
                                            color: Color(0xffEAEAEA))),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                      onTap: () {
                                        Storage.remove('token');
                            Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        alignment: Alignment.center,
                                        child: Text('确定',
                                            style: TextStyle(
                                                decoration: TextDecoration.none,
                                                color: Color(0xFF3895FF),
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    'PingFangSC-Medium,PingFang SC',
                                                fontSize:
                                                    Ui.setFontSizeSetSp(36.0))),
                                      )),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            width: Ui.width(2),
                                            color: Color(0xffEAEAEA))),
                                  ),
                                ),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(Ui.width(20))),
                          ),
                        ),
                      )
                    ],
                  )),
            );
          });
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          appBar: PreferredSize(
              child: Container(
                height: Ui.height(0),
              ),
              preferredSize: Size(0, 0)),
          body: Container(
            color: Color(0xFFFBFCFF),
            child: ListView(
              children: <Widget>[
                Container(
                  width: Ui.width(750),
                  height: Ui.width(300),
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
                          bottom: Ui.width(40),
                          left: Ui.width(30),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  barrierDismissible:
                                      true, //是否点击空白区域关闭对话框,默认为true，可以关闭
                                  context: context,
                                  builder: (BuildContext context) {
                                    var list = List();
                                    list.add('拍照');
                                    list.add('从相册选择');
                                    return CommonBottomSheet(
                                      list: list,
                                      onItemClickListener: (index) async {
                                        var image;
                                        if (index == 0) {
                                          image = await ImagePicker.pickImage(
                                              source: ImageSource.camera);
                                        } else {
                                          image = await ImagePicker.pickImage(
                                              source: ImageSource.gallery);
                                        }
                                        if (image != null) {
                                          uploadData(image);
                                        }
                                        Navigator.pop(context);
                                      },
                                    );
                                  });
                            },
                            child: Container(
                              width: Ui.width(150),
                              height: Ui.width(150),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Ui.width(90.0))),
                              ),
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: imgurl == null||imgurl==''
                                    ? Image.asset('images/2.0x/myicon.png')
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(90.0),
                                        child: Image.network(
                                          '${imgurl}',
                                          fit: BoxFit.cover,
                                          width: Ui.width(120),
                                          height: Ui.width(120),
                                        ),
                                      ),
                              ),
                            ),
                          )),
                      Positioned(
                        bottom: Ui.width(90),
                        left: Ui.width(210),
                        child: Container(
                          child: Text(
                            data == null ? '' : '${data['name']}',
                            style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'PingFangSC-Medium,PingFang SC',
                                fontSize: Ui.setFontSizeSetSp(32.0)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/authentication');
                  },
                  child: Container(
                    width: Ui.width(750),
                    height: Ui.width(130),
                    padding:
                        EdgeInsets.fromLTRB(Ui.width(30), 0, Ui.width(50), 0),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Color(0XFFEEF3F9),
                        offset: Offset(1, 0),
                        blurRadius: Ui.width(20.0),
                      ),
                    ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '我的认证',
                          style: TextStyle(
                              color: Color(0XFF111F37),
                              fontSize: Ui.setFontSizeSetSp(32),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'PingFangSC-Regular,PingFang SC'),
                        ),
                        Image.asset(
                          'images/2.0x/rightmore.png',
                          width: Ui.width(15),
                          height: Ui.width(28),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/settlement');
                  },
                  child: Container(
                    width: Ui.width(750),
                    height: Ui.width(130),
                    margin: EdgeInsets.fromLTRB(0, Ui.width(20), 0, 0),
                    padding:
                        EdgeInsets.fromLTRB(Ui.width(30), 0, Ui.width(50), 0),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Color(0XFFEEF3F9),
                        offset: Offset(1, 0),
                        blurRadius: Ui.width(20.0),
                      ),
                    ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '我的结算',
                          style: TextStyle(
                              color: Color(0XFF111F37),
                              fontSize: Ui.setFontSizeSetSp(32),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'PingFangSC-Regular,PingFang SC'),
                        ),
                        Image.asset(
                          'images/2.0x/rightmore.png',
                          width: Ui.width(15),
                          height: Ui.width(28),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (isAgent == 1) {
                      Navigator.pushNamed(context, '/broker');
                    } else {
                      Navigator.pushNamed(context, '/agent');
                    }
                  },
                  child: Container(
                    width: Ui.width(750),
                    height: Ui.width(130),
                    margin: EdgeInsets.fromLTRB(0, Ui.width(20), 0, 0),
                    padding:
                        EdgeInsets.fromLTRB(Ui.width(30), 0, Ui.width(50), 0),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Color(0XFFEEF3F9),
                        offset: Offset(1, 0),
                        blurRadius: Ui.width(20.0),
                      ),
                    ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '水印管理',
                          style: TextStyle(
                              color: Color(0XFF111F37),
                              fontSize: Ui.setFontSizeSetSp(32),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'PingFangSC-Regular,PingFang SC'),
                        ),
                        Image.asset(
                          'images/2.0x/rightmore.png',
                          width: Ui.width(15),
                          height: Ui.width(28),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/qrcode',
                        arguments: {'imgurl': qrcode, 'user': data,'id':data['id']});
                  },
                  child: Container(
                    width: Ui.width(750),
                    height: Ui.width(130),
                    margin: EdgeInsets.fromLTRB(0, Ui.width(20), 0, 0),
                    padding:
                        EdgeInsets.fromLTRB(Ui.width(30), 0, Ui.width(50), 0),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Color(0XFFEEF3F9),
                        offset: Offset(1, 0),
                        blurRadius: Ui.width(20.0),
                      ),
                    ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '我的二维码',
                          style: TextStyle(
                              color: Color(0XFF111F37),
                              fontSize: Ui.setFontSizeSetSp(32),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'PingFangSC-Regular,PingFang SC'),
                        ),
                        Image.asset(
                          'images/2.0x/rightmore.png',
                          width: Ui.width(15),
                          height: Ui.width(28),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showtosh();
                   
                    // Navigator.popAndPushNamed(context, '/login');
                  },
                  child: Container(
                    width: Ui.width(750),
                    height: Ui.width(130),
                    margin: EdgeInsets.fromLTRB(0, Ui.width(20), 0, 0),
                    padding:
                        EdgeInsets.fromLTRB(Ui.width(30), 0, Ui.width(50), 0),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Color(0XFFEEF3F9),
                        offset: Offset(1, 0),
                        blurRadius: Ui.width(20.0),
                      ),
                    ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '退出登陆',
                          style: TextStyle(
                              color: Color(0XFF111F37),
                              fontSize: Ui.setFontSizeSetSp(32),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'PingFangSC-Regular,PingFang SC'),
                        ),
                        Image.asset(
                          'images/2.0x/rightmore.png',
                          width: Ui.width(15),
                          height: Ui.width(28),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
