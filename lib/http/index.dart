/*
 * @Descripttion: 
 * @version: 
 * @Author: jackWu
 * @Date: 2020-10-16 10:38:30
 * @LastEditors: sueRimn
 * @LastEditTime: 2020-10-17 11:47:32
 */
import 'package:dio/dio.dart';
import '../common/Storage.dart';
class HttpUtlis {
 static String _domain = 'http://test.api.tuangeche.com.cn/';
    // static String _domain = 'http://192.168.1.51:8080/';
  static getToken() async {
    try {
      String token = await Storage.getString('token');
      return token;
    } catch (e) {
      return '';  
    }
  }

  static Dio _dio;
  static BaseOptions _options;

  static getoption() async {
    _options =new BaseOptions(connectTimeout: 50000, receiveTimeout: 3000, headers: {
      'Content-Type': 'application/json',
      'Third-Auth-Token':await getToken(),
      // 'Third-Auth-Token':'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTE4MzkzNTM0MDk4NDgwNzQyNiwidHlwZSI6MiwiaWF0IjoxNTkwMzc4NzkxfQ.JL351y4v8YS8-Xj9OYSPML9ngHCdyAN4UChMukq20_w'
    });
  }

  static get(String url, {options, Function success, Function failure}) async {
    await getoption();
    Dio dio = buildDio();
    try {
      Response response = await dio.get(_domain + url, options: options);
      var json = response.data;
      if (json['errno'] == 0 || json['errno'] == 401) {
        success(json);
      } else {
        failure(json['errmsg']);
      }
    } catch (exception) {
      print(exception);
    }
  }

  static post(String url,{params, options, Function success, Function failure}) async {
    await getoption();
    Dio dio = buildDio();
    
    try {
      Response response =await dio.post(_domain + url, data: params, options: options);
      var json = response.data;
      if (json['errno'] == 0 || json['errno'] == 401) {
        success(json);
      } else {
        failure(json['errmsg']);
      }
      // success(response.data);
    } catch (exception) {
      failure(exception);
    }
  }

  static Dio buildDio() {
    // if (_dio == null) {
    _dio = new Dio(_options);
    // Dio dio = new Dio();
    //    
    // }
    return _dio;
  }
}
