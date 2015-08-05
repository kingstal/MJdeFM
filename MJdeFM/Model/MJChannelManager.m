//
//  MJChannelManager.m
//
//
//  Created by WangMinjun on 15/8/3.
//
//

#import "MJChannelManager.h"
#import "MJFetcher.h"
#import "MJUserInfoManager.h"

NSString* const MJChannelViewControllerDidSelectChannelNotification = @"MJChannelViewControllerDidSelectChannelNotification";

#define LOGINCHANNEL @"http://douban.fm/j/explore/get_login_chls?uk=%@"
#define RECOMMENDCHANNEL @"http://douban.fm/j/explore/get_recommend_chl"
#define TRENDINGCHANNEL @"http://douban.fm/j/explore/up_trending_channels"
#define HOTCHANNEL @"http://douban.fm/j/explore/hot_channels"

@interface MJChannelManager ()

@property (nonatomic, strong) NSOperationQueue* queue;

@end

@implementation MJChannelManager

- (NSOperationQueue*)queue
{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

+ (instancetype)sharedChannelManager
{
    static MJChannelManager* _channelManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _channelManager = [[self alloc] init];
    });
    return _channelManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        _channels = [[NSMutableArray alloc] init];
        [self addMyChannel];
        _currentChannel = _channels[0][0];
    }
    return self;
}

- (void)updateChannels
{
    [_channels removeAllObjects];
    [self addMyChannel];
    [self addRecommendChannel];
    [self addTrendingChannel];
    [self addHotChannel];
}

- (void)addMyChannel
{
    //我的兆赫
    MJChannel* privateChannel = [[MJChannel alloc] init];
    privateChannel.name = @"♪我的私人♪";
    privateChannel.ID = @"0";
    MJChannel* redheartChannel = [[MJChannel alloc] init];
    redheartChannel.name = @"我的红心";
    redheartChannel.ID = @"-3";

    NSArray* myChannels = @[ privateChannel, redheartChannel ];
    [_channels addObject:myChannels];
}

- (void)addRecommendChannel
{
    NSMutableArray* recommendChannels = [NSMutableArray array];
    NSString* cookies = [MJUserInfoManager sharedUserInfoManager].userInfo.cookies;

    if (cookies) {
        [[MJFetcher sharedFetcher] fetchChannelWithURL:[NSString stringWithFormat:LOGINCHANNEL, cookies]
            success:^(MJFetcher* fetcher, id data) {
                NSDictionary* channelDicts = [data objectForKey:@"res"];
                for (NSDictionary* channelDict in [channelDicts objectForKey:@"rec_chls"]) {
                    MJChannel* channel = [[MJChannel alloc] initWithDictionary:channelDict];
                    [recommendChannels addObject:channel];
                }
                [_channels addObject:recommendChannels];
                if ([self.delegate respondsToSelector:@selector(channelManagerdidUpdateChannel:)]) {
                    [self.delegate channelManagerdidUpdateChannel:self];
                }
            }
            failure:^(MJFetcher* fetcher, NSError* error) {
                NSLog(@"%@", error);
            }];
    }
    else {
        [[MJFetcher sharedFetcher] fetchChannelWithURL:RECOMMENDCHANNEL
            success:^(MJFetcher* fetcher, id data) {
                NSDictionary* channelDict = [data objectForKey:@"res"];
                MJChannel* channel = [[MJChannel alloc] initWithDictionary:channelDict];
                [recommendChannels addObject:channel];
                [_channels addObject:recommendChannels];
                if ([self.delegate respondsToSelector:@selector(channelManagerdidUpdateChannel:)]) {
                    [self.delegate channelManagerdidUpdateChannel:self];
                }
            }
            failure:^(MJFetcher* fetcher, NSError* error) {
                NSLog(@"%@", error);
            }];
    }
}

- (void)addTrendingChannel
{
    // 上升最快
    NSMutableArray* trendingChannels = [NSMutableArray array];
    [[MJFetcher sharedFetcher] fetchChannelWithURL:TRENDINGCHANNEL
        success:^(MJFetcher* fetcher, id data) {
            NSDictionary* channelDicts = data;
            for (NSDictionary* channelDict in [channelDicts objectForKey:@"channels"]) {
                MJChannel* channel = [[MJChannel alloc] initWithDictionary:channelDict];
                [trendingChannels addObject:channel];
            }
            [_channels addObject:trendingChannels];
            if ([self.delegate respondsToSelector:@selector(channelManagerdidUpdateChannel:)]) {
                [self.delegate channelManagerdidUpdateChannel:self];
            }
        }
        failure:^(MJFetcher* fetcher, NSError* error) {
            NSLog(@"%@", error);
        }];
}

- (void)addHotChannel
{
    // 热门
    NSMutableArray* hotChannels = [NSMutableArray array];

    [[MJFetcher sharedFetcher] fetchChannelWithURL:HOTCHANNEL
        success:^(MJFetcher* fetcher, id data) {
            NSDictionary* channelDicts = data;
            for (NSDictionary* channelDict in [channelDicts objectForKey:@"channels"]) {
                MJChannel* channel = [[MJChannel alloc] initWithDictionary:channelDict];
                [hotChannels addObject:channel];
            }
            [_channels addObject:hotChannels];
            if ([self.delegate respondsToSelector:@selector(channelManagerdidUpdateChannel:)]) {
                [self.delegate channelManagerdidUpdateChannel:self];
            }
        }
        failure:^(MJFetcher* fetcher, NSError* error) {
            NSLog(@"%@", error);
        }];
}

@end
