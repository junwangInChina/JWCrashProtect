//
//  NSMutableArray+CrashProtect.m
//  JWCrashProtect
//
//  Created by wangjun on 2018/6/13.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "NSMutableArray+CrashProtect.h"
#import "NSObject+CrashProtect.h"
#import <objc/runtime.h>

@implementation NSMutableArray (CrashProtect)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        @autoreleasepool {
            
            // 初始化时，包含nil数据
            [objc_getClass("__NSPlaceholderArray") swizzleSelector:@selector(initWithObjects:count:)
                                              withSwizzledSelector:@selector(jw_safeInitWithObjects:count:)];
            
            // 移除数据为nil时 crash
            [objc_getClass("__NSArrayM") swizzleSelector:@selector(removeObject:)
                                    withSwizzledSelector:@selector(jw_safeRemoveObject:)];
            
            // 添加数据为nil时 crash
            [objc_getClass("__NSArrayM") swizzleSelector:@selector(addObject:)
                                    withSwizzledSelector:@selector(jw_safeAddObject:)];
            
            // 移除数据下标越界 [array removeObjectAtIndex:1000];
            [objc_getClass("__NSArrayM") swizzleSelector:@selector(removeObjectAtIndex:)
                                    withSwizzledSelector:@selector(jw_safeRemoveObjectAtIndex:)];
            
            // 插入数据下标越界 [array insertObject:obj atIndex:1000];
            [objc_getClass("__NSArrayM") swizzleSelector:@selector(insertObject:atIndex:)
                                    withSwizzledSelector:@selector(jw_safeInsertObject:atIndex:)];
            
            // [array objectAtIndex:1000]这样的越界
            [objc_getClass("__NSArrayM") swizzleSelector:@selector(objectAtIndex:)
                                    withSwizzledSelector:@selector(jw_safeObjectAtIndex:)];
            
            // array[1000]这样的越界
            [objc_getClass("__NSArrayM") swizzleSelector:@selector(objectAtIndexedSubscript:)
                                    withSwizzledSelector:@selector(jw_safeObjectAtIndexedSubscript:)];
            
            // 替换某个数据越界 [array replaceObjectAtIndex:1000 withObject:obj];
            [objc_getClass("__NSArrayM") swizzleSelector:@selector(replaceObjectAtIndex:withObject:)
                                    withSwizzledSelector:@selector(jw_safeReplaceObjectAtIndex:withObject:)];
        }
    });
}

- (instancetype)jw_safeInitWithObjects:(const id _Nonnull __unsafe_unretained *)objects count:(NSUInteger)count
{
    BOOL hasNilObject = NO;
    for (NSUInteger i = 0; i < count; i++)
    {
        if ([objects[i] isKindOfClass:[NSArray class]])
        {
            
        }
        if (objects[i] == nil)
        {
            hasNilObject = YES;
        }
    }
    if (hasNilObject)
    {
        id __unsafe_unretained newObjects[count];
        NSUInteger index = 0;
        for (NSUInteger i = 0; i < count; ++i)
        {
            if (objects[i] != nil)
            {
                newObjects[index++] = objects[i];
            }
        }
        return [self jw_safeInitWithObjects:newObjects count:index];
    }
    
    return [self jw_safeInitWithObjects:objects count:count];
}

- (void)jw_safeRemoveObject:(id)obj
{
    if (obj == nil)
    {
        return;
    }
    [self jw_safeRemoveObject:obj];
}

- (void)jw_safeAddObject:(id)obj
{
    if (obj == nil)
    {
        return;
    }
    [self jw_safeAddObject:obj];
}

- (void)jw_safeRemoveObjectAtIndex:(NSUInteger)index
{
    if (self.count <= 0)
    {
        return;
    }
    if (index >= self.count)
    {
        return;
    }
    [self jw_safeRemoveObjectAtIndex:index];
}

- (void)jw_safeInsertObject:(id)obj atIndex:(NSUInteger)index
{
    if (obj == nil)
    {
        return;
    }
    if (index > self.count)
    {
        return;
    }
    [self jw_safeInsertObject:obj atIndex:index];
}

- (instancetype)jw_safeObjectAtIndex:(NSInteger)index
{
    if (self.count <= 0)
    {
        return nil;
    }
    if (index >= self.count)
    {
        return nil;
    }
    return [self jw_safeObjectAtIndex:index];
}

- (instancetype)jw_safeObjectAtIndexedSubscript:(NSUInteger)index
{
    if (self.count <= 0)
    {
        return nil;
    }
    if (index >= self.count)
    {
        return nil;
    }
    return [self jw_safeObjectAtIndexedSubscript:index];
}

- (void)jw_safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)obj
{
    if (obj == nil)
    {
        return;
    }
    if (self.count <= 0)
    {
        return;
    }
    if (index >= self.count)
    {
        return;
    }
    [self jw_safeReplaceObjectAtIndex:index withObject:obj];
}
@end
