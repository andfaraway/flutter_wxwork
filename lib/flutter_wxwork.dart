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

}



class AuthModel {
  /// 1.取消 0.成功 2.失败
  String? errCode;
  String? code;
  String? state;

  AuthModel();

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    AuthModel model = AuthModel();
    model.errCode = json['errCode'];
    model.code = json['errCode'];
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