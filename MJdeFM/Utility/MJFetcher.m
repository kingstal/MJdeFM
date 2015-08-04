//
//  MJFetcher.m
//
//
//  Created by WangMinjun on 15/8/3.
//
//

#import "MJFetcher.h"
#import "MJSong.h"
#import "MJChannel.h"

#define PLAYLISTURLFORMATSTRING @"http://douban.fm/j/mine/playlist?type=%@&sid=%@&pt=%f&channel=%@&from=mainsite"
#define LOGINURLSTRING @"http://douban.fm/partner/logout"
#define LOGOUTURLSTRING @"http://douban.fm/partner/logout"
#define CAPTCHAIDURLSTRING @"http://douban.fm/j/new_captcha"
#define CAPTCHAIMGURLFORMATSTRING @"http://douban.fm/misc/captcha?size=m&id=%@"

@implementation MJFetcher

+ (MJFetcher*)sharedFetcher
{
    static MJFetcher* _sharedFetcher = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFetcher = [[self alloc] init];
    });
    return _sharedFetcher;
}

/**
 *  实例化一个AFHTTPRequestOperationManager，用于解析 json
 */
- (AFHTTPRequestOperationManager*)JSONRequestOperationManager
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // fixed server text/html issue
    NSSet* acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    [manager.responseSerializer setAcceptableContentTypes:acceptableContentTypes];
    return manager;
}

/**
 *  实例化一个通用的AFHTTPRequestOperationManager
 */
- (AFHTTPRequestOperationManager*)HTTPRequestOperationManager
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return manager;
}

//type
//n : None. Used for get a song list only.
//e : Ended a song normally.
//u : Unlike a hearted song.
//r : Like a song.
//s : Skip a song.
//b : Trash a song.
//p : Use to get a song list when the song in playlist was all played.
//sid : the song's id
/**
 *  获取播放列表信息
 */
- (void)fetchPlaylistwithType:(NSString*)type song:(MJSong*)song passedTime:(NSTimeInterval)passedTime channel:(MJChannel*)channel success:(MJMJFetcherSuccessBlock)successBlock failure:(MJMJFetcherErrorBlock)errorBlock
{
    NSString* playlistURLString = [NSString stringWithFormat:PLAYLISTURLFORMATSTRING, type, song.sid, passedTime, channel.ID];

    self.requestOperation = [[self JSONRequestOperationManager] GET:playlistURLString
        parameters:nil
        success:^(AFHTTPRequestOperation* operation, id responseObject) {
            NSDictionary* songDictionary = responseObject;
            NSMutableArray* songs = [NSMutableArray new];
            for (NSDictionary* song in [songDictionary objectForKey:@"song"]) {
                //subtype=T为广告标识位，如果是T，则不加入播放列表(去广告)
                if ([[song objectForKey:@"subtype"] isEqualToString:@"T"]) {
                    continue;
                }
                MJSong* tempSong = [[MJSong alloc] initWithDictionary:song];
                [songs addObject:tempSong];
            }
            successBlock(self, songs);
            //
            //            if ([type isEqualToString:@"r"]) {
            //                [SongInfo setCurrentSongIndex:-1];
            //            }
            //            else {
            //                if ([appDelegate.playList count] != 0) {
            //                    [SongInfo setCurrentSongIndex:0];
            //                    [SongInfo setCurrentSong:[appDelegate.playList objectAtIndex:[SongInfo currentSongIndex]]];
            //                    [appDelegate.player setContentURL:[NSURL URLWithString:[SongInfo currentSong].url]];
            //                    [appDelegate.player play];
            //                }
            //                //如果是未登录用户第一次使用红心列表，会导致列表中无歌曲
            //                else {
            //                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"HeyMan" message:@"红心列表中没有歌曲，请您先登陆，或者添加红心歌曲" delegate:self cancelButtonTitle:@"GET" otherButtonTitles:nil];
            //                    [alertView show];
            //                    ChannelInfo* myPrivateChannel = [[ChannelInfo alloc] init];
            //                    myPrivateChannel.name = @"我的私人";
            //                    myPrivateChannel.ID = @"0";
            //                    [ChannelInfo updateCurrentCannel:myPrivateChannel];
            //                }
            //            }
            //            [self.delegate reloadTableviewData];
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            //            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"HeyMan" message:@"登陆失败啦" delegate:self cancelButtonTitle:@"哦,酱紫" otherButtonTitles:nil];
            //            [alertView show];
            //            NSLog(@"LOADPLAYLIST_ERROR:%@", error);
            errorBlock(self, error);
        }];
}

@end
