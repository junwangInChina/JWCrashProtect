//
//  NSObject+CrashProtect.m
//  JWCrashProtect
//
//  Created by wangjun on 2018/6/13.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "NSObject+CrashProtect.h"
#import <objc/runtime.h>

@implementation NSObject (CrashProtect)

+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector
{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // 添加交换方法，
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    // 添加成功，替换
    if (didAddMethod)
    {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    // 若被添加的方法已存在，则会添加失败，直接替换即可
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
