//
//  MJChannelManager.h
//
//
//  Created by WangMinjun on 15/8/3.
//
//

#import <Foundation/Foundation.h>
#import "MJChannel.h"

typedef void (^UpdateChannelsSuccessBlock)();

extern NSString* const MJChannelViewControllerDidSelectChannelNotification;

@class MJChannelManager;

@protocol MJChannelManagerDelegate <NSObject>

- (void)channelManagerdidUpdateChannel:(MJChannelManager*)manager;

@end

@interface MJChannelManager : NSObject

@property (nonatomic, strong) MJChannel* currentChannel;
@property (nonatomic, strong) NSMutableArray* channels;

@property (nonatomic, weak) id<MJChannelManagerDelegate> delegate;

+ (instancetype)sharedChannelManager;
- (void)updateChannels;

@end
