#import "AliyunLogDartSdkPlugin.h"
#import "AliyunLogArgumentUtils.h"
#import "AliyunLogProducer/AliyunLogProducer.h"


@interface AliyunLogDartSdkPlugin ()
//@property LogProducerConfig *logProducerConfig;
//@property LogProducerClient *logProducerClient;
@property NSMutableDictionary<NSString*, NSDictionary<NSString*, NSObject*>*> *instanceHandlers;
- (void) initProducer: (FlutterMethodCall *)call result: (FlutterResult)result;
- (void) updateLogProducerConfig: (FlutterMethodCall *)call config: (LogProducerConfig *)config;
- (void) addLog: (FlutterMethodCall *)call result: (FlutterResult)result;
- (void) onLogSendDone: (NSString *)logstore resultCode: (LogProducerResult)resultCode errorMessage: (NSString *)errorMessage logBytes: (NSInteger)logBytes compressedBytes: (NSInteger)compressedBytes;
- (NSString *) randomToken;
@end

@implementation AliyunLogDartSdkPlugin

- (instancetype)init
{
    self = [super init];
    if (self) {
        _instanceHandlers = [NSMutableDictionary dictionary];
    }
    return self;
}

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
    LogProducerConfig *_logProducerConfig = [[LogProducerConfig alloc] initWithEndpoint:@"" project:@"" logstore:@""];
    [self updateLogProducerConfig:call config:_logProducerConfig];
    NSString *error = [self setupPersistent:call];
    if (error.length > 0) {
        return result([self error:error code:LogProducerInvalid]);
    }

    LogProducerClient *_logProducerClient = [[LogProducerClient alloc] initWithLogProducerConfig:_logProducerConfig callback:on_send_done_function_in_flutter userparams:self];

    NSString *token = [self randomToken];
    [_instanceHandlers setObject:@{@"config": _logProducerConfig, @"client": _logProducerClient} forKey:token];

    result([self success: @{@"token": token}]);
}

- (LogProducerConfig *) getLogProducerConfigByToken: (FlutterMethodCall *)call {
    NSString *token = [AliyunLogArgumentUtils stringValue:call key:@"token"];
    if (token.length <= 0) {
        return nil;
    }

    return (LogProducerConfig *)[_instanceHandlers objectForKey:token][@"config"];
}

- (LogProducerClient *) getLogProducerClientByToken: (FlutterMethodCall *)call {
    NSString *token = [AliyunLogArgumentUtils stringValue:call key:@"token"];
    if (token.length <= 0) {
        return nil;
    }

    return (LogProducerClient *)[_instanceHandlers objectForKey:token][@"client"];
}

- (void) updateLogProducerConfig: (FlutterMethodCall *)call config: (LogProducerConfig *)config {
    LogProducerConfig *_logProducerConfig = config;
    if (nil == _logProducerConfig) {
        _logProducerConfig = [self getLogProducerConfigByToken:call];
    }
    
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

    // debuggable
    if (debuggable) {
        [LogProducerConfig Debug];
    }
}

- (NSString *) setupPersistent: (FlutterMethodCall *)call {
    BOOL persistent = [AliyunLogArgumentUtils boolValue:call key:@"persistent"];
    BOOL persistentForceFlush = [AliyunLogArgumentUtils boolValue:call key:@"persistentForceFlush"];
    NSString *persistentFilePath = [AliyunLogArgumentUtils stringValue:call key:@"persistentFilePath"];
    int persistentMaxFileCount = [AliyunLogArgumentUtils intValue:call key:@"persistentMaxFileCount"];
    int persistentMaxFileSize = [AliyunLogArgumentUtils intValue:call key:@"persistentMaxFileSize"];
    int persistentMaxLogCount = [AliyunLogArgumentUtils intValue:call key:@"persistentMaxLogCount"];
    
    // persistent
    if (persistent) {
        if (persistentFilePath.length <= 0) {
            return @"persistent file path must not be null.";
        }
        LogProducerConfig *_logProducerConfig = [self getLogProducerConfigByToken:call];
        
        [_logProducerConfig SetPersistent:1];
        [_logProducerConfig SetPersistentForceFlush:persistentForceFlush ? 1 : 0];
        [_logProducerConfig SetPersistentMaxFileCount:persistentMaxFileCount > 0 ? persistentMaxFileCount : 10];
        [_logProducerConfig SetPersistentMaxFileSize:persistentMaxFileSize > 0 ? persistentMaxFileSize : 1024 * 1024];
        [_logProducerConfig SetPersistentMaxLogCount:persistentMaxLogCount > 0 ? persistentMaxLogCount : 64 * 1024];
        
        NSString *path = [self setupPersistentFilePath:persistentFilePath];
        [_logProducerConfig SetPersistentFilePath:path];
    }
    return nil;
}

- (NSString *) setupPersistentFilePath: (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths lastObject] stringByAppendingFormat:@"/%@", filePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path];
    if (NO == existed) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return [path stringByAppendingString:@"/dat"];
}

- (void) addLog: (FlutterMethodCall *)call result: (FlutterResult)result {
    LogProducerClient *_logProducerClient = [self getLogProducerClientByToken:call];
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
    LogProducerConfig *_logProducerConfig = [self getLogProducerConfigByToken:call];
    if (nil == _logProducerConfig) {
        result([self error:@"LogProducerConfig is null" code:LogProducerInvalid]);
        return;
    }

    [self updateLogProducerConfig:call config:_logProducerConfig];
    result([self success]);
}

- (void) destroy: (FlutterMethodCall *)call result: (FlutterResult)result {
    LogProducerClient *_logProducerClient = [self getLogProducerClientByToken:call];
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

- (NSString *) randomToken {
    NSUInteger min = 100000;
    NSUInteger max = 999999;
    NSUInteger randomNumber = arc4random_uniform((uint32_t)(max - min + 1)) + min;
    return [NSString stringWithFormat:@"%lu", randomNumber];
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
