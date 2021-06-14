//
//  ViewController.m
//  WKwebview
//
//  Created by 倩 on 2020/6/28.
//  Copyright © 2020 倩. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
@interface ViewController ()
@property(nonatomic,strong)WKWebView *mainWebView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController *vc = [self getCurrentVC];
    NSLog(@"vc:%@",vc.description);
    // 禁止选择CSS
//    NSString *css = @"body{-webkit-user-select:none;-webkit-user-drag:none;}";
//
//    // CSS选中样式取消
//    NSMutableString *javascript = [NSMutableString string];
//    [javascript appendString:@"var style = document.createElement('style');"];
//    [javascript appendString:@"style.type = 'text/css';"];
//    [javascript appendFormat:@"var cssContent = document.createTextNode('%@');", css];
//    [javascript appendString:@"style.appendChild(cssContent);"];
//    [javascript appendString:@"document.body.appendChild(style);"];
//
//    // javascript注入
//    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
//    [userContentController addUserScript:noneSelectScript];
//    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
//    configuration.userContentController = userContentController;
    
    self.mainWebView = [[WKWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.mainWebView];
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    // Do any additional setup after loading the view.
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)canResignFirstResponder{
    return NO;
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation

{
}



-(UIViewController *) getTopMostController
{
    UIWindow *topWindow = [UIApplication sharedApplication].keyWindow;
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        topWindow = [self returnWindowWithWindowLevelNormal];
    }
    
    UIViewController *topController = topWindow.rootViewController;
    if(topController == nil)
    {
        topWindow = [UIApplication sharedApplication].delegate.window;
        if (topWindow.windowLevel != UIWindowLevelNormal)
        {
            topWindow = [self returnWindowWithWindowLevelNormal];
        }
        topController = topWindow.rootViewController;
    }
    
    while(topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    
    if([topController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController*)topController;
        topController = [nav.viewControllers lastObject];
        
        while(topController.presentedViewController)
        {
            topController = topController.presentedViewController;
        }
    }
    
    return topController;
}
-(UIWindow *) returnWindowWithWindowLevelNormal
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *topWindow in windows)
    {
        if (topWindow.windowLevel == UIWindowLevelNormal)
            return topWindow;
    }
    return [UIApplication sharedApplication].keyWindow;
}

-(UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            windows = tmpWin;
            break;
        }
    }
    result = window.rootViewController;
    while (result.presentingViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result visibleViewController];
    }
    return result;
}
@end
