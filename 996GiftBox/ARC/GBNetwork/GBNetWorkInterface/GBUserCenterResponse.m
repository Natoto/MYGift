//
//  GBUserCenterResponse.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-23.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBUserCenterResponse.h"
#import "GBUserInfoModel.h"

@implementation GBUserCenterResponse

- (id)initWithResponseDictionary:(NSDictionary *)responseDictionary {
    self = [super init];
    if (self) {
        if ([[responseDictionary allKeys] containsObject:@"error_code"]) {
            NSNumber *state = [responseDictionary objectForKey:@"error_code"];
            _isError = (state.intValue == 0 ? NO : YES);
            if (_isError) {
                _errorMessage = [responseDictionary objectForKey:@"msg"];
            }
        }
    }
    return self;
}

@end


#pragma mark - GBUserInfoResponse 用户信息

@implementation GBUserInfoResponse

- (id)initWithResponseDictionary:(NSDictionary *)responseDictionary
{
    self = [super initWithResponseDictionary:responseDictionary];
    if (self) {
        if (!_isError) {
            NSDictionary *dic = [responseDictionary objectForKey:@"data"];
            GBUserInfoModel *model = [[GBUserInfoModel alloc] init];
            model.userName = [dic objectForKey:@"username"];
            model.nickName = [dic objectForKey:@"nickname"];
            model.gender = [dic objectForKey:@"gender"];
            switch ([model.gender intValue]) {
                case 0:{
                    model.genderStr = @"保密";
                    break;
                }
                case 1:{
                    model.genderStr = @"男";
                    break;
                }
                case 2:{
                    model.genderStr = @"女";
                    break;
                }
                    
                default:
                    break;
            }
            model.avatar_small_url = [dic objectForKey:@"avatar_small_url"];
            model.avatar_middle_url = [dic objectForKey:@"avatar_middle_url"];
            model.avatar_big_url = [dic objectForKey:@"avatar_big_url"];
            
            self.userInfoModel = model;
        }
        
    }
    return self;
}

@end
