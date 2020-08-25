import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TalkingDataAppAnalytics {
  static const MethodChannel _channel =
      const MethodChannel('TalkingData_AppAnalytics');

  static Future<String> getDeviceID() async{
    return await _channel.invokeMethod('getDeviceID');
  }

  static Future<void> onPageStart(String pageName) async{
    return await _channel.invokeMethod('onPageStart', <String, dynamic>{
      'pageName': pageName
    });
  }

  static Future<void> onPageEnd(String pageName) async{
    return await _channel.invokeMethod('onPageEnd', <String, dynamic>{
      'pageName': pageName
    });
  }

  static Future<void> onEvent({@required String eventID, String eventLabel, Map params}) async{
    return await _channel.invokeMethod('onEvent', <String, dynamic>{
      'eventID':eventID,
      'eventLabel':eventLabel,
      'params':params
    });
  }

  static Future<void> setGlobalKV(String key, Object value) async{
    return await _channel.invokeMethod('setGlobalKV', <String, dynamic>{
      'key':key,
      'value':value
    });
  }

  static Future<void> removeGlobalKV(String key) async{
    return await _channel.invokeMethod('removeGlobalKV', <String, dynamic>{
      'key':key
    });
  }

  static Future<void> onRegister({String accountID, AccountType accountType, String name}) async{
    return await _channel.invokeMethod('onRegister', <String, dynamic>{
      'accountID': accountID,
      'accountType': accountType.toString().split('.')[1],
      'name': name
    });
  }

  static Future<void> onLogin({String accountID, AccountType accountType, String name}) async{
    return await _channel.invokeMethod('onLogin', <String, dynamic>{
      'accountID': accountID,
      'accountType': accountType.toString().split('.')[1],
      'name': name
    });
  }

  static Future<void> onPlaceOrder({String accountID, Order order}) async{
    return await _channel.invokeMethod('onPlaceOrder', <String, dynamic>{
      'accountID': accountID,
      'orderID': order.orderID,
      'totalPrice': order.totalPrice,
      'currencyType': order.currencyType,
      'orderDetails': order._orderDetails
    });
  }

  static Future<void> onOrderPaySucc({String accountID, String payType, Order order}) async{
    return await _channel.invokeMethod('onOrderPaySucc', <String, dynamic>{
      'accountID': accountID,
      'payType': payType,
      'orderID': order.orderID,
      'totalPrice': order.totalPrice,
      'currencyType': order.currencyType,
      'orderDetails': order._orderDetails
    });
  }

  static Future<void> onAddItemToShoppingCart({String itemId, String category, String name, int unitPrice, int amount}) async{
    return await _channel.invokeMethod('onAddItemToShoppingCart', <String, dynamic>{
      'itemID': itemId,
      'category': category,
      'name': name,
      'unitPrice': unitPrice,
      'amount': amount
    });
  }

  static Future<void> onViewItem({String itemId ,String category,String name,int unitPrice}) async{
    return await _channel.invokeMethod('onViewItem', <String, dynamic>{
      'itemID': itemId,
      'category': category,
      'name': name,
      'unitPrice': unitPrice
    });
  }

  static Future<void> onViewShoppingCart(ShoppingCart shoppingCart) async{
    return await _channel.invokeMethod('onViewShoppingCart', <String, dynamic>{
      'shoppingCartDetails': shoppingCart._shoppingCartDetails
    });
  }

}


enum AccountType{
  ANONYMOUS, // 匿名
  REGISTERED, // 自有帐户显性注册
  SINA_WEIBO, // 新浪微博
  QQ, // QQ账号
  QQ_WEIBO, // QQ微博账号
  ND91, // 网龙91
  WEIXIN,//微信账号
  TYPE1, //
  TYPE2, //
  TYPE3, //
  TYPE4, //
  TYPE5, //
  TYPE6, //
  TYPE7, //
  TYPE8, //
  TYPE9, //
  TYPE10 //
}

class Order{
  Order({
    this.orderID,
    this.totalPrice,
    this.currencyType,
  });

  final String orderID;

  final int totalPrice;

  final String currencyType;

  List _orderDetails = List();

  addItem(String id, String category, String name, int unitPrice, int amount){
    Map map = Map();
    map['id'] = id;
    map['category'] = category;
    map['name'] = name;
    map['unitPrice'] = unitPrice;
    map['amount'] = amount;
    _orderDetails.add(map);
  }


}

class ShoppingCart{
  ShoppingCart();

  List _shoppingCartDetails = List();

  addItem(String itemID, String category, String name, int unitPrice, int amount){
    Map map = Map();
    map['itemID'] = itemID;
    map['category'] = category;
    map['name'] = name;
    map['unitPrice'] = unitPrice;
    map['amount'] = amount;
    _shoppingCartDetails.add(map);
  }
}