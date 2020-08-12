import 'package:flutter/services.dart';

/// 公共方法
class Utils {
  /// 设置剪贴板文字
  static setClipboardText(String cp) {
    Clipboard.setData(
      ClipboardData(text: cp)
    );
  }
}
