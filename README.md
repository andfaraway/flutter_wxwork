# flutter_wxwork

企业微信登录授权flutter插件

## 使用方式

```dart

final _flutterWxworkPlugin = FlutterWxwork();

/// 判断是否安装企业微信
bool isInstall = await _flutterWxworkPlugin.isAppInstalled();

/// 初始化（发起授权之前需先进行初始化）
var result = await _flutterWxworkPlugin.register(scheme: 'scheme', corpId: 'corpId', agentId: 'agentId');

/// 调起授权
var result = await _flutterWxworkPlugin.auth();
```

## iOS 配置

1.添加需要支持的白名单
ios/Runner/info.plist 增加 key：LSApplicationQueriesSchemes，添加 wxwork。

```html

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>wxwork</string>
</array>
```

2.在XCode中，选择你的工程设置项，选中“TARGETS”一栏，在“Info”标签栏的“URL Types”添加“URL Schemes”，其内容分别为你的scheme和corpId。

## Android 配置

### 若为android11以上，需要在 android/src/main/AndroidManifest.xml 中添加 <queries>标签

```html

<manifest package="com.example.app">
    ...
    // 在应用的AndroidManifest.xml添加如下
    <queries>标签
        <queries>
            <package android:name="com.tencent.wework"/>
            // 指定企业微信包名
        </queries>
        ...
</manifest>
```