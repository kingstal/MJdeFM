//
//  MJChannel.m
//
//
//  Created by WangMinjun on 15/8/3.
//
//

#import "MJChannel.h"

@implementation MJChannel

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        self.ID = [dictionary objectForKey:@"id"];
        self.name = [dictionary objectForKey:@"name"];
    }
    return self;
}

+ (instancetype)channelWithDictionary:(NSDictionary*)dictionary
{
    return [[MJChannel alloc] initWithDictionary:dictionary];
}

@end
