import 'package:aliyun_log_dart_sdk/aliyun_log_dart_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const endpoint = 'https://cn-hangzhou.log.aliyuncs.com';
  const project = 'yuanbo-for-test';
  const logstore = 'test-logstore';
  const accesskeyId = 'xxxxxxxxxxxxxxxxxx';
  const accesskeySecret = 'yyyyyyyyyyyyyyyyyyy';
  const securityToeken = 'jfsdj;fjajfsdj';

  group('LogProducerConfigurationTests', () {
    test('constructor-empty', () async {
      LogProducerConfiguration configuration = LogProducerConfiguration();
      expect(null, configuration.endpoint);
      expect(null, configuration.project);
      expect(null, configuration.logstore);
      expect(null, configuration.accessKeyId);
      expect(null, configuration.accessKeySecret);
      expect(null, configuration.securityToken);
    });

    test('constructor-same', () async {
      LogProducerConfiguration configuration = LogProducerConfiguration(
          endpoint: endpoint,
          project: project,
          logstore: logstore,
          accessKeyId: accesskeyId,
          accessKeySecret: accesskeySecret,
          securityToken: securityToeken);
      expect(endpoint, configuration.endpoint);
      expect(project, configuration.project);
      expect(logstore, configuration.logstore);
      expect(accesskeyId, configuration.accessKeyId);
      expect(accesskeySecret, configuration.accessKeySecret);
      expect(securityToeken, configuration.securityToken);
    });

    test('constructor-setter', () async {
      LogProducerConfiguration configuration = LogProducerConfiguration();
      configuration.endpoint = endpoint;
      configuration.project = project;
      expect(endpoint, configuration.endpoint);
      expect(project, configuration.project);
    });

    test('constructor-mixed', () async {
      LogProducerConfiguration configuration = LogProducerConfiguration(endpoint: endpoint, accessKeyId: accesskeyId);
      expect(endpoint, configuration.endpoint);
      expect(accesskeyId, configuration.accessKeyId);
    });

    test('toMap', () async {
      LogProducerConfiguration configuration = LogProducerConfiguration(
          endpoint: endpoint,
          project: project,
          logstore: logstore,
          accessKeyId: accesskeyId,
          accessKeySecret: accesskeySecret,
          securityToken: securityToeken);
      Map<String?, String?>? tags = {'tag1': 'value1', 'tag2': 'value2'};
      configuration.debuggable = true;
      configuration.connectTimeout = 1111;
      configuration.sendTimeout = 2222;
      configuration.ntpTimeOffset = 10;
      configuration.maxLogDelayTime = 12;
      configuration.dropDelayLog = true;
      configuration.dropUnauthorizedLog = true;
      configuration.source = "mock";
      configuration.topic = "mock";
      // configuration.tags = tags;
      configuration.addTag('tag1', 'value1');
      configuration.addTag('tag2', 'value2');
      configuration.packetLogBytes = 10 * 1024;
      configuration.packetLogCount = 20 * 1024;
      configuration.packetTimeout = 30;
      configuration.maxBufferLimit = 15 * 1024;
      configuration.persistent = true;
      configuration.persistentForceFlush = true;
      configuration.persistentFilePath = "/test/data/";
      configuration.persistentMaxFileCount = 20;
      configuration.persistentMaxLogCount = 100 * 1024;

      Map<String?, Object?> map = configuration.toMap();
      expect(endpoint, map['endpoint']);
      expect(project, map['project']);
      expect(logstore, map['logstore']);
      expect(accesskeyId, map['accessKeyId']);
      expect(accesskeySecret, map['accessKeySecret']);
      expect(securityToeken, map['securityToken']);
      expect(1111, map['connectTimeout']);
      expect(2222, map['sendTimeout']);
      expect(10, map['ntpTimeOffset']);
      expect(12, map['maxLogDelayTime']);
      expect(true, map['dropDelayLog']);
      expect(true, map['dropUnauthorizedLog']);
      expect("mock", map['topic']);
      expect("mock", map['topic']);
      expect(tags, map['tags']);
      expect(10 * 1024, map['packetLogBytes']);
      expect(20 * 1024, map['packetLogCount']);
      expect(30, map['packetTimeout']);
      expect(15 * 1024, map['maxBufferLimit']);
      expect(true, map['persistent']);
      expect(true, map['persistentForceFlush']);
      expect("/test/data/", map['persistentFilePath']);
      expect(20, map['persistentMaxFileCount']);
      expect(100 * 1024, map['persistentMaxLogCount']);
    });
  });
}
