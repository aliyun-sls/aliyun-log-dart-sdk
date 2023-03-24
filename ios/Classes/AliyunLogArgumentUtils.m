//
// Copyright 2023 aliyun-sls Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
	

#import "AliyunLogArgumentUtils.h"

@implementation AliyunLogArgumentUtils

+ (int) intValue: (FlutterMethodCall *)call key: (NSString *)key {
    if (nil == call.arguments) {
        return 0;
    }
    
    if ([call.arguments[key] isKindOfClass:[NSNull class]]) {
        return 0;
    }
    
    return [call.arguments[key] intValue];
    
}
+ (BOOL) boolValue: (FlutterMethodCall *)call key: (NSString *)key {
    if (nil == call.arguments) {
        return false;
    }
    
    if ([call.arguments[key] isKindOfClass:[NSNull class]]) {
        return false;
    }
    
    return [call.arguments[key] boolValue];
}
+ (NSString *) stringValue: (FlutterMethodCall *)call key: (NSString *)key {
    if (nil == call.arguments) {
        return nil;
    }
    
    if ([call.arguments[key] isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if (![call.arguments[key] isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    return [call.arguments[key] copy];
}

+ (NSDictionary *) dictValue: (FlutterMethodCall *)call key: (NSString *)key {
    if (nil == call.arguments) {
        return nil;
    }
    
    if ([call.arguments[key] isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if (![call.arguments[key] isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return [call.arguments[key] copy];
}
@end
