import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../http/index.dart';
import '../../ui/ui.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import '../../provider/Addreslist.dart';

// /Users/wudi/Desktop/code/flutter_tuangeche/ios/.symlinks/plugins/city_pickers/android/build.gradle
// /Users/wudi/Desktop/code/flutter_tuangeche/ios/.symlinks/plugins/city_pickers/example/android/app/build.gradle
class Adresseditor extends StatefulWidget {
  final Map arguments;

  Adresseditor({Key key, this.arguments}) : super(key: key);

  @override
  _AdresseditorState createState() => _AdresseditorState();
}

class _AdresseditorState extends State<Adresseditor> {
  var _initNameController = new TextEditingController();
  var _initDetailController = new TextEditingController();
  var _initTelController = new TextEditingController();
  bool defaulted = false;
  String name = '';
  String province = '';
  String city = '';
  String county = '';
  String town = '';
  String detail = '';
  String tel = '';
  String id = '';
  Timer timer;

  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await HttpUtlis.get('third/address/${widget.arguments['id']}',
        success: (value) {
      if (value['errno'] == 0) {
        setState(() {
          id = value['data']['id'];
          name = value['data']['name'];
          province = value['data']['province'];
          city = value['data']['city'];
          county = value['data']['county'];
          town = value['data']['town'];
          detail = value['data']['detail'];
          tel = value['data']['tel'];
          defaulted = value['data']['defaulted'];
        });
        this._initNameController.text = value['data']['name'];
        ;
        this._initDetailController.text = value['data']['detail'];
        this._initTelController.text = value['data']['tel'];
      }
    }, failure: (error) {
      Toast.show('${error}', context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    });
  }

