import 'dart:convert';
import 'package:tuangechezs/common/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/ui.dart';
import '../../common/Storage.dart';
import '../config/config.dart';
import '../../http/index.dart';
import '../../common/Unit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../common/ShareBottomSheet.dart';
import '../../common/StoreImage.dart';
class Brokercard extends StatefulWidget {
  final Map arguments;
  Brokercard({Key key, this.arguments}) : super(key: key);
  @override
  _BrokercardState createState() => _BrokercardState();
}

class _BrokercardState extends State<Brokercard> {
  String qrcode = '';
  var data;
  var isloading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await HttpUtlis.get('third/user/info', success: (value) async {
      if (value['errno'] == 0) {
        setState(() {
          data = value['data'];
          qrcode = '${Config.url}third/user/qrcode/${data['id']}';
        });
        await Storage.setString('userInfo', json.encode(value['data']));
      }
      setState(() {
        isloading = true;
      });
    }, failure: (error) {
      Unit.setToast('${error}', context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Ui.init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          appBar: PreferredSize(
              child: Container(
                height: Ui.height(0),
              ),
              preferredSize: Size(0, 0)),
          body: isloading
              ? Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/2.0x/carsbg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          left: Ui.width(30),
                          top:
                              Ui.width(30) + MediaQuery.of(context).padding.top,
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
                        left: Ui.width(0),
                        top: Ui.width(140) + MediaQuery.of(context).padding.top,
                        child: Container(
                          width: Ui.width(750),
                          height: Ui.width(1120),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/2.0x/agentbg.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Ui.width(116), Ui.width(180), 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${data['name']}',
                                      style: TextStyle(
                                          color: Color(0XFF111F37),
                                          fontSize: Ui.setFontSizeSetSp(40),
                                          fontWeight: FontWeight.w500,
                                          fontFamily:
                                              'PingFangSC-Regular,PingFang SC'),
                                    ),
                                    SizedBox(
                                      width: Ui.width(27),
                                    ),
                                    Container(
                                      width: Ui.width(166),
                                      height: Ui.width(42),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFf1f6ff),
                                        border: Border.all(
                                            width: Ui.width(1),
                                            color: Color(0xFF347AFF)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '团个车经纪人',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0XFF347AFF),
                                            fontSize: Ui.setFontSizeSetSp(24),
                                            fontWeight: FontWeight.w400,
                                            fontFamily:
                                                'PingFangSC-Regular,PingFang SC'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(Ui.width(116),
                                    Ui.width(75), Ui.width(40), 0),
                                child: Text(
                                  '太原团个车网络科技有限公司',
                                  style: TextStyle(
                                      color: Color(0XFF111F37),
                                      fontSize: Ui.setFontSizeSetSp(32),
                                      fontWeight: FontWeight.w500,
                                      fontFamily:
                                          'PingFangSC-Regular,PingFang SC'),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Ui.width(116), Ui.width(75), 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'images/2.0x/contact.png',
                                      width: Ui.width(27),
                                      height: Ui.width(27),
                                    ),
                                    SizedBox(
                                      width: Ui.width(30),
                                    ),
                                    Text(
                                      '${data['mobile']}',
                                      style: TextStyle(
                                          color: Color(0XFF5E6578),
                                          fontSize: Ui.setFontSizeSetSp(28),
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              'PingFangSC-Regular,PingFang SC'),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Ui.width(116), Ui.width(27), 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'images/2.0x/wechatnum.png',
                                      width: Ui.width(27),
                                      height: Ui.width(27),
                                    ),
                                    SizedBox(
                                      width: Ui.width(30),
                                    ),
                                    Text(
                                      '${data['wechat'] != null ? data['wechat'] : "暂未填写微信号"}',
                                      style: TextStyle(
                                          color: Color(0XFF5E6578),
                                          fontSize: Ui.setFontSizeSetSp(28),
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              'PingFangSC-Regular,PingFang SC'),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Ui.width(116), Ui.width(27), 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'images/2.0x/address.png',
                                      width: Ui.width(27),
                                      height: Ui.width(27),
                                    ),
                                    SizedBox(
                                      width: Ui.width(30),
                                    ),
                                    Text(
                                      data['address'] != null
                                          ? '${data['address']}'
                                          : '',
                                      style: TextStyle(
                                          color: Color(0XFF5E6578),
                                          fontSize: Ui.setFontSizeSetSp(28),
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              'PingFangSC-Regular,PingFang SC'),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onLongPress: () async {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext contexts) {
                                        return StoreImage(
                                          context: context,
                                          imgUrl: "${this.qrcode}",
                                        );
                                      });
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      Ui.width(280), Ui.width(60), 0, 0),
                                  width: Ui.width(190),
                                  height: Ui.width(190),
                                  child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl: '${this.qrcode}'),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ShareBottomSheet(
                                          type: 'image',
                                          imageurl: '${this.qrcode}',
                                          sharetype: 8,
                                          dataId: data['id'],
                                        );
                                      });
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      Ui.width(69), Ui.width(90), 0, 0),
                                  child: Container(
                                    width: Ui.width(600),
                                    height: Ui.width(90),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFFFFFFF),
                                        borderRadius:
                                            BorderRadius.circular(Ui.width(45)),
                                        border: Border.all(
                                            width: Ui.width(1),
                                            color: Color(0xFF2F8CFA))),
                                    child: Text(
                                      '一键分享',
                                      style: TextStyle(
                                          color: Color(0XFF2F8CFA),
                                          fontSize: Ui.setFontSizeSetSp(32),
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              'PingFangSC-Regular,PingFang SC'),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: Ui.width(74),
                        top: Ui.width(140) + MediaQuery.of(context).padding.top,
                        child: Container(
                          width: Ui.width(164),
                          height: Ui.width(164),
                          padding: EdgeInsets.fromLTRB(Ui.width(8), Ui.width(8),
                              Ui.width(8), Ui.width(8)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0XFFE6EFFF),
                                offset: Offset(1, 1),
                                blurRadius: Ui.width(10.0),
                              ),
                            ],
                            borderRadius: new BorderRadius.all(
                                new Radius.circular(Ui.width(164.0))),
                          ),
                          child: Container(
                              width: Ui.width(148),
                              height: Ui.width(148),
                              child: ClipOval(
                                  child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl: '${data['avatar']}'))),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  child: LoadingDialog(
                    text: "加载中…",
                  ),
                ),
        ));
  }
}
