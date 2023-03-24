Aliyun SLS SDK for Dart
==========

| package             | pub                                                                                                                  | likes                                                                                                                | popularity                                                                                                                     | pub points                                                                                                                 |
|---------------------|----------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|
| aliyun_log_dart_sdk | [![pub package](https://img.shields.io/pub/v/aliyun_log_dart_sdk.svg)](https://pub.dev/packages/aliyun_log_dart_sdk) | [![likes](https://img.shields.io/pub/likes/aliyun_log_dart_sdk)](https://pub.dev/packages/aliyun_log_dart_sdk/score) | [![popularity](https://img.shields.io/pub/popularity/aliyun_log_dart_sdk)](https://pub.dev/packages/aliyun_log_dart_sdk/score) | [![pub points](https://img.shields.io/pub/points/aliyun_log_dart_sdk)](https://pub.dev/packages/aliyun_log_dart_sdk/score) |


阿里云日志服务 SLS 官方插件，当前支持 Android/iOS 数据采集。

#### 使用方式

- 登录 [阿里云 SLS 控制台](https://sls.console.aliyun.com/lognext/profile)，并创建或获取endpoint、project、logstore、AK 等信息。
- 按照 [pub.dev](https://pub.dev/packages/aliyun_log_dart_sdk/install) 上面的安装说明，对项目进行配置。
- 使用 endpoint、project、logstore 等信息初始化 SLS Dart SDK。

```dart
import 'package:aliyun_log_dart_sdk/aliyun_log_dart_sdk.dart';
  AliyunLogDartSdk? _aliyunLogSdk;

  void _initProducer() async {
    LogProducerConfiguration configuration = LogProducerConfiguration(
        endpoint: 'your endpoint', project: 'your project', logstore: 'your logstore'
    ); // endpoint、project、logstore 后续可动态更新
    configuration.accessKeyId = 'your access key id';
    configuration.accessKeySecret = 'your access key secret';
    configuration.securityToken = 'your access key token'; // 使用 STS 方式获取的 AK 时需要
    _aliyunLogSdk = AliyunLogDartSdk();
    LogProducerResult result = await _aliyunLogSdk!.initProducer(configuration);
  }

```

##### 上报日志
可以通过 addLog 方法上报自定义业务日志。
```dart
LogProducerResult code = await _aliyunLogSdk!.addLog({
    'str': 'str value',
    'int': 12,
    'double': 12.12,
    'boolean': true,
    'map': {'key': 'value', 'inntt': 3333},
    'array': ['a1', 'a2'],
    'null': null,
    'content': '中文'
});
```
仅当 `code == LogProducerResult.ok` 时才表示 addLog 成功。其他情况下错误码的说明参见后文。

##### 配置参数说明
配置参数定义在 LogProducerConfiguration 类中：

| 配置参数               | 参数说明                                         | 取值                                                                                                    |
|------------------------|--------------------------------------------------|---------------------------------------------------------------------------------------------------------|
| endpoint               | SLS endpoint                                     | 一般在 project 的概览页获取，更多参见：[服务入口](https://help.aliyun.com/document_detail/29008.html)。 |
| project                | 日志服务的资源管理单元                           | [Project介绍](https://help.aliyun.com/document_detail/48873.html)                                       |
| logstore               | 日志服务中数据的采集、存储、查询单元             | [Logstore介绍](https://help.aliyun.com/document_detail/48874.html)                                      |
| accesskeyId            | 访问日志服务需要使用 AccessKey 用来进行身份验证  | [AccessKey介绍](https://help.aliyun.com/document_detail/28628.html)                                     |
| accessKeySecret        | 访问日志服务需要使用 AccessKey 用来进行身份验证  | [AccessKey介绍](https://help.aliyun.com/document_detail/28628.html)                                     |
| securityToken          | 访问日志服务需要使用 AccessKey 用来进行身份验证  | [AccessKey介绍](https://help.aliyun.com/document_detail/28628.html)                                     |
| debuggable             | 是否开启调试模式                                 | 默认为 false，表示关闭。 当遇到数据采集问题时建议开启                                                   |
| connectTimeout         | 网络连接超时时间                                 | 默认为 10 秒。一般不建议修改。                                                                          |
| sendTimeout            | 网络发送超时时间                                 | 默认为 15 秒。一般不建议修改。                                                                          |
| ntpTimeOffset          | 设备时间与标准时间之差                           | 默认为 0 秒。不建议修改，SDK 已经支持时间自动校正。                                                     |
| maxLogDelayTime        | 日志时间与本机时间之差                           | 默认为 7 天。超过该值后，会根据 dropDelayLog 进行处理。不建议修改。                                     |
| dropDelayLog           | 对超过 maxLogDelayTime 日志的处理策略            | 默认为 false，不丢弃。`__time__` 会重置为当前时间                                                       |
| dropUnauthorizedLog    | 是否丢弃鉴权失败的日志                           | 默认为 false，不丢弃。                                                                                  |
| source                 | `__source__` 字段的值                            | 默认为 Android                                                                                          |
| topic                  | `__topic__` 字段的值                             | 无默认值。                                                                                              |
| _tags                  | `__tag__:xxx:yyy` 字段的值                       | 无默认值。需要通 `LogProducerConfiguration.addTag()` 方法设置。过                                       |
| packetLogBytes         | 每个待发送日志包的大小                           | 整数，取值为1~5242880，单位为字节。默认为1024 * 1024                                                    |
| packetLogCount         | 每个待发送日志包中日志数量的最大值               | 整数，取值为1~4096，默认为1024                                                                          |
| packetTimeout          | 待发送日志包等待超时时间，超时则会立即发送       | 整数，单位为毫秒，默认为3000                                                                            |
| persistent             | 是否开启断点续传功能。                           | 默认为 false。建议开启，                                                                                |
| persistentForceFlush   | 是否每次 `addLog` 强制刷新，高可靠性场景建议打开 | 默认为 false。一般不建议打开，对性能会有一定的影响。                                                    |
| persistentFilePath     | 断点续传 binlog 缓存路径                         | 默认为空字符串。配置的路径需要存在，且**不同 AliyunLogDartSdk 实例对应的路径必须不同**。                |
| persistentMaxFileCount | 持久化文件滚动个数，建议设置成10                 | 默认为 10。                                                                                             |
| persistentMaxFileSize  | 每个持久化文件大小                               | 默认为 1 MB。                                                                                           |
| persistentMaxLogCount  | 最多缓存的日志数，不建议超过1M                   | 默认为65536                                                                                             |

##### 动态配置参数
SDK 支持对 endpoint、project、logstore、AK 等参数动态更新。

- 更新 endpoit、project、logstore：
```dart
await _aliyunLogSdk!.setEndpoint('https://cn-hangzhou.log.aliyuncs.com');
await _aliyunLogSdk!.setProject('yuanbo-test-2');
await _aliyunLogSdk!.setLogstore('test2');
```

- 更新 AccessKey
```dart
// securityToken 为可选值，仅当 AccessKey 是通过 STS 方式获取时必填
await _aliyunLogSdk!.setAccessKey('your accesskey id', 'your accesskey secret', securityToken: 'your accesskey token');
```

- 更新 source、topic、tag
```dart
await _aliyunLogSdk!.setSource('flutter');
await _aliyunLogSdk!.setTopic('flutter-test');
await _aliyunLogSdk!.addTag('tag1', 'value1');
await _aliyunLogSdk!.addTag('tag2', 'value2');
```

- 其他参数动态配置
```dart
LogProducerConfiguration configuration = LogProducerConfiguration();
configuration.dropDelayLog = true;
configuration.dropUnauthorizedLog = true;
await _aliyunLogSdk!.updateConfiguration(configuration);
```
**注意：**`AliyunLogDartSdk.updateConfiguration()` 不支持动态配置断点续传相关的参数。

##### 设置日志发送回调
SDK 支持设置日志发送回调。日志发送成功或失败时，都会产生对应的回调信息。我们可以通过回调信息来观察 SDK 的运行情况，或者更新 SDK 的参数配置。

```dart
_aliyunLogSdk!.setLogCallback(
  (resultCode, errorMessage, logBytes, compressedBytes) {
    print('log send result: ${resultCode.name}');
  }
);
```

##### 开启断点续传
**注意：** 断点续传功能的开启，必须要在初始化 AliyunLogDartSdk 时决定，Sdk 初始化完成后不支持动态修改断点续传相关配置信息。

```dart
configuration.persistent = true;
configuration.persistent = true; // 开启断点续传
configuration.persistentFilePath = 'flutter/demo'; // binlog 缓存目录
configuration.persistentForceFlush = false; // 关闭强制刷新，建议关闭，开启后会对性能产生一定的影响
configuration.persistentMaxFileCount = 10; // 缓存文件数量，默认为 10
configuration.persistentMaxFileSize = 1024 * 1024; // 单个缓存文件的大小，默认为 1MB
configuration.persistentMaxLogCount = 64 * 1024; // 缓存日志的数量，默认为 64K
_aliyunLogSdk = AliyunLogDartSdk();
LogProducerResult result = await _aliyunLogSdk!.initProducer(configuration);
```

##### 错误码说明
| 错误码            | 说明                           | 解决方法                                                            |
|:------------------|:-------------------------------|:--------------------------------------------------------------------|
| ok                | 成功                           |                                                                     |
| invalid           | SDK 已销毁或无效               | SDK 初始化失败或已销毁（主动调用了destroy()方法）                   |
| writeError        | 数据写入错误                   | 同 sendQuotaError                                                   |
| dropError         | 缓存已满                       | 磁盘或内存缓存已满，日志无法写入。                                  |
| sendNetworkError  | 网络错误                       | 检查网络连接情况                                                    |
| sendQuotaError    | Project 写 Quota 已满          | Project写入流量已达上限，提工单联系 SLS                             |
| sendUnauthorized  | AK 授权过期或无效              | AK 过期、无效，或AK权限策略配置不正确                               |
| sendServerError   | 服务错误                       | 服务故障                                                            |
| sendDiscardError  | 数据被丢弃                     | SDK 会自动重新发送                                                  |
| sendTimeError     | 与服务器时间不同步             | 设备时间与服务时间不同步，SDK 会自动修复该问题                      |
| sendExitBuffered  | SDK 销毁时，缓存数据还没有发出 | 可能会导致数据丢失，建议开启断点续传功能可避免数据丢失              |
| parametersInvalid | SDK 初始化参数错误             | 一般是 AK 没有配置，或 endpoint、project、logstore 配置不正确导致的 |
| persistentError   | 缓存数据写入磁盘失败           | 缓存文件路径配置不正确，或缓存文件已经写满，或系统磁盘空间不够导致  |
| unknown           | 未知错误                       | 不太可能出现，如果出现请提 bug                                      |
