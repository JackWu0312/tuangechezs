import './Storage.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import '../ui/ui.dart';

class Unit {
  static getToken() async {
    // await Storage.setString('token', 'ddd');
    try {
      String token = await Storage.getString('token');
      return token;
    } catch (e) {
      return null;
    }
  }

  static isAgent() async {
    try {
      String token = await Storage.getString('isagent');
      return token;
    } catch (e) {
      return '';
    }
  }

  static setAgent(text) async {
    Storage.setString('isagent', text);
  }

  static setToast(text, context) {
    Toast.show('${text}', context,
        backgroundColor: Color(0xff5b5956),
        backgroundRadius: Ui.width(16),
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.CENTER);
  }

  static text(text, color, size, fontweight) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: Ui.setFontSizeSetSp(size),
          fontWeight: fontweight == 5
              ? FontWeight.w500
              : fontweight == 6 ? FontWeight.w600 : FontWeight.w400,
          fontFamily: 'PingFangSC-Regular,PingFang SC;'),
    );
  }

  static textStyle(color, size, fontweight) {
    return TextStyle(
        color: color,
        fontSize: Ui.setFontSizeSetSp(size),
        fontWeight: fontweight == 5
            ? FontWeight.w500
            : fontweight == 6 ? FontWeight.w600 : FontWeight.w400,
        fontFamily: 'PingFangSC-Regular,PingFang SC;');
  }


  static isCardId(String cardId) {
    if (cardId.length != 18) {
      return false; // 位数不够
    }
    // 身份证号码正则
    RegExp postalCode = new RegExp(
        r'^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|[Xx])$');
    // 通过验证，说明格式正确，但仍需计算准确性
    if (!postalCode.hasMatch(cardId)) {
      return false;
    }
    //将前17位加权因子保存在数组里
    final List idCardList = [
      "7",
      "9",
      "10",
      "5",
      "8",
      "4",
      "2",
      "1",
      "6",
      "3",
      "7",
      "9",
      "10",
      "5",
      "8",
      "4",
      "2"
    ];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    final List idCardYArray = [
      '1',
      '0',
      '10',
      '9',
      '8',
      '7',
      '6',
      '5',
      '4',
      '3',
      '2'
    ];
    // 前17位各自乖以加权因子后的总和
    int idCardWiSum = 0;

    for (int i = 0; i < 17; i++) {
      int subStrIndex = int.parse(cardId.substring(i, i + 1));
      int idCardWiIndex = int.parse(idCardList[i]);
      idCardWiSum += subStrIndex * idCardWiIndex;
    }
    // 计算出校验码所在数组的位置
    int idCardMod = idCardWiSum % 11;
    // 得到最后一位号码
    String idCardLast = cardId.substring(17, 18);
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if (idCardMod == 2) {
      if (idCardLast != 'x' && idCardLast != 'X') {
        return false;
      }
    } else {
      //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
      if (idCardLast != idCardYArray[idCardMod]) {
        return false;
      }
    }
    return true;
  }

  static isCard(String card) {
    RegExp mobile = new RegExp(r"([1-9]{1})(\d{15}|\d{18})$");
    return mobile.hasMatch(card);
  }
}
