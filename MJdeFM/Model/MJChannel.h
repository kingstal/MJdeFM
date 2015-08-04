//
//  MJChannel.h
//
//
//  Created by WangMinjun on 15/8/3.
//
//

#import <Foundation/Foundation.h>

@interface MJChannel : NSObject
@property (nonatomic) NSString* ID;
@property (nonatomic) NSString* name;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
+ (instancetype)channelWithDictionary:(NSDictionary*)dictionary;
@end
