//
//  NSFetchRequest+extensions.h
//  FJCode
//
//  Created by Corey Floyd on 11/26/11.
//  Copyright (c) 2011 Flying Jalapeño. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchRequest (extensions)

- (void)andPredicate:(NSPredicate*)pred;
- (void)orPredicate:(NSPredicate*)pred;

@end
