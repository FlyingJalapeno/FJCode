

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapViewController : UIViewController <MKMapViewDelegate> {
	IBOutlet MKMapView *mapView;

    NSMutableArray* annotations;
        
    CLLocationCoordinate2D currentCcoordinate;
    CLLocationCoordinate2D defaultCoordinate;
        
    int numberOfLocationsToCenterMap; //default is 100
    BOOL shouldPromptToLaunchDirections;    

}
@property(nonatomic,retain)NSMutableArray *annotations;
@property (nonatomic) CLLocationCoordinate2D defaultCoordinate;

@property(nonatomic,retain)IBOutlet MKMapView *mapView;
@property(nonatomic,assign)CLLocationCoordinate2D currentCcoordinate;

@property (nonatomic) int numberOfLocationsToCenterMap;
@property (nonatomic) BOOL shouldPromptToLaunchDirections;


//subclasses overide
- (void)selectedAnnotation:(id<MKAnnotation>)anAnnotation;


@end
