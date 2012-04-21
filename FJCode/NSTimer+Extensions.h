//
//  NSTImer+Extensions.h
//  LittleLamb
//
//  Created by Corey Floyd on 4/12/11.
//  Copyright 2011 Flying Jalapeño. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSTimer (Extensions)

+ (void)addTimer:(NSTimer*)timer forKey:(NSString*)key;

+ (NSTimer*)timerForKey:(NSString*)key;

+ (void)stopTimerForKey:(NSString*)key;

@end


@interface NSTimer (Blocks)
+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
@end
