//
//  NSArrayHelper.m
//  CocoaHelpers
//
//  Created by Shaun Harrison on 10/28/08.
//  Copyright 2008 enormego. All rights reserved.
//

#import "NSArrayHelper.h"


@implementation NSArray (Helper)

- (BOOL)isEmpty {
	return [self count] == 0 ? YES : NO;
}



- (NSUInteger)lastIndex{
    
    if([self count] == 0)
        return NSNotFound;
    
    return [self count]-1;
}


@end

@implementation NSArray (UtilityExtensions)
- (id) firstObject
{
	return [self objectAtIndex:0];
}

- (id) firstObjectSafe{
    
    if ([self count] > 0)
		return [self objectAtIndex:0];
	
	return nil;
    
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
    
    

// A la LISP, will return an array populated with values
- (NSArray *) mapWithSelector: (SEL) selector withObject: (id) object1 withObject: (id) object2
{
	NSMutableArray *results = [NSMutableArray array];
	for (id eachitem in self)
	{
		if (![eachitem respondsToSelector:selector])
		{
			[results addObject:[NSNull null]];
			continue;
		}
		
		id riz = [eachitem performSelector:selector withObject:object1 withObject:object2];
		if (riz)
			[results addObject:riz];
		else
			[results addObject:[NSNull null]];
	}
	return results;
}
 
 
- (NSArray *) mapWithSelector: (SEL) selector withObject: (id) object1
{
	return [self mapWithSelector:selector withObject:object1 withObject:nil];
}


- (NSArray *) mapWithSelector: (SEL) selector
{
	return [self mapWithSelector:selector withObject:nil];
}


@end



@implementation  NSMutableArray(primatives)

- (void)addInt:(int)integer{
	
	[self addObject:[NSNumber numberWithInt:integer]];
}

@end


@implementation  NSMutableArray(Stack)


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

@end

@implementation  NSMutableArray(Queue)

-(void) enqueue:(id) item {
	[self insertObject:item atIndex:0];
}

-(id) dequeue {
	id r = [[self lastObject] retain];
	[self removeLastObject];
	return [r autorelease];
}
@end


@implementation NSMutableArray (UtilityExtensions)
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

@implementation NSArray (StringExtensions)
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
