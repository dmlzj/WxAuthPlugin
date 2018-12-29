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
WX_EXPORT_METHOD_SYNC(@selector(initWX:))
WX_EXPORT_METHOD(@selector(WXAuth:callback:))

/** 判断是否安装了微信 */
-(BOOL)isInstallWXApp
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.WXAppIsInstall = [WXApi isWXAppInstalled];
    });
    return self.WXAppIsInstall;
}

- (void)initWX:(NSString *)appkey
{
    [WXApi registerApp:appkey];
}

- (void)WXAuth:(NSDictionary *)info callback:(WXModuleCallback)callback
{
    [[WXAuthManager shareInstance] WXAuth:info callback:callback];
}
@end
