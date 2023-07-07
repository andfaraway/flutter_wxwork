import 'flutter_wxwork_method_channel.dart';
import 'flutter_wxwork_platform_interface.dart';

class FlutterWxwork {
  Future<bool> isAppInstalled() {
    return FlutterWxworkPlatform.instance.isAppInstalled();
  }

  Future<bool> register({required String scheme, required String corpId, required String agentId}) {
    return FlutterWxworkPlatform.instance.register(scheme: scheme, corpId: corpId, agentId: agentId);
  }

  Future<AuthModel> auth({String state = 'state'}) async {
    return FlutterWxworkPlatform.instance.auth(state: state);
  }
}
