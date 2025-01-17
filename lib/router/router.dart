import 'package:flutter/material.dart';
import '../page/login/login.dart';
import '../page/login/register.dart';
import '../page/index.dart';
import '../page/home/dried.dart';
import '../page/order/stock.dart';
import '../page/my/authentication.dart';
import '../page/my/settlement.dart';
import '../page/my/agent.dart';
import '../page/my/broker.dart';
import '../page/home/brokercard.dart';
import '../page/home/agentcard.dart';
import '../page/home/qrcode.dart';
import '../page/home/preview.dart';
import '../page/home/poster.dart';
import '../page/order/orderdetail.dart';
import '../common/easywebview.dart';
import '../common/driedwebview.dart';
import '../page/home/videolist.dart';
import '../page/home/warreport.dart';
//配置路由
final routes = {
  '/login': (context) => Login(),
  '/home': (context) => IndexPages(),
  '/register': (context) => Register(),
  '/dried': (context) => Dried(),
  '/authentication': (context) => Authentication(),
  '/settlement': (context) => Settlement(),
  '/agent': (context) => Agent(),
  '/broker': (context) => Broker(),
  '/poster': (context) => Poster(),
  '/videolist': (context) => Videolist(),
  '/warreport': (context) => Warreport(),
  '/stock': (context,{arguments}) => Stock(arguments:arguments),
  '/orderdetail': (context,{arguments})=> Orderdetail(arguments:arguments),
  '/qrcode':  (context,{arguments}) => Qrcode(arguments:arguments),
  '/preview':  (context,{arguments})=> Preview(arguments:arguments),
  '/brokercard':  (context,{arguments})=> Brokercard(arguments:arguments),
  '/agentcard':  (context,{arguments})=> Agentcard(arguments:arguments),
  '/easywebview':  (context,{arguments})=> Easywebview(arguments:arguments),
  '/driedwebview':(context,{arguments}) => Driedwebview(arguments:arguments),
};

//固定写法
var onGenerateRoute = (RouteSettings settings) {
// 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
