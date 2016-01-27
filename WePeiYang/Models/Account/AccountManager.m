//
//  AccountManager.m
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/25.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import "AccountManager.h"
#import "twtSDK.h"
#import "SolaFoundationKit.h"
#import "SolaInstance.h"
#import "SolaSessionManager.h"

@implementation AccountManager

+ (BOOL)tokenExists {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:TOKEN_SAVE_KEY] == nil) {
        return NO;
    } else {
        [SolaInstance shareInstance].token = [[NSUserDefaults standardUserDefaults] stringForKey:TOKEN_SAVE_KEY];
        return YES;
    }
}

+ (void)removeToken {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_SAVE_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ID_SAVE_KEY];
    [SolaInstance shareInstance].token = nil;
}

+ (void)getTokenWithTwtUserName:(NSString *)twtuname password:(NSString *)password success:(void (^)())success failure:(void (^)(NSString *))failure {
    [twtSDK getTokenWithTwtUserName:twtuname password:password success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic objectForKey:@"data"] != nil) {
            NSDictionary *data = [dic objectForKey:@"data"];
            if ([data objectForKey:@"token"] != nil) {
                NSString *token = [data objectForKey:@"token"];
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:TOKEN_SAVE_KEY];
                [[NSUserDefaults standardUserDefaults] setObject:twtuname forKey:ID_SAVE_KEY];
                [SolaInstance shareInstance].token = token;
                if (success != nil) {
                    success();
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure != nil) {
            NSError *jsonError;
            NSData *errorResponse = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:errorResponse options:NSJSONReadingMutableContainers error:&jsonError];
            if ([dic objectForKey:@"message"] != nil) {
                failure(dic[@"message"]);
            } else {
                failure(error.localizedDescription);
            }
        }
    }];
}

+ (void)refreshTokenSuccess:(void (^)())success failure:(void (^)(NSString *))failure {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:TOKEN_SAVE_KEY] != nil) {
        [twtSDK refreshTokenWithOldToken:[[NSUserDefaults standardUserDefaults] stringForKey:TOKEN_SAVE_KEY] success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (failure != nil) {
                NSError *jsonError;
                NSData *errorResponse = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:errorResponse options:NSJSONReadingMutableContainers error:&jsonError];
                if ([dic objectForKey:@"message"] != nil) {
                    failure(dic[@"message"]);
                } else {
                    failure(error.localizedDescription);
                }
            }
        }];
    } else {
        if (failure != nil) {
            failure(@"Token 不存在");
        }
    }
}

+ (void)tokenIsValid:(void (^)())success failure:(void (^)(NSString *))failure {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:TOKEN_SAVE_KEY] != nil) {
        [twtSDK checkToken:[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN_SAVE_KEY] success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            if ([dic objectForKey:@"error_code"] != nil) {
                if ([dic[@"error_code"] isEqualToString:@"-1"]) {
                    if (success != nil) {
                        success();
                    }
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (failure != nil) {
                NSError *jsonError;
                NSData *errorResponse = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:errorResponse options:NSJSONReadingMutableContainers error:&jsonError];
                if ([dic objectForKey:@"message"] != nil) {
                    failure(dic[@"message"]);
                } else {
                    failure(error.localizedDescription);
                }
            }
        }];
    } else {
        if (failure != nil) {
            failure(@"Token 不存在");
        }
    }
}

+ (void)bindTjuAccountWithTjuUserName:(NSString *)tjuuname password:(NSString *)tjupwd success:(void (^)())success failure:(void (^)(NSString *))failure {
    NSDictionary *parameters = @{@"tjuuname": tjuuname,
                                 @"tjupasswd": tjupwd};
    [SolaSessionManager solaSessionWithSessionType:SessionTypeGET URL:@"/auth/bind/tju" token:[[NSUserDefaults standardUserDefaults] stringForKey:TOKEN_SAVE_KEY] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary *dic = (NSDictionary *)responseObject;
//        if ([dic objectForKey:@"error_code"] != nil) {
//            if ([dic[@"error_code"] isEqualToString:@"-1"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TJU_BIND_KEY];
        if (success != nil) {
            success();
        }
//            }
//        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure != nil) {
            NSError *jsonError;
            NSData *errorResponse = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:errorResponse options:NSJSONReadingMutableContainers error:&jsonError];
            if ([dic objectForKey:@"message"] != nil) {
                failure(dic[@"message"]);
            } else {
                failure(error.localizedDescription);
            }
        }
    }];
}

+ (void)unbindTjuAccountSuccess:(void (^)())success failure:(void (^)(NSString *))failure {
    [SolaSessionManager solaSessionWithSessionType:SessionTypeGET URL:@"/auth/unbind/tju" token:[[NSUserDefaults standardUserDefaults] stringForKey:TOKEN_SAVE_KEY] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:TJU_BIND_KEY];
        if (success != nil) {
            success();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure != nil) {
            NSError *jsonError;
            NSData *errorResponse = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:errorResponse options:NSJSONReadingMutableContainers error:&jsonError];
            if ([dic objectForKey:@"message"] != nil) {
                failure(dic[@"message"]);
            } else {
                failure(error.localizedDescription);
            }
        }
    }];
}

@end