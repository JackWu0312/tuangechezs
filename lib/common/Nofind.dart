import 'package:flutter/material.dart';
import '../ui/ui.dart';

class Nofind extends StatelessWidget {
  final String text;

  const Nofind({Key key, @required this.text}) : super(key: key);

   Widget build(BuildContext context) {
    Ui.init(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      // color: Color(0XFFFFFFFF),
      child: Center(
        child: Container(
          height: Ui.width(450),
          child: Column(
            children: <Widget>[
              Container(
                width: Ui.width(400),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.asset('images/2.0x/nofind.png'),
                ),
              ),
              Text(
               text,
                style: TextStyle(
                    color: Color(0xFF111F37),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'PingFangSC-Medium,PingFang SC',
                    fontSize: Ui.setFontSizeSetSp(28.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
