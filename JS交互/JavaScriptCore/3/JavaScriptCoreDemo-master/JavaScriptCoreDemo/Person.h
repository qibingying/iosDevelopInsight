//
//  Person.h
//  JavaScriptCoreDemo
//
//  Created by 晓童 韩 on 16/2/25.
//  Copyright © 2016年 晓童 韩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol PersonProtocol <JSExport>

@property (nonatomic, strong) NSDictionary *urls;
- (NSString *)fullName;

@end

@interface Person : NSObject <PersonProtocol>

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

@end
