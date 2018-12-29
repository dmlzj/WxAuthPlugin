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
@end
