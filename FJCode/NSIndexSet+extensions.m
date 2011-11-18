//
//  NSIndexSet+extensions.m
//  FJCode
//
//  Created by Corey Floyd on 11/14/11.
//  Copyright (c) 2011 Flying Jalapeño. All rights reserved.
//

#import "NSIndexSet+extensions.h"


NSIndexSet* contiguousIndexSetWithFirstAndLastIndexes(NSUInteger first, NSUInteger last){
    
    if(last < first)
        return nil;
    
    if(first == NSNotFound || last == NSNotFound)
        return nil;
    
    NSUInteger length = last-first + 1;
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(first, length)];
    
    return indexes;
    
}


NSIndexSet* indexesAdded(NSIndexSet* oldSet, NSIndexSet* newSet){
    
    NSMutableIndexSet* s = [newSet mutableCopy];
    [s removeIndexes:oldSet];
    
    return s;
}

NSIndexSet* indexesRemoved(NSIndexSet* oldSet, NSIndexSet* newSet){
    
    NSMutableIndexSet* s = [oldSet mutableCopy];
    [s removeIndexes:newSet];
    
    return s;
}



NSRange rangeWithContiguousIndexes(NSIndexSet* indexes){
    
    if(!indexesAreContiguous(indexes))
        return NSMakeRange(0, 0);
    
    NSUInteger firstIndex = [indexes firstIndex];
    NSUInteger length = [indexes count];
    
    return NSMakeRange(firstIndex, length);
    
}


BOOL indexesAreContiguous(NSIndexSet* indexes){
    
    if([indexes count] == 0)
        return YES;
    
    return ((([indexes lastIndex] - [indexes firstIndex]) + 1) == [indexes count]);
}


@implementation NSIndexSet (extensions)

- (NSIndexSet*)_intersectionWithIndexSet:(NSIndexSet*)otherIndexSet{
    
    return [self indexesWithOptions:0 passingTest:^BOOL(NSUInteger idx, BOOL *stop) {
        
        if([otherIndexSet containsIndex:idx])
            return YES;
        
        return NO;
        
    }];
}


- (NSIndexSet*)intersectionWithIndexSet:(NSIndexSet*)otherIndexSet{
    
    if([self count] < [otherIndexSet count]){
        
        return [self _intersectionWithIndexSet:otherIndexSet];
    }
    
    return [otherIndexSet _intersectionWithIndexSet:self];
    
}

@end
