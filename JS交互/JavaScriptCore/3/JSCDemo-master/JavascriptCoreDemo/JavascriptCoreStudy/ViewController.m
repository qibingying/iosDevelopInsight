//
//  ViewController.m
//  JavascriptCoreStudy
//
//  Created by shange on 2017/4/12.
//  Copyright © 2017年 jinshan. All rights reserved.
//

#import "ViewController.h"
#import "GetImage.h"
#import <SMS_SDK/SMSSDK.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "SaveImage_Util.h"
/**
 *  实现js代理，js调用ios的入口就在这里
 */
@protocol JSDelegate <JSExport>

- (void)getImage:(id)parameter;// 这个方法就是window.document.iosDelegate.getImage(JSON.stringify(parameter)); 中的 getImage()方法

@end

@interface ViewController ()<UIWebViewDelegate,JSDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,JSOCViewControllerExport>
/**
 *  属性说明
 */
@property(nonatomic,strong) UIWebView *mywebview;
/**
 *  属性说明
 */
@property(nonatomic,strong) NSString *phoneNumber;
/**
 *  属性说明
 */
@property(nonatomic,strong) JSContext *jsContext;
//  代理专用
@property(strong, nonatomic) JSContext *myContext;
@property(retain, nonatomic) UIWebView *myWebView;


@end

@implementation ViewController
{
    int indextNumb;       // 交替图片名字
    UIImage *getImage;//获取的图片
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mywebview =[[UIWebView alloc]initWithFrame:self.view.frame];
    self.mywebview.delegate = self;
    NSString *filePath =[[NSBundle mainBundle]pathForResource:@"SMSDK" ofType:@"html"];
    if (filePath)
    {
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:filePath]];
        [self.mywebview loadRequest:request];
    }
    [self.view addSubview:self.mywebview];

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"-------------%@",request);
    return true;
}

//  注意此方法只会执行一次
-(void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self initSMSDK];
    [self getCode];
    [self commitCode];
//    协议测试
    // 协议测试
    [self gotoWebView];
    [self registOC];
}
// oc 调用js
-(void) initSMSDK
{
//    创建上下文
    // 1.这种方式需要传入一个JSVirtualMachine对象，如果传nil，会导致应用崩溃的。
//    JSVirtualMachine *JSVM = [[JSVirtualMachine alloc] init];
//    JSContext *jscontext = [[JSContext alloc] initWithVirtualMachine:JSVM];
    
    // 2.这种方式，内部会自动创建一个JSVirtualMachine对象，可以通过JSCtx.virtualMachine
    // 看其是否创建了一个JSVirtualMachine对象。
//    JSContext *jscontext = [[JSContext alloc] init];
/**********以上的方法经过测试都不好使*************/
    
//    创建上下文
   self.jsContext = [self.mywebview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//   参数接受  注意一定输传递方法的名字,不要加()// 和webview的调用方法的区别
    JSValue *jsvalue = _jsContext[@"initSDK"];   // 返回的是方法的名字和内容
    NSLog(@"----ll------%@",[jsvalue toDictionary]);
//   调用函数/传递参数
  JSValue *initData = [jsvalue callWithArguments:@[@"从oc中传递第一个参数进去"]];
  NSDictionary *dic = [initData toDictionary];
    NSString *appkey = dic[@"appkey"][@"appkey"];
    NSString  *appSecrect = dic[@"appSecrect"][@"appSecrect"];
    NSLog(@"-------ww--------------%@",dic);
    [SMSSDK registerApp:appkey withSecret:appSecrect];
    
//    NSString *
//    [jscontext evaluateScript:@"initSDK('abc')"];
}
// js 调用oc的代码
// 获取短信验证码
- (void) getCode
{
    //    异常捕获机制
    _jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        context.exception = exception;
        NSLog(@"---错误数据的处理----%@",exception);
    };

    __weak typeof (self) weakSelf = self; // 防止循环引用就加上 __weak
    _jsContext[@"getCode"] = ^ (id oc){
        NSLog(@"-----phone------%@",oc);
        NSArray *arr =[JSContext currentArguments]; // 获取当前的上下文
        for (id objc in arr) {
            weakSelf.phoneNumber = objc;
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:objc zone:@"86" customIdentifier:nil result:^(NSError *error) {
                JSContext *jscontext = weakSelf.jsContext;
                NSLog(@"------block中的jscontent---%@",jscontext);
                if (!error)
                {
                    JSValue *jsvalue = jscontext[@"getCodeCallBack"]; // 注入方法
                  [jsvalue callWithArguments:@[@"获取短信验证码成功"]];                               // 调用方法
                 }
                else
                {
                    JSValue *jsvalue = jscontext[@"getCodeCallBack"]; // 注入方法
                    [jsvalue callWithArguments:@[@"获取验证码失败"]];
                }
            }];
        }
    };
}

