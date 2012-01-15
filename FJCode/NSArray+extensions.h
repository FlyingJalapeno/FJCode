//
//  NSArray+extensions.h
//  FJCode
//
//  Created by Corey Floyd on 11/26/11.
//  Copyright (c) 2011 Flying Jalapeño. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (extensions)

/*
 * Checks to see if the array is empty
 */
@property(nonatomic,readonly,getter=isEmpty) BOOL empty;

- (NSUInteger)lastIndex; //returns NSNotFound for empty array

- (id) firstObject;
- (id) firstObjectSafe; //checks to see if length > 0
- (id)objectAtIndexSafe:(NSUInteger)index;

- (NSArray *) uniqueMembers;
- (NSArray *) unionWithArray: (NSArray *) array;
- (NSArray *) intersectionWithArray: (NSArray *) array;

- (NSArray*)mapWithBlock:(id (^)(id obj, NSUInteger idx))block;
- (void)each:(void (^)(id))block;
- (NSArray* )select:(BOOL (^)(id))block;
- (id)reduce:(id)initial withBlock:(id (^)(id,id))block;
- (void)addInt:(int)integer;

- (id )objectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)objectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;


//strings
- (NSArray *) arrayBySortingStrings;
@property (readonly, getter=arrayBySortingStrings) NSArray *sortedStrings;
@property (readonly) NSString *stringValue;

- (NSUInteger)randomIndex;

@end





@interface NSMutableArray (UtilityExtensions)

//Stack
- (void)push:(id)item;
- (id)pop;
- (id)top;
- (NSArray*)popToObject:(id)object;
- (NSArray*)popToRootObject;


//Queue
- (void)enqueue:(id)item;
- (id)dequeue;


- (NSMutableArray *) removeFirstObject;
- (NSMutableArray *) reverse;
- (void)scramble;

@property (readonly, getter=reverse) NSMutableArray *reversed;

@end