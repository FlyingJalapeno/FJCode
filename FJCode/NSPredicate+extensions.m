//
//  NSPredicate+extensions.m
//  Congress
//
//  Created by Corey Floyd on 9/26/11.
//  Copyright 2011 Flying Jalapeño. All rights reserved.
//

#import "NSPredicate+extensions.h"

@implementation NSPredicate (extensions)

- (NSPredicate*)andPredicateWithPredicate:(NSPredicate*)predicate{
    
    return [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:self, predicate, nil]];
    
}
- (NSPredicate*)orPredicateWithPredicate:(NSPredicate*)predicate{
    
      return [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:self, predicate, nil]];
}

@end
