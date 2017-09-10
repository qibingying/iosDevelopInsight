//
//  ViewController.m
//  JavaScriptCoreDemo
//
//  Created by 晓童 韩 on 16/2/25.
//  Copyright © 2016年 晓童 韩. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#import "Person.h"

@protocol JSUITextFieldExport <JSExport>

@property(nonatomic,copy) NSString *text;

@end

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self jsTest8];
    
    class_addProtocol([UITextField class], @protocol(JSUITextFieldExport));
}

- (IBAction)buttonClicked {
    JSContext *context = [[JSContext alloc] init];
    context[@"log"] = ^() {
        NSLog(@"---Begin Log---");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
        NSLog(@"---End Log---");
    };
    
    context[@"textField"] = self.textField;
    NSString *script = @"var text = textField.text;";
    [context evaluateScript:script];
    
    [context evaluateScript:@"log(text)"];
    
    NSString *script2 = @"var num = parseInt(textField.text, 10);"
    "++num;"
    "textField.text = num;";
    [context evaluateScript:script2];
}

- (void)jsTest {
    JSContext *context = [[JSContext alloc] init];
    JSValue *jsValue = [context evaluateScript:@"15 + 7"];
    int intVal = [jsValue toInt32];
    NSLog(@"JSValue: %@, int: %d", jsValue, intVal);
}

- (void)jsTest2 {
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"var arr = [15, 7 , 'www.ibloodline.com'];"];
    JSValue *jsValueArray = context[@"arr"]; // Get array from JSContext
    
    NSLog(@"jsValueArray: %@;    length: %@", jsValueArray, jsValueArray[@"length"]);
    jsValueArray[1] = @"blog"; // Use JSValue as array
    jsValueArray[7] = @7;
    
    NSLog(@"jsValueArray: %@;    length: %d", jsValueArray, [jsValueArray[@"length"] toInt32]);
    
    NSArray *nsArray = [jsValueArray toArray];
    NSLog(@"NSArray: %@", nsArray);
}

- (void)jsTest3 {
    JSContext *context = [[JSContext alloc] init];
    context[@"log"] = ^() {
        NSLog(@"---Begin Log---");
        
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
        
        JSValue *this = [JSContext currentThis];
        NSLog(@"this: %@",this);
        NSLog(@"---End Log---");
    };
    
    [context evaluateScript:@"log('ibloodline', [15, 7], { hello:'javascript', js:100 });"];
}

- (void)jsTest4 {
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"function add(a, b) { return a + b; }"];
    JSValue *add = context[@"add"];
    NSLog(@"JSValue add:  %@", add);
    
    JSValue *sum = [add callWithArguments:@[@(15), @(7)]];
    NSLog(@"JSValue sum:  %d",[sum toInt32]);
}

- (void)jsTest5 {
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *con, JSValue *exception) {
        NSLog(@"JSValue exception:%@", exception);
        con.exception = exception;
    };
    
    [context evaluateScript:@"ibloodline.age = 897"];
}

- (void)jsTest6 {
    
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *con, JSValue *exception) {
        NSLog(@"JSValue exception: %@", exception);
        con.exception = exception;
    };
    
    context[@"log"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            NSLog(@"---js log: ---");
            NSLog(@"%@", obj);
            NSLog(@"---js log end: ---");
        }
    };

    JSValue *obj =[context evaluateScript:@"var jsObj = { age:897, name:'ibloodline' }; log(jsObj.age); jsObj"];
    NSLog(@"JSValue obj: %@, %@", obj[@"age"], obj[@"name"]);
    
    NSDictionary *dic = [obj toDictionary];
    NSLog(@"NSDictionary dic: %@, %@", dic[@"age"], dic[@"name"]);
}

- (void)jsTest7 {
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *con, JSValue *exception) {
        NSLog(@"JSValue exception: %@", exception);
        con.exception = exception;
    };
    
    context[@"log"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            NSLog(@"---js log begin: ---");
            NSLog(@"%@", obj);
            NSLog(@"---js log end: ---");
        }
    };
    
    NSDictionary *dic = @{@"name": @"ibloodline", @"#":@(897)};
    context[@"dic"] = dic;
    [context evaluateScript:@"log(dic.name, dic['#'])"];
}

- (void)jsTest8 {
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *con, JSValue *exception) {
        NSLog(@"JSValue exception: %@", exception);
        con.exception = exception;
    };
    
    context[@"log"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            NSLog(@"js log: %@", obj);
        }
    };
    
    Person *person = [[Person alloc] init];
    context[@"p"] = person;
    person.firstName = @"Tony";
    person.lastName = @"Han";
    person.urls = @{@"site": @"http://www.ibloodline.com"};
    
    // ok to get fullName
    [context evaluateScript:@"log(p.fullName());"];
    // cannot access firstName
    [context evaluateScript:@"log(p.firstName);"];
    // ok to access dictionary as object
    [context evaluateScript:@"log('site:', p.urls.site, 'blog:', p.urls.blog);"];
    // ok to change urls property
    [context evaluateScript:@"p.urls = {blog:'http://blog.ibloodline.com'}"];
    [context evaluateScript:@"log('-------')"];
    [context evaluateScript:@"log('site:', p.urls.site, 'blog:', p.urls.blog);"];
    
    // affect on Objective-C side as well
    NSLog(@"%@", person.urls);
}

@end
