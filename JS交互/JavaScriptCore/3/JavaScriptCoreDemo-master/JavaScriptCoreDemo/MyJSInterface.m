//
//  MyJSInterface.m
//  JavaScriptCoreDemo
//
//  Created by 晓童 韩 on 16/2/26.
//  Copyright © 2016年 晓童 韩. All rights reserved.
//

#import "MyJSInterface.h"

@implementation MyJSInterface

#pragma mark - js调用接口
- (void)log:(NSString *)logStr {
    NSLog(@"%@", logStr);
}

- (void)myJSInterfaceMethodWithArg1:(NSString *)arg1 {
    NSLog(@"myJSInterfaceMethodWithArg1:%@", arg1);
}

- (void)myJSInterfaceMethodWithArgs:(NSString *)arg1 :(NSString *)arg2 {
    NSLog(@"myJSInterfaceMethodWithArgs:%@, %@", arg1, arg2);
}

- (NSNumber *)myJSInterfaceMethod:(NSNumber *)num {
    int numInt = [num intValue];
    numInt += 24;
    return [NSNumber numberWithInt:numInt];
}

- (void)setupMethodWithArg:(NSNumber *)num {
    NSLog(@"call js initMethodWithArg...");
}

@end
