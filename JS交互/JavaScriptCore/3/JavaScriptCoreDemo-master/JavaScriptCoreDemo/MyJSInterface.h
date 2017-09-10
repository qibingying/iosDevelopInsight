//
//  MyJSInterface.h
//  JavaScriptCoreDemo
//
//  Created by 晓童 韩 on 16/2/26.
//  Copyright © 2016年 晓童 韩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol MyJSInterfaceExport <JSExport>

- (void)log:(NSString *)logStr;

- (void)myJSInterfaceMethodWithArg1:(NSString *)arg1;

/**
 *  多个参数调用时比较别扭，第二个参数之前直接加冒号。
 */
- (void)myJSInterfaceMethodWithArgs:(NSString *)arg1 :(NSString *)arg2;

- (NSNumber *)myJSInterfaceMethod:(NSNumber *)num;

//- (void)initMethodWithArg:(NSNumber *)num;

/**
 * init开头的方法必须使用JSExportAs转换。
 */
JSExportAs(initMethodWithArg, - (void)setupMethodWithArg:(NSNumber *)num);

@end

@interface MyJSInterface : NSObject <MyJSInterfaceExport>

@end
