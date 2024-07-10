#import "FlutterWxworkPlugin.h"

@implementation FlutterWxworkPlugin

FlutterMethodChannel *channel;
FlutterResult authResult;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_wxwork"
            binaryMessenger:[registrar messenger]];
  FlutterWxworkPlugin* instance = [[FlutterWxworkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  [registrar addApplicationDelegate:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if([@"isAppInstalled" isEqualToString:call.method]){
      NSString *str = [NSString stringWithFormat:@"%hhd",[WWKApi isAppInstalled]];
      result(str);
   }else if ([@"register" isEqualToString:call.method]) {
     NSDictionary *dic = call.arguments;
     NSString *scheme = dic[@"scheme"];
     NSString *corpId = dic[@"corpId"];
     NSString *agentId = dic[@"agentId"];
     result([NSString stringWithFormat:@"%hhd",[WWKApi registerApp:scheme corpId:corpId agentId:agentId]]);
  } else if ([@"auth" isEqualToString:call.method]){
     WWKSSOReq *req = [[WWKSSOReq alloc] init];
     // state参数为这次请求的唯一标示，客户端需要维护其唯一性。SSO回调时会原样返回
     req.state = call.arguments[@"state"];
     [WWKApi sendReq:req];
     authResult = result;
  } else if ([@"sendReq" isEqualToString:call.method]) {
      if (call.arguments) {
          NSDictionary *dic = call.arguments;
          if (dic[@"type"]) {
              NSInteger type = [dic[@"type"] intValue];
              if (type == 1) {
                  WWKSendMessageReq * req = [[WWKSendMessageReq alloc] init];
                  WWKMessageTextAttachment * text = [[WWKMessageTextAttachment alloc] init];
                  text.text = dic[@"text"];
                  req.attachment = text;
                  [WWKApi sendReq:req];
                  authResult = result;
              } else if (type == 2) {
                  if ([dic[@"data"] isKindOfClass:FlutterStandardTypedData.class]) {
                      FlutterStandardTypedData *imageData = dic[@"data"];
                      WWKSendMessageReq * req = [[WWKSendMessageReq alloc] init];
                      WWKMessageFileAttachment * file = [[WWKMessageFileAttachment alloc] init];
                      file.data = imageData.data;
                      req.attachment = file;
                      [WWKApi sendReq:req];
                      authResult = result;
                  }else{
                      result(@"0");
                  }
              } else if (type == 3) {
                  WWKSendMessageReq * req = [[WWKSendMessageReq alloc] init];
                  WWKMessageLinkAttachment * link = [[WWKMessageLinkAttachment alloc] init];
                  link.title = dic[@"title"];
                  link.summary = dic[@"summary"];
                  link.url = dic[@"url"];
                  link.iconurl = dic[@"iconurl"];
                  link.icon = dic[@"icon"];
                  link.withShareTicket = dic[@"withShareTicket"];
                  link.shareTicketState = dic[@"shareTicketState"];
                  req.attachment = link;
                  [WWKApi sendReq:req];
                  authResult = result;
              }else{
                  result(@"0");
              }
          }else{
              result(@"0");
          }
      }else{
          result(@"0");
      }
  }
}


- (void)onResp:(WWKBaseResp *)resp {
    /*! @brief 所有通过sendReq发送的SDK请求的结果都在这个函数内部进行异步回调
     * @param resp SDK处理请求后的返回结果 需要判断具体是哪项业务的回调
     */
    /* SSO的回调 */
    if ([resp isKindOfClass:[WWKSSOResp class]]) {
        WWKSSOResp *r = (WWKSSOResp *)resp;
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc]init];
        if([self isBlankString:r.code]){
              [mDic setObject:@"1" forKey:@"errCode"];
              [mDic setObject:@"" forKey:@"code"];
        }else{
             [mDic setObject:@"0" forKey:@"errCode"];
             [mDic setObject:r.code forKey:@"code"];
        }
        [mDic setObject:r.state forKey:@"state"];
        authResult(mDic);
       // [channel invokeMethod:@"auth" arguments:mDic];
    }

}


#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    return [WWKApi handleOpenURL:url delegate:self];
}

- (BOOL)isBlankString:(NSString *)string{

    if (string == nil) {

        return YES;

    }

    if (string == NULL) {

        return YES;

    }

    if ([string isKindOfClass:[NSNull class]]) {

        return YES;

    }

    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {

        return YES;

    }

    return NO;

}
@end
