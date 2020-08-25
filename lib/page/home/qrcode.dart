import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/ui.dart';
import '../../common/Unit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../common/ShareBottomSheet.dart';
import '../../common/StoreImage.dart';
class Qrcode extends StatefulWidget {
  final Map arguments;
  Qrcode({Key key, this.arguments}) : super(key: key);
  @override
  _QrcodeState createState() => _QrcodeState();
}

class _QrcodeState extends State<Qrcode> {
  int isAgent = 1;
  @override
  void initState() {
    super.initState();
    getisAgent();
  }
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
          body: Container(
            color: Color(0xFFFBFCFF),
            child: ListView(
              children: <Widget>[
                Container(
                  width: Ui.width(750),
                  height: Ui.width(1100) + MediaQuery.of(context).padding.top,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: Ui.width(750),
                          height: Ui.width(300) +
                              MediaQuery.of(context).padding.top,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/2.0x/cardbg.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                  left: Ui.width(30),
                                  top: Ui.width(30) +
                                      MediaQuery.of(context).padding.top,
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
                                top: Ui.width(80) +
                                    MediaQuery.of(context).padding.top,
                                child: Container(
                                  width: Ui.width(750),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${widget.arguments['user']['name']}的名片',
                                    style: TextStyle(
                                        color: Color(0XFFFFFFFF),
                                        fontSize: Ui.setFontSizeSetSp(36),
                                        fontWeight: FontWeight.w500,
                                        fontFamily:
                                            'PingFangSC-Regular,PingFang SC'),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: Ui.width(30),
                        top: Ui.width(230) + MediaQuery.of(context).padding.top,
                        child: Container(
                          width: Ui.width(690),
                          height: Ui.width(900),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0XFFEEF3F9),
                                offset: Offset(1, 1),
                                blurRadius: Ui.width(20.0),
                              ),
                            ],
                            borderRadius: new BorderRadius.all(
                                new Radius.circular(Ui.width(10.0))),
                          ),
                          padding: EdgeInsets.fromLTRB(
                              Ui.width(70), Ui.width(30), Ui.width(30), 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                onLongPress: () async {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext contexts) {
                                        return StoreImage(
                                          context: context,
                                          imgUrl:  "${widget.arguments['imgurl']}",
                                        );
                                      });
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      Ui.width(115), Ui.width(85), 0, 0),
                                  width: Ui.width(320),
                                  height: Ui.width(320),
                                  child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl:
                                          '${widget.arguments['imgurl']}'),
                                ),

                                // Container(
                                //   margin: EdgeInsets.fromLTRB(
                                //       Ui.width(115), Ui.width(85), 0, 0),
                                //   width: Ui.width(320),
                                //   height: Ui.width(320),
                                //   decoration: BoxDecoration(
                                //     image: DecorationImage(
                                //       image: NetworkImage(
                                //           '${widget.arguments['imgurl']}'),
                                //       fit: BoxFit.cover,
                                //     ),
                                //   ),
                                // ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(0, Ui.width(100), 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                            '电话：${widget.arguments['user']['mobile']}',
                                            style: TextStyle(
                                                color: Color(0XFF111F37),
                                                fontSize:
                                                    Ui.setFontSizeSetSp(28),
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    'PingFangSC-Regular,PingFang SC'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0, Ui.width(30), 0, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'images/2.0x/company.png',
                                            width: Ui.width(26),
                                            height: Ui.width(28),
                                          ),
                                          SizedBox(
                                            width: Ui.width(30),
                                          ),
                                          Text(
                                            widget.arguments['user']
                                                        ['company'] ==
                                                    null
                                                ? '公司：'
                                                : '公司：${widget.arguments['user']['company']}',
                                            style: TextStyle(
                                                color: Color(0XFF111F37),
                                                fontSize:
                                                    Ui.setFontSizeSetSp(28),
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    'PingFangSC-Regular,PingFang SC'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    isAgent != 1
                                        ? Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0, Ui.width(30), 0, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                  'images/2.0x/address.png',
                                                  width: Ui.width(25),
                                                  height: Ui.width(29),
                                                ),
                                                SizedBox(
                                                  width: Ui.width(30),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    '地址：${widget.arguments['user']['address']}',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0XFF111F37),
                                                        fontSize:
                                                            Ui.setFontSizeSetSp(
                                                                28),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            'PingFangSC-Regular,PingFang SC'),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : Text('')
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: Ui.width(310),
                        top: Ui.width(165) + MediaQuery.of(context).padding.top,
                        child: Container(
                            width: Ui.width(130),
                            height: Ui.width(130),
                            child: ClipOval(
                                child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl:
                                        '${widget.arguments['user']['avatar']}'))),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return ShareBottomSheet(
                            type: 'image',
                            sharetype: 8,
                            imageurl: widget.arguments['imgurl'],
                            dataId: widget.arguments['id'],
                          );
                        });
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        Ui.width(30), Ui.width(50), Ui.width(30), 0),
                    child: Container(
                      width: Ui.width(690),
                      height: Ui.width(90),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(Ui.width(45)),
                          border: Border.all(
                              width: Ui.width(1), color: Color(0xFF2F8CFA))),
                      child: Text(
                        '一键分享',
                        style: TextStyle(
                            color: Color(0XFF2F8CFA),
                            fontSize: Ui.setFontSizeSetSp(32),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'PingFangSC-Regular,PingFang SC'),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
