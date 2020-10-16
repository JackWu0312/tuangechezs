import 'package:flutter/material.dart';
import 'package:tuangechezs/page/material/materialIndex.dart';
import '../ui/ui.dart';
import './home/home.dart';
import './order/order.dart';
import './my/my.dart';
import 'mall/mall.dart';
class IndexPages extends StatefulWidget {
  IndexPages({Key key}) : super(key: key);
  @override
  _IndexPagesState createState() => _IndexPagesState();
}

class _IndexPagesState extends State<IndexPages> {
  int _currentIndex = 0;
  @override
  void initState() { 
    super.initState();
    
  }
  
  @override
  Widget build(BuildContext context) {
    Ui.init(context);
    return Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
           Home(),
           Order(),
            Mall(),
            MaterialIndex(),
           My()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFFFFFFFF),
          currentIndex: _currentIndex,
          unselectedItemColor: Color(0xFF9398A5),
          selectedItemColor: Color(0xFF2F8CFA),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: Ui.setFontSizeSetSp(20.0),
          unselectedFontSize: Ui.setFontSizeSetSp(20.0),
          onTap: (int index) {
            setState(() {
              this._currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/2.0x/extension.png',
                width: Ui.width(65.0),
                height: Ui.width(55.0),
              ),
              activeIcon: Image.asset(
                'images/2.0x/extensionselect.png',
                width: Ui.width(65.0),
                height: Ui.width(55.0),
              ),
              title: Text("推广"),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/2.0x/order.png',
                width: Ui.width(65.0),
                height: Ui.width(55.0),
              ),
              activeIcon: Image.asset(
                'images/2.0x/orderselect.png',
                width: Ui.width(65.0),
                height: Ui.width(55.0),
              ),
              title: Text("订单"),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/2.0x/mall.png',
                width: Ui.width(65.0),
                height: Ui.width(55.0),
              ),
              activeIcon: Image.asset(
                'images/2.0x/mall_select.png',
                width: Ui.width(65.0),
                height: Ui.width(55.0),
              ),
              title: Text("兑换"),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                  'images/2.0x/material.png',
                  width: Ui.width(65),
                  height:Ui.width(55)
              ),
              activeIcon: Image.asset(
                'images/2.0x/material_select.png',
                width: Ui.width(65),
                height: Ui.width(55),
              ),
              title: Text('素材'),
            ),
            BottomNavigationBarItem(
                icon: Image.asset(
                  'images/2.0x/my.png',
                  width: Ui.width(65.0),
                  height: Ui.width(55.0),
                ),
                activeIcon: Image.asset(
                  'images/2.0x/myselect.png',
                  width: Ui.width(65.0),
                  height: Ui.width(55.0),
                ),
                title: Text("我的")),
          ],
        ));
  }
}