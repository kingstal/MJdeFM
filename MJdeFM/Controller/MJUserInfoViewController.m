//
//  MJUserInfoViewController.m
//
//
//  Created by WangMinjun on 15/8/4.
//
//

#import "MJUserInfoViewController.h"
#import "MJLoginViewController.h"
#import "UIButton+AFNetworking.h"
#import "MJUserInfo.h"
#import "MJFetcher.h"
#import "MJUserInfoManager.h"
#import "MBProgressHUD.h"

@interface MJUserInfoViewController () <MJLoginViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel* usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel* playedLabel;
@property (strong, nonatomic) IBOutlet UILabel* likedLabel;
@property (strong, nonatomic) IBOutlet UILabel* bannedLabel;
@property (strong, nonatomic) IBOutlet UIButton* loginBtn;
@property (strong, nonatomic) IBOutlet UIButton* logoutBtn;

@property (nonatomic, strong) MJUserInfo* userInfo;

- (IBAction)loginBtnTapped:(UIButton*)sender;
- (IBAction)logoutBtnTapped:(UIButton*)sender;

@end

@implementation MJUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.userInfo = [MJUserInfoManager sharedUserInfoManager].userInfo;
}
- (void)viewDidLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.loginBtn.layer.cornerRadius = self.loginBtn.frame.size.width / 2.0;
    self.loginBtn.layer.masksToBounds = YES;
}

- (void)setUserInfo:(MJUserInfo*)userInfo
{
    _userInfo = userInfo;

    if (!userInfo) {
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
        self.loginBtn.userInteractionEnabled = YES;
        self.usernameLabel.hidden = YES;
        self.playedLabel.text = @"0";
        self.likedLabel.text = @"0";
        self.bannedLabel.text = @"0";
        self.logoutBtn.hidden = YES;
        return;
    }
    [self.loginBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img3.douban.com/icon/ul%@-1.jpg", userInfo.userID]] placeholderImage:[UIImage imageNamed:@"lufei"]];

    self.loginBtn.userInteractionEnabled = NO;

    self.usernameLabel.text = userInfo.name;
    self.playedLabel.text = userInfo.played;
    self.likedLabel.text = userInfo.liked;
    self.bannedLabel.text = userInfo.banned;
    self.logoutBtn.hidden = NO;
}

- (IBAction)loginBtnTapped:(UIButton*)sender
{
    MJLoginViewController* loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MJLoginViewController class])];
    loginVC.delegate = self;
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)loginViewControllerLoginSuccess:(MJLoginViewController*)loginVC userInfo:(MJUserInfo*)userInfo
{
    self.userInfo = userInfo;
    [MJUserInfoManager sharedUserInfoManager].userInfo = userInfo;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logoutBtnTapped:(UIButton*)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[MJFetcher sharedFetcher] logoutUser:self.userInfo
        success:^(MJFetcher* fetcher, id data) {
            self.userInfo = nil;
            [MJUserInfoManager sharedUserInfoManager].userInfo = nil;

            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
        failure:^(MJFetcher* fetcher, NSError* error) {
            NSLog(@"%@", error);
        }];
}

@end
