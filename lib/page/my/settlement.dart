import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/ui.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import '../../http/index.dart';
import '../../common/Unit.dart';
import '../../common/LoadingDialog.dart';
import '../../common/Nofind.dart';

class Settlement extends StatefulWidget {
  Settlement({Key key}) : super(key: key);

  @override
  _SettlementState createState() => _SettlementState();
}

class _SettlementState extends State<Settlement> {
  String year = '2020';
  DateTime _dateTime;
  var isloading = false;
  _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('确定', style: TextStyle(color: Color(0xFF5BBEFF))),
        cancel: Text('取消', style: TextStyle(color: Color(0xFF6A7182))),
      ),
      minDateTime: DateTime.parse('2021-00-00'),
      maxDateTime: DateTime.parse('2026-00-00'),
      initialDateTime: _dateTime,
      dateFormat: 'yyyy年',
      locale: DateTimePickerLocale.zh_cn,
      onCancel: () => print('onCancel'),
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          year = dateTime.toString().substring(0, 4);
          list = [];
          nolist = true;
          isMore = true;
          page = 1;
          limit = 10;
          getData();
        });
      },
    );
  }

  var amount;
  ScrollController _scrollController = new ScrollController();
  List list = [];
  bool nolist = true;
  bool isMore = true;
  int page = 1;
  int limit = 10;
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 100) {
        if (nolist) {
          getData();
        }
        setState(() {
          isMore = false;
        });
      }
    });
    getData();
    getDataamount();
  }

  getData() async {
    if (isMore) {
      await HttpUtlis.get(
          'third/commission/list?page=${this.page}&limit=${this.limit}&year=${this.year}',
          success: (value) {
        if (value['errno'] == 0) {
          if (value['data']['list'].length < limit) {
            setState(() {
              nolist = false;
              this.isMore = true;
              list.addAll(value['data']['list']);
            });
          } else {
            setState(() {
              page++;
              nolist = true;
              this.isMore = true;
              list.addAll(value['data']['list']);
            });
          }
        }
      }, failure: (error) {
        Unit.setToast('${error}', context);
      });
    }
  }

  getDataamount() async {
    await HttpUtlis.get('third/commission/amount', success: (value) {
      if (value['errno'] == 0) {
        setState(() {
          amount = value['data'];
        });
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
                                  ))),
                        ],
                      ),
                    )),
                preferredSize:
                    Size(MediaQuery.of(context).size.width, Ui.width(90))),
            body: isloading
                ? Stack(
                    children: <Widget>[
                      Container(
                        color: Color(0xFFFBFCFF),
                        padding: EdgeInsets.fromLTRB(0, Ui.width(300), 0, 0),
                        child: list.length > 0
                            ? ListView.builder(
                                controller: _scrollController,
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: Ui.width(750),
                                    height: Ui.width(180),
                                    padding: EdgeInsets.fromLTRB(
                                        Ui.width(30), 0, 0, 0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Color(0xffEAEAEA)))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: Ui.width(750),
                                          height: Ui.width(45),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: Ui.width(220),
                                                height: Ui.width(45),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: list[index]['status']['value']!=0?Color(0xFFF6F6F6):Color(0xFFFFEEEE),
                                                  borderRadius:
                                                      BorderRadius.horizontal(
                                                          left: Radius.circular(
                                                              Ui.width(100))),
                                                ),
                                                child: Text(
                                                  '${list[index]['status']['label']}：¥${list[index]['money']}',
                                                  style: TextStyle(
                                                      color: list[index]['status']['value']!=0?Color(0xFF9398A5):Color(0xFF9EA5406),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          'PingFangSC-Medium,PingFang SC',
                                                      fontSize:
                                                          Ui.setFontSizeSetSp(
                                                              24.0)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: Ui.width(750),
                                          padding: EdgeInsets.fromLTRB(
                                              0, 0, Ui.width(30), 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '${list[index]['goodsName']}',
                                                style: TextStyle(
                                                    color: Color(0xFF111F37),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'PingFangSC-Medium,PingFang SC',
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(
                                                            30.0)),
                                              ),
                                              SizedBox(
                                                height: Ui.width(6),
                                              ),
                                              Text(
                                                '${list[index]['addTime'].substring(0, 10)}    ${list[index]['buyer']}/${list[index]['phone']}',
                                                style: TextStyle(
                                                    color: Color(0xFF9398A5),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'PingFangSC-Medium,PingFang SC',
                                                    fontSize:
                                                        Ui.setFontSizeSetSp(
                                                            26.0)),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Nofind(
                                text: "暂无更多数据哦～",
                              ),
                      ),
                      Positioned(
                        left: 0,
                        top: Ui.width(180),
                        child: Container(
                          width: Ui.width(750),
                          height: Ui.width(120),
                          padding: EdgeInsets.fromLTRB(
                              Ui.width(30), 0, Ui.width(30), 0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xffEAEAEA)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'images/2.0x/money.png',
                                      width: Ui.width(40),
                                      height: Ui.width(40),
                                    ),
                                    SizedBox(
                                      width: Ui.width(20),
                                    ),
                                    Text(
                                      '分佣记录',
                                      style: TextStyle(
                                          color: Color(0xFF111F37),
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              'PingFangSC-Medium,PingFang SC',
                                          fontSize: Ui.setFontSizeSetSp(28.0)),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _showDatePicker();
                                },
                                child: Container(
                                  width: Ui.width(160),
                                  height: Ui.width(45),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(Ui.width(30)),
                                      border: Border.all(
                                          width: Ui.width(1),
                                          color: Color(0xFF2F8CFA))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '${this.year}',
                                        style: TextStyle(
                                            color: Color(0xFF2F8CFA),
                                            fontWeight: FontWeight.w400,
                                            fontFamily:
                                                'PingFangSC-Medium,PingFang SC',
                                            fontSize:
                                                Ui.setFontSizeSetSp(26.0)),
                                      ),
                                      SizedBox(
                                        width: Ui.width(20),
                                      ),
                                      Image.asset(
                                        'images/2.0x/select.png',
                                        width: Ui.width(18),
                                        height: Ui.width(9),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: Ui.width(750),
                          height: Ui.width(180),
                          padding: EdgeInsets.fromLTRB(Ui.width(40), 0, 0, 0),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: Ui.width(360),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: Ui.width(10),
                                    ),
                                    Text(
                                      '总收入（元）',
                                      style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontWeight: FontWeight.w500,
                                          fontFamily:
                                              'PingFangSC-Medium,PingFang SC',
                                          fontSize: Ui.setFontSizeSetSp(26.0)),
                                    ),
                                    SizedBox(
                                      height: Ui.width(15),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            '¥ ',
                                            style: TextStyle(
                                                color: Color(0xFFFFFFFF),
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    'PingFangSC-Medium,PingFang SC',
                                                fontSize:
                                                    Ui.setFontSizeSetSp(34.0)),
                                          ),
                                          Text(
                                            '${amount['paid']}',
                                            style: TextStyle(
                                                color: Color(0xFFFFFFFF),
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    'PingFangSC-Medium,PingFang SC',
                                                fontSize:
                                                    Ui.setFontSizeSetSp(70.0)),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: Ui.width(320),
                                margin:
                                    EdgeInsets.fromLTRB(Ui.width(10), 0, 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: Ui.width(10),
                                    ),
                                    Text(
                                      '未到账（元）',
                                      style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontWeight: FontWeight.w500,
                                          fontFamily:
                                              'PingFangSC-Medium,PingFang SC',
                                          fontSize: Ui.setFontSizeSetSp(26.0)),
                                    ),
                                    SizedBox(
                                      height: Ui.width(30),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            '¥ ',
                                            style: TextStyle(
                                                color: Color(0xFFFFFFFF),
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    'PingFangSC-Medium,PingFang SC',
                                                fontSize:
                                                    Ui.setFontSizeSetSp(36.0)),
                                          ),
                                          Text(
                                            '${amount['unpaid']}',
                                            style: TextStyle(
                                                color: Color(0xFFFFFFFF),
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    'PingFangSC-Medium,PingFang SC',
                                                fontSize:
                                                    Ui.setFontSizeSetSp(50.0)),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : Container(
                    child: LoadingDialog(
                      text: "加载中…",
                    ),
                  )));
  }
}
