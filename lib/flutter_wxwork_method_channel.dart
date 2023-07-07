import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_wxwork_platform_interface.dart';

/// An implementation of [FlutterWxworkPlatform] that uses method channels.
class MethodChannelFlutterWxwork extends FlutterWxworkPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_wxwork');

  @override
  Future<bool> isAppInstalled() async {
    final result = await methodChannel.invokeMethod<String>('isAppInstalled');
    return _stringToBool(result);
  }

  @override
  Future<bool> register({required String scheme, required String corpId, required String agentId}) async {
    String? result = await methodChannel.invokeMethod<String>('register', <String, String>{
      'scheme': scheme,
      'corpId': corpId,
      'agentId': agentId,
    });
    return _stringToBool(result);
  }

  @override
  Future<AuthModel> auth({required String state}) async {
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
