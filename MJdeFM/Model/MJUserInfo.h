//
//  MJUserInfo.h
//
//
//  Created by WangMinjun on 15/8/4.
//
//

#import <Foundation/Foundation.h>

@interface MJUserInfo : NSObject <NSCoding>

@property (nonatomic, strong) NSString* login; // 0 : 登录成功
@property (nonatomic, strong) NSString* cookies;
@property (nonatomic, strong) NSString* userID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* banned;
@property (nonatomic, strong) NSString* liked;
@property (nonatomic, strong) NSString* played;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
+ (instancetype)userInfoWithDictionary:(NSDictionary*)dictionary;

@end
