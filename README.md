# [flutter_wxwork](https://pub.dev/packages/flutter_wxwork)

企业微信flutter插件

- ✅ 登录授权
- ✅ 分享


## 使用方式

```dart  
import 'package:flutter_wxwork/flutter_wxwork.dart';  
  
final _flutterWxworkPlugin = FlutterWxwork();  
  
/// 判断是否安装企业微信  
bool isInstall = await _flutterWxworkPlugin.isAppInstalled();  
  
/// 初始化（发起授权之前需先进行初始化）  
final result = await _flutterWxworkPlugin.register(scheme: 'scheme', corpId: 'corpId', agentId:'agentId');  
  
/// 调起授权  
final result = await _flutterWxworkPlugin.auth();

/// 分享
_flutterWxworkPlugin.shareText('hello world');
```  

## iOS 配置

1.添加需要支持的白名单  
```ios/Runner/info.plist``` 增加 key：LSApplicationQueriesSchemes，添加 wxwork。

```html  
  
<key>LSApplicationQueriesSchemes</key>  
<array>  
<string>wxwork</string>  
</array>  
```  

2.在XCode中，选择你的工程设置项，选中“TARGETS”一栏，在“Info”标签栏的“URL Types”添加“URL Schemes”，其内容分别为你的`scheme`和`corpId`。


若报错：+[NSData wwkapi_nilobj]

可打开XCode打开项目，``TARGETS -> Runner -> Build Settings -> Other Linker Flags``添加
```html  
$(inherited) -ObjC -l"WXWorkApi"  
```  

## Android 配置

### 若为android11以上，在 ```android/src/main/AndroidManifest.xml``` 中添加 <queries> 标签

```html  
<queries>  
<package android:name="com.tencent.wework" /> // 指定企业微信包名  
</queries>  
```  

### 如果需要混淆代码(release模式默认混淆)，需要在`android/app`目录下加上 proguard-rules.pro 文件
```html  
-keep class com.tencent.wework.api.** {*;}  
```  

### 网页端安卓签名获取
[安卓签名工具](https://dldir1.qq.com/qqcontacts/Gen_Signature_Android.apk)


如果对你有帮助,不吝给个start~ 谢谢佬们