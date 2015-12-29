//
//  UIView+FormScroll.m
//  gcleeEmpty
//
//  Created by LeeGichun on 2015. 12. 12..
//  Copyright (c) 2015년 gclee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+FormScroll.h"


@implementation UIView (FormScroll)


-(void)scrollToY:(float)y
{
    
    [UIView beginAnimations:@"registerScroll" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    self.transform = CGAffineTransformMakeTranslation(0, y);
    [UIView commitAnimations];
    
}

-(void)scrollToView:(UIView *)view
{
    CGRect theFrame = view.frame;
    float y = theFrame.origin.y - 0;
    y -= (y/1.7);//1.7
    
    [self scrollToY:-y];
}

-(void)scrollToTag:(UIView *)view tag:(NSInteger)tag
{
    CGRect theFrame = view.frame;
    float y = 100;
    
    switch (tag) {
        case 1:
            y+=130;
            break;
        case 2:
            y+=170;
            break;
        case 4:
            y+=240;
            break;
        case 5:
            y+=300;
            break;
    }
    
    [self scrollToY:-y];
}


-(void)scrollElement:(UIView *)view toPoint:(float)y
{
    CGRect theFrame = view.frame;
    float orig_y = theFrame.origin.y;
    float diff = y - orig_y;
    if (diff < 0) {
        [self scrollToY:diff];
    }
    else {
        [self scrollToY:0];
    }
    
}

@end