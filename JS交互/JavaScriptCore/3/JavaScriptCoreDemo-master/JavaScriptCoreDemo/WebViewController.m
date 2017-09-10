//
//  WebViewController.m
//  JavaScriptCoreDemo
//
//  Created by 晓童 韩 on 16/2/25.
//  Copyright © 2016年 晓童 韩. All rights reserved.
//

#import "WebViewController.h"
#import <Masonry/Masonry.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "MyJSInterface.h"

@interface WebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) UIWebView *webView;

@property (nonatomic, strong) JSContext *context;
@property (nonatomic, strong) JSValue   *jsObj;
@property (nonatomic, strong) JSManagedValue *managedValue;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] init];
    //去掉UIWebView的底图
    for (UIView *subView in [webView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subView).bounces = NO;
        }
    }
    //设置背景透明
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    self.webView = webView;
    [self.view insertSubview:webView atIndex:0];
    self.webView.delegate = self;
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//  加载方式一
//    NSURL *htmlFile = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html" subdirectory:@"htmls"];
//    [webView loadRequest:[NSURLRequest requestWithURL:htmlFile]];

    
//  加载方式二
    NSURL *baseURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html" subdirectory:@"htmls"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html" inDirectory:@"htmls"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlStr baseURL:baseURL];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad");
    
    [self setupJSObj];
}

- (void)setupJSObj {
    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    MyJSInterface *ocObj = [[MyJSInterface alloc] init];
    JSValue *jsObj = [JSValue valueWithObject:ocObj inContext:self.context];
    self.jsObj = jsObj;
    JSManagedValue* managedValue = [JSManagedValue managedValueWithValue:self.jsObj];
    self.managedValue = managedValue;
    [self.context.virtualMachine addManagedReference:self.managedValue withOwner:self];
    self.context[@"jsObj"] = jsObj;
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"%@", exception);
        context.exception = exception;
    };
}

- (IBAction)callJSMethod:(UIButton *)sender {
    [self.webView stringByEvaluatingJavaScriptFromString:@"log('call js method!')"];
    
}


- (void)dealloc {
    NSLog(@"%@ dealloc", [self class]);
}
@end
