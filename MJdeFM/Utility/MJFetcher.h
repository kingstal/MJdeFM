//
//  MJFetcher.h
//
//
//  Created by WangMinjun on 15/8/3.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class MJSong;
@class MJChannel;
@class MJFetcher;

typedef void (^MJMJFetcherErrorBlock)(MJFetcher* fetcher, NSError* error);
typedef void (^MJMJFetcherSuccessBlock)(MJFetcher* fetcher, id data);

@interface MJFetcher : NSObject

@property (nonatomic, strong) NSOperation* requestOperation;

+ (MJFetcher*)sharedFetcher;

- (void)fetchPlaylistwithType:(NSString*)type song:(MJSong*)song passedTime:(NSTimeInterval)passedTime channel:(MJChannel*)channel success:(MJMJFetcherSuccessBlock)successBlock failure:(MJMJFetcherErrorBlock)errorBlock;

@end
