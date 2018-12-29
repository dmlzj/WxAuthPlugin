//
//  WXAuthManager.m
//  WeexEros
//
//  Created by mac3 on 2018/12/28.
//  Copyright © 2018 benmu. All rights reserved.
//

#import "WXAuthManager.h"
#import "SVProgressHUD.h"
#import "WXApi.h"
#import "WXAuthInfoModel.h"
#import <YYModel/YYModel.h>
#import "NSDictionary+Util.h"

@interface WXAuthManager () <WXApiDelegate, UIAlertViewDelegate>
@property (nonatomic, copy) WXModuleCallback WXAuthCallBack;     // 微信授权登录结果回调js方法
@end

@implementation WXAuthManager

/* 检验是否安装了微信 */
- (BOOL)checkInstallWX
{
    if ([WXApi isWXAppInstalled]) {
        return YES;
    } else {
        [SVProgressHUD dismiss];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"需要安装微信进行授权"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"取消",@"安装", nil];
        [alert show];
    }
    
    return NO;
}


//调用微信授权登录
- (void)WXAuthWithInfo:(WXAuthInfoModel *)info
{
    if (![self checkInstallWX]) return;
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = info.scope;
    req.state = info.state;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

//微信授权登录回调
-(void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (self.WXAuthCallBack) {
            NSDictionary *resultData = [NSDictionary configCallbackDataWithResCode:resp.errCode msg:resp.errStr data:nil];
            self.WXAuthCallBack(resultData);
            self.WXAuthCallBack = nil;
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
    }
}

#pragma mark - Public Method

+ (instancetype)shareInstance
{
    static WXAuthManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[WXAuthManager alloc] init];
    });
    return _instance;
}

- (void)WXAuth:(NSDictionary *)authInfo callback:(WXModuleCallback)callback
{
    self.WXAuthCallBack = callback;
    WXAuthInfoModel * info = [WXAuthInfoModel yy_modelWithJSON:authInfo];
    [self WXAuthWithInfo:info];
}
@end
