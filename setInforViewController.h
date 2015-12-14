//
//  setInforViewController.h
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 17..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol setInforViewControllerDelegate;

@interface setInforViewController : UIViewController <UITextFieldDelegate>

//@property (nonatomic,retain) UIPopoverController *popoverController;
@property (nonatomic,retain) UIDatePicker *datepicker;
@property (nonatomic, weak) id<setInforViewControllerDelegate> delegate;
@property (nonatomic) CGSize contentSize;

-(BOOL)textFieldValueIsValid:(UITextField*)textField;
-(void)endEdit;

@end

@protocol setInforViewControllerDelegate <NSObject>
@optional
- (void)didTouchBackButton;
- (void)didLoginAfter;
- (void)didTouchMainAD;
@end

