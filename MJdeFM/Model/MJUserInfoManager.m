//
//  MJUserInfoManager.m
//
//
//  Created by WangMinjun on 15/8/4.
//
//

#import "MJUserInfoManager.h"

@implementation MJUserInfoManager

+ (instancetype)sharedUserInfoManager
{
    static MJUserInfoManager* userInfoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfoManager = [[self alloc] init];
    });
    return userInfoManager;
}

- (void)archiverUserInfo
{
    NSString* file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"userInfo.data"];
    [NSKeyedArchiver archiveRootObject:self.userInfo toFile:file];
}

- (MJUserInfo*)unarchiverUserInfo
{
    NSString* file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"userInfo.data"];
    MJUserInfo* userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    return userInfo;
}

- (void)setUserInfo:(MJUserInfo*)userInfo
{
    _userInfo = userInfo;
    [self archiverUserInfo];
}

@end
