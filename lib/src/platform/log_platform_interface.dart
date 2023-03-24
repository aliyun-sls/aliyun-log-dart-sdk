import 'package:aliyun_log_dart_sdk/aliyun_log_dart_sdk.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'log_platform_method_channel.dart';

typedef LogCallback = void Function(LogProducerResult resultCode,
    String? errorMessage, int logBytes, int compressedBytes);

abstract class LogPlatform extends PlatformInterface {
  static final Object _token = Object();
  static LogPlatform _instance = LogMethodChannelPlatform();

  static LogPlatform get instance => _instance;
  static set instance(LogPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  LogPlatform() : super(token: _token);

  Future<LogProducerResult> initProducer(
      Map<String?, Object?> parameter) async {
    throw UnimplementedError('initProducer() has not been implemented.');
  }

  Future<void> setLogCallback(LogCallback callback) async {
    throw UnimplementedError('setLogCallback() has not been implemented.');
  }

  Future<void> setEndpoint(String? endpoint) async {
    throw UnimplementedError('setEndpoint() has not been implemented.');
  }

  Future<void> setProject(String? project) async {
    throw UnimplementedError('setProject() has not been implemented.');
  }

  Future<void> setLogstore(String? logstore) async {
    throw UnimplementedError('setLogstore() has not been implemented.');
  }

  Future<void> setAccessKey(String? accessKeyId, String? accessKeySecret,
      {String? securityToken}) async {
    throw UnimplementedError('setAccessKey() has not been implemented.');
  }

  Future<void> setSource(String? source) async {
    throw UnimplementedError('setSource() has not been implemented.');
  }

  Future<void> setTopic(String? topic) async {
    throw UnimplementedError('setTopic() has not been implemented.');
  }

  Future<void> addTag(String? key, String? value) async {
    throw UnimplementedError('addTag() has not been implemented.');
  }

  Future<void> updateConfiguration(
      LogProducerConfiguration configuration) async {
    throw UnimplementedError('updateConfiguration() has not been implemented.');
  }

  Future<void> destroy() async {
    throw UnimplementedError('destroy() has not been implemented.');
  }

  Future<LogProducerResult> addLog(Map<String?, Object?> parameter) async {
    throw UnimplementedError('addLog() has not been implemented.');
  }
}
