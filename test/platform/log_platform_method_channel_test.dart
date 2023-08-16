import 'package:aliyun_log_dart_sdk/aliyun_log_dart_sdk.dart';
import 'package:aliyun_log_dart_sdk/src/platform/log_platform_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  LogMethodChannelPlatform platform = LogMethodChannelPlatform();
  const MethodChannel channel = MethodChannel("aliyun_sls/flutter_sdk");

  TestWidgetsFlutterBinding.ensureInitialized();
  Map<Object?, Object?>? parameters;

  setUp(() {
    parameters = {};
    channel.setMockMethodCallHandler((MethodCall call) async {
      Map<String?, Object?>? rst = {};
      switch (call.method) {
        case 'initProducer':
          rst.putIfAbsent('code', () => 0);
          rst.putIfAbsent('data', () => {'token': '12345'});
          break;
        case 'addLog':
          rst.putIfAbsent('code', () => 0);
          break;
        default:
          parameters!.addAll(call.arguments);
          rst.putIfAbsent('code', () => 1);
      }

      return rst;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
    parameters = null;
  });

  test('initProduder', () async {
    expect(await platform.initProducer({'endpoint': 'test'}), {
      'code': 0,
      'data': {'token': '12345'}
    });
  });

  test('addLog', () async {
    expect(await platform.addLog('', {'k1': 'v1'}), LogProducerResult.ok);
  });

  test('setEndpoint', () async {
    const endpoint = 'https://cn-heyuan.log.aliyuncs.com';
    await platform.setEndpoint('', endpoint);
    expect(parameters!['endpoint'], endpoint);
  });

  test('setProject', () async {
    const project = 'yuanb-test-project1';
    await platform.setProject('', project);
    expect(parameters!['project'], project);
  });

  test('setLogstore', () async {
    const logstore = 'yuanbo-logstore1';
    await platform.setLogstore('', logstore);
    expect(parameters!['logstore'], logstore);
  });

  test('setAccessKey', () async {
    const accessKeyId = 'id';
    const accessKeySecret = 'secret';
    const securityToken = 'token';
    await platform.setAccessKey('', accessKeyId, accessKeySecret, securityToken: securityToken);
    expect(parameters!['accessKeyId'], accessKeyId);
    expect(parameters!['accessKeySecret'], accessKeySecret);
    expect(parameters!['securityToken'], securityToken);
  });

  test('setSource', () async {
    const source = 'flutter';
    await platform.setSource('', source);
    expect(parameters!['source'], source);
  });

  test('setTopic', () async {
    const topic = 'topic';
    await platform.setTopic('', topic);
    expect(parameters!['topic'], topic);
  });

  test('addTag', () async {
    const tagKey = 'topic';
    const tagValue = 'value';
    await platform.addTag('', tagKey, tagValue);
    expect(parameters!['tags'], {tagKey: tagValue});
  });

  test('updateConfiguration', () async {
    LogProducerConfiguration configuration = LogProducerConfiguration();
    await platform.updateConfiguration('', configuration);
    expect(parameters!.length, 27);

    configuration = LogProducerConfiguration();
    configuration.endpoint = 'https://cn-hangzhou.log.aliyuncs.com';
    await platform.updateConfiguration('', configuration);
    expect(parameters!['endpoint'], 'https://cn-hangzhou.log.aliyuncs.com');

    configuration.project = 'ptj';
    await platform.updateConfiguration('', configuration);
    expect(parameters!['project'], 'ptj');
  });
}
