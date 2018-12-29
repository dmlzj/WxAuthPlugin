//
//  WXAuthInfoModel.h
//  WeexEros
//
//  Created by mac3 on 2018/12/28.
//  Copyright © 2018 benmu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXAuthInfoModel : NSObject

@property (nonatomic, copy) NSString *scope;//应用授权作用域，如获取用户个人信息则填写snsapi_userinfo
@property (nonatomic, copy) NSString *state;//用于保持请求和回调的状态，授权请求后原样带回给第三方。该参数可用于防止csrf攻击（跨站请求伪造攻击），建议第三方带上该参数，可设置为简单的随机数加session进行校验
@property (nonatomic, copy) NSString *appid;//应用唯一标识，在微信开放平台提交应用审核通过后获得
@end
