//
//  NSDictionary+CrashProtect.m
//  JWCrashProtect
//
//  Created by wangjun on 2018/6/13.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "NSDictionary+CrashProtect.h"
#import "NSObject+CrashProtect.h"
#import <objc/runtime.h>

@implementation NSDictionary (CrashProtect)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSDictionaryI") swizzleSelector:@selector(initWithObjects:forKeys:count:)
                                         withSwizzledSelector:@selector(jw_safeInitWithObjects:forKeys:count:)];
            
            [objc_getClass("__NSDictionaryI") swizzleSelector:@selector(dictionaryWithObjects:forKeys:count:)
                                         withSwizzledSelector:@selector(jw_safeDictionaryWithObjects:forKeys:count:)];
            
            [objc_getClass("__NSDictionaryI") swizzleSelector:@selector(objectForKey:)
                                         withSwizzledSelector:@selector(jw_safeObjectForKey:)];
            
            [objc_getClass("__NSDictionaryI") swizzleSelector:@selector(length)
                                         withSwizzledSelector:@selector(jw_safeLength)];
            
        }
    });
}

- (instancetype)jw_safeInitWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt
{
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger index = 0;
    for (NSUInteger i = 0; i < cnt; i++)
    {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj)
        {
            continue;
        }
        if (!obj)
        {
            obj = [NSNull null];
        }
        safeKeys[index] = key;
        safeObjects[index] = obj;
        index++;
    }
    return [self jw_safeInitWithObjects:safeObjects forKeys:safeKeys count:index];
}

+ (instancetype)jw_safeDictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt
{
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger index = 0;
    for (NSUInteger i = 0; i < cnt; i++)
    {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj)
        {
            continue;
        }
        if (!obj)
        {
            obj = [NSNull null];
        }
        safeKeys[index] = key;
        safeObjects[index] = obj;
        index++;
    }
    return [self jw_safeDictionaryWithObjects:safeObjects forKeys:safeKeys count:index];
}

- (instancetype)jw_safeObjectForKey:(NSString *)key
{
    if ([self isKindOfClass:[NSDictionary class]])
    {
        return [self jw_safeObjectForKey:key];
    }
    return nil;
}

- (NSUInteger)jw_safeLength
{
    if ([self isKindOfClass:[NSDictionary class]])
    {
        return [[self allKeys] count];
    }
    return 0;
}



@end
