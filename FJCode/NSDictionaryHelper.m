//
//  NSDictionaryHelper.m
//  CocoaHelpers
//
//  Created by Shaun Harrison on 10/29/08.
//  Copyright 2008 enormego. All rights reserved.
//

#import "NSDictionaryHelper.h"


@implementation NSDictionary (Helper)

- (NSString*)parameterString{
    
    NSMutableArray *pairs = [[[NSMutableArray alloc] init] autorelease]; 
    for (id key in [self allKeys]) { 
        id value = [self objectForKey:key]; 
        if ([value isKindOfClass:[NSArray class]]) { 
            for (id val in value) { 
                [pairs addObject:[NSString stringWithFormat:@"%@=%@",key, [val stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];   
            } 
        } else { 
            [pairs addObject:[NSString stringWithFormat:@"%@=%@",key, [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]; 
        } 
    } 
    return [pairs componentsJoinedByString:@"&"]; 
    
    
}

- (NSString*)parameterStringUnescaped{
    
    NSMutableArray *pairs = [[[NSMutableArray alloc] init] autorelease]; 
    for (id key in [self allKeys]) { 
        id value = [self objectForKey:key]; 
        if ([value isKindOfClass:[NSArray class]]) { 
            for (id val in value) { 
                [pairs addObject:[NSString stringWithFormat:@"%@=%@",key, val]];   
            } 
        } else { 
            [pairs addObject:[NSString stringWithFormat:@"%@=%@",key, value ]]; 
        } 
    } 
    return [pairs componentsJoinedByString:@"&"]; 
    
    
}

- (BOOL)containsObjectForKey:(id)key {
	return [[self allKeys] containsObject:key];
}

- (BOOL)isEmpty {
	return [self count] == 0 ? YES : NO;
}

- (id)objectForKeyNilIfNULL:(id)aKey{
    
    id obj = [self objectForKey:aKey];
    
    if(obj == [NSNull null])
        return nil;
    
    return obj;
}

@end


@implementation NSMutableDictionary (Helper)

- (void)setObjectIfNotNil:(id)anObject forKey:(id)aKey{
    
    if(anObject != nil && aKey != nil)
        [self setObject:anObject forKey:aKey];
    
}

@end