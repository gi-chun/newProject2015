//
//  NSMutableArray+Stack.h
//  gcleeEmpty
//
//  Created by LeeGichun on 2015. 12. 28..
//  Copyright (c) 2015년 gclee. All rights reserved.
//

#ifndef gcleeEmpty_NSMutableArray_Stack_h
#define gcleeEmpty_NSMutableArray_Stack_h

@interface NSMutableArray (StackExtension)

- (void)push:(id)object;
- (id)pop;
- (void)delAll;

@end

#endif
