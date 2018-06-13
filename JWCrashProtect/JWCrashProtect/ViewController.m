//
//  ViewController.m
//  JWCrashProtect
//
//  Created by wangjun on 2018/6/13.
//  Copyright © 2018年 wangjun. All rights reserved.
//

#import "ViewController.h"

#import "JWCrashProtect/JWCrashProtect.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4"]];
    
    NSLog(@"%@",tempArray[100]);
    [tempArray removeObjectAtIndex:10];
    [tempArray replaceObjectAtIndex:10 withObject:@"5"];
    NSLog(@"%@",tempArray);
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [tempDic setValue:nil forKey:@"1"];
    [tempDic setValue:@"2" forKey:nil];
    [tempDic setValue:@"3" forKey:@"3"];
    tempDic[@"4"] = nil;
    tempDic[@"5"] = @"5";
    NSLog(@"%@",tempDic);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
