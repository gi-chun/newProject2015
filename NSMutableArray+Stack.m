//
//  NSMutableArray+Stack.m
//  gcleeEmpty
//
//  Created by LeeGichun on 2015. 12. 28..
//  Copyright (c) 2015년 gclee. All rights reserved.
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (StackExtension)

- (void)push:(id)object {
    [self addObject:object];
}

- (id)pop {
    id lastObject = [self lastObject];
    [self removeLastObject];
    return lastObject;
}

- (void)delAll
{
    [self removeAllObjects];
}

@end