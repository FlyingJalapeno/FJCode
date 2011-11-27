//
//  NSFetchRequest+extensions.m
//  FJCode
//
//  Created by Corey Floyd on 11/26/11.
//  Copyright (c) 2011 Flying Jalapeño. All rights reserved.
//

#import "NSFetchRequest+extensions.h"
#import "NSPredicate+extensions.h"

@implementation NSFetchRequest (extensions)

- (void)andPredicate:(NSPredicate*)pred{
    
    if(pred == nil)
        return;
    
    NSPredicate* newPred = [self predicate];
    
    if(newPred)
        newPred = [newPred andPredicateWithPredicate:pred];
    else
        newPred = pred;
    
    [self setPredicate:newPred];

}


- (void)orPredicate:(NSPredicate*)pred{
    
    if(pred == nil)
        return;
    
    NSPredicate* newPred = [self predicate];
    
    if(newPred)
        newPred = [newPred orPredicateWithPredicate:pred];
    else
        newPred = pred;
    
    [self setPredicate:newPred];
}

@end
