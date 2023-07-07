package com.example.flutter_wxwork;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.tencent.wework.api.IWWAPI;
import com.tencent.wework.api.IWWAPIEventHandler;
import com.tencent.wework.api.WWAPIFactory;
import com.tencent.wework.api.model.BaseMessage;
import com.tencent.wework.api.model.WWAuthMessage;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FlutterWxworkPlugin
 */
public class FlutterWxworkPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    private String APPID;
    private String AGENTID;
    private String SCHEMA;

    private IWWAPI iwwapi;

    private Context context;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_wxwork");
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();
        iwwapi = WWAPIFactory.createWWAPI(context);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        @SuppressWarnings("unchecked")
        Map<String, String> arguments = (Map<String, String>) call.arguments;

        if (call.method.equals("isAppInstalled")) {
            boolean installed = iwwapi.isWWAppInstalled();
            if (installed) {
                result.success("1");
            } else {
                result.success("0");
            }
        } else if (call.method.equals("register")) {
            APPID = arguments.get("corpId");
            SCHEMA = arguments.get("scheme");
            AGENTID = arguments.get("agentId");
            boolean hasRegister = iwwapi.registerApp(SCHEMA);
            if (hasRegister) {
                result.success("1");
            } else {
                result.success("0");
            }
        } else if (call.method.equals("auth")) {
            String state = arguments.get("state");

            final WWAuthMessage.Req req = new WWAuthMessage.Req();
            req.sch = SCHEMA;
            req.appId = APPID;
            req.agentId = AGENTID;
            req.state = state;

//            Toast.makeText(context, "sch：" + req.sch,
//                    Toast.LENGTH_SHORT).show();

            iwwapi.sendMessage(req, new IWWAPIEventHandler() {
                @Override
                public void handleResp(BaseMessage resp) {
                    if (resp instanceof WWAuthMessage.Resp) {
                        WWAuthMessage.Resp rsp = (WWAuthMessage.Resp) resp;
                        Map<String, String> map = new HashMap<>();
                        map.put("code", rsp.code);
                        map.put("errCode", String.valueOf(rsp.errCode));
                        map.put("state", String.valueOf(rsp.state));
                        result.success(map);
                    }
                }
            });

        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
