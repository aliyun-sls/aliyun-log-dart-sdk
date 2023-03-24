import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:aliyun_log_dart_sdk/aliyun_log_dart_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateFormat formatter = DateFormat('HH:mm:ss SSS');
  AliyunLogDartSdk? _aliyunLogSdk;
  String _consoleText = '';

  @override
  void initState() {
    super.initState();

    if (!mounted) return;
    print("application started.");
  }

  void print(String message) {
    setState(() {
      _consoleText += '${formatter.format(DateTime.now())}: ';
      _consoleText += message;
      _consoleText += '\n';
    });
  }

  void _initProducer() async {
    if (null != _aliyunLogSdk) {
      print('producer has been inited. please restart app.');
      return;
    }

    LogProducerConfiguration configuration = LogProducerConfiguration(
        endpoint: 'https://cn-hangzhou.log.aliyuncs.com',
        project: 'yuanbo-test-1',
        logstore: 'test');
    configuration.accessKeyId = '';
    configuration.accessKeySecret = '';

    _aliyunLogSdk = AliyunLogDartSdk();
    LogProducerResult result = await _aliyunLogSdk!.initProducer(configuration);
    print('init producer: ${result.name}');

    _aliyunLogSdk!
        .setLogCallback((resultCode, errorMessage, logBytes, compressedBytes) {
      // 参数配置错误，需要更新参数
      if (LogProducerResult.parametersInvalid == resultCode) {
        // 如更新 endpoint 配置
        _aliyunLogSdk!.setEndpoint('your endpoint');
        // AK 没有配置，或配置错误也会触发parametersInvalid
        _aliyunLogSdk!.setAccessKey(
            'your access key id', 'your access key secret',
            securityToken: 'your token');
      }
      // 授权过期，需要更新 AK
      if (LogProducerResult.sendUnauthorized == resultCode) {
        _aliyunLogSdk!.setAccessKey(
            'your access key id', 'your access key secret',
            securityToken: 'your token');
      }
      print('log send result: ${resultCode.name}');
    });
  }

  void _initProducerWithPersistent() async {
    if (null != _aliyunLogSdk) {
      print('producer has been inited. please restart app.');
      return;
    }
    LogProducerConfiguration configuration = LogProducerConfiguration(
        endpoint: 'https://cn-hangzhou.log.aliyuncs.com',
        project: 'yuanbo-test-1',
        logstore: 'test');
    configuration.accessKeyId = '';
    configuration.accessKeySecret = '';

    configuration.persistent = true; // 开启断点续传
    configuration.persistentFilePath = 'flutter/demo'; // binlog 缓存目录
    configuration.persistentForceFlush = false; // 关闭强制刷新，建议关闭，开启后会对性能产生一定的影响
    configuration.persistentMaxFileCount = 10; // 缓存文件数量，默认为 10
    configuration.persistentMaxFileSize = 1024 * 1024; // 单个缓存文件的大小，默认为 1MB
    configuration.persistentMaxLogCount = 64 * 1024; // 缓存日志的数量，默认为 64K

    _aliyunLogSdk = AliyunLogDartSdk();
    LogProducerResult result = await _aliyunLogSdk!.initProducer(configuration);
    print('init producer: ${result.name}');

    _aliyunLogSdk!
        .setLogCallback((resultCode, errorMessage, logBytes, compressedBytes) {
      print('log send result: ${resultCode.name}');
    });

    print('init producer success.');
  }

  void _sendLog() async {
    if (!check()) {
      return;
    }

    LogProducerResult result = await _aliyunLogSdk!.addLog({
      'str': 'str value',
      'int': 12,
      'double': 12.12,
      'boolean': true,
      'map': {'key': 'value', 'inntt': 3333},
      'array': ['a1', 'a2'],
      'null': null,
      'content': '中文'
    });
    print('add log resutlt: ${result.name}');
  }

  void _setEndpoint() async {
    if (!check()) {
      return;
    }

    await _aliyunLogSdk!.setEndpoint('https://cn-hangzhou.log.aliyuncs.com');
    await _aliyunLogSdk!.setProject('yuanbo-test-2');
    await _aliyunLogSdk!.setLogstore('test2');
    print('set endpoint/project/logstore success.');
  }

  void _setAccessKey() async {
    if (!check()) {
      return;
    }

    await _aliyunLogSdk!.setAccessKey('xxxxxxx', 'yyyyyyyyyyy');
    print('set accesskey success');
  }

  void _setSourceAndTopicAndTag() async {
    if (!check()) {
      return;
    }

    await _aliyunLogSdk!.setSource('flutter');
    await _aliyunLogSdk!.setTopic('flutter-test');
    await _aliyunLogSdk!.addTag('tag1', 'value1');
    await _aliyunLogSdk!.addTag('tag2', 'value2');
    print('set source/topic/tag success');
  }

  void _destroy() async {
    if (!check()) {
      return;
    }

    await _aliyunLogSdk!.destroy();
    print('destroy plugin success');
  }

  bool check() {
    if (null == _aliyunLogSdk) {
      print('you should init producer first.');
      return false;
    }
    return true;
  }

  void _updateConfiguration() async {
    LogProducerConfiguration configuration = LogProducerConfiguration();
    configuration.dropDelayLog = true;
    configuration.dropUnauthorizedLog = true;
    await _aliyunLogSdk!.updateConfiguration(configuration);
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SLS Plugin example app'),
        ),
        body: Column(
          children: [
            _buildConsoleText(),
            _buildButton(color, 'init', _initProducer),
            _buildButton(
                color, 'init with persistent', _initProducerWithPersistent),
            _buildButton(color, 'send', _sendLog),
            _buildButton(color, 'set endpoint/project/logstore', _setEndpoint),
            _buildButton(color, 'set accesskey', _setAccessKey),
            _buildButton(
                color, 'set source/topic/tag', _setSourceAndTopicAndTag),
            _buildButton(color, 'update configuration', _updateConfiguration),
            _buildButton(color, 'destroy', _destroy),
          ],
        ),
      ),
    );
  }

  Widget _buildConsoleText() {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(bottom: 18),
                padding: const EdgeInsets.all(6),
                height: 140,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.67,
                    ),
                    color: Colors.black),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    _consoleText,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        letterSpacing: 2,
                        wordSpacing: 2,
                        fontFeatures: [FontFeature.tabularFigures()]),
                  ),
                ),
              ))
        ]);
  }

  Widget _buildButton(Color color, String label, VoidCallback? onPressed) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextButton(
                  onPressed: onPressed,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                      side: MaterialStateProperty.all(
                          BorderSide(color: color, width: 0.67)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      padding: MaterialStateProperty.all(const EdgeInsets.only(
                          left: 12, top: 6, right: 12, bottom: 6))),
                  child: Text(
                    label,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: color),
                  )),
            )),
      ],
    );
  }
}
