#import <Flutter/Flutter.h>

@interface AliyunLogDartSdkPlugin : NSObject<FlutterPlugin>
@property(nonatomic, strong) FlutterMethodChannel *channel;
+ (instancetype) initWithChannel: (FlutterMethodChannel *)channel;
@end
