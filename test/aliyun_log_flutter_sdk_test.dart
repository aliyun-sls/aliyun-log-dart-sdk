import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aliyun_log_dart_sdk/aliyun_log_dart_sdk.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLogPlatform with MockPlatformInterfaceMixin implements LogPlatform {
  @visibleForTesting
  Map<String?, Object?>? parameter;

  @override
  Future<LogProducerResult> initProducer(Map<String?, Object?> parameter) async {
    this.parameter = parameter;
    return LogProducerResult.ok;
  }

  @override
  Future<LogProducerResult> addLog(Map<String?, Object?> parameter) async {
    this.parameter = parameter;
    return LogProducerResult.ok;
  }

  @override
  Future<void> addTag(String? key, String? value) async {
    parameter = {'key': key, 'value': value};
  }

  @override
  Future<void> destroy() {
    throw UnimplementedError();
  }

  @override
  Future<void> setAccessKey(String? accessKeyId, String? accessKeySecret, {String? securityToken}) async {
    parameter = {'accessKeyId': accessKeyId, 'accessKeySecret': accessKeySecret, 'securityToekn': securityToken};
  }

  @override
  Future<void> setEndpoint(String? endpoint) async {
    parameter = {'endpoint': endpoint};
  }

  @override
  Future<void> setLogCallback(LogCallback callback) {
    throw UnimplementedError();
  }

  @override
  Future<void> setLogstore(String? logstore) async {
    parameter = {'logstore': logstore};
  }

  @override
  Future<void> setProject(String? project) async {
    parameter = {'project': project};
  }

  @override
  Future<void> setSource(String? source) async {
    parameter = {'source': source};
  }

  @override
  Future<void> setTopic(String? topic) async {
    parameter = {'topic': topic};
  }

  @override
  Future<void> updateConfiguration(LogProducerConfiguration configuration) async {
    parameter = configuration.toMap();
  }
}

void main() {
  group('AliyunLogFlutterSdk-ConstructorTests', () {
    test('normal', () async {
      MockLogPlatform mockLogPlatform = MockLogPlatform();
      LogPlatform.instance = mockLogPlatform;

      const String endpoint = "https://cn-shanghai.log.aliyuncs.com";
      LogProducerConfiguration configuration = LogProducerConfiguration(endpoint: endpoint);
      AliyunLogDartSdk(configuration);
      expect(endpoint, mockLogPlatform.parameter?['endpoint']);
    });
  });

  group('AliyunLogFlutterSdk-OperationsTests', () {
    MockLogPlatform mockLogPlatform = MockLogPlatform();
    AliyunLogDartSdk? sdk;
    setUp(() {
      // expect(LogPlatform.instance, isInstanceOf<LogMethodChannelPlatform>());

      LogPlatform.instance = mockLogPlatform;
      sdk = AliyunLogDartSdk(LogProducerConfiguration());
    });

    test('$MockLogPlatform is the default instance', () {
      expect(LogPlatform.instance, isInstanceOf<MockLogPlatform>());
    });

    test('addLogTest', () async {
      Map<String?, Object?> log = {};
      sdk!.addLog(log);
      expect({}, mockLogPlatform.parameter);

      log = {'id': 12323, 'name': 'xiaoming', 'height': 164.5};
      sdk!.addLog(log);
      expect({'id': 12323, 'name': 'xiaoming', 'height': 164.5}, mockLogPlatform.parameter);
    });

    test('addTag', () async {
      const key = 'name';
      const value = 'xiaoming';
      sdk!.addTag(key, value);
      expect(key, mockLogPlatform.parameter?['key']);
      expect(value, mockLogPlatform.parameter?['value']);
    });

    test('setAccessKey', () async {
      sdk!.setAccessKey('keyxxxxxx', 'secyyyyyyy', securityToken: 'tokendsdsdsdsd');
      expect('keyxxxxxx', mockLogPlatform.parameter?['accessKeyId']);
      expect('secyyyyyyy', mockLogPlatform.parameter?['accessKeySecret']);
      expect('tokendsdsdsdsd', mockLogPlatform.parameter?['securityToekn']);
    });

    test('setEndpoint', () async {
      sdk!.setEndpoint('https://cn-guangzhou.log.aliyuncs.com');
      expect('https://cn-guangzhou.log.aliyuncs.com', mockLogPlatform.parameter?['endpoint']);
    });

    test('setProject', () async {
      sdk!.setProject('yuanbo-test-project');
      expect('yuanbo-test-project', mockLogPlatform.parameter?['project']);
    });

    test('setLogstore', () async {
      sdk!.setLogstore('yuanbo-test-logstore');
      expect('yuanbo-test-logstore', mockLogPlatform.parameter?['logstore']);
    });

    test('setSource', () async {
      sdk!.setSource('test-source');
      expect('test-source', mockLogPlatform.parameter?['source']);
    });

    test('setTopic', () async {
      sdk!.setTopic('test-topic');
      expect('test-topic', mockLogPlatform.parameter?['topic']);
    });

    test('setTopic', () async {
      sdk!.setTopic('test-topic');
      expect('test-topic', mockLogPlatform.parameter?['topic']);
    });

    test('updateConfiguration', () async {
      LogProducerConfiguration configuration =
          LogProducerConfiguration(endpoint: "https://cn-beijing.log.aliyuncs.com");
      sdk!.updateConfiguration(configuration);
      Map<String?, Object?> expt = configuration.toMap();
      expect(expt, mockLogPlatform.parameter);
    });
  });
}
