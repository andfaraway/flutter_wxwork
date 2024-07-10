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
  
  Future<bool> sendReq(TextAttachment? text, FileAttachment? file, LinkAttachment? link) async {
    if (text == null && file == null && link == null) {
      assert(false, '发了个寂寞🐣');
      return Future<bool>.value(false);
    }

    if (text != null) {
      final result = await methodChannel.invokeMethod('sendReq', text.toJson());
      return _stringToBool(result);
    }
    if (file != null) {
      final result = await methodChannel.invokeMethod('sendReq', file.toJson());
      return _stringToBool(result);
    }
    if (link != null) {
      final result = await methodChannel.invokeMethod('sendReq', link.toJson());
      return _stringToBool(result);
    }
    return Future<bool>.value(false);
  }
}



class AuthModel {
  /// 1.取消 0.成功 2.失败
  String? errCode;
  String? code;
  String? state;

  bool get isSuccess =>  errCode == '1';
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



class TextAttachment {
  static const int type = 1;
  String? text;

  Map<String, dynamic> toJson() =>
    <String, dynamic>{'text': text, 'type': type};

}

//文件、图片、视频
class FileAttachment {
  static const int type = 2;
  FileAttachment({required this.data});
  Uint8List data;
  Map toJson() => {'data': data, };
}

//文件、图片、视频
class LinkAttachment {
  static const int type = 2;
  String? title;//不能超过512bytes
  String? summary;//不能超过1k
  String? url;
  String? iconurl;
  String? icon;
  int? withShareTicket;
  String? shareTicketState;

  Map<String, dynamic> toJson() =>
    <String, dynamic>{'title': title, 'summary': summary, 'url': url, 'iconurl': iconurl, 'icon': icon, 'withShareTicket': withShareTicket, 'shareTicketState': shareTicketState, 'type': type};

}