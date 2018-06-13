//
//  NSMutableDictionary+CrashProtect.m
//  JWCrashProtect
//
//  Created by wangjun on 2018/6/13.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "NSMutableDictionary+CrashProtect.h"
#import "NSObject+CrashProtect.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (CrashProtect)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        @autoreleasepool {
            
            [objc_getClass("__NSDictionaryM") swizzleSelector:@selector(setObject:forKey:)
                                         withSwizzledSelector:@selector(jw_safeSetObject:forKey:)];
            [objc_getClass("__NSDictionaryM") swizzleSelector:@selector(setObject:forKeyedSubscript:)
                                         withSwizzledSelector:@selector(jw_safeSetObject:forKeyedSubscript:)];
            
            [objc_getClass("__NSDictionaryM") swizzleSelector:@selector(setValue:forKey:)
                                         withSwizzledSelector:@selector(jw_safeSetValue:forKey:)];
    
        }
    });
}

- (void)jw_safeSetObject:(id)obj forKey:(NSString *)aKey
{
    if (!aKey || !obj)
    {
        return;
    }
    
    [self jw_safeSetObject:obj forKey:aKey];
}

- (void)jw_safeSetObject:(id)obj forKeyedSubscript:(NSString *)key
{
    if (!key || !obj)
    {
        return;
    }
    [self jw_safeSetObject:obj forKeyedSubscript:key];

}

- (void)jw_safeSetValue:(id)value forKey:(NSString *)key
{
    if (!key || !value)
    {
        return;
    }
    [self jw_safeSetValue:value forKey:key];
}

@end
