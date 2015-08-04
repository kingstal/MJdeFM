//
//  MJLoginViewController.h
//
//
//  Created by WangMinjun on 15/8/4.
//
//

#import <UIKit/UIKit.h>
@class MJUserInfo;
@class MJLoginViewController;

@protocol MJLoginViewControllerDelegate <NSObject>

- (void)loginViewControllerLoginSuccess:(MJLoginViewController*)loginVC userInfo:(MJUserInfo*)userInfo;

@end

@interface MJLoginViewController : UIViewController

@property (nonatomic, weak) id<MJLoginViewControllerDelegate> delegate;

@end
