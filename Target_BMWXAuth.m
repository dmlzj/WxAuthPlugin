//
//  Target_BMWXAuth.m
//  AFNetworking
//
//  Created by mac3 on 2018/12/30.
//

#import "Target_BMWXAuth.h"
#import "WXAuthManager.h"
@implementation Target_BMWXAuth
- (BOOL)Action_WXAuthHandleOpenURL:(NSDictionary *)info
{
    return [[WXAuthManager shareInstance] applicationOpenURL:info[@"url"]];

}

@end
