//
//  completeViewController.h
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 18..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol completeViewControllerDelegate;

@interface completeViewController : UIViewController

@property (nonatomic, weak) id<completeViewControllerDelegate> delegate;
@property (nonatomic) CGSize contentSize;

@end

@protocol completeViewControllerDelegate <NSObject>
@optional
- (void)didTouchBackButton;
- (void)didLoginAfter;
- (void)didTouchMainAD;
@end
