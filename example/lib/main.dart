import 'package:flutter/material.dart';
import 'package:flutter_wxwork/flutter_wxwork.dart';

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
                      bool isInstall = await _flutterWxworkPlugin.isAppInstalled();
                      _showMessage('isInstall = $isInstall');
                    }),
                _titleCell(
                    title: 'register',
                    onTap: () async {
                      var result = await _flutterWxworkPlugin.register(
                          scheme: 'wwauth7b44fc449ab4eabd000045', corpId: 'ww7b44fc449ab4eabd', agentId: '1000045');
                      _showMessage('register = $result');
                    }),
                _titleCell(
                    title: 'auth',
                    onTap: () async {
                      var result = await _flutterWxworkPlugin.auth();
                      _showMessage('auth = $result');
                      print('result=$result,errCode=${result.code}');
                    }),
              ],
            );
          })),
    );
  }

  Widget _titleCell({required String title, void Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40,
          width: double.infinity,
          color: Colors.grey,
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
