//
//  UIView+NibInitializer.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 12. 9..
//  Copyright (c) 2015년 gclee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+NibInitializer.h"

@implementation UIView (NibInitializer)

- (instancetype)initWithNibNamed:(NSString *)nibNameOrNil
{
    if (!nibNameOrNil) {
        nibNameOrNil = NSStringFromClass([self class]);
    }
    NSArray *viewsInNib = [[NSBundle mainBundle] loadNibNamed:nibNameOrNil
                                                        owner:self
                                                      options:nil];
    for (id view in viewsInNib) {
        if ([view isKindOfClass:[self class]]) {
            self = view;
            break;
        }
    }
    return self;
}

@end