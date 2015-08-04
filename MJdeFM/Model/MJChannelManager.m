//
//  MJChannelManager.m
//
//
//  Created by WangMinjun on 15/8/3.
//
//

#import "MJChannelManager.h"

@implementation MJChannelManager

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

        //初始化数据源Array
        //    [MJChannel updateChannelsTitleArray:@[ @"我的兆赫", @"推荐频道", @"上升最快兆赫", @"热门兆赫" ]];
        //    NSMutableArray* channels = [MJChannel channels];

        //我的兆赫
        MJChannel* myPrivateChannel = [[MJChannel alloc] init];
        myPrivateChannel.name = @"我的私人";
        myPrivateChannel.ID = @"0";
        MJChannel* myRedheartChannel = [[MJChannel alloc] init];
        myRedheartChannel.name = @"我的红心";
        myRedheartChannel.ID = @"-3";

        NSArray* myChannels = @[ myPrivateChannel, myRedheartChannel ];
        [_channels addObject:myChannels];
        //推荐兆赫
        NSArray* recommendChannels = [NSMutableArray array];
        [_channels addObject:recommendChannels];
        //上升最快兆赫
        NSMutableArray* upTrendingChannels = [NSMutableArray array];
        [_channels addObject:upTrendingChannels];
        //热门兆赫
        NSMutableArray* hotChannels = [NSMutableArray array];
        [_channels addObject:hotChannels];

        _currentChannel = myPrivateChannel;
    }
    return self;
}

@end