// 提交验证码
- (void)commitCode
{
    //    异常捕获机制
    _jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        context.exception = exception;
        NSLog(@"---错误数据的处理----%@",exception);
    };
    __weak typeof (self)weakSelf = self;
    _jsContext[@"commitCode"] = ^(){
        NSLog(@"------l--------------%@",weakSelf.phoneNumber);
            NSArray *args = [JSContext currentArguments]; //返回结果为当前被调用方法的参数
            for (id objc in args) {
                NSLog(@"---js返回的参数----%@",objc); // 打印JS方法接收到的所有参数
                [SMSSDK commitVerificationCode:objc phoneNumber:weakSelf.phoneNumber zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
                    JSContext *jscontext = weakSelf.jsContext;//获取当前上下文
                    NSLog(@"-------js---%@",jscontext);
                    if (!error)
                    {
                         NSLog(@"成功了啊");
                        JSValue *jsvalue = jscontext[@"commitCodeCallBack"]; // 注入方法
                        [jsvalue callWithArguments:@[@"验证成功"]];
                    }
                    else
                    {
                         NSLog(@"失败了啊");
                        JSValue *jsvalue = jscontext[@"commitCodeCallBack"]; // 注入方法
                        [jsvalue callWithArguments:@[@"验证失败"]];
                    }
                }];
        }
    };
}
#pragma mark 调用方法
- (void)gotoWebView
{
    if (!self.myWebView)
    {
        //初始化 WebView
        self.myWebView = [[UIWebView alloc] initWithFrame:
                          CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-100)];
        self.myWebView.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.400 alpha:1.000];
        // 代理
        self.myWebView.delegate = self;
        NSURL *path = [[NSBundle mainBundle] URLForResource:@"SMSDK" withExtension:@"html"];
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:path]];
        [self.view addSubview:self.myWebView];
    }
}

#pragma mark UIWebViewDelegate
// 加载完成开始监听js的方法
- (void)registOC
{
    self.jsContext = [self.myWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"iosDelegate"] = self;//挂上代理  iosDelegate是window.document.iosDelegate.getImage(JSON.stringify(parameter)); 中的 iosDelegate
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception){
        context.exception = exception;
        NSLog(@"获取 self.jsContext 异常信息：%@",exception);
    };
//    测试处理
    self.jsContext[@"objc"] = self;//挂上代理  iosDelegate是window.document.iosDelegate.getImage(JSON.stringify(parameter)); 中的 iosDelegate
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception){
        context.exception = exception;
        NSLog(@"js方法写错了 错误的信息都会在此处输出：%@",exception);
    };
}

//  协议实现
- (void)getImage:(id)parameter
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@" 1当前线程  %@",[NSThread currentThread]);
            // 把 parameter json字符串解析成字典
            NSString *jsonStr = [NSString stringWithFormat:@"%@", parameter];
            NSDictionary *jsParameDic = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding ] options:NSJSONReadingMutableContainers error:nil];
            NSLog(@" 2当前线程  %@",[NSThread currentThread]);
            NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSObject *object = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:0
                                                                 error:&err];
NSLog(@" 2%@",object);
            
        });});
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSObject *object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
//    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
//    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"js传来的json字典: %@", jsParameDic);
//
//    });
        NSArray *arr =[JSContext currentArguments];
    for (id objc in arr)
    {
        NSLog(@"=-----%@",[objc toDictionary]);
        NSLog(@" 3当前线程  %@",[NSThread currentThread]);

    }
    [self beginOpenPhoto];  // 相机的处理,
}

+ (NSString*)getJsonWith:(NSDictionary*)dic {
    
    NSString *json = nil;
    
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        
        if(!error) {
            
            json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
        }
        
        else {
            
            NSLog(@"JSON parse error: %@", error);
            
        }
        
    }
    
    else {
        
        NSLog(@"Not a valid JSON object: %@", dic);
        
    }
    
    return json;
    
}
- (void)beginOpenPhoto
{
    // 主队列 异步打开相机
    dispatch_async(dispatch_get_main_queue(), ^{
        [self takePhoto];
    });
}
#pragma mark 取消选择照片代理方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark      //打开本地照片
- (void) localPhoto
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark      //打开相机拍照
- (void) takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"模拟器中不能打开相机");
        [self localPhoto];
    }
}
//  选择一张照片后进入这里
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //  当前选择的类型是照片
    if ([type isEqualToString:@"public.image"])
    {
        // 获取照片
        getImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSLog(@"===Decoded image size: %@", NSStringFromCGSize(getImage.size));
        // obtainImage 压缩图片 返回原尺寸
        indextNumb = indextNumb == 1?2:1;
        NSString *nameStr = [NSString stringWithFormat:@"Varify%d.jpg",indextNumb];
        __weak typeof (self) weakSelf = self;
        [SaveImage_Util saveImage:getImage ImageName:nameStr back:^(NSString *imagePath) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"图片路径：%@",imagePath);
                /**
                 *  这里是IOS 调 js 其中 setImageWithPath 就是js中的方法 setImageWithPath(),参数是字典
                 */
                JSValue *jsValue = weakSelf.jsContext[@"setImageWithPath"];
                [jsValue callWithArguments:@[@{@"imagePath":imagePath,@"iosContent":@"获取图片成功，把系统获取的图片路径传给js 让html显示"}]];
            });
        }];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

// 测试
- (void)takePicture
{
    //    当使用JSExport协议的方式来实现交互时，我们可能会在我们的交互对象中声明了一个JSContext属性用来保存JS上下文，代码可能通常这样
    NSLog(@"走吧");
}























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
