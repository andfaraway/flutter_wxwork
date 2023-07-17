import 'dart:convert';
import 'package:flutter/services.dart';

class FlutterWxwork {
  final methodChannel = const MethodChannel('flutter_wxwork');

  Future<bool> isAppInstalled() async {
    final result = await methodChannel.invokeMethod<String>('isAppInstalled');
    return _stringToBool(result);
  }

  Future<bool> register({required String scheme, required String corpId, required String agentId}) async {
    String? result = await methodChannel.invokeMethod<String>('register', <String, String>{
      'scheme': scheme,
      'corpId': corpId,
      'agentId': agentId,
    });
    return _stringToBool(result);
  }

  Future<AuthModel> auth({String state = 'state'}) async {
    var content = await methodChannel.invokeMethod('auth', {"state": state});
    return AuthModel.fromJson(Map<String, dynamic>.from(content));
  }

  bool _stringToBool(String? string) {
    if (string == '1') {
      return true;
    } else {
      return false;
    }
  }

  void shareText(String text) {
    if (text.trim().isEmpty) {
      assert(false, 'text is empty!');
    }
    methodChannel.invokeMethod('share', {
      'type': ShareType.text.value,
      'text': text,
    });
  }

  void shareImage({
    String? name,
    required Uint8List data,
  }) {
    methodChannel.invokeMethod('share', {
      'type': ShareType.image.value,
      'name': name,
      'data': data,
    });
  }

  void shareLink({
    required String title,
    required String summary,
    required String url,
    String? icon,
  }) {
    if (url.trim().isEmpty) {
      assert(false, 'url is empty!');
    }
    methodChannel.invokeMethod('share', {
      'type': ShareType.link.value,
      'title': title,
      'summary': summary,
      'url': url,
      'icon': icon,
    });
  }
}

class AuthModel {
  /// 1.取消 0.成功 2.失败
  String? errCode;
  String? code;
  String? state;

  bool get isSuccess => errCode == '1';

  AuthModel();

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    AuthModel model = AuthModel();
    model.errCode = json['errCode'];
    model.code = json['code'];
    model.state = json['state'];
    return model;
  }

  Map<String, dynamic> toJson() {
    return {'errorCode': errCode, 'code': code, 'state': state};
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}

enum ShareType {
  text,
  image,
  video,
  link,
}

extension _ShareTypeEx on ShareType {
  String get value => toString().split('.').last;
}
