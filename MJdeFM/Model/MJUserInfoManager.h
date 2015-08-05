//
//  MJUserInfoManager.h
//
//
//  Created by WangMinjun on 15/8/4.
//
//

#import <Foundation/Foundation.h>
#import "MJUserInfo.h"

@interface MJUserInfoManager : NSObject

@property (nonatomic, strong) MJUserInfo* userInfo;

+ (instancetype)sharedUserInfoManager;

- (void)archiverUserInfo;
- (MJUserInfo*)unarchiverUserInfo;

@end
