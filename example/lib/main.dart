import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wxwork/flutter_wxwork.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterWxworkPlugin = FlutterWxwork();

  late BuildContext _builderContext;

  bool isRegister = false;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Builder(builder: (context) {
            _builderContext = context;
            return Column(
              children: [
                _titleCell(
                    title: 'isAppInstalled',
                    onTap: () async {
                      bool isInstall =
                          await _flutterWxworkPlugin.isAppInstalled();
                      _showMessage('isInstall = $isInstall');
                    }),
                _titleCell(
                    title: 'register',
                    onTap: () async {
                      isRegister = await _flutterWxworkPlugin.register(
                          scheme: 'wwauth8f1e80541af434bd000002',
                          corpId: 'ww8f1e80541af434bd',
                          agentId: '1000002');
                      _showMessage('register = $isRegister');
                      setState(() {});
                    }),
                if (isRegister)
                  Column(
                    children: [
                      _titleCell(
                        title: 'auth',
                        onTap: () async {
                          var result = await _flutterWxworkPlugin.auth();
                          _showMessage('auth = $result');
                        },
                        color: Colors.green,
                      ),
                      _titleCell(
                          title: 'share text',
                          onTap: () async {
                            _flutterWxworkPlugin.shareText('text');
                          }),
                      _titleCell(
                          title: 'share image',
                          onTap: () async {
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (image == null) {
                              return;
                            }
                            Uint8List data = File(image.path).readAsBytesSync();
                            _flutterWxworkPlugin.shareImage(
                                name: 'name', data: data);
                          }),
                      _titleCell(
                          title: 'share link',
                          onTap: () async {
                            _flutterWxworkPlugin.shareLink(
                                title: 'example',
                                summary: 'this is test',
                                url: 'https://libin.zone',
                                icon:
                                    'https://libin.zone/src/wechat_awatar.png');
                          }),
                    ],
                  )
              ],
            );
          })),
    );
  }

  Widget _titleCell(
      {required String title, void Function()? onTap, Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40,
          width: double.infinity,
          color: color ?? Colors.grey,
          child: Center(
              child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          )),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    if (!_builderContext.mounted) return;
    ScaffoldMessenger.maybeOf(_builderContext)?.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    ));
  }
}
