import 'dart:ui';
import 'package:flutter/material.dart';
import '../ui/ui.dart';

/// 底部弹出框
class CommonBottomSheet extends StatefulWidget {
  CommonBottomSheet({Key key, this.list, this.onItemClickListener})
      : assert(list != null),
        super(key: key);
  final list;
  final OnItemClickListener onItemClickListener;
  @override
  _CommonBottomSheetState createState() => _CommonBottomSheetState();
}

typedef OnItemClickListener = void Function(int index);

class _CommonBottomSheetState extends State<CommonBottomSheet> {
  OnItemClickListener onItemClickListener;
  var itemCount;
  double itemHeight = Ui.width(100);
  var borderColor = Colors.white;
  double circular = 10;
  @override
  void initState() {
    super.initState();
    onItemClickListener = widget.onItemClickListener;
  }

  @override
  Widget build(BuildContext context) {
    Ui.init(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    Size screenSize = MediaQuery.of(context).size;

    var deviceWidth = orientation == Orientation.portrait
        ? screenSize.width
        : screenSize.height;
    /// *2-1是为了加分割线，最后还有一个cancel，所以加1
    itemCount = (widget.list.length * 2 - 1) + 1;
    var height = ((widget.list.length + 1) * Ui.width(110)).toDouble();
    var cancelContainer = Container(
        height: itemHeight,
        margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white, // 底色
          borderRadius: BorderRadius.circular(circular),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  "                            取消                            ",
                  style: TextStyle(
                      fontFamily: 'PingFangSC-Regular,PingFang SC',
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      color: Color(0xFF33AAF5),
                      fontSize: Ui.setFontSizeSetSp(34),),
                ),
              )),
        ));
    var listview = ListView.builder(
        itemCount: itemCount,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          if (index == itemCount - 1) {
            return new Container(
              child: cancelContainer,
              margin: const EdgeInsets.only(top: 10),
            );
          }
          return getItemContainer(context, index);
        });

    var totalContainer = Container(
      child: listview,
      height: height,
      width: deviceWidth * 0.98,
    );

    var stack = Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          bottom: 0,
          child: totalContainer,
        ),
      ],
    );
    return stack;
  }

  Widget getItemContainer(BuildContext context, int index) {
    if (widget.list == null) {
      return Container();
    }
    if (index.isOdd) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Divider(
          height: 0.5,
          color: borderColor,
        ),
      );
    }

    var borderRadius;
    var margin;
    var border;
    var borderAll = Border.all(color: borderColor, width: Ui.width(1));
    var borderSide = BorderSide(color: borderColor, width:Ui.width(1));
    var isFirst = false;
    var isLast = false;

    /// 只有一个元素
    if (widget.list.length == 1) {
      borderRadius = BorderRadius.circular(circular);
      margin = EdgeInsets.only(bottom: 10, left: 10, right: 10);
      border = borderAll;
    } else if (widget.list.length > 1) {
      /// 第一个元素
      if (index == 0) {
        isFirst = true;
        borderRadius = BorderRadius.only(
            topLeft: Radius.circular(circular),
            topRight: Radius.circular(circular));
        margin = EdgeInsets.only(
          left: 10,
          right: 10,
        );
        //  border =Border(left:BorderSide(color: Colors.white, width:Ui.width(1)));
        // border = Border(top: borderSide, left: borderSide, right: borderSide);
      } else if (index == itemCount - 2) {
        isLast = true;
        /// 最后一个元素
        borderRadius = BorderRadius.only(
            bottomLeft: Radius.circular(circular),
            bottomRight: Radius.circular(circular));
        margin = EdgeInsets.only(left: 10, right: 10);
        // border =Border(left:BorderSide(color: Colors.white, width:Ui.width(0)));
            // Border(bottom: borderSide);
      } else {
        /// 其他位置元素
        margin = EdgeInsets.only(left: 10, right: 10);
        border =Border(bottom: borderSide);
      }
    }
    var isFirstOrLast = isFirst || isLast;
    int listIndex = index ~/ 2;
    var text = widget.list[listIndex];
    var contentText = Text(
      text,
      style: TextStyle(
          fontFamily: 'PingFangSC-Regular,PingFang SC',
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
          color: Color(0xFF33AAF5),
          fontSize:  Ui.setFontSizeSetSp(34),),
    );

    var center;
    if (!isFirstOrLast) {
      center = Center(
        child: contentText,
      );
    }
    var itemContainer = Container(
        height: itemHeight,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white, // 底色
          borderRadius: borderRadius==null? BorderRadius.circular(0):borderRadius,
          border: border,
        ),
        child: center);
    var onTap2 = () {
      if (onItemClickListener != null) {
        onItemClickListener(index);
      }
    };
    var stack = Stack(
      alignment: Alignment.center,
      children: <Widget>[itemContainer, contentText],
    );
    var getsture = GestureDetector(
      onTap: onTap2,
      child: isFirstOrLast ? stack : itemContainer,
    );
    return getsture;
  }
}
