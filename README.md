 ![show](show.gif)



MJdeFM是一个关于豆瓣FM的iOS客户端，参考开源项目[DoubanFM](https://github.com/XVXVXXX/DoubanFM)，但在其基础上做了一些调整，主要包括以下几个方面：

- 对其代码进行重构，减少了模块之间的耦合度。

- 使用[Context-Menu.iOS](https://github.com/Yalantis/Context-Menu.iOS)替换原有的[CDSideBarController](https://github.com/christophedellac/CDSideBarController)。

- 修改了原有项目中的bug，并增添添加/取消红心歌曲的功能。

 ​

从该项目中学到的知识点：

- 使用`MPMoviePlayerController`来进行歌曲的播放。

- 使用`AVFoundation`中的`AVAudioSession`实现后台音乐播放。

 ``` objective-c
 	AVAudioSession* session = [AVAudioSession sharedInstance];
     [session setCategory:AVAudioSessionCategoryPlayback error:nil];
     [session setActive:YES error:nil];
 ```

- 添加播放控制器（Remote Control Events）

 ``` objective-c
 //告诉系统，接受远程控制事件
 [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
 [self becomeFirstResponder];

 //响应远程音乐播放控制消息
 - (void)remoteControlReceivedWithEvent:(UIEvent*)event
 {
     if (event.type == UIEventTypeRemoteControl) {
         switch (event.subtype) {
         case UIEventSubtypeRemoteControlPause:
         case UIEventSubtypeRemoteControlPlay:
             [self pauseButton:nil]; // 切换播放、暂停按钮
             break;
         case UIEventSubtypeRemoteControlNextTrack:
             [self skipButton:nil]; // 播放下一曲按钮
             break;
         default:
             break;
         }
     }
 }
 ```

 - 在锁屏界面显示播放歌曲信息

 ``` objective-c
 //其实就是设置一个全局变量的值，当系统处于音乐播放状态时，锁屏界面就会将NowPlayingInfo中的信息展示出来。
 - (void)configPlayingInfo
 {
     if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
         if (self.playingSong.title != nil) {
             NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
             [dict setObject:self.playingSong.title
                      forKey:MPMediaItemPropertyTitle];
             [dict setObject:self.playingSong.artist
                      forKey:MPMediaItemPropertyArtist];
             [dict
                 setObject:[NSNumber numberWithFloat:[self.playingSong.length floatValue]]
                    forKey:MPMediaItemPropertyPlaybackDuration];

             NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.playingSong.picture]];
             UIImage* posterImage = [UIImage imageWithData:data];
             if (posterImage) {
                 [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:posterImage] forKey:MPMediaItemPropertyArtwork];
             }

             [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
         }
     }
 }
 ```
