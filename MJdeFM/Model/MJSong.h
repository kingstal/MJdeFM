//
//  MJSong.h
//
//
//  Created by WangMinjun on 15/8/3.
//
//

#import <Foundation/Foundation.h>

@interface MJSong : NSObject

@property (nonatomic) NSString* title;
@property (nonatomic) NSString* artist;
@property (nonatomic) NSString* picture;
@property (nonatomic) NSString* length;
@property (nonatomic) NSString* like;
@property (nonatomic) NSString* url;
@property (nonatomic) NSString* sid;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
+ (instancetype)songWithDictionary:(NSDictionary*)dictionary;
@end
