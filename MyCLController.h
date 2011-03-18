

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MyCLController : NSObject <CLLocationManagerDelegate>  {	
    
	CLLocationManager *locationManager;
            	    
    NSTimer* updateTimer;
    
    NSDate* lastActiveTime;
	
}

@property(nonatomic, retain, readonly)CLLocation *location;
@property (nonatomic, retain) NSTimer *updateTimer;
@property (nonatomic, copy) NSDate *lastActiveTime;

+ (MyCLController *)sharedMyCLController;

- (void)startUpdating;
- (void)stopUpdating;

- (void)printDescription;

@end
