//
//  Person.m
//  JavaScriptCoreDemo
//
//  Created by 晓童 韩 on 16/2/25.
//  Copyright © 2016年 晓童 韩. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize urls;

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
