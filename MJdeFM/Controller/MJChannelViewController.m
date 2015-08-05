//
//  MJChannelViewController.m
//
//
//  Created by WangMinjun on 15/8/5.
//
//

#import "MJChannelViewController.h"
#import "MJChannelManager.h"
#import "MJRefresh.h"

@interface MJChannelViewController () <MJChannelManagerDelegate>

@property (nonatomic, strong) NSArray* channels;

@end

@implementation MJChannelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 设置 MJChannelViewController 为 MJChannelManager 的 delegate，当 channel 发生改变时，tableView  reload
    [MJChannelManager sharedChannelManager].delegate = self;
    self.channels = [MJChannelManager sharedChannelManager].channels;

    //添加上拉刷新
    __weak __typeof(self) weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [[MJChannelManager sharedChannelManager] updateChannels];
        [weakSelf.tableView.header endRefreshing];
    }];
}

- (void)channelManagerdidUpdateChannel:(MJChannelManager*)manager
{
    self.channels = manager.channels;
}

- (void)setChannels:(NSArray*)channels
{
    _channels = [channels copy];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [self.channels count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.channels[section] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"channelCell" forIndexPath:indexPath];

    MJChannel* channel = self.channels[indexPath.section][indexPath.row];
    cell.textLabel.text = channel.name;
    return cell;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* title = nil;
    switch (section) {
    case 0:
        title = @"我的兆赫";
        break;
    case 1:
        title = @"推荐兆赫";
        break;
    case 2:
        title = @"上升最快兆赫";
        break;
    case 3:
        title = @"热门兆赫";
        break;
    default:
        break;
    }
    return title;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MJChannel* channel = self.channels[indexPath.section][indexPath.row];
    NSDictionary* dic = @{ @"channel" : channel };

    [[NSNotificationCenter defaultCenter] postNotificationName:MJChannelViewControllerDidSelectChannelNotification object:nil userInfo:dic];
}

@end
