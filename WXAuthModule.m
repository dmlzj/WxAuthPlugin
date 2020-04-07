//
//  WXAuthModule.m
//  WeexEros
//
//  Created by mac3 on 2018/12/28.
//  Copyright © 2018 benmu. All rights reserved.
//

#import "WXAuthModule.h"
#import "WXAuthManager.h"
#import <WechatOpenSDK/WXApi.h>
#import <WeexPluginLoader/WeexPluginLoader/WeexPluginLoader.h>

WX_PlUGIN_EXPORT_MODULE(WXAuth, WXAuthModule)

@interface WXAuthModule ()
@property (nonatomic, assign) BOOL WXAppIsInstall;
@end

@implementation WXAuthModule
@synthesize weexInstance;
WX_EXPORT_METHOD_SYNC(@selector(isInstallWXApp))
WX_EXPORT_METHOD_SYNC(@selector(initWX:universalLink:))
WX_EXPORT_METHOD(@selector(WXAuth:callback:))
WX_EXPORT_METHOD_SYNC(@selector(openMini:))

/** 判断是否安装了微信 */
-(BOOL)isInstallWXApp
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.WXAppIsInstall = [WXApi isWXAppInstalled];
    });
    return self.WXAppIsInstall;
}

- (void)initWX:(NSString *)appkey universalLink:(NSString *)universalLink
{
    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
      NSLog(@"WeChatSDK: %@", log);
    }];

  [WXApi registerApp:appkey universalLink:universalLink];

  //调用自检函数
  [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
      NSLog(@"%@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion);
    }];
}

- (void)WXAuth:(NSDictionary *)info callback:(WXModuleCallback)callback
{
    [[WXAuthManager shareInstance] WXAuth:info callback:callback];
}

- (void)openMini:(NSDictionary *)info
{
    [[WXAuthManager shareInstance] LaunchMiniProgramReqWithId:info[@"id"] programPath:info[@"path"]];
}

@end
