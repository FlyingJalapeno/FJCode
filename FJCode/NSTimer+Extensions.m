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


@implementation NSTimer (Blocks)

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats
{
    void (^block)() = [inBlock copy];
    id ret = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(jdExecuteSimpleBlock:) userInfo:block repeats:inRepeats];
    [block release];
    return ret;
}

+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats
{
    void (^block)() = [inBlock copy];
    id ret = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(jdExecuteSimpleBlock:) userInfo:block repeats:inRepeats];
    [block release];
    return ret;
}

+(void)jdExecuteSimpleBlock:(NSTimer *)inTimer;
{
    if([inTimer userInfo])
    {
        void (^block)() = (void (^)())[inTimer userInfo];
        block();
    }
}

@end