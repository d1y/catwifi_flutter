import 'package:catwifi/config.dart';
import 'package:localstorage/localstorage.dart';

/// app LocalStorage
LocalStorage catWifiApp = new LocalStorage(CatWifiConfig.fsApp);

// /// 首次启动
// LocalStorage firstRunStorage = new LocalStorage(CatWifiConfig.firstRunKey);

// /// `wifi` 列表
// LocalStorage wifiLists = new LocalStorage(CatWifiConfig.wifiListKey);
