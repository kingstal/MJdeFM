//
//  MJUserInfo.m
//
//
//  Created by WangMinjun on 15/8/4.
//
//

#import "MJUserInfo.h"

@implementation MJUserInfo

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        self.login = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"r"]];
        NSDictionary* tempUserInfoDic = [dictionary valueForKey:@"user_info"];
        self.cookies = [tempUserInfoDic valueForKey:@"ck"];
        self.userID = [tempUserInfoDic valueForKey:@"id"];
        self.name = [tempUserInfoDic valueForKey:@"name"];
        NSDictionary* tempPlayRecordDic = [tempUserInfoDic valueForKey:@"play_record"];
        self.banned = [NSString stringWithFormat:@"%@", [tempPlayRecordDic valueForKey:@"banned"]];
        self.liked = [NSString stringWithFormat:@"%@", [tempPlayRecordDic valueForKey:@"liked"]];
        self.played = [NSString stringWithFormat:@"%@", [tempPlayRecordDic valueForKey:@"played"]];
    }
    return self;
}

+ (instancetype)userInfoWithDictionary:(NSDictionary*)dictionary
{
    return [[MJUserInfo alloc] initWithDictionary:dictionary];
}

@end
