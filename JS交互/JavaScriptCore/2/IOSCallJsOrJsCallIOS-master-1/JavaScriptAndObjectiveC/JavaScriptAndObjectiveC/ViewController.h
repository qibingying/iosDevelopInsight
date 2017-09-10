//
//  ViewController.h
//  JavaScriptAndObjectiveC
//
//  Created by huangyibiao on 15/10/13.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JavaScriptObjectiveCDelegate <JSExport>

// JS调用此方法来调用OC的系统相册方法
- (void)callSystemCamera;
// 在JS中调用时，函数名应该为showAlertMsg(arg1, arg2)
// 这里是只两个参数的。
- (void)showAlert:(NSString *)title msg:(NSString *)msg;
// 通过JSON传过来
- (void)callWithDict:(NSDictionary *)params;
// JS调用Oc，然后在OC中通过调用JS方法来传值给JS。
- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params;

@end

// 此模型用于注入JS的模型，这样就可以通过模型来调用方法。
@interface HYBJsObjCModel : NSObject <JavaScriptObjectiveCDelegate>

@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, weak) UIWebView *webView;


@property(nonatomic,strong)NSString *ftitle;//(分享朋友圈内容)
@property(nonatomic,assign)NSNumber *friendContent;//(分享朋友圈内容)

@end

@implementation HYBJsObjCModel

- (void)callWithDict:(NSDictionary *)params {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@" 1当前线程  %@",[NSThread currentThread]);
        __block NSThread *currentThread = [NSThread currentThread];
  NSLog(@"Js调用了OC的方法，参数为：%@", params);
//    NSData *jsonData = [params dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                        options:NSJSONReadingMutableContainers
//                                                          error:&err];
    NSLog(@"Js调用了OC的方法，参数为：%@", params[@"name"]);
    NSLog(@"Js调用了OC的方法，参数为：%@", params[@"age"]);
    self.ftitle =params[@"name"];
//    self.friendContent = params[@"age"];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:self.ftitle message:self.ftitle delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [a show];
    });
//             });});
}

// Js调用了callSystemCamera
- (void)callSystemCamera {
  NSLog(@"JS调用了OC的方法，调起系统相册");
  
  // JS调用后OC后，又通过OC调用JS，但是这个是没有传参数的
  JSValue *jsFunc = self.jsContext[@"jsFunc"];
  [jsFunc callWithArguments:nil];
}

- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params {
  NSLog(@"jsCallObjcAndObjcCallJsWithDict was called, params is %@", params);
    __block NSThread *currentThread = [NSThread currentThread];

    NSLog(@" 1当前线程  %@",[NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
//        if ([self isEqualToString:@"授权失败"]){
            UIAlertView *a = [[UIAlertView alloc] initWithTitle:self.ftitle message:self.ftitle delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [a show];
        
        [self performSelector:@selector(messageWithParameters) onThread:currentThread withObject:nil waitUntilDone:NO];

//        }
    });

  
}

- (void)messageWithParameters{
    NSLog(@" 2当前线程  %@",[NSThread currentThread]);
    // 调用JS的方法
    JSValue *jsParamFunc = self.jsContext[@"jsParamFunc"];
    [jsParamFunc callWithArguments:@[@{@"age": @10, @"name": @"lili", @"height": @158}]];
}

- (void)showAlert:(NSString *)title msg:(NSString *)msg {
  dispatch_async(dispatch_get_main_queue(), ^{
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [a show];
  });
}


@end

@interface ViewController : UIViewController

@end

