import 'package:catwifi/body.dart';
import 'package:catwifi/config.dart';
import 'package:catwifi/fs.dart';
import 'package:catwifi/utils.dart';
import 'package:catwifi/wifi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  Wifi wifiFace = Wifi.decode("");

  WifiList wifiList = new WifiList();

  /// 初始化
  bool initialized = false;

  /// 修改 `wifi`
  void addWifiFace(String str) {
    setState(() {
      wifiFace = Wifi.decode(str);
      if (wifiFace.isFormat) {
        WifiItem item = WifiItem(
            wifiName: wifiFace.wifiName,
            wifiPassword: wifiFace.wifiPassword,
            type: wifiFace.type);
        var isAdd = true;
        wifiList.items.forEach((element) {
          if (wifiFace.wifiName == element.wifiName) {
            isAdd = false;
          }
        });
        if (isAdd) {
          wifiList.items.add(item);
          saveToStorage();
        }
        print("wifi名称: ${wifiFace.wifiName}");
        print("wifi密码: ${wifiFace.wifiPassword}");
        print("wifi类型: ${wifiFace.type}");
      }
    });
  }

  /// 保存数据
  void saveToStorage() {
    var x = wifiList.toJSONEncodable();
    catWifiApp.setItem(CatWifiConfig.fsApp, x);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('catwifi'),
        centerTitle: true,
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: FutureBuilder(
        future: catWifiApp.ready,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return catWifiEmpty(context);
          }
          var items = catWifiApp.getItem(CatWifiConfig.wifiListKey);
          if (!initialized) {
            if (items != null) {
              wifiList.items = List<WifiItem>.from(
                (items as List).map(
                  (item) => WifiItem(
                    wifiName: item['wifiName'],
                    wifiPassword: item['wifiPassword'],
                    type: item['type'],
                  ),
                ),
              );
              initialized = true;
            }
          }
          return CatWifiBody(
            lists: wifiList,
            onClick: (item) {
              var pwd = item.wifiPassword;
              Utils.setClipboardText(pwd);
              showCupertinoDialog(
                  context: context,
                  builder: (ctx) {
                    return CupertinoAlertDialog(
                      title: Text("已复制wifi密码"),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop("remove dialog");
                          },
                          child: Text("我知道了"),
                        )
                      ],
                    );
                  });
            },
          );
        },
      ),
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlatButton.icon(
                  onPressed: () async {
                    var wifiStr = await scanner.scanPhoto();
                    addWifiFace(wifiStr);
                  },
                  color: Colors.blue,
                  highlightColor: Colors.blue[700],
                  colorBrightness: Brightness.dark,
                  splashColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  icon: Icon(Icons.photo),
                  label: Text(
                    "选择图片",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
              SizedBox(
                width: 16,
              ),
              FlatButton.icon(
                  onPressed: () async {
                    String cameraScanResult = await scanner.scan();
                    addWifiFace(cameraScanResult);
                  },
                  color: Colors.blue,
                  highlightColor: Colors.blue[700],
                  colorBrightness: Brightness.dark,
                  splashColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  icon: Icon(Icons.photo),
                  label: Text(
                    "扫描图片",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ))
            ],
          )),
    );
  }
}
