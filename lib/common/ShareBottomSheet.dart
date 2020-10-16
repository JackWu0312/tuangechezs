import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fake_weibo/fake_weibo.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tuangechezs/event/ShareBackEvent.dart';
import 'package:tuangechezs/provider/Integral.dart';
import 'package:tuangechezs/provider/TaskEvent.dart';
import '../ui/ui.dart';
import '../http/index.dart';
import '../common/Unit.dart';
import '../provider/Share.dart';
import 'package:fluwx/fluwx.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:okhttp_kit/okhttp_kit.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import './Storage.dart';

class ShareBottomSheet extends StatefulWidget {
  final type;
  final imageurl;
  final sharetype;
  final dataId;
  final h5Url;
  final title;
  final openApp;
  final description;
  final token;
  final shareImageFile;
  final shareImageData;

  ShareBottomSheet(
      {this.type,
      this.title,
      this.openApp = false,
      this.token = false,
      this.description,
      this.shareImageFile,
      this.shareImageData,
      this.h5Url,
      this.imageurl,
      this.sharetype,
      this.dataId});

  @override
  _ShareBottomSheetState createState() => _ShareBottomSheetState();
}

class _ShareBottomSheetState extends State<ShareBottomSheet> {
  static const String _WEIBO_APP_KEY = '3464088721';
  StreamSubscription<WeChatShareResponse> _wxshare;
  StreamSubscription<WeiboSdkResp> _sharewobo;

  static const List<String> _WEIBO_SCOPE = <String>[
    WeiboScope.ALL,
  ];
  Weibo _weibo = Weibo()
    ..registerApp(
      appKey: _WEIBO_APP_KEY,
      scope: _WEIBO_SCOPE,
    );

  @override
  void initState() {
    super.initState();
    fluwx.registerWxApi(
        appId: "wx625897de48af6d91",
        universalLink: "https://app.third.tuangeche.com.cn/");
    _wxshare = fluwx.responseFromShare.listen((data) {
      //监听 微信分享
      // getShare(8,1);
    });
    _sharewobo = _weibo.shareMsgResp().listen((res) {
      //监听 微博分享
      // getShare(8,2);
    });
  }

  void dispose() {
    _wxshare.cancel();
    if (_sharewobo != null) {
      _sharewobo.cancel();
    }
    eventBus.fire(ShareBackEvent(false));
    super.dispose();
  }

  /*
    dataId  分享内容数据ID
    type      int
    分享类型：1APP、2商品、3订单、4软文、5视频、6晒单、7海报、8名片
    platform  int
    分享平台：1微信、2微博，3QQ

   */
  getShare(type, platform) {
    print(widget.dataId);
    HttpUtlis.post("third/share/callback",
        params: {'type': type, 'platform': platform, 'dataId': widget.dataId},
        success: (value) async {
      if (value['errno'] == 0) {
        final counter = Provider.of<Share>(context);
        counter.increment(true);
        final counterIntegral = Provider.of<Integral>(context);
        counterIntegral.increment(true);
        //任务数据刷新
        final taskCounter = Provider.of<TaskEvent>(context);
        taskCounter.increment(true);
      }
    }, failure: (error) {
      Unit.setToast(error, context);
    });
  }

  shareWechat(index) async {
    // index 1 微信会话  2 朋友圈
    getShare(widget.sharetype, 1);
    var model;
    if (widget.type == 'image') {
      if (null != widget.imageurl) {
        model = fluwx.WeChatShareImageModel(
            image: '${widget.imageurl}',
            thumbnail: '${widget.imageurl}',
            transaction: '${widget.imageurl}',
            scene: index == 1
                ? fluwx.WeChatScene.SESSION
                : fluwx.WeChatScene.TIMELINE,
            description: "image");
      } else {
        model = fluwx.WeChatShareImageModel.fromFile(widget.shareImageFile,
            description: "image",
            scene: index == 1
                ? fluwx.WeChatScene.SESSION
                : fluwx.WeChatScene.TIMELINE);
      }
    } else if (widget.type == 'video') {
      String token = await Storage.getString('userInfo');
      model = fluwx.WeChatShareWebPageModel(
          webPage: widget.token
              ? '${widget.h5Url}/${json.decode(token)['id']}'
              : '${widget.h5Url}',
          //个人二维码
          title: '${widget.title}',
          description: '${widget.title}',
          thumbnail: "assets://images/loginnew.png",
          scene: index == 1
              ? fluwx.WeChatScene.SESSION
              : fluwx.WeChatScene.TIMELINE,
          transaction: "hh");
    } else if (widget.type == 'h5') {
      model = fluwx.WeChatShareWebPageModel(
          webPage: widget.openApp ? '${widget.h5Url}/2' : '${widget.h5Url}',
          title: '${widget.title}',
          description: '${widget.description}',
          thumbnail: "assets://images/loginnew.png",
          scene: index == 1
              ? fluwx.WeChatScene.SESSION
              : fluwx.WeChatScene.TIMELINE,
          transaction: "hh");
    }
    fluwx.shareToWeChat(model);
  }

