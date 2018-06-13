//
//  NSArray+CrashProtect.m
//  JWCrashProtect
//
//  Created by wangjun on 2018/6/13.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "NSArray+CrashProtect.h"
#import "NSObject+CrashProtect.h"
#import <objc/runtime.h>

@implementation NSArray (CrashProtect)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        @autoreleasepool {
            
            // 越界崩溃方式一：[array objectAtIndex:1000];
            [objc_getClass("__NSArrayI") swizzleSelector:@selector(objectAtIndex:)
                                    withSwizzledSelector:@selector(jw_safeObjectAtIndex:)];
            // 越界崩溃方式一：arr[1000];
            [objc_getClass("__NSArrayI") swizzleSelector:@selector(objectAtIndexedSubscript:)
                                    withSwizzledSelector:@selector(jw_safeObjectAtIndexedSubscript:)];
        }
    });
}

- (instancetype)jw_safeObjectAtIndex:(NSUInteger)index
{
    if (index > (self.count - 1))
    {
        return nil;
    }
    else
    {
        return [self jw_safeObjectAtIndex:index];
    }
}

- (instancetype)jw_safeObjectAtIndexedSubscript:(NSUInteger)index
{
    if (index > (self.count - 1))
    {
        return nil;
    }
    else
    {
        return [self jw_safeObjectAtIndexedSubscript:index];
    }
}

@end
