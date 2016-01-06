//
//  LoginViewController.h
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 17..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LoginTypeDefault = 0,
    LoginTypeConfig,
    LoginTypeAD
}MYLoginType;


@protocol LoginViewControllerDelegate;

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;
@property (nonatomic) CGSize contentSize;

- (id)appDelegate;
- (void)autoLogin;
- (void)setLoginType:(NSInteger) loginType;

@end

@protocol LoginViewControllerDelegate <NSObject>
@optional
- (void)didTouchBackButton;
- (void)didLoginAfter;
- (void)didTouchMainAD;
- (void)didTouchGoSunny;
@end
