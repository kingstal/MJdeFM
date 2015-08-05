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

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init]) {
        self.login = [aDecoder decodeObjectForKey:@"login"];
        self.cookies = [aDecoder decodeObjectForKey:@"cookies"];
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.banned = [aDecoder decodeObjectForKey:@"banned"];
        self.liked = [aDecoder decodeObjectForKey:@"liked"];
        self.played = [aDecoder decodeObjectForKey:@"played"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:_login forKey:@"login"];
    [aCoder encodeObject:_cookies forKey:@"cookies"];
    [aCoder encodeObject:_userID forKey:@"userID"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_banned forKey:@"banned"];
    [aCoder encodeObject:_liked forKey:@"liked"];
    [aCoder encodeObject:_played forKey:@"played"];
}

@end
