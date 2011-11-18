//
//  NSIndexSet+extensions.h
//  FJCode
//
//  Created by Corey Floyd on 11/14/11.
//  Copyright (c) 2011 Flying Jalapeño. All rights reserved.
//

#import <Foundation/Foundation.h>

NSRange rangeWithContiguousIndexes(NSIndexSet* indexes);

BOOL indexesAreContiguous(NSIndexSet* indexes);

NSIndexSet* indexesRemoved(NSIndexSet* oldSet, NSIndexSet* newSet);

NSIndexSet* indexesAdded(NSIndexSet* oldSet, NSIndexSet* newSet);

NSIndexSet* contiguousIndexSetWithFirstAndLastIndexes(NSUInteger first, NSUInteger last);

@interface NSIndexSet (extensions)

- (NSIndexSet*)intersectionWithIndexSet:(NSIndexSet*)otherIndexSet;

@end
