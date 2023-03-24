class LogProducerConfiguration {
  /// The endpoint of log service.
  String? endpoint;

  /// The project of log service.
  String? project;

  /// The logstore of log service.
  String? logstore;

  String? accessKeyId;
  String? accessKeySecret;
  String? securityToken;

  bool? debuggable;

  int? connectTimeout;
  int? sendTimeout;
  int? ntpTimeOffset;
  int? maxLogDelayTime;
  bool? dropDelayLog;
  bool? dropUnauthorizedLog;

  String? source;
  String? topic;
  Map<String?, String?>? _tags;

  int? packetLogBytes;
  int? packetLogCount;
  int? packetTimeout;
  int? maxBufferLimit;

  bool? persistent;
  bool? persistentForceFlush;
  String? persistentFilePath;
  int? persistentMaxFileCount;
  int? persistentMaxFileSize;
  int? persistentMaxLogCount;

  LogProducerConfiguration(
      {this.endpoint,
      this.project,
      this.logstore,
      this.accessKeyId,
      this.accessKeySecret,
      this.securityToken});

  void addTag(String? key, String? value) {
    _tags ??= {};
    _tags!.putIfAbsent(key, () => value);
  }

  Map<String, Object?> toMap() {
    return {
      "endpoint": endpoint,
      "project": project,
      "logstore": logstore,
      "accessKeyId": accessKeyId,
      "accessKeySecret": accessKeySecret,
      "securityToken": securityToken,
      "debuggable": debuggable,
      "connectTimeout": connectTimeout,
      "sendTimeout": sendTimeout,
      "ntpTimeOffset": ntpTimeOffset,
      "maxLogDelayTime": maxLogDelayTime,
      "dropDelayLog": dropDelayLog,
      "dropUnauthorizedLog": dropUnauthorizedLog,
      "topic": topic,
      "source": source,
      "tags": _tags,
      "packetLogBytes": packetLogBytes,
      "packetLogCount": packetLogCount,
      "packetTimeout": packetTimeout,
      "maxBufferLimit": maxBufferLimit,
      "persistent": persistent,
      "persistentForceFlush": persistentForceFlush,
      "persistentFilePath": persistentFilePath,
      "persistentMaxFileCount": persistentMaxFileCount,
      "persistentMaxFileSize": persistentMaxFileSize,
      "persistentMaxLogCount": persistentMaxLogCount
    };
  }
}
