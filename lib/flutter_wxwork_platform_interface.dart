import 'dart:convert';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_wxwork_method_channel.dart';

abstract class FlutterWxworkPlatform extends PlatformInterface {
  /// Constructs a FlutterWxworkPlatform.
  FlutterWxworkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterWxworkPlatform _instance = MethodChannelFlutterWxwork();

  /// The default instance of [FlutterWxworkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterWxwork].
  static FlutterWxworkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterWxworkPlatform] when
  /// they register themselves.
  static set instance(FlutterWxworkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> isAppInstalled() {
    throw UnimplementedError('isAppInstalled() has not been implemented.');
  }

  Future<AuthModel> auth({required String state}) async {
    throw UnimplementedError('auth() has not been implemented.');
  }

  Future<bool> register({required String scheme, required String corpId, required String agentId}) {
    throw UnimplementedError('auth() has not been implemented.');
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
