
#import "Functions.h"


NSString* documentsDirectory(){
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
}

NSString* cachesDirectory(){
    
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
}


NSString* fileNameBasedOnCurrentTime() {
	NSString* fileName = [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"png"];
	return fileName;
}



float nanosecondsWithSeconds(float seconds){
    
    return (seconds * 1000000000);
    
}

dispatch_time_t dispatchTimeFromNow(float seconds){
    
    return  dispatch_time(DISPATCH_TIME_NOW, nanosecondsWithSeconds(seconds));
    
}

NSUInteger sizeOfFolderContentsInBytes(NSString* folderPath){
    
    NSError* error = nil;
    NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error];
    
    if (error != nil){
        return NSNotFound;
    }
    
    double bytes = 0.0;
    for(NSString* eachFile in contents){
        
        NSDictionary* meta = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:eachFile] error:&error];
        
        if(error != nil){
            
            break;
        }
        
        NSNumber* fileSize = [meta objectForKey:NSFileSize];
        bytes += [fileSize unsignedIntegerValue];
    } 
    
    if(error != nil){
        
        return NSNotFound;
    }
    
    return bytes;
    
}


double megaBytesWithBytes(long long bytes){
    
    NSNumber* b = [NSNumber numberWithLongLong:bytes];
    
    double bytesAsDouble = [b doubleValue];
    
    double mb = bytesAsDouble/1048576.0;
    
    return mb;
    
}


NSString* timeZoneString(){
    
    NSTimeZone* ltz = [NSTimeZone localTimeZone];
    NSString* abbreviation = [ltz abbreviation];
    return abbreviation;
}

void dispatchOnMainQueue(dispatch_block_t block){
    
    dispatch_async(dispatch_get_main_queue(), block);
}

void dispatchOnMainQueueAfterDelayInSeconds(float delay, dispatch_block_t block){
    
    dispatchAfterDelayInSeconds(delay, dispatch_get_main_queue(), block);    
}

void dispatchAfterDelayInSeconds(float delay, dispatch_queue_t queue, dispatch_block_t block){
    
    dispatch_after(dispatchTimeFromNow(delay), queue, block);
    
}

Progress progressMake(unsigned long long complete, unsigned long long total){
    
    if(total == 0)
        return kProgressZero;
    
    Progress p;
    
    p.total = total;
    p.complete = complete;
    
    NSNumber* t = [NSNumber numberWithLongLong:total];
    NSNumber* c = [NSNumber numberWithLongLong:complete];
    
    double r = [c doubleValue]/[t doubleValue];
    
    p.ratio = r;
    
    return p;
}


Progress const kProgressZero = {
    0,
    0,
    0.0
};
