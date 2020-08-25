import 'package:flutter/material.dart';
import './common/NoSplash.dart';
import './router/router.dart';
import 'dart:io'; //提供Platform接口
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './common/CupertinoLocalizationsDelegate.dart';
import './common/Unit.dart';
// import './common/Storage.dart';
import './provider/Orderback.dart';
import './provider/Share.dart';

String token = '/home';
List<Locale> an = [
  const Locale('zh', 'CH'),
  const Locale('en', 'US'),
];
List<Locale> ios = [
  const Locale('en', 'US'),
  const Locale('zh', 'CH'),
];

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  if (await Unit.getToken() != null) {
    token = '/home';
  } else {
    token = '/login';
  }
  // Future.delayed(Duration(milliseconds: 10), () {
  runApp(MyApp());
  // });

  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前       MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  requestPermiss() async {
    //请求权限
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions(
            [PermissionGroup.location, PermissionGroup.camera]);
    //校验权限
    // if(permissions[PermissionGroup.camera] != PermissionStatus.granted){
    //   print("无照相权限");
    // }
    if (permissions[PermissionGroup.location] != PermissionStatus.granted) {
      bool isOpened = await PermissionHandler().openAppSettings();
      print(isOpened);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Orderback()),
        ChangeNotifierProvider(create: (_) => Share()),
      ],
      child: MaterialApp(
        // home: Tabs(),
        title: '团个车助手',
        initialRoute: token,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: onGenerateRoute,
        theme: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
            splashFactory: const NoSplashFactory(),
            // primaryColor: Color(0XFFFFFFFF),
            platform: TargetPlatform.iOS,
            primaryColor: Colors.white),
        localizationsDelegates: [
          CupertinoLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: Platform.isIOS ? ios : an,
        locale: Locale('zh'),
      ),
    );
  }
}
