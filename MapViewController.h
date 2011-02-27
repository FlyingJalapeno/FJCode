

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol MapViewControllerDelegate;

@class Store;

@interface MapViewController : UIViewController <MKMapViewDelegate> {
	IBOutlet MKMapView *mapView;

    NSMutableArray* annotations;
        
    CLLocationCoordinate2D currentCcoordinate;
    CLLocationCoordinate2D defaultCoordinate;
    
    int numberOfLocationsToCenterMap; //default is 100
    
    id delegate;

}
@property(nonatomic,retain)NSMutableArray *annotations;
@property (nonatomic) CLLocationCoordinate2D defaultCoordinate;

@property(nonatomic,retain)IBOutlet MKMapView *mapView;
@property(nonatomic,assign)CLLocationCoordinate2D currentCcoordinate;

@property (nonatomic) int numberOfLocationsToCenterMap;
@property (nonatomic, assign) id delegate;

@end



@protocol MapViewControllerDelegate <NSObject>

@optional
- (void)mapViewController:(MapViewController*)controller selectedAnnotation:(id<MKAnnotation>)anAnnotation;

@end
