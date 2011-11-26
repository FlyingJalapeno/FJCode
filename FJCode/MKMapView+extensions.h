//
//  MKMapView+extensions.h
//  Congress
//
//  Created by Corey Floyd on 11/22/11.
//  Copyright (c) 2011 Flying Jalapeño. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (extensions)

- (void)addAnnotationsSortedByDistanceFromUserLocation:(NSArray *)annotations; 

- (NSArray*)annotationsWithoutUserAnnotation;

- (void)centerOnAnnotation:(id<MKAnnotation>)annotation animated:(BOOL)animated;
- (void)centerOnAllAnnotationsAnimated:(BOOL)animated;
- (void)centerOnAnnotations:(NSArray*)someAnnotations animated:(BOOL)animated;
- (void)centerOnAnnotationsUpToIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)smartCenterOnAnnotationsUpToIndex:(NSUInteger)index withDefaultCenter:(CLLocation*)center animated:(BOOL)animated;

- (void)centerOnCoordinate:(CLLocationCoordinate2D)coord animated:(BOOL)animated;
- (void)centerOnLocation:(CLLocation*)aLocation animated:(BOOL)animated;

@end
