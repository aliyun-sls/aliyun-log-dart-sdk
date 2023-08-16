import 'package:aliyun_log_dart_sdk/src/log_producer_result.dart';
import 'log_producer_configuration.dart';
import 'platform/log_platform_interface.dart';

class AliyunLogDartSdk {
  String _token = "";
  AliyunLogDartSdk();

  Future<LogProducerResult> initProducer(LogProducerConfiguration configuration) async {
    var parameter = configuration.toMap();
    // return await LogPlatform.instance.initProducer(parameter);
    Map<Object?, Object?>? res = await LogPlatform.instance.initProducer(parameter);

    if (null != res) {
      Map<Object?, Object?>? data = res['data'] as Map<Object?, Object?>;
      _token = data['token'].toString();
      return intToLogProducerResult(int.parse(res['code'].toString()));
    }
    return LogProducerResult.invalid;
  }

  void setLogCallback(LogCallback callback) async {
    LogPlatform.instance.setLogCallback(_token, callback);
  }

  Future<void> setEndpoint(String? endpoint) async {
    await LogPlatform.instance.setEndpoint(_token, endpoint);
  }

  Future<void> setProject(String? project) async {
    await LogPlatform.instance.setProject(_token, project);
  }

  Future<void> setLogstore(String? logstore) async {
    await LogPlatform.instance.setLogstore(_token, logstore);
  }

  Future<void> setAccessKey(String? accessKeyId, String? accessKeySecret, {String? securityToken}) async {
    await LogPlatform.instance.setAccessKey(_token, accessKeyId, accessKeySecret, securityToken: securityToken);
  }

  Future<void> setSource(String? soruce) async {
    await LogPlatform.instance.setSource(_token, soruce);
  }

  Future<void> setTopic(String? topic) async {
    await LogPlatform.instance.setTopic(_token, topic);
  }

  Future<void> addTag(String? key, String? value) async {
    await LogPlatform.instance.addTag(_token, key, value);
  }

  Future<void> updateConfiguration(LogProducerConfiguration configuration) async {
    await LogPlatform.instance.updateConfiguration(_token, configuration);
  }

  Future<void> destroy() async {
    await LogPlatform.instance.destroy(_token);
  }

  Future<LogProducerResult> addLog(Map<String?, Object?> log) async {
    return LogPlatform.instance.addLog(_token, log);
  }
}
