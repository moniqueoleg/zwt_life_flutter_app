import 'package:flutter/material.dart';
import 'package:zwt_life_flutter_app/common/style/GlobalStyle.dart';
import 'package:zwt_life_flutter_app/common/utils/NavigatorUtils.dart';
class HomeTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;
    return Container(
      color: GlobalColors.ThemeColor,
      padding: EdgeInsets.only(
          top: statusBarHeight, left: 10, right: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                NavigatorUtils.goSearchPage(context);
              },
              child: Container(
                height: 34.0,
                padding: EdgeInsets.all(5.0),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.search,
                        color: Color(0xFF979797),
                        size: 22,
                      ),
                    ),
                    Text(
                      "搜索商品",
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Color(0xFF979797),
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 6.0),
            child: Icon(
              Icons.add_alert,
              size: 25.0,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

}