//
//  MJLoginViewController.m
//
//
//  Created by WangMinjun on 15/8/4.
//
//

#import "MJLoginViewController.h"
#import "MJFetcher.h"
#import "UIButton+AFNetworking.h"
#import "MJUserInfo.h"

@interface MJLoginViewController ()

@property (nonatomic, weak) IBOutlet UIButton* captchaBtn;
@property (nonatomic, weak) IBOutlet UITextField* username;
@property (nonatomic, weak) IBOutlet UITextField* password;
@property (nonatomic, weak) IBOutlet UITextField* captcha;

@property (nonatomic, strong) NSString* captchaID;

- (IBAction)submitButtonTapped:(UIButton*)sender;
- (IBAction)cancelButtonTapped:(UIButton*)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)captchaBtnTapped:(id)sender;

@end

@implementation MJLoginViewController

- (void)
viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCaptcha];
}

- (void)loadCaptcha
{
    [[MJFetcher sharedFetcher] fetchCaptchaImageURLSuccess:^(MJFetcher* fetcher, id data) {
        NSArray* captchaArray = data;
        self.captchaID = captchaArray[0];
        [self.captchaBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:captchaArray[1]]];
    } failure:^(MJFetcher* fetcher, id data) {
        NSLog(@"%@", data);
    }];
}

- (IBAction)captchaBtnTapped:(id)sender
{
    [self loadCaptcha];
}

- (IBAction)submitButtonTapped:(UIButton*)sender
{
    NSString* username = _username.text;
    NSString* password = _password.text;
    NSString* captcha = _captcha.text;

    [[MJFetcher sharedFetcher] loginwithUsername:username
        password:password
        captcha:captcha
        captchaID:self.captchaID
        rememberOnorOff:@"off"
        success:^(MJFetcher* fetcher, id data) {
            MJUserInfo* userInfo = data;
            if ([userInfo.login isEqualToString:@"0"]) {
                if ([self.delegate respondsToSelector:@selector(loginViewControllerLoginSuccess:userInfo:)]) {
                    [self.delegate loginViewControllerLoginSuccess:self userInfo:userInfo];
                }
            }
        }
        failure:^(MJFetcher* fetcher, NSError* error) {
            NSLog(@"%@", error);
        }];
}

- (IBAction)cancelButtonTapped:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}

@end
