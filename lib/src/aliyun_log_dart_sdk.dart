import 'package:aliyun_log_dart_sdk/src/log_producer_result.dart';
import 'log_producer_configuration.dart';
import 'platform/log_platform_interface.dart';

class AliyunLogDartSdk {
  AliyunLogDartSdk();

  Future<LogProducerResult> initProducer(
      LogProducerConfiguration configuration) async {
    var parameter = configuration.toMap();
    return await LogPlatform.instance.initProducer(parameter);
  }

  void setLogCallback(LogCallback callback) async {
    LogPlatform.instance.setLogCallback(callback);
  }

  Future<void> setEndpoint(String? endpoint) async {
    await LogPlatform.instance.setEndpoint(endpoint);
  }

  Future<void> setProject(String? project) async {
    await LogPlatform.instance.setProject(project);
  }

  Future<void> setLogstore(String? logstore) async {
    await LogPlatform.instance.setLogstore(logstore);
  }

  Future<void> setAccessKey(String? accessKeyId, String? accessKeySecret,
      {String? securityToken}) async {
    await LogPlatform.instance.setAccessKey(accessKeyId, accessKeySecret,
        securityToken: securityToken);
  }

  Future<void> setSource(String? soruce) async {
    await LogPlatform.instance.setSource(soruce);
  }

  Future<void> setTopic(String? topic) async {
    await LogPlatform.instance.setTopic(topic);
  }

  Future<void> addTag(String? key, String? value) async {
    await LogPlatform.instance.addTag(key, value);
  }

  Future<void> updateConfiguration(
      LogProducerConfiguration configuration) async {
    await LogPlatform.instance.updateConfiguration(configuration);
  }

  Future<void> destroy() async {
    await LogPlatform.instance.destroy();
  }

  Future<LogProducerResult> addLog(Map<String?, Object?> log) async {
    return LogPlatform.instance.addLog(log);
  }
}