  del() {
    HttpUtlis.post("third/address/delete/${this.id}", params: {},
        success: (value) async {
      if (value['errno'] == 0) {
        Toast.show('删除成功～', context,
            backgroundColor: Color(0xff5b5956),
            backgroundRadius: Ui.width(16),
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
        final counter = Provider.of<Addreslist>(context);
        counter.increment(true);
        timer = new Timer(new Duration(seconds: 1), () {
          Navigator.pop(context);
        });
        // Navigator.pop(context);
      }
    }, failure: (error) {
      Toast.show('${error}', context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    });
  }

  submit() {
    if (this.province == '') {
      Toast.show("请选择省", context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
      return;
    }
    if (this.city == '') {
      Toast.show("请选择市", context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
      return;
    }
    if (this.county == '') {
      Toast.show("请选择县/区", context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
      return;
    }
    if (this.detail == '') {
      Toast.show("请填写详细地址", context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
      return;
    }
    if (this.name == '') {
      Toast.show("请填写收货人姓名", context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
      return;
    }

    if (!RegExp(r"^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$")
        .hasMatch(tel)) {
      Toast.show("请输入正确的手机号码", context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
      return;
    }
    HttpUtlis.post("third/address/save", params: {
      'id': this.id,
      "name": this.name,
      "province": this.province,
      "city": this.city,
      "county": this.county,
      "town": this.town,
      "detail": this.detail,
      "tel": this.tel,
      "defaulted": this.defaulted
    }, success: (value) async {
      if (value['errno'] == 0) {
        Toast.show('编辑成功～', context,
            backgroundColor: Color(0xff5b5956),
            backgroundRadius: Ui.width(16),
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
        final counter = Provider.of<Addreslist>(context);
        counter.increment(true);
        timer = new Timer(new Duration(seconds: 1), () {
          Navigator.pop(context);
        });
        // Navigator.pop(context);
      }
    }, failure: (error) {
      Toast.show('${error}', context,
          backgroundColor: Color(0xff5b5956),
          backgroundRadius: Ui.width(16),
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    });
  }

  @override
  Widget build(BuildContext context) {
    Ui.init(context);
    return Container(
        color: Colors.white,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
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
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                '编辑收货地址',
                                style: TextStyle(
                                    color: Color(0XFFFFFFFF),
                                    fontSize: Ui.setFontSizeSetSp(36),
                                    fontWeight: FontWeight.w500,
                                    fontFamily:
                                    'PingFangSC-Regular,PingFang SC'),
                              ),
                            ),
                            Positioned(
                                left: Ui.width(650),
                                top: Ui.width(20),
                                child: InkWell(
                                    onTap: (){
                                      del();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.fromLTRB(0, 0, Ui.width(40), 0),
                                      child: Text(
                                        '删除',
                                        style: TextStyle(
                                            color: Color(0XFFFFFFFF),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'PingFangSC-Medium,PingFang SC',
                                            fontSize: Ui.setFontSizeSetSp(30.0)),
                                      ),
                                    )))
                          ],
                        ),
                      )),
                  preferredSize:
                  Size(MediaQuery.of(context).size.width, Ui.width(90))),
              body: Container(
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.fromLTRB(Ui.width(40), 0, Ui.width(40), 0),
                      width: Ui.width(750),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: Ui.width(670),
                            height: Ui.width(120),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xffEAEAEA)))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: Ui.width(145),
                                  child: Text(
                                    '地区:',
                                    style: TextStyle(
                                        color: Color(0xFF111F37),
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Medium,PingFang SC',
                                        fontSize: Ui.setFontSizeSetSp(30.0)),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () async {
                                      Result result = await CityPickers.showCityPicker(
                                          context: context,
                                          height: Ui.width(500),
                                          cancelWidget: Text('取消',
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: Color(0xFF3895FF),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      'PingFangSC-Medium,PingFang SC',
                                                  fontSize: Ui.setFontSizeSetSp(
                                                      30.0))),
                                          confirmWidget: Text('确定',
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: Color(0xFF3895FF),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      'PingFangSC-Medium,PingFang SC',
                                                  fontSize: Ui.setFontSizeSetSp(
                                                      30.0))));
                                      if (result != null) {
                                        setState(() {
                                          province = result.provinceName;
                                          city = result.cityName;
                                          county = result.areaName;
                                        });
                                      }
                                    },
                                    child: Container(
                                        child: province != ''
                                            ? Text(
                                                '${province} ${city} ${county}',
                                                style: TextStyle(
                                                    color: Color(0xFF111F37),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'PingFangSC-Medium,PingFang SC',
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(
                                                            30.0)),
                                              )
                                            : Text(
                                                '点击选择',
                                                style: TextStyle(
                                                    color: Color(0xFFC4C9D3),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'PingFangSC-Medium,PingFang SC',
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(
                                                            30.0)),
                                              )),
                                  ),
                                ),
                                Image.asset('images/2.0x/rightmy.png',
                                    width: Ui.width(15), height: Ui.width(28))
                              ],
                            ),
                          ),
                          Container(
                            width: Ui.width(670),
                            height: Ui.width(120),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xffEAEAEA)))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: Ui.width(145),
                                  child: Text(
                                    '详细地址:',
                                    style: TextStyle(
                                        color: Color(0xFF111F37),
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Medium,PingFang SC',
                                        fontSize: Ui.setFontSizeSetSp(30.0)),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    controller: this._initDetailController,
                                    autofocus: false,
                                    // textInputAction: TextInputAction.none,
                                    keyboardAppearance: Brightness.light,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        color: Color(0XFF111F37),
                                        fontWeight: FontWeight.w400,
                                        fontSize: Ui.setFontSizeSetSp(30)),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '请填写详细地址',
                                        hintStyle: TextStyle(
                                          color: Color(0xFFC4C9D3),
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              'PingFangSC-Medium,PingFang SC',
                                          fontSize: Ui.setFontSizeSetSp(30.0),
                                        )),
                                    onChanged: (value) {
                                      detail = value;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: Ui.width(670),
                            height: Ui.width(120),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xffEAEAEA)))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: Ui.width(145),
                                  child: Text(
                                    '收货人:',
                                    style: TextStyle(
                                        color: Color(0xFF111F37),
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Medium,PingFang SC',
                                        fontSize: Ui.setFontSizeSetSp(30.0)),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    autofocus: false,
                                    controller: this._initNameController,
                                    // textInputAction: TextInputAction.none,
                                    keyboardAppearance: Brightness.light,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        color: Color(0XFF111F37),
                                        fontWeight: FontWeight.w400,
                                        fontSize: Ui.setFontSizeSetSp(30)),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '请填写收货人',
                                        hintStyle: TextStyle(
                                          color: Color(0xFFC4C9D3),
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              'PingFangSC-Medium,PingFang SC',
                                          fontSize: Ui.setFontSizeSetSp(30.0),
                                        )),
                                    onChanged: (value) {
                                      name = value;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: Ui.width(670),
                            height: Ui.width(120),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xffEAEAEA)))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: Ui.width(145),
                                  child: Text(
                                    '手机号:',
                                    style: TextStyle(
                                        color: Color(0xFF111F37),
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Medium,PingFang SC',
                                        fontSize: Ui.setFontSizeSetSp(30.0)),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    controller: this._initTelController,
                                    autofocus: false,
                                    // textInputAction: TextInputAction.none,
                                    keyboardAppearance: Brightness.light,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                        color: Color(0XFF111F37),
                                        fontWeight: FontWeight.w400,
                                        fontSize: Ui.setFontSizeSetSp(30)),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '请填写手机号',
                                        hintStyle: TextStyle(
                                          color: Color(0xFFC4C9D3),
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              'PingFangSC-Medium,PingFang SC',
                                          fontSize: Ui.setFontSizeSetSp(30.0),
                                        )),
                                    onChanged: (value) {
                                      tel = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: Ui.width(670),
                            height: Ui.width(120),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xffEAEAEA)))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    '设为默认地址',
                                    style: TextStyle(
                                        color: Color(0xFF111F37),
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Medium,PingFang SC',
                                        fontSize: Ui.setFontSizeSetSp(30.0)),
                                  ),
                                ),
                                CupertinoSwitch(
                                  value: defaulted,
                                  activeColor: Color(0xFFD10123),
                                  onChanged: (bool value) {
                                    setState(() {
                                      this.defaulted = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: Ui.width(40),
                        left: Ui.width(40),
                        child: InkWell(
                          onTap: () {
                            submit();
                          },
                          child: Container(
                            width: Ui.width(670),
                            height: Ui.width(80),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xFFD10123),
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(Ui.width(6.0))),
                            ),
                            child: Text(
                              '保存地址',
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'PingFangSC-Medium,PingFang SC',
                                  fontSize: Ui.setFontSizeSetSp(28.0)),
                            ),
                          ),
                        ))
                  ],
                ),
              )),
        ));
  }
}