  shareWeibo() async {
    getShare(widget.sharetype, 2);
    if (widget.type == 'image') {
      if (null != widget.imageurl) {
        OkHttpClient client = OkHttpClientBuilder().build();
        var resp = await client
            .newCall(RequestBuilder()
                .get()
                .url(HttpUrl.parse('${widget.imageurl}'))
                .build())
            .enqueue();
        if (resp.isSuccessful()) {
          Directory saveDir = Platform.isAndroid
              ? await path_provider.getExternalStorageDirectory()
              : await path_provider.getApplicationDocumentsDirectory();
          File saveFile =
              File(path.join(saveDir.path, '${new DateTime.now()}.png'));
          if (!saveFile.existsSync()) {
            saveFile.createSync(recursive: true);
            saveFile.writeAsBytesSync(
              await resp.body().bytes(),
              flush: true,
            );
          }
          await _weibo.shareImage(
              text: '买车就选团个车', imageUri: Uri.file(saveFile.path));
        }
      } else {
        print("weibo = " + widget.shareImageFile.path);
        _weibo.shareImage(
            text: '买车就选团个车',
            imageData: widget.shareImageData,
//            imageUri: Uri.file(widget.shareImageFile.path)
        );
      }
    } else if (widget.type == 'video') {
      String token = await Storage.getString('userInfo');
      AssetImage image = const AssetImage('images/2.0x/loginnew.png');
      AssetBundleImageKey key =
          await image.obtainKey(createLocalImageConfiguration(context));
      ByteData thumbData = await key.bundle.load(key.name);
      await _weibo.shareWebpage(
        title: '${widget.title}',
        description: '${widget.title}',
        thumbData: thumbData.buffer.asUint8List(),
        webpageUrl: widget.token
            ? '${widget.h5Url}/${json.decode(token)['id']}'
            : '${widget.h5Url}', //个人二维码
      );
    } else if (widget.type == 'h5') {
      AssetImage image = const AssetImage('images/2.0x/loginnew.png');
      AssetBundleImageKey key =
          await image.obtainKey(createLocalImageConfiguration(context));
      ByteData thumbData = await key.bundle.load(key.name);
      await _weibo.shareWebpage(
        title: '${widget.title}',
        description: '${widget.description}',
        thumbData: thumbData.buffer.asUint8List(),
        webpageUrl: widget.openApp
            ? '${widget.h5Url}/1'
            : '${widget.h5Url}', // 1 表示h5 没有打开app悬浮tabar
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Ui.width(750),
      height: Ui.width(450),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              width: Ui.width(750),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      shareWechat(1);
                    },
                    child: Container(
                      width: Ui.width(130),
                      height: Ui.width(185),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'images/2.0x/wechat.png',
                            width: Ui.width(120),
                            height: Ui.width(120),
                          ),
                          SizedBox(height: Ui.width(24)),
                          Text(
                            '微信好友',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0XFF111F37),
                                fontSize: Ui.setFontSizeSetSp(26),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'PingFangSC-Regular,PingFang SC'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      shareWechat(2);
                    },
                    child: Container(
                      width: Ui.width(140),
                      height: Ui.width(185),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'images/2.0x/timeline.png',
                            width: Ui.width(120),
                            height: Ui.width(120),
                          ),
                          SizedBox(height: Ui.width(24)),
                          Text(
                            '微信朋友圈',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0XFF111F37),
                                fontSize: Ui.setFontSizeSetSp(26),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'PingFangSC-Regular,PingFang SC'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      shareWeibo();
                    },
                    child: Container(
                      width: Ui.width(130),
                      height: Ui.width(185),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'images/2.0x/weibo.png',
                            width: Ui.width(120),
                            height: Ui.width(120),
                          ),
                          SizedBox(height: Ui.width(24)),
                          Text(
                            '微博',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0XFF111F37),
                                fontSize: Ui.setFontSizeSetSp(26),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'PingFangSC-Regular,PingFang SC'),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: Ui.width(750),
                height: Ui.width(90),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 1, color: Color(0xffEAEAEA)))),
                child: Text(
                  '取消',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0XFF111F37),
                      fontSize: Ui.setFontSizeSetSp(32),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'PingFangSC-Regular,PingFang SC'),
                ),
              ))
        ],
      ),
    );
  }
}
