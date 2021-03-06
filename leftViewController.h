//
//  leftViewController.h
//  gcleeEmpty
//
//  Created by gclee on 2015. 10. 21..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol leftViewControllerDelegate;

@interface leftViewController : UIViewController

@property (nonatomic, weak) id <leftViewControllerDelegate> delegate;

- (void)setViewLogin;
- (void)setViewLogout;

@end

@protocol leftViewControllerDelegate <NSObject>
@optional
- (void)didTouchMenuItem:(NSInteger)menuType;
- (void)didTouchCloseBtn;
- (void)didTouchLogOutBtn;
- (void)didTouchLogInBtn;
- (void)didTouchSummitBtn;
- (void)didTouchAD;
- (void)didTouchLetterBtn;
@end