import 'package:aliyun_log_dart_sdk/src/log_producer_configuration.dart';
import 'package:aliyun_log_dart_sdk/src/log_producer_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'log_platform_interface.dart';

class LogMethodChannelPlatform extends LogPlatform {
  @visibleForTesting
  final channel = const MethodChannel('aliyun_sls/flutter_sdk');

  LogCallback? _callback;

  Future<void> _handleMessage(MethodCall call) async {
    if (call.method == 'on_send_done') {
      if (null == _callback) {
        return;
      }

      int resultCode = call.arguments['code'];
      String? errorMessage = call.arguments['errorMessage'];
      int logBytes = call.arguments['logBytes'];
      int compressedBytes = call.arguments['compressedBytes'];
      _callback!(intToLogProducerResult(resultCode), errorMessage, logBytes, compressedBytes);
    }
  }

  @override
  Future<Map<Object?, Object?>?> initProducer(Map<String?, Object?> parameter) async {
    return await channel.invokeMethod<Map<Object?, Object?>?>("initProducer", parameter);
  }

  @override
  Future<void> setLogCallback(String token, LogCallback callback) async {
    _callback = callback;
    channel.setMethodCallHandler(_handleMessage);
  }

  @override
  Future<void> setEndpoint(String token, String? endpoint) async {
    await channel.invokeMethod('setEndpoint', {'token': token, 'endpoint': endpoint});
  }

  @override
  Future<void> setProject(String token, String? project) async {
    await channel.invokeMethod('setProject', {'token': token, 'project': project});
  }

  @override
  Future<void> setLogstore(String token, String? logstore) async {
    await channel.invokeMethod('setLogstore', {'token': token, 'logstore': logstore});
  }

  @override
  Future<void> setAccessKey(String token, String? accessKeyId, String? accessKeySecret, {String? securityToken}) async {
    await channel.invokeMethod('setAccessKey', {
      'token': token,
      'accessKeyId': accessKeyId,
      'accessKeySecret': accessKeySecret,
      'securityToken': securityToken
    });
  }

  @override
  Future<void> setSource(String token, String? source) async {
    await channel.invokeMethod('setSource', {'token': token, 'source': source});
  }

  @override
  Future<void> setTopic(String token, String? topic) async {
    await channel.invokeMethod('setTopic', {'token': token, 'topic': topic});
  }

  @override
  Future<void> addTag(String token, String? key, String? value) async {
    await channel.invokeMethod('addTag', {
      'token': token,
      'tags': {key: value}
    });
  }

  @override
  Future<void> destroy(String token) async {
    await channel.invokeMethod('destroy', {'token': token});
  }

  @override
  Future<LogProducerResult> addLog(String token, Map<String?, Object?> parameter) async {
    Map res = await channel.invokeMethod('addLog', {'token': token, 'log': parameter});
    return intToLogProducerResult(res['code']);
  }

  @override
  Future<void> updateConfiguration(String token, LogProducerConfiguration configuration) async {
    Map<String, Object?> arguments = configuration.toMap();
    arguments.putIfAbsent("token", () => token);
    await channel.invokeMethod('updateConfiguration', arguments);
  }
}
