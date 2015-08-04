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

- (void)viewDidLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.loginBtn.layer.cornerRadius = self.loginBtn.frame.size.width / 2.0;
    self.loginBtn.layer.masksToBounds = YES;
}

- (void)loginViewControllerLoginSuccess:(MJLoginViewController*)loginVC userInfo:(MJUserInfo*)userInfo
{
    self.userInfo = userInfo;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUserInfo:(MJUserInfo*)userInfo
{
    _userInfo = userInfo;

    [self.loginBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img3.douban.com/icon/ul%@-1.jpg", userInfo.userID]]];
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

- (IBAction)logoutBtnTapped:(UIButton*)sender
{
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
