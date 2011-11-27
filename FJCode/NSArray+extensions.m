//
//  NSArray+extensions.m
//  FJCode
//
//  Created by Corey Floyd on 11/26/11.
//  Copyright (c) 2011 Flying Jalapeño. All rights reserved.
//

#import "NSArray+extensions.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@implementation NSArray (extensions)


- (BOOL)isEmpty {
	return [self count] == 0 ? YES : NO;
}



- (NSUInteger)lastIndex{
    
    if([self count] == 0)
        return NSNotFound;
    
    return [self count]-1;
}

- (id) firstObject
{
	return [self objectAtIndex:0];
}

- (id) firstObjectSafe{
    
    if ([self count] > 0)
		return [self objectAtIndex:0];
	
	return nil;
    
}

- (id)objectAtIndexSafe:(NSUInteger)index{
    
    if(index == NSNotFound)
        return nil;
    if(index >= [self count])
        return nil;
    
    return [self objectAtIndex:index];
    
}

- (NSArray *) uniqueMembers
{
	NSMutableArray *copy = [self mutableCopy];
	for (id object in self)
	{
		[copy removeObjectIdenticalTo:object];
		[copy addObject:object];
	}
	return copy;
}

- (NSArray *) unionWithArray: (NSArray *) anArray
{
	if (!anArray) return self;
	return [[self arrayByAddingObjectsFromArray:anArray] uniqueMembers];
}

- (NSArray *) intersectionWithArray: (NSArray *) anArray
{
	NSMutableArray *copy = [self mutableCopy];
	for (id object in self)
		if (![anArray containsObject:object]) 
			[copy removeObjectIdenticalTo:object];
	return [copy uniqueMembers];
}

- (NSArray*)mapWithBlock:(id (^)(id obj, NSUInteger idx))block{
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:[self count]];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        id mappedObject = block(obj, idx);
        
        [array addObject:mappedObject];
        
    }];
    
    return array;
    
}

- (void)each:(void (^)(id))block
{
    for (id obj in self) {
        block(obj);
    }
}

- (NSArray *)select:(BOOL (^)(id))block
{
    NSMutableArray *rslt = [NSMutableArray array];
    for (id obj in self) {
        if (block(obj)) {
            [rslt addObject:obj]; 
        }
    }
    return rslt;
}

- (id)reduce:(id)initial withBlock:(id (^)(id,id))block
{
    id rslt = initial;
    for (id obj in self) {
        rslt = block(rslt, obj);
    }
    return rslt;
    
}



- (id )objectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate{
    
    NSUInteger index = [self indexOfObjectPassingTest:predicate];
    
    if(index == NSNotFound)
        return nil;
    
    return [self objectAtIndex:index];
    
    
}


- (NSArray *)objectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate{
    
    NSIndexSet* set = [self indexesOfObjectsPassingTest:predicate];
    
    return [self objectsAtIndexes:set];
    
}


- (NSArray *) arrayBySortingStrings
{
	NSMutableArray *sort = [NSMutableArray arrayWithArray:self];
	for (id eachitem in self)
		if (![eachitem isKindOfClass:[NSString class]])	[sort removeObject:eachitem];
	return [sort sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSString *) stringValue
{
	return [self componentsJoinedByString:@" "];
}

@end


@implementation NSMutableArray (UtilityExtensions)


- (void)addInt:(int)integer{
	
	[self addObject:[NSNumber numberWithInt:integer]];
}



-(void) push:(id) item {
	[self addObject:item]; // where list is the actual array in your stack
}

-(id) pop {
	id r = [[self lastObject] retain];
	[self removeLastObject];
	return [r autorelease];
}

- (id)top{
    
    return [self lastObject];
    
}
- (NSArray*)popToObject:(id)object{
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    while (![[self top] isEqual:object]) {
		[returnArray addObject:[self pop]];
	}
    
    return [returnArray autorelease];
}
- (NSArray*)popToRootObject{
    
    return [self popToObject:[self firstObject]];
}



-(void) enqueue:(id) item {
	[self insertObject:item atIndex:0];
}

-(id) dequeue {
	id r = [[self lastObject] retain];
	[self removeLastObject];
	return [r autorelease];
}

- (NSMutableArray *) reverse
{
	for (int i=0; i<(floor([self count]/2.0)); i++) 
		[self exchangeObjectAtIndex:i withObjectAtIndex:([self count]-(i+1))];
	return self;
}

// Make sure to run srandom([[NSDate date] timeIntervalSince1970]); or similar somewhere in your program
- (NSMutableArray *) scramble
{
	for (int i=0; i<([self count]-2); i++) 
		[self exchangeObjectAtIndex:i withObjectAtIndex:(i+(random()%([self count]-i)))];
	return self;
}

- (NSMutableArray *) removeFirstObject
{
	[self removeObjectAtIndex:0];
	return self;
}
@end



