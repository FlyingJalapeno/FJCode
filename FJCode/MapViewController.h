

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate> {

	IBOutlet MKMapView *mapView;
    
    UIImage* pinImage;
        
    int numberOfLocationsToCenterMap; //default is 25
    BOOL animatePinDrop;
    
}
@property(nonatomic,retain)IBOutlet MKMapView *mapView;

@property (nonatomic) int numberOfLocationsToCenterMap;

@property (nonatomic, retain) UIImage *pinImage;

- (void)reloadMapWithAnnotations:(NSArray*)annotations animated:(BOOL)animated;

@end
