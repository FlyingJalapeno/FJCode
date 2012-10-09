//
//  NSPredicate+extensions.h
//  Congress
//
//  Created by Corey Floyd on 9/26/11.
//  Copyright 2011 Flying Jalapeño. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPredicate (extensions)

- (NSPredicate*)andPredicateWithPredicate:(NSPredicate*)predicate;
- (NSPredicate*)orPredicateWithPredicate:(NSPredicate*)predicate;

@end
