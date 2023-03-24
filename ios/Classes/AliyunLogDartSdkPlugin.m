#import "AliyunLogDartSdkPlugin.h"
#import "AliyunLogArgumentUtils.h"
#import "AliyunLogProducer/AliyunLogProducer.h"

@interface AliyunLogDartSdkPlugin ()
@property LogProducerConfig *logProducerConfig;
@property LogProducerClient *logProducerClient;
- (void) initProducer: (FlutterMethodCall *)call result: (FlutterResult)result;
- (void) updateLogProducerConfig: (FlutterMethodCall *)call;
- (void) addLog: (FlutterMethodCall *)call result: (FlutterResult)result;
- (void) onLogSendDone: (NSString *)logstore resultCode: (LogProducerResult)resultCode errorMessage: (NSString *)errorMessage logBytes: (NSInteger)logBytes compressedBytes: (NSInteger)compressedBytes;
@end

@implementation AliyunLogDartSdkPlugin
+ (instancetype) initWithChannel: (FlutterMethodChannel *)channel {
    AliyunLogDartSdkPlugin *plugin = [[AliyunLogDartSdkPlugin alloc] init];
    plugin.channel = channel;
    return plugin;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"aliyun_sls/flutter_sdk"
                                     binaryMessenger:[registrar messenger]
    ];


    AliyunLogDartSdkPlugin* instance = [AliyunLogDartSdkPlugin initWithChannel:channel];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"initProducer" isEqualToString:call.method]) {
        [self initProducer:call result:result];
    } else if ([@"addLog" isEqualToString:call.method]){
        [self addLog:call result:result];
    } else if ([@"setEndpoint" isEqualToString:call.method] ||
               [@"setProject" isEqualToString:call.method] ||
               [@"setLogstore" isEqualToString:call.method] ||
               [@"setAccessKey" isEqualToString:call.method] ||
               [@"setSource" isEqualToString:call.method] ||
               [@"setTopic" isEqualToString:call.method] ||
               [@"addTag" isEqualToString:call.method] ||
               [@"updateConfiguration" isEqualToString:call.method]){
        [self updateConfiguration:call result:result];
    } else if ([@"destroy" isEqualToString:call.method]) {
        [self destroy:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void) initProducer: (FlutterMethodCall *)call result: (FlutterResult) result {
    _logProducerConfig = [[LogProducerConfig alloc] initWithEndpoint:@"" project:@"" logstore:@""];
    [self updateLogProducerConfig:call];

    _logProducerClient = [[LogProducerClient alloc] initWithLogProducerConfig:_logProducerConfig callback:on_send_done_function_in_flutter userparams:self];

    result([self success]);
}

- (void) updateLogProducerConfig: (FlutterMethodCall *)call {
    if (nil == _logProducerConfig || nil == call.arguments) {
        return;
    }

    NSString *endpoint = [AliyunLogArgumentUtils stringValue:call key:@"endpoint"];
    NSString *project = [AliyunLogArgumentUtils stringValue:call key:@"project"];
    NSString *logstore = [AliyunLogArgumentUtils stringValue:call key:@"logstore"];
    NSString *accessKeyId = [AliyunLogArgumentUtils stringValue:call key:@"accessKeyId"];
    NSString *accessKeySecret = [AliyunLogArgumentUtils stringValue:call key:@"accessKeySecret"];
    NSString *securityToken = [AliyunLogArgumentUtils stringValue:call key:@"securityToken"];

    BOOL debuggable = [AliyunLogArgumentUtils boolValue:call key:@"debuggable"];
    int connectTimeout = [AliyunLogArgumentUtils intValue:call key:@"connectTimeout"];
    int sendTimeout = [AliyunLogArgumentUtils intValue:call key:@"sendTimeout"];
    int ntpTimeOffset = [AliyunLogArgumentUtils intValue:call key:@"ntpTimeOffset"];
    int maxLogDelayTime = [AliyunLogArgumentUtils intValue:call key:@"maxLogDelayTime"];
    BOOL dropDelayLog = [AliyunLogArgumentUtils boolValue:call key:@"dropDelayLog"];
    BOOL dropUnauthorizedLog = [AliyunLogArgumentUtils boolValue:call key:@"dropUnauthorizedLog"];

    NSString *source = [AliyunLogArgumentUtils stringValue:call key:@"source"];
    NSString *topic = [AliyunLogArgumentUtils stringValue:call key:@"topic"];
    NSDictionary *tags = [AliyunLogArgumentUtils dictValue:call key:@"tags"];

    int packetLogBytes = [AliyunLogArgumentUtils intValue:call key:@"packetLogBytes"];
    int packetLogCount = [AliyunLogArgumentUtils intValue:call key:@"packetLogCount"];
    int packetTimeout = [AliyunLogArgumentUtils intValue:call key:@"packetTimeout"];
    int maxBufferLimit = [AliyunLogArgumentUtils intValue:call key:@"maxBufferLimit"];

    BOOL persistent = [AliyunLogArgumentUtils boolValue:call key:@"persistent"];
    BOOL persistentForceFlush = [AliyunLogArgumentUtils boolValue:call key:@"persistentForceFlush"];
    NSString *persistentFilePath = [AliyunLogArgumentUtils stringValue:call key:@"persistentFilePath"];
    int persistentMaxFileCount = [AliyunLogArgumentUtils intValue:call key:@"persistentMaxFileCount"];
    int persistentMaxLogCount = [AliyunLogArgumentUtils intValue:call key:@"persistentMaxLogCount"];

    if (endpoint.length > 0) {
        [_logProducerConfig setEndpoint:endpoint];
    }
    if (project.length > 0) {
        [_logProducerConfig setProject:project];
    }
    if (logstore.length > 0) {
        [_logProducerConfig setLogstore:logstore];
    }
    if (accessKeyId.length > 0 && accessKeySecret.length > 0) {
        if (securityToken.length > 0) {
            [_logProducerConfig ResetSecurityToken:accessKeyId accessKeySecret:accessKeySecret securityToken:securityToken];
        } else {
            [_logProducerConfig setAccessKeyId:accessKeyId];
            [_logProducerConfig setAccessKeySecret:accessKeySecret];
        }
    }

    // basic options
    if (connectTimeout > 0) {
        [_logProducerConfig SetConnectTimeoutSec:connectTimeout];
    }
    if (sendTimeout > 0) {
        [_logProducerConfig SetSendTimeoutSec:sendTimeout];
    }
    if (ntpTimeOffset > 0) {
        [_logProducerConfig SetNtpTimeOffset:ntpTimeOffset];
    }
    if (maxLogDelayTime > 0) {
        [_logProducerConfig SetMaxLogDelayTime:maxLogDelayTime];
    }
    [_logProducerConfig SetDropDelayLog:dropDelayLog ? 1 : 0];
    [_logProducerConfig SetDropUnauthorizedLog:dropUnauthorizedLog ? 1 : 0];

    // source & topic & tags
    if (source.length > 0) {
        [_logProducerConfig SetSource:source];
    }
    if (topic.length > 0) {
        [_logProducerConfig SetTopic:topic];
    }
    if (nil != tags) {
        for (NSString *key in tags) {
            if (key.length > 0) {
                [_logProducerConfig AddTag:key value:[tags objectForKey:key]];
            }
        }
    }

    // packet
    if (packetLogBytes > 0) {
        [_logProducerConfig SetPacketLogBytes:packetLogBytes];
    }
    if (packetLogCount > 0) {
        [_logProducerConfig SetPacketLogCount:packetLogCount];
    }
    if (packetTimeout > 0) {
        [_logProducerConfig SetPacketTimeout:packetTimeout];
    }
    if (maxBufferLimit > 0) {
        [_logProducerConfig SetMaxBufferLimit:maxBufferLimit];
    }

    // persistent
    if (persistent) {
        [_logProducerConfig SetPersistent:1];
        [_logProducerConfig SetPersistentForceFlush:persistentForceFlush ? 1 : 0];
        [_logProducerConfig SetPersistentFilePath:persistentFilePath];
        if (persistentMaxFileCount > 0) {
            [_logProducerConfig SetPersistentMaxFileCount:persistentMaxFileCount];
        }
        if (persistentMaxLogCount > 0) {
            [_logProducerConfig SetPersistentMaxLogCount:persistentMaxLogCount];
        }
    }

    // debuggable
    if (debuggable) {
        [LogProducerConfig Debug];
    }
}

- (void) addLog: (FlutterMethodCall *)call result: (FlutterResult)result {
    if (nil == _logProducerClient || nil == call.arguments) {
        result([self error:@"arguments is null or client is null" code:LogProducerInvalid]);
        return;
    }

    NSDictionary *data = [AliyunLogArgumentUtils dictValue:call key:@"log"];
    if (nil == data) {
        result([self error:@"log data is null" code:LogProducerInvalid]);
        return;
    }

    Log *log = [Log log];
    [log putContents:data];
    LogProducerResult res = [_logProducerClient AddLog:log];
    if (LogProducerOK == res) {
        result([self success]);
    } else {
        result([self error:res]);
    }
}

- (void) updateConfiguration: (FlutterMethodCall *)call result: (FlutterResult)result {
    if (nil == _logProducerConfig) {
        result([self error:@"LogProducerConfig is null" code:LogProducerInvalid]);
        return;
    }

    [self updateLogProducerConfig:call];
    result([self success]);
}

- (void) destroy: (FlutterMethodCall *)call result: (FlutterResult)result {
    if (nil == _logProducerClient) {
        result([self error:@"LogProducerConfig is null" code:LogProducerInvalid]);
        return;
    }

    [_logProducerClient DestroyLogProducer];
    _logProducerClient = nil;

    result([self success]);
}

- (NSDictionary *) success {
    return [self success: nil];
}

- (NSDictionary *) success: (NSDictionary *) data {
    return [self createResultData:LogProducerOK data:data error:nil];
}

- (NSDictionary *) error: (LogProducerResult) code {
    return [self error: @"" code:code];
}

- (NSDictionary *) error: (NSString *)error code: (LogProducerResult)code {
    return [self createResultData:code data:nil error:error];
}

- (NSDictionary *) createResultData: (LogProducerResult)code data: (NSDictionary *)data error: (NSString *)error {
    return @{
        @"code": @((int)code),
        @"data": (nil == data ? @{} : data),
        @"error": (error.length > 0 ? error : @"")
    };
}

- (void) onLogSendDone: (NSString *)logstore resultCode: (LogProducerResult)resultCode errorMessage: (NSString *)errorMessage logBytes: (NSInteger)logBytes compressedBytes: (NSInteger)compressedBytes {
    [_channel invokeMethod:@"on_send_done"
                 arguments:@{
        @"code": @((int)resultCode),
        @"errorMessage": [errorMessage copy],
        @"logBytes": @(logBytes),
        @"compressedBytes": @(compressedBytes)
    }
    ];
}

void on_send_done_function_in_flutter(const char * config_name, log_producer_result result, size_t log_bytes, size_t compressed_bytes, const char * req_id, const char * error_message, const unsigned char * raw_buffer, void *user_param) {
    AliyunLogDartSdkPlugin *plugin = (__bridge AliyunLogDartSdkPlugin *)user_param;
    if (nil == plugin) {
        return;
    }

    [plugin onLogSendDone:[NSString stringWithUTF8String:config_name]
               resultCode:result
             errorMessage:[NSString stringWithUTF8String:error_message]
                 logBytes:log_bytes
          compressedBytes:compressed_bytes
    ];
}
@end
