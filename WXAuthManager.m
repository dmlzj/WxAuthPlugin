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

#pragma mark - 微信小程序唤起
- (void)LaunchMiniProgramReqWithId:(NSString *)programId programPath:(NSString *)path{
    // 第三方应用不需要判断微信版本具体支持哪些功能，由微信侧判断并作出相应的提示
    //if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        WXLaunchMiniProgramReq *launchMiniProgram = [WXLaunchMiniProgramReq object];
        launchMiniProgram.userName = programId ;//@"gh_735baf534a96";
        launchMiniProgram.path = path;   //小程序指定页面( 默认为nil, 默认首页)
        launchMiniProgram.miniProgramType = WXMiniProgramTypeRelease;
        dispatch_async(dispatch_get_main_queue(), ^{
            [WXApi sendReq:launchMiniProgram];
        });
    //}else{
        //提示
    //}
    
}
//微信授权登录回调
-(void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (self.WXAuthCallBack) {
            SendAuthResp *req = (SendAuthResp *)resp;
            self.WXAuthCallBack(req.code);
            self.WXAuthCallBack = nil;
        }
    }
}
//  处理回调结果
//
- (BOOL)applicationOpenURL:(NSURL *)url
{
    // 微信回调结果
    if ([url.host isEqualToString:@"oauth"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
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

