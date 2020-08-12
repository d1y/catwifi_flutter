import 'package:catwifi/wifi.dart';
import 'package:flutter/material.dart';

class CatWifiBody extends StatelessWidget {
  CatWifiBody({this.lists, this.onClick});

  final WifiList lists;
  
  final Function(WifiItem) onClick;

  @override
  Widget build(BuildContext context) {
    if (lists == null) return catWifiEmpty(context);
    if (lists.items.length == 0) {
      return catWifiEmpty(context);
    } else {
      return ListView(
        children: lists.items.map((item) {
          return ListTile(
            onLongPress: () {
              onClick(item);
            },
            title: Text(
              item.wifiName,
              style: TextStyle(color: Colors.green, fontSize: 14.2),
            ),
            leading: Text(
              item.type,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.wavy,
                  decorationThickness: 1.8),
            ),
            trailing:
                Text(item.wifiPassword, style: TextStyle(color: Colors.blue)),
          );
        }).toList(),
      );
    }
  }
}

/// 当数据为空
Widget catWifiEmpty(BuildContext ctx) {
  return Center(
    child: Image.asset(
      "images/pix.jpg",
      width: MediaQuery.of(ctx).size.width * .633,
    ),
  );
}
