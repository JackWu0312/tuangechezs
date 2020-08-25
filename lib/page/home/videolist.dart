import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuangechezs/common/Nofind.dart';
import '../../ui/ui.dart';
import '../../http/index.dart';
import '../../common/Unit.dart';
import '../../video/full_video_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../common/ShareBottomSheet.dart';
import '../config/config.dart';
class Videolist extends StatefulWidget {
  Videolist({Key key}) : super(key: key); 

  @override
  _VideolistState createState() => _VideolistState();
}

class _VideolistState extends State<Videolist> {
  bool isloading = false;
  var test = false;
  bool falge = true;
  List arr = [];
  List arr1 = [];

  ScrollController _scrollController = new ScrollController();
  List list = [];
  bool nolist = true;
  bool isMore = true;
  int page = 1;
  int limit = 10;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 60) {
        if (nolist) {
          getData();
        }
        setState(() {
          isMore = false;
        });
      }
    });
    getData();
  }


  // getvideo() {
  //   setState(() {
  //     arr = [];
  //     arr1 = [];
  //   });
  //   for (var i = 0, len = list.length; i < len; i++) {
  //     VideoPlayerController videoPlayerController;
  //     videoPlayerController =
  //         VideoPlayerController.network('${list[i]['url']}');
  //     arr.add(videoPlayerController);
  //     ChewieController chewieController;
  //     chewieController = ChewieController(
  //       videoPlayerController: videoPlayerController,
  //       aspectRatio: 5 / 3,
  //       autoPlay: false,
  //       looping: false,
  //       showControlsOnInitialize: false,
  //       allowMuting: false,
  //       autoInitialize: true,
  //     );
  //     arr1.add(chewieController);
  //   }
  // }

  getData() async {
    if (isMore) {
      await HttpUtlis.get(
          'third/promote/videos?page=${this.page}&limit=${this.limit}',
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
          // getvideo();
        }
      }, failure: (error) {
        Unit.setToast('${error}', context);
      });
    }
  }

  @override
  void dispose() {
    // for (var i = 0, len = list.length; i < len; i++) {
    //   arr1[i].dispose();
    //   arr[i].dispose();
    // }
    super.dispose();
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
                            '汽车视频',
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
          body: list.length > 0
              ? Container(
                  color: Colors.white,
                  width: Ui.width(750),
                  padding: EdgeInsets.fromLTRB(
                      Ui.width(30), Ui.width(0), Ui.width(30), Ui.width(30)),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, Ui.width(30), 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(CupertinoPageRoute(
                                            builder: (_) => FullVideoPage(
                                                  playType: PlayType.network,
                                                  titles:
                                                      '${list[index]['title']}',
                                                  dataSource:
                                                      '${list[index]['url']}',
                                                )));
                                  },
                                  
                                  child: Container(
                                    // width: Ui.width(690),
                                    // height: Ui.width(380),
                                    // decoration: BoxDecoration(
                                    //     borderRadius: new BorderRadius.all(
                                    //         new Radius.circular(Ui.width(4.0))),
                                    //     image: DecorationImage(
                                    //       image: NetworkImage(
                                    //           '${list[index]['picUrl']}'),
                                    //       fit: BoxFit.fill,
                                    //     )),
                                    child: Stack(
                                      children: <Widget>[
                                        ClipRRect(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        new Radius.circular(
                                                            Ui.width(4.0))),
                                                child: CachedNetworkImage(
                                                     width: Ui.width(690),
                                                      height: Ui.width(380),
                                                    fit: BoxFit.fill,
                                                    imageUrl:
                                                        '${list[index]['picUrl']}'),
                                              ),
                                        // Chewie(controller: arr1[index]),
                                        // Positioned(
                                        //   left: Ui.width(280),
                                        //   top: Ui.width(130),
                                        //   child: !arr[index].value.isPlaying
                                        //       ? Image.asset(
                                        //           'images/2.0x/play.png',
                                        //           width: Ui.width(120),
                                        //           height: Ui.width(120))
                                        //       : Text(''),
                                        // ),
                                        Positioned(
                                            left: Ui.width(280),
                                            top: Ui.width(130),
                                            child: Image.asset(
                                                'images/2.0x/play.png',
                                                width: Ui.width(120),
                                                height: Ui.width(120))),
                                        Positioned(
                                            right: Ui.width(0),
                                            top: Ui.width(0),
                                            child: InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return ShareBottomSheet(
                                                        type:'video',
                                                        sharetype:5,
                                                        h5Url:'${Config.weblink}appvideozs/${list[index]['id']}',
                                                        token:true,
                                                        dataId:'${list[index]['id']}',
                                                        title:'${list[index]['title']}'
                                                      );
                                                      
                                                      
                                                      // Container(
                                                      //   width: Ui.width(750),
                                                      //   height: Ui.width(450),
                                                      //   color: Colors.white,
                                                      //   child: Column(
                                                      //     mainAxisAlignment:
                                                      //         MainAxisAlignment
                                                      //             .start,
                                                      //     crossAxisAlignment:
                                                      //         CrossAxisAlignment
                                                      //             .start,
                                                      //     children: <Widget>[
                                                      //       Expanded(
                                                      //         flex: 1,
                                                      //         child: Container(
                                                      //           width: Ui.width(
                                                      //               750),
                                                      //           child: Row(
                                                      //             mainAxisAlignment:
                                                      //                 MainAxisAlignment
                                                      //                     .spaceAround,
                                                      //             crossAxisAlignment:
                                                      //                 CrossAxisAlignment
                                                      //                     .center,
                                                      //             children: <
                                                      //                 Widget>[
                                                      //               InkWell(
                                                      //                 onTap:
                                                      //                     () {
                                                      //                   getwechat(
                                                      //                       1,
                                                      //                       index);
                                                      //                 },
                                                      //                 child:
                                                      //                     Container(
                                                      //                   width: Ui.width(
                                                      //                       130),
                                                      //                   height:
                                                      //                       Ui.width(185),
                                                      //                   child:
                                                      //                       Column(
                                                      //                     mainAxisAlignment:
                                                      //                         MainAxisAlignment.start,
                                                      //                     crossAxisAlignment:
                                                      //                         CrossAxisAlignment.center,
                                                      //                     children: <
                                                      //                         Widget>[
                                                      //                       Image.asset(
                                                      //                         'images/2.0x/wechat.png',
                                                      //                         width: Ui.width(120),
                                                      //                         height: Ui.width(120),
                                                      //                       ),
                                                      //                       SizedBox(height: Ui.width(24)),
                                                      //                       Text(
                                                      //                         '微信好友',
                                                      //                         textAlign: TextAlign.center,
                                                      //                         style: TextStyle(color: Color(0XFF111F37), fontSize: Ui.setFontSizeSetSp(26), fontWeight: FontWeight.w400, fontFamily: 'PingFangSC-Regular,PingFang SC'),
                                                      //                       ),
                                                      //                     ],
                                                      //                   ),
                                                      //                 ),
                                                      //               ),
                                                      //               InkWell(
                                                      //                 onTap:
                                                      //                     () {
                                                      //                   getwechat(
                                                      //                       2,
                                                      //                       index);
                                                      //                 },
                                                      //                 child:
                                                      //                     Container(
                                                      //                   width: Ui.width(
                                                      //                       140),
                                                      //                   height:
                                                      //                       Ui.width(185),
                                                      //                   child:
                                                      //                       Column(
                                                      //                     mainAxisAlignment:
                                                      //                         MainAxisAlignment.start,
                                                      //                     crossAxisAlignment:
                                                      //                         CrossAxisAlignment.center,
                                                      //                     children: <
                                                      //                         Widget>[
                                                      //                       Image.asset(
                                                      //                         'images/2.0x/timeline.png',
                                                      //                         width: Ui.width(120),
                                                      //                         height: Ui.width(120),
                                                      //                       ),
                                                      //                       SizedBox(height: Ui.width(24)),
                                                      //                       Text(
                                                      //                         '微信朋友圈',
                                                      //                         textAlign: TextAlign.center,
                                                      //                         style: TextStyle(color: Color(0XFF111F37), fontSize: Ui.setFontSizeSetSp(26), fontWeight: FontWeight.w400, fontFamily: 'PingFangSC-Regular,PingFang SC'),
                                                      //                       ),
                                                      //                     ],
                                                      //                   ),
                                                      //                 ),
                                                      //               ),
                                                      //               InkWell(
                                                      //                 onTap:
                                                      //                     () async {
                                                      //                   getShare(
                                                      //                       5,
                                                      //                       2);
                                                      //                   String
                                                      //                       token =
                                                      //                       await Storage.getString('userInfo');
                                                      //                   AssetImage
                                                      //                       image =
                                                      //                       const AssetImage('images/2.0x/loginnew.png');
                                                      //                   AssetBundleImageKey
                                                      //                       key =
                                                      //                       await image.obtainKey(createLocalImageConfiguration(context));
                                                      //                   ByteData
                                                      //                       thumbData =
                                                      //                       await key.bundle.load(key.name);
                                                      //                   await _weibo
                                                      //                       .shareWebpage(
                                                      //                     title:
                                                      //                         '${list[index]['title']}',
                                                      //                     description:
                                                      //                         '${list[index]['title']}',
                                                      //                     thumbData: thumbData
                                                      //                         .buffer
                                                      //                         .asUint8List(),
                                                      //                     webpageUrl:
                                                      //                         '${Config.weblink}appvideozs/${list[index]['id']}/${json.decode(token)['id']}',
                                                      //                   );
                                                      //                 },
                                                      //                 child:
                                                      //                     Container(
                                                      //                   width: Ui.width(
                                                      //                       130),
                                                      //                   height:
                                                      //                       Ui.width(185),
                                                      //                   child:
                                                      //                       Column(
                                                      //                     mainAxisAlignment:
                                                      //                         MainAxisAlignment.start,
                                                      //                     crossAxisAlignment:
                                                      //                         CrossAxisAlignment.center,
                                                      //                     children: <
                                                      //                         Widget>[
                                                      //                       Image.asset(
                                                      //                         'images/2.0x/weibo.png',
                                                      //                         width: Ui.width(120),
                                                      //                         height: Ui.width(120),
                                                      //                       ),
                                                      //                       SizedBox(height: Ui.width(24)),
                                                      //                       Text(
                                                      //                         '微博',
                                                      //                         textAlign: TextAlign.center,
                                                      //                         style: TextStyle(color: Color(0XFF111F37), fontSize: Ui.setFontSizeSetSp(26), fontWeight: FontWeight.w400, fontFamily: 'PingFangSC-Regular,PingFang SC'),
                                                      //                       ),
                                                      //                     ],
                                                      //                   ),
                                                      //                 ),
                                                      //               )
                                                      //             ],
                                                      //           ),
                                                      //         ),
                                                      //       ),
                                                      //       GestureDetector(
                                                      //           onTap: () {
                                                      //             Navigator.pop(
                                                      //                 context);
                                                      //           },
                                                      //           child:
                                                      //               Container(
                                                      //             width:
                                                      //                 Ui.width(
                                                      //                     750),
                                                      //             height:
                                                      //                 Ui.width(
                                                      //                     90),
                                                      //             alignment:
                                                      //                 Alignment
                                                      //                     .center,
                                                      //             decoration: BoxDecoration(
                                                      //                 border: Border(
                                                      //                     top: BorderSide(
                                                      //                         width: 1,
                                                      //                         color: Color(0xffEAEAEA)))),
                                                      //             child: Text(
                                                      //               '取消',
                                                      //               textAlign:
                                                      //                   TextAlign
                                                      //                       .center,
                                                      //               style: TextStyle(
                                                      //                   color: Color(
                                                      //                       0XFF111F37),
                                                      //                   fontSize:
                                                      //                       Ui.setFontSizeSetSp(
                                                      //                           32),
                                                      //                   fontWeight:
                                                      //                       FontWeight
                                                      //                           .w400,
                                                      //                   fontFamily:
                                                      //                       'PingFangSC-Regular,PingFang SC'),
                                                      //             ),
                                                      //           ))
                                                      //     ],
                                                      //   ),
                                                      // );
                                                    });
                                              },
                                              child: Container(
                                                child: Image.asset(
                                                    'images/2.0x/sharevideo.png',
                                                    width: Ui.width(70),
                                                    height: Ui.width(70)),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      0, Ui.width(20), 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${list[index]['title']}',
                                    style: TextStyle(
                                        color: Color(0xFF111F37),
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            'PingFangSC-Medium,PingFang SC',
                                        fontSize: Ui.setFontSizeSetSp(32.0)),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  ))
              : Nofind(
                  text: "暂无更多数据哦～",
                ),
        ));
  }
}
