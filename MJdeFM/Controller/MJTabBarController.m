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

    UIViewController* v1 = [UIViewController new];
    v1.view.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.78f alpha:1.0f];
    UIViewController* v2 = [UIViewController new];
    v2.view.backgroundColor = [UIColor greenColor];
    UIViewController* v3 = [UIViewController new];
    v3.view.backgroundColor = [UIColor yellowColor];
    self.viewControllers = @[ v1, v2, v3 ];
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
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(screenRect.size.width - 44,
                                                           0, 44, 44)];
    [button setBackgroundImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(presentMenuButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
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
    NSLog(@"Menu dismissed with indexpath = %@", indexPath);
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(YALContextMenuTableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView dismisWithIndexPath:indexPath];
    switch (indexPath.row) {
    case 0:
    case 1:
    case 2:
        self.selectedIndex = indexPath.row;
        break;
    case 3:
        break;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 45;
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
