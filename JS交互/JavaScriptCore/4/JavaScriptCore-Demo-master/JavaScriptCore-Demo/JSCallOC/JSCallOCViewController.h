//
//  JSCallOCViewController.h
//  JavaScriptCore-Demo
//
//  Created by Jakey on 14/12/26.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//js 调 oc

#import <UIKit/UIKit.h>
//1.导入JavaScriptCore的头文件
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TestJSExport <JSExport>
//g修改别名  前面是js调用的方法名   改成后面的方法
JSExportAs
(calculateForJS  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)handleFactorialCalculateWithNumber:(NSNumber *)number
 );
//js调用的跳转界面的方法
- (void)pushViewController:(NSString *)view title:(NSString *)title;
@end


//3.在JS交互中，很多事情都是在webView的delegate方法中完成的所以要实现UIWebViewDelegate
@interface JSCallOCViewController : UIViewController<UIWebViewDelegate,TestJSExport>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
//通过JSContent创建一个使用JS的环境
@property (strong, nonatomic) JSContext *context;
@end
