//
//  MJChannelManager.h
//
//
//  Created by WangMinjun on 15/8/3.
//
//

#import <Foundation/Foundation.h>
#import "MJChannel.h"

@interface MJChannelManager : NSObject

@property (nonatomic, strong) MJChannel* currentChannel;
@property (nonatomic, strong) NSMutableArray* channels;

+ (instancetype)sharedChannelManager;
@end
