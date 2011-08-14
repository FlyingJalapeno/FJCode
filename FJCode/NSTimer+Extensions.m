//
//  NSTImer+Extensions.m
//  LittleLamb
//
//  Created by Corey Floyd on 4/12/11.
//  Copyright 2011 Flying Jalapeño. All rights reserved.
//

#import "NSTimer+Extensions.h"

static NSMutableDictionary* _keyedTimers = nil;

@implementation NSTimer(Extensions)


+ (void)load{
    
    _keyedTimers = [[NSMutableDictionary alloc] init];
    
}



+ (void)addTimer:(NSTimer*)timer forKey:(NSString*)key{
     
    [self stopTimerForKey:key];
    [_keyedTimers setObject:timer forKey:key];
    
}

+ (NSTimer*)timerForKey:(NSString*)key{
    
    return [_keyedTimers objectForKey:key]; 
    
}

+ (void)stopTimerForKey:(NSString*)key{
        
    NSTimer* t = [_keyedTimers objectForKey:key];
    [t invalidate];    

}


@end
