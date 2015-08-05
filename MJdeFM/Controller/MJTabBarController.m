//
//  MJTabBarController.m
//
//
//  Created by WangMinjun on 15/8/3.
//
//

#import "MJTabBarController.h"
#import "ContextMenuCell.h"
#import "YALContextMenuTableView.h"
#import "MJPlayerViewController.h"
#import "MJUserInfoViewController.h"
#import "MJChannelViewController.h"
#import "Masonry.h"

static NSString* const menuCellIdentifier = @"rotationCell";

@interface MJTabBarController () <UITableViewDelegate,
    UITableViewDataSource,
    YALContextMenuTableViewDelegate>

@property (nonatomic, strong) YALContextMenuTableView* contextMenuTableView;

@property (nonatomic, strong) NSArray* menuTitles;
@property (nonatomic, strong) NSArray* menuIcons;

@end

@implementation MJTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initiateMenuOptions];
    [self initButton];

    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MJPlayerViewController* playerVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([MJPlayerViewController class])];
    MJUserInfoViewController* userInfoVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([MJUserInfoViewController class])];
    MJChannelViewController* channelVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([MJChannelViewController class])];

    self.viewControllers = @[ playerVC, channelVC, userInfoVC ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBar.hidden = YES;

    //移除UITabBarButton
    for (UIView* child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //should be called after rotation animation completed
    [self.contextMenuTableView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    [self.contextMenuTableView updateAlongsideRotation];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:nil
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                                     //should be called after rotation animation completed
                                     [self.contextMenuTableView reloadData];
                                 }];
    [self.contextMenuTableView updateAlongsideRotation];
}

#pragma mark - IBAction

- (void)presentMenuButtonTapped
{
    // init YALContextMenuTableView tableView
    if (!self.contextMenuTableView) {
        self.contextMenuTableView = [[YALContextMenuTableView alloc] initWithTableViewDelegateDataSource:self];
        self.contextMenuTableView.animationDuration = 0.15;
        //optional - implement custom YALContextMenuTableView custom protocol
        self.contextMenuTableView.yalDelegate = self;

        //register nib
        UINib* cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
        [self.contextMenuTableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];
    }

    // it is better to use this method only for proper animation
    [self.contextMenuTableView showInView:self.view withEdgeInsets:UIEdgeInsetsZero animated:YES];
}

#pragma mark - Local methods

- (void)initButton
{
    UIButton* button = [UIButton new];
    [button setBackgroundImage:[UIImage imageNamed:@"menuIcon"]
                      forState:UIControlStateNormal];
    [button addTarget:self action:@selector(presentMenuButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    [button mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view.mas_top).offset(3);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.equalTo(@64);
        make.width.equalTo(@64);
    }];
}

- (void)initiateMenuOptions
{
    self.menuTitles = @[
        @"",
        @"",
        @"",
        @"",
    ];

    self.menuIcons = @[ [UIImage imageNamed:@"menuClose"],
        [UIImage imageNamed:@"menuPlayer"],
        [UIImage imageNamed:@"menuChannel"],
        [UIImage imageNamed:@"menuLogin"] ];
}

#pragma mark - YALContextMenuTableViewDelegate

- (void)contextMenuTableView:(YALContextMenuTableView*)contextMenuTableView didDismissWithIndexPath:(NSIndexPath*)indexPath
{
    //    NSLog(@"Menu dismissed with indexpath = %@", indexPath);
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(YALContextMenuTableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView dismisWithIndexPath:indexPath];
    switch (indexPath.row) {
    case 0:
        break;
    case 1:
    case 2:
    case 3:
        self.selectedIndex = indexPath.row - 1;
        break;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 64;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuTitles.count;
}

- (UITableViewCell*)tableView:(YALContextMenuTableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    ContextMenuCell* cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];

    if (cell) {
        cell.backgroundColor = [UIColor clearColor];
        cell.menuTitleLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
        cell.menuImageView.image = [self.menuIcons objectAtIndex:indexPath.row];
    }

    return cell;
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController*)tabBarController didSelectViewController:(UIViewController*)viewController
{
    //set up crossfade transition
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionFade;
    //apply transition to tab bar controller's view
    [self.tabBarController.view.layer addAnimation:transition forKey:nil];
}

@end
