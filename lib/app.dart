import 'package:catwifi/wifi.dart';
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

  /// 修改 `wifi`
  void changeWifiFace(String str) {
    setState(() {
      wifiFace = Wifi.decode(str);
    });
    if (wifiFace.isFormat) {
      print("wifi名称: ${wifiFace.wifiName}");
      print("wifi密码: ${wifiFace.wifiPassword}");
      print("wifi类型: ${wifiFace.type}");
      print("wifi类型: ${wifiFace.isFormat}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${wifiFace.isFormat}'),
        centerTitle: true,
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: !wifiFace.isFormat
          ? Center(
              child: Image.asset(
                "images/pix.jpg",
                width: MediaQuery.of(context).size.width * .633,
              ),
            )
          : ListView(
              children: [
                ListTile(
                  title: Text(
                    wifiFace.wifiName,
                    style: TextStyle(color: Colors.green, fontSize: 14.2),
                  ),
                  leading: Text(
                    wifiFace.type,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.wavy,
                        decorationThickness: 1.8),
                  ),
                  trailing: Text(wifiFace.wifiPassword,
                      style: TextStyle(color: Colors.blue)),
                )
              ],
            ),
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 24.0),
                child: FloatingActionButton(
                    onPressed: () async {
                      var wifiStr = await scanner.scanPhoto();
                      changeWifiFace(wifiStr);
                    },
                    tooltip: "选择图片",
                    child: Icon(Icons.photo)),
              ),
              FloatingActionButton(
                  onPressed: () async {
                    String cameraScanResult = await scanner.scan();
                    changeWifiFace(cameraScanResult);
                  },
                  tooltip: "扫描图片",
                  child: Icon(Icons.photo_camera))
            ],
          )),
    );
  }
}
