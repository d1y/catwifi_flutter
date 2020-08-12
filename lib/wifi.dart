/// create by d1y<chenhonzhou@gmail.com>
/// https://github.com/d1y/cat_wifi/blob/master/decode.go

class WifiList {

  /// 列表
  List<WifiItem> items;

  WifiList() {
    items = List();
  }

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }

}

class WifiItem {
  /// `wifi` ssid 名称
  String wifiName;

  /// `wifi` 密码
  String wifiPassword;

  /// `wifi` 类型
  String type;

  WifiItem({this.wifiName, this.wifiPassword, this.type});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['wifiName'] = wifiName;
    m['wifiPassword'] = wifiPassword;
    m['type'] = type;

    return m;
  }
}

/// `wifi` 解密
class Wifi {
  // 解码
  Wifi.decode(String wifiStr) {
    try {
      // T:WPA;S:FAST_TEST;P:6666
      var x1 = "WIFI:";
      var x2 = ";;";

      /// 原始长度
      var rawLength = wifiStr.length;

      /// 最小的长度
      var decodeMinLength = x1.length + x2.length;

      /// 偏移值索引
      var offsetIndex = wifiStr.lastIndexOf(x2);

      /// 偏移值
      var offset = rawLength - offsetIndex;
      isFormat = rawLength > decodeMinLength &&
          wifiStr.indexOf(x1) == 0 &&
          offset == 2;
      // print(isFormat);
      if (!isFormat) return;
      var R = wifiStr.substring(x1.length, offsetIndex);
      // T:WPA;S:FAST_TEST;P:6666
      // print(R);
      var rs = R.split(";");
      type = rs[0].substring(2);
      wifiName = rs[1].substring(2);
      wifiPassword = rs[2].substring(2);
    } catch (e) {
      isFormat = false;
    }
  }

  /// `wifi` 名称
  String wifiName = "";

  /// `wifi` 密码
  String wifiPassword = "";

  /// `wifi` 加密方式..
  String type = "";

  /// 格式是否正确
  bool isFormat = false;
}
