//
//  WXAuthManager.h
//  WeexEros
//
//  Created by mac3 on 2018/12/28.
//  Copyright © 2018 benmu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>

@interface WXAuthManager : NSObject
+ (instancetype)shareInstance;
//调用微信授权登录
- (void)WXAuth:(NSDictionary *)AuthInfo callback:(WXModuleCallback)callback;

- (void) LaunchMiniProgramReqWithId:(NSString *)programId programPath:(NSString *)path;
/** 从其他app掉起次app时调用 */
- (BOOL)applicationOpenURL:(NSURL *)url;
@end

