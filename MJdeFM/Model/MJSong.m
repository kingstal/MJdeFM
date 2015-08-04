//
//  MJSong.m
//
//
//  Created by WangMinjun on 15/8/3.
//
//

#import "MJSong.h"

@implementation MJSong

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        self.artist = [dictionary objectForKey:@"artist"];
        self.title = [dictionary objectForKey:@"title"];
        self.url = [dictionary objectForKey:@"url"];
        self.picture = [dictionary objectForKey:@"picture"];
        self.length = [dictionary objectForKey:@"length"];
        self.like = [dictionary objectForKey:@"like"];
        self.sid = [dictionary objectForKey:@"sid"];
    }
    return self;
}

+ (instancetype)songWithDictionary:(NSDictionary*)dictionary
{
    return [[MJSong alloc] initWithDictionary:dictionary];
}

@end
