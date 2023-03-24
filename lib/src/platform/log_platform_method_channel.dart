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
      _callback!(LogProducerResult.fromInt(resultCode), errorMessage, logBytes, compressedBytes);
    }
  }

  @override
  Future<LogProducerResult> initProducer(Map<String?, Object?> parameter) async {
    Map<Object?, Object?>? res = await channel.invokeMethod<Map<Object?, Object?>?>("initProducer", parameter);

    if (null != res) {
      return LogProducerResult.fromInt(int.parse(res['code'].toString()));
    }
    return LogProducerResult.invalid;
  }

  @override
  Future<void> setLogCallback(LogCallback callback) async {
    _callback = callback;
    channel.setMethodCallHandler(_handleMessage);
  }

  @override
  Future<void> setEndpoint(String? endpoint) async {
    await channel.invokeMethod('setEndpoint', {'endpoint': endpoint});
  }

  @override
  Future<void> setProject(String? project) async {
    await channel.invokeMethod('setProject', {'project': project});
  }

  @override
  Future<void> setLogstore(String? logstore) async {
    await channel.invokeMethod('setLogstore', {'logstore': logstore});
  }

  @override
  Future<void> setAccessKey(String? accessKeyId, String? accessKeySecret, {String? securityToken}) async {
    await channel.invokeMethod('setAccessKey',
        {'accessKeyId': accessKeyId, 'accessKeySecret': accessKeySecret, 'securityToken': securityToken});
  }

  @override
  Future<void> setSource(String? source) async {
    await channel.invokeMethod('setSource', {'source': source});
  }

  @override
  Future<void> setTopic(String? topic) async {
    await channel.invokeMethod('setTopic', {'topic': topic});
  }

  @override
  Future<void> addTag(String? key, String? value) async {
    await channel.invokeMethod('addTag', {
      'tags': {key: value}
    });
  }

  @override
  Future<void> destroy() async {
    await channel.invokeMethod('destroy');
  }

  @override
  Future<LogProducerResult> addLog(Map<String?, Object?> parameter) async {
    Map res = await channel.invokeMethod('addLog', {'log': parameter});
    return LogProducerResult.fromInt(res['code']);
  }

  @override
  Future<void> updateConfiguration(LogProducerConfiguration configuration) async {
    await channel.invokeMethod('updateConfiguration', configuration.toMap());
  }
}
