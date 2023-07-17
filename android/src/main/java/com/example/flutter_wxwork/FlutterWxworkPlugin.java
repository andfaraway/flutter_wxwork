package com.example.flutter_wxwork;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;

import com.tencent.wework.api.IWWAPI;
import com.tencent.wework.api.IWWAPIEventHandler;
import com.tencent.wework.api.WWAPIFactory;
import com.tencent.wework.api.model.BaseMessage;
import com.tencent.wework.api.model.WWAuthMessage;
import com.tencent.wework.api.model.WWMediaFile;
import com.tencent.wework.api.model.WWMediaImage;
import com.tencent.wework.api.model.WWMediaLink;
import com.tencent.wework.api.model.WWMediaText;
import com.tencent.wework.api.model.WWMediaVideo;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

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
        switch (call.method) {
            case "isAppInstalled":
                boolean installed = iwwapi.isWWAppInstalled();
                if (installed) {
                    result.success("1");
                } else {
                    result.success("0");
                }
                break;
            case "register":
                APPID = call.argument("corpId");
                SCHEMA = call.argument("scheme");
                AGENTID = call.argument("agentId");
                boolean hasRegister = iwwapi.registerApp(SCHEMA);
                if (hasRegister) {
                    result.success("1");
                } else {
                    result.success("0");
                }
                break;
            case "auth":
                String state = call.argument("state");

                final WWAuthMessage.Req req = new WWAuthMessage.Req();
                req.sch = SCHEMA;
                req.appId = APPID;
                req.agentId = AGENTID;
                req.state = state;

                iwwapi.sendMessage(req, resp -> {
                    if (resp instanceof WWAuthMessage.Resp) {
                        WWAuthMessage.Resp rsp = (WWAuthMessage.Resp) resp;
                        Map<String, String> map = new HashMap<>();
                        map.put("code", rsp.code);
                        map.put("errCode", String.valueOf(rsp.errCode));
                        map.put("state", String.valueOf(rsp.state));
                        result.success(map);
                    }
                });
                break;
            case "share":
                String packageName = context.getPackageName();
                String appName;
                try {
                    ApplicationInfo info = context.getPackageManager().getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA);
                    appName = info.loadLabel(context.getPackageManager()).toString();
                } catch (Exception e) {
                    result.success("0");
                    return;
                }

                String type = call.argument("type");
                if (Objects.equals(type, "text")) {
                    WWMediaText txt = new WWMediaText(call.argument("text"));
                    txt.appPkg = packageName;
                    txt.appName = appName;
                    txt.appId = APPID; //企业唯一标识。创建企业后显示在，我的企业 CorpID字段
                    txt.agentId = AGENTID; //应用唯一标识。显示在具体应用下的 AgentId字段
                    iwwapi.sendMessage(txt, resp -> {
                        if (resp instanceof WWMediaText) {
                            result.success("1");
                        }
                    });
                    break;
                } else if (Objects.equals(type, "image")) {
                    byte[] data = call.argument("data");
                    WWMediaFile file = new WWMediaImage();
                    file.fileName = call.argument("name");
//                    file.filePath = call.argument("path");
                    file.fileData = data;
                    file.appPkg = packageName;
                    file.appName = appName;
                    file.appId = APPID; //企业唯一标识。创建企业后显示在，我的企业 CorpID字段
                    file.agentId = AGENTID; //应用唯一标识。显示在具体应用下的 AgentId字段
                    iwwapi.sendMessage(file, resp -> {
                        if (resp instanceof WWMediaFile) {
                            result.success("1");
                        }
                    });
                } else if (Objects.equals(type, "video")) {
                    byte[] data = call.argument("data");
                    WWMediaVideo file = new WWMediaVideo();
                    file.fileName = call.argument("name");
                  //  file.filePath = call.argument("path");
                    file.fileData = data;
                    file.appPkg = packageName;
                    file.appName = appName;
                    file.appId = APPID; //企业唯一标识。创建企业后显示在，我的企业 CorpID字段
                    file.agentId = AGENTID; //应用唯一标识。显示在具体应用下的 AgentId字段
                    iwwapi.sendMessage(file, resp -> {
                        if (resp instanceof WWMediaVideo) {
                            result.success("1");
                        }
                    });
                } else if (Objects.equals(type, "file")) {
                    byte[] data = call.argument("data");
                    WWMediaFile file = new WWMediaFile();
                    file.fileName = call.argument("name");
                    // file.filePath = call.argument("path");
                    file.fileData = data;
                    file.appPkg = packageName;
                    file.appName = appName;
                    file.appId = APPID; //企业唯一标识。创建企业后显示在，我的企业 CorpID字段
                    file.agentId = AGENTID; //应用唯一标识。显示在具体应用下的 AgentId字段
                    iwwapi.sendMessage(file, resp -> {
                        if (resp instanceof WWMediaFile) {
                            result.success("1");
                        }
                    });
                } else if (Objects.equals(type, "link")) {
                    WWMediaLink link = new WWMediaLink();
                    link.thumbUrl = call.argument("icon");
                    link.webpageUrl = call.argument("url");
                    link.title = call.argument("title");
                    link.description = call.argument("summary");
                    link.appPkg = packageName;
                    link.appName = appName;
                    link.appId = APPID; //企业唯一标识。创建企业后显示在，我的企业 CorpID字段
                    link.agentId = AGENTID; //应用唯一标识。显示在具体应用下的 AgentId字段
                    iwwapi.sendMessage(link, resp -> {
                        if (resp instanceof WWMediaLink) {
                            result.success("1");
                        }
                    });
                }
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
