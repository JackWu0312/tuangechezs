import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/ui.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../http/index.dart';
import '../../common/Unit.dart';
import '../../common/LoadingDialog.dart';

class Orderdetail extends StatefulWidget {
  final Map arguments;
  Orderdetail({Key key, this.arguments}) : super(key: key);
  @override
  _OrderdetailState createState() => _OrderdetailState();
}

class _OrderdetailState extends State<Orderdetail> {
  bool isloading = false;
  var data;
  @override
  void initState() { 
    super.initState();
    getData();
    print(widget.arguments['id']);
  }
 getData() async {
      await HttpUtlis.get(
          'third/order/${widget.arguments['id']}',
          success: (value) {
        if (value['errno'] == 0) {
          setState(() {
            data=value['data'];
          });
        }
      }, failure: (error) {
        Unit.setToast('${error}', context);
      });
    setState(() {
      isloading=true;
    });
  }

  @override
  Widget build(BuildContext context) {
     Ui.init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child:  Scaffold(
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
                              left: 0,
                              top: Ui.width(30),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: Ui.width(80),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                  'images/2.0x/back.png',
                                  width: Ui.width(20),
                                  height: Ui.width(36),
                                ),
                                )
                              )),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '订单详情',
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
            body:isloading? Container(
              color: Colors.white,
              width: Ui.width(750),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, Ui.width(90)),
                    child: ListView(
                      children: <Widget>[
                        Container(
                          width: Ui.width(750),
                          height: Ui.width(400),
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {},
                                child: Image.network(
                                  "${data['goods'][0]['picUrl']}",
                                  fit: BoxFit.fill,
                                ),
                              );
                            },
                            itemCount: 1,
                            autoplay: false,
                          ),
                        ),
                        Container(
                          width: Ui.width(750),
                          height: Ui.width(90),
                          margin: EdgeInsets.fromLTRB(0, Ui.width(30), 0, 0),
                          padding: EdgeInsets.fromLTRB(
                              Ui.width(30), 0, Ui.width(30), 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '客户姓名',
                                style: TextStyle(
                                    color: Color(0XFF111F37),
                                    fontSize: Ui.setFontSizeSetSp(28),
                                    fontWeight: FontWeight.w400,
                                    fontFamily:
                                        'PingFangSC-Regular,PingFang SC'),
                              ),
                              Text(
                                '${data['order']['consignee']}',
                                style: TextStyle(
                                    color: Color(0XFF6A7182),
                                    fontSize: Ui.setFontSizeSetSp(28),
                                    fontWeight: FontWeight.w400,
                                    fontFamily:
                                        'PingFangSC-Regular,PingFang SC'),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: Ui.width(750),
                          height: Ui.width(90),
                          padding: EdgeInsets.fromLTRB(
                              Ui.width(30), 0, Ui.width(30), 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '客户电话',
                                style: TextStyle(
                                    color: Color(0XFF111F37),
                                    fontSize: Ui.setFontSizeSetSp(28),
                                    fontWeight: FontWeight.w400,
                                    fontFamily:
                                        'PingFangSC-Regular,PingFang SC'),
                              ),
                              Text(
                                '${data['order']['mobile']}',
                                style: TextStyle(
                                    color: Color(0XFF6A7182),
                                    fontSize: Ui.setFontSizeSetSp(28),
                                    fontWeight: FontWeight.w400,
                                    fontFamily:
                                        'PingFangSC-Regular,PingFang SC'),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: Ui.width(750),
                          height: Ui.width(90),
                          padding: EdgeInsets.fromLTRB(
                              Ui.width(30), 0, Ui.width(30), 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: Ui.width(200),
                                child: Text(
                                 data['order']['type']['value']==1?'订购车型':'订购商品',
                                  style: TextStyle(
                                      color: Color(0XFF111F37),
                                      fontSize: Ui.setFontSizeSetSp(28),
                                      fontWeight: FontWeight.w400,
                                      fontFamily:
                                          'PingFangSC-Regular,PingFang SC'),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${data['goods'][0]['goodsName']}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Color(0XFF6A7182),
                                        fontSize: Ui.setFontSizeSetSp(28),
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Regular,PingFang SC'),
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          width: Ui.width(750),
                          height: Ui.width(90),
                          padding: EdgeInsets.fromLTRB(
                              Ui.width(30), 0, Ui.width(30), 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '订单日期',
                                style: TextStyle(
                                    color: Color(0XFF111F37),
                                    fontSize: Ui.setFontSizeSetSp(28),
                                    fontWeight: FontWeight.w400,
                                    fontFamily:
                                        'PingFangSC-Regular,PingFang SC'),
                              ),
                              Text(
                                '${data['order']['addTime'].substring(0, 10)}',
                                style: TextStyle(
                                    color: Color(0XFF6A7182),
                                    fontSize: Ui.setFontSizeSetSp(28),
                                    fontWeight: FontWeight.w400,
                                    fontFamily:
                                        'PingFangSC-Regular,PingFang SC'),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: Ui.width(750),
                          height: Ui.width(90),
                          padding: EdgeInsets.fromLTRB(
                              Ui.width(30), 0, Ui.width(30), 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: Ui.width(200),
                                child: Text(
                                  '客户地址',
                                  style: TextStyle(
                                      color: Color(0XFF111F37),
                                      fontSize: Ui.setFontSizeSetSp(28),
                                      fontWeight: FontWeight.w400,
                                      fontFamily:
                                          'PingFangSC-Regular,PingFang SC'),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                   data['order']['address']==null?'':'${data['order']['address']}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Color(0XFF6A7182),
                                        fontSize: Ui.setFontSizeSetSp(28),
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Regular,PingFang SC'),
                                  ))
                            ],
                          ),
                        ),
                       
                      ],
                    ),
                  ),
                ],
              ),
            ):Container(
                  child: LoadingDialog(
                    text: "加载中…",
                  ),
                ))));
  }
}
