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
#import "MJUserInfo.h"

#define PLAYLISTURLFORMATSTRING                                                \
  @"http://douban.fm/j/mine/"                                                  \
  @"playlist?type=%@&sid=%@&pt=%f&channel=%@&from=mainsite"
#define CAPTCHAIDURLSTRING @"http://douban.fm/j/new_captcha"
#define CAPTCHAIMGURLFORMATSTRING @"http://douban.fm/misc/captcha?size=l&id=%@"
#define LOGINURLSTRING @"http://douban.fm/j/login"
#define LOGOUTURLSTRING @"http://douban.fm/partner/logout"
#define ADDHEARTSONGURL @"http://douban.fm/j/song/%@/interest"

@implementation MJFetcher

+ (MJFetcher *)sharedFetcher {
  static MJFetcher *_sharedFetcher = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedFetcher = [[self alloc] init];
  });
  return _sharedFetcher;
}

/**
 *  实例化一个AFHTTPRequestOperationManager，用于解析 json
 */
- (AFHTTPRequestOperationManager *)JSONRequestOperationManager {
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  manager.responseSerializer = [AFJSONResponseSerializer serializer];
  // fixed server text/html issue
  NSSet *acceptableContentTypes = [NSSet
      setWithObjects:@"application/json", @"text/json", @"text/javascript",
                     @"text/plain", @"text/html", nil];
  [manager.responseSerializer setAcceptableContentTypes:acceptableContentTypes];
  return manager;
}

/**
 *  实例化一个通用的AFHTTPRequestOperationManager
 */
- (AFHTTPRequestOperationManager *)HTTPRequestOperationManager {
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  return manager;
}

// type
// n : None. Used for get a song list only.
// e : Ended a song normally.
// u : Unlike a hearted song.
// r : Like a song.
// s : Skip a song.
// b : Trash a song.
// p : Use to get a song list when the song in playlist was all played.
// sid : the song's id
/**
 *  获取播放列表信息
 */
- (void)fetchPlaylistwithType:(NSString *)type
                         song:(MJSong *)song
                   passedTime:(NSTimeInterval)passedTime
                      channel:(MJChannel *)channel
                      success:(MJFetcherSuccessBlock)successBlock
                      failure:(MJFetcherErrorBlock)errorBlock {
  NSString *playlistURLString =
      [NSString stringWithFormat:PLAYLISTURLFORMATSTRING, type, song.sid,
                                 passedTime, channel.ID];
  NSLog(@"---url:%@", playlistURLString);

  self.requestOperation =
      [[self JSONRequestOperationManager] GET:playlistURLString
          parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *songDictionary = responseObject;
            NSMutableArray *songs = [NSMutableArray new];
            for (NSDictionary *song in [songDictionary objectForKey:@"song"]) {
              // subtype=T为广告标识位，如果是T，则不加入播放列表(去广告)
              if ([[song objectForKey:@"subtype"] isEqualToString:@"T"]) {
                continue;
              }
              MJSong *tempSong = [[MJSong alloc] initWithDictionary:song];
              [songs addObject:tempSong];
            }
            successBlock(self, songs);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            errorBlock(self, error);
          }];
}

- (void)fetchCaptchaImageURLSuccess:(MJFetcherSuccessBlock)successBlock
                            failure:(MJFetcherSuccessBlock)errorBlock {
  self.requestOperation = [[self HTTPRequestOperationManager]
      GET:CAPTCHAIDURLSTRING
      parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableString *captchaID =
            [[NSMutableString alloc] initWithData:responseObject
                                         encoding:NSUTF8StringEncoding];
        [captchaID
            replaceOccurrencesOfString:@"\""
                            withString:@""
                               options:NSCaseInsensitiveSearch
                                 range:NSMakeRange(0, [captchaID length])];
        NSString *captchaImageURL =
            [NSString stringWithFormat:CAPTCHAIMGURLFORMATSTRING, captchaID];
        NSArray *captchaArray = @[ captchaID, captchaImageURL ];
        successBlock(self, captchaArray);
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(self, error);
      }];
}

- (void)loginwithUsername:(NSString *)username
                 password:(NSString *)password
                  captcha:(NSString *)captcha
                captchaID:(NSString *)captchaID
          rememberOnorOff:(NSString *)rememberOnorOff
                  success:(MJFetcherSuccessBlock)successBlock
                  failure:(MJFetcherErrorBlock)errorBlock {
  NSDictionary *loginParameters = @{
    @"source" : @"radio",
    @"alias" : username,
    @"form_password" : password,
    @"captcha_solution" : captcha,
    @"captcha_id" : captchaID,
    @"remember" : rememberOnorOff
  };

  self.requestOperation =
      [[self JSONRequestOperationManager] POST:LOGINURLSTRING
          parameters:loginParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *result = responseObject;
            MJUserInfo *userInfo =
                [[MJUserInfo alloc] initWithDictionary:result];
            successBlock(self, userInfo);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            errorBlock(self, error);
          }];
}

- (void)logoutUser:(MJUserInfo *)userInfo
           success:(MJFetcherSuccessBlock)successBlock
           failure:(MJFetcherErrorBlock)errorBlock {
  NSDictionary *logoutParameters = @{
    @"source" : @"radio",
    @"ck" : userInfo.cookies,
    @"no_login" : @"y"
  };
  self.requestOperation =
      [[self HTTPRequestOperationManager] GET:LOGOUTURLSTRING
          parameters:logoutParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
            successBlock(self, responseObject);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            errorBlock(self, error);
          }];
}

- (void)fetchChannelWithURL:(NSString *)url
                    success:(MJFetcherSuccessBlock)successBlock
                    failure:(MJFetcherErrorBlock)errorBlock {
  self.requestOperation = [[self JSONRequestOperationManager] GET:url
      parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"--succcess:%@", url);
        NSDictionary *result = responseObject;
        NSDictionary *channels = [result objectForKey:@"data"];
        successBlock(self, channels);
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(self, error);
      }];
}

- (void)user:(MJUserInfo *)user
addHeartSong:(MJSong *)song
      action:(NSString *)action
     success:(MJFetcherSuccessBlock)successBlock
     failure:(MJFetcherErrorBlock)errorBlock {
  NSDictionary *parameters = @{ @"ck" : user.cookies, @"action" : action };

  self.requestOperation = [[self HTTPRequestOperationManager]
      POST:[NSString stringWithFormat:ADDHEARTSONGURL, song.sid]
      parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(self, responseObject);
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(self, error);
      }];
}
@end
