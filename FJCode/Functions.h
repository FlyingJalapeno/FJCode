
#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark paths

NSString* documentsDirectory();
NSString* cachesDirectory();

NSString* fileNameBasedOnCurrentTime();


#pragma mark -
#pragma mark size

NSUInteger sizeOfFolderContentsInBytes(NSString* folderPath);
double megaBytesWithBytes(long long bytes);


#pragma mark -
#pragma mark time

float nanosecondsWithSeconds(float seconds);
dispatch_time_t dispatchTimeFromNow(float seconds);

NSString* timeZoneString();


#pragma mark -
#pragma mark Dispatch Help

void dispatchOnMainQueue(dispatch_block_t block);
void dispatchOnMainQueueAfterDelayInSeconds(float delay, dispatch_block_t block);

void dispatchAfterDelayInSeconds(float delay, dispatch_queue_t queue, dispatch_block_t block);


#pragma mark -
#pragma mark Progress

typedef struct {
    unsigned long long complete;
    unsigned long long total;
    double ratio;
} Progress;

Progress progressMake(unsigned long long complete, unsigned long long total);
extern Progress const kProgressZero;

