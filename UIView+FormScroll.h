//
//  UIView+FormScroll.h
//  gcleeEmpty
//
//  Created by LeeGichun on 2015. 12. 12..
//  Copyright (c) 2015년 gclee. All rights reserved.
//

#ifndef gcleeEmpty_UIView_FormScroll_h
#define gcleeEmpty_UIView_FormScroll_h

#import <Foundation/Foundation.h>

@interface UIView (FormScroll)

-(void)scrollToY:(float)y;
-(void)scrollToView:(UIView *)view;
-(void)scrollToTag:(UIView *)view tag:(NSInteger)tag;
-(void)scrollElement:(UIView *)view toPoint:(float)y;

@end

#endif
