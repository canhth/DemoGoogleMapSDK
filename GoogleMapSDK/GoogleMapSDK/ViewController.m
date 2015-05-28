//
//  ViewController.m
//  GoogleMapSDK
//
//  Created by QC_Test on 5/27/15.
//  Copyright (c) 2015 QC_Test. All rights reserved.
//

#import "ViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "CSMarker.h"
#import "DirectionsListVC.h"
#import "StreetViewVC.h"

@interface ViewController ()
{
    GMSMapView *mapView_;
}

@property (copy, nonatomic) NSSet *markers;
@property (strong, nonatomic) NSURLSession *markerSession;
@property (strong, nonatomic) CSMarker *userCreateMarker;
@property (strong, nonatomic) NSArray *steps;
@property (strong, nonatomic) UIButton *directionsButton;
@property (strong, nonatomic) UIButton *streetViewButton;
@property (assign, nonatomic) CLLocationCoordinate2D activemarkerCoordinate;
@property (strong, nonatomic) GMSPolyline *polyline;

@end

@implementation ViewController

            
- (void)viewDidLoad {
    [super viewDidLoad];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:28.5382 longitude:-81.3684 zoom:15 bearing:0 viewingAngle:0];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    [mapView_ setMinZoom:10 maxZoom:18];
    mapView_.delegate = self;
    self.view = mapView_;
    
    [self createButton];

    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.URLCache =[[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024 diskCapacity:10*1024*1024 diskPath:@"MarkerData"];
    self.markerSession = [NSURLSession sessionWithConfiguration:config];

   // [self drawLine];
    
}

#pragma mark - Button methods
/**
 *  Create Button
 */
- (void)createButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(downloadMarkerData:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    button.frame = CGRectMake(50, 80, 80, 40);
    [mapView_ addSubview:button];
    
    self.directionsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.directionsButton.alpha = 0.0;
    [self.directionsButton addTarget:self action:@selector(directionsTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.directionsButton setTitle:@"Show directions" forState:UIControlStateNormal];
    self.directionsButton.frame = CGRectMake(80, 500, 150, 40);
    [mapView_ addSubview:self.directionsButton];
    
    self.streetViewButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.streetViewButton.alpha = 0.0;
    [self.streetViewButton addTarget:self action:@selector(cameraTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.streetViewButton setTitle:@"StretView" forState:UIControlStateNormal];
    self.streetViewButton.frame = CGRectMake(80, 100, 150, 40);
    [mapView_ addSubview:self.streetViewButton];
}

/**
 *  Is tap button Directions
 *
 *  @param sender sefl
 */
- (void)directionsTapped :(id)sender
{
    DirectionsListVC *directionsListVC = [[DirectionsListVC alloc] init];
    directionsListVC.steps = self.steps;
    NSLog(@"%@", [self.steps objectAtIndex:0]);
    [self presentViewController:directionsListVC animated:YES completion:^{
        self.steps = nil;
        mapView_.selectedMarker = nil;
        self.directionsButton.alpha = 0.0;
    }];
}

/**
 *  Is tap button camera StreetView
 *
 *  @param sender sefl
 */
- (void)cameraTapped :(id)sender
{
    StreetViewVC *streetViewVC = [[StreetViewVC alloc] init];
    streetViewVC.coordinate = self.activemarkerCoordinate;
    [self presentViewController:streetViewVC animated:YES completion:^ {
        self.streetViewButton.alpha = 0.0;
        mapView_.selectedMarker = nil;
    }];

}

#pragma mark - Network Request.
/**
 *  Download file Json when click button LoadMarker
 *
 *  @param sender self
 */
- (void)downloadMarkerData:(id)sender
{
    NSURL *lakesURL = [ NSURL URLWithString:@"http://www.json-generator.com/api/json/get/cfZbsJjHTm?indent=2"];
    NSURLSessionDataTask *task = [self.markerSession dataTaskWithURL:lakesURL
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
                                                       NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
  
                                                       [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                           [self createMarkerObjectsWithJson:json];
                                                       }];
                                                   }];
    [task resume];
}

/**
 *  Create Martket when click
 *
 *  @param json array Json
 */
- (void)createMarkerObjectsWithJson:(NSArray *)json
{
    NSMutableSet *mutableSet = [[NSMutableSet alloc] initWithSet:self.markers];
    for (NSDictionary *markerData in json)
    {
        CSMarker *newMarker = [[CSMarker alloc] init];
        
        newMarker.objectID = [markerData[@"id"] stringValue];
        newMarker.appearAnimation = (int)[markerData[@"appearAnimation"] integerValue];
        newMarker.position = CLLocationCoordinate2DMake([markerData[@"lat"] doubleValue], [markerData[@"lng"] doubleValue]);
        newMarker.title = markerData[@"title"];
        newMarker.snippet = markerData[@"snippet"];
        newMarker.map = nil;
        
        [mutableSet addObject:newMarker];
    }
    self.markers = [mutableSet copy];
    [self drawMarkers];
    
}

/**
 *  Draw markers in map
 */
- (void)drawMarkers
{
    for (CSMarker *mark in self.markers) {
        if (mark.map == nil) {
            mark.map = mapView_;
        }
    }
    if (self.userCreateMarker != nil && self.userCreateMarker.map == nil) {
        self.userCreateMarker.map = mapView_;
        mapView_.selectedMarker = self.userCreateMarker;
        GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate setTarget:self.userCreateMarker.position];
        [mapView_ animateWithCameraUpdate:cameraUpdate];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    mapView_.padding =
    UIEdgeInsetsMake(self.topLayoutGuide.length + 5,
                     0,
                     self.bottomLayoutGuide.length + 5,
                     0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - GMSMapDelegate

/**
 *  Create view when click Marker
 *
 *  @param mapView
 *  @param marker
 *
 *  @return UIView show in marker
 */
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    UIView *infoWindow = [[UIView alloc] init];
    infoWindow.frame = CGRectMake(0, 0, 200, 70);

    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"infoWindow"]];
    [infoWindow addSubview:backgroundImage];
    
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.frame = CGRectMake(14, 11, 175, 16);
    [infoWindow addSubview:titleLable];
    titleLable.text = marker.title;
    
    UILabel *snipperLable = [[UILabel alloc] init];
    snipperLable.frame = CGRectMake(14, 42, 175, 16);
    [infoWindow addSubview:snipperLable];
    snipperLable.text = marker.snippet;
    
    return infoWindow;
}

/**
 *  Event tap to marker
 *
 *  @param mapView
 *  @param marker
 *
 *  @return YES:NO
 */
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    self.activemarkerCoordinate = marker.position;
    if (mapView.myLocation == nil) {
        NSString *urlString = [NSString stringWithFormat:@"%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@",
                               @"https://maps.googleapis.com/maps/api/directions/json",
                               28.5382,
                               -81.3687,
                               marker.position.latitude,
                               marker.position.longitude,
                               @"AIzaSyClevjiagBqidhXxTm1BDlk0SYV2bJ12bk"];
        NSURL *directionsURL = [NSURL URLWithString:urlString];
        
        self.polyline.map = nil;
        self.polyline = nil;
        NSURLSessionDataTask *directionsTask = [self.markerSession dataTaskWithURL:directionsURL
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *e)  {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (!error) {
                self.steps = json[@"routes"][0][@"legs"][0][@"steps"];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.directionsButton.alpha = 1.0;
                    self.streetViewButton.alpha = 1.0;
                    GMSPath *path =
                    [GMSPath pathFromEncodedPath:
                     json[@"routes"][0][@"overview_polyline"][@"points"]];
                    self.polyline = [GMSPolyline polylineWithPath:path];
                    self.polyline.strokeWidth = 7;
                    self.polyline.strokeColor = [UIColor greenColor];
                    self.polyline.map = mapView_;
                }];
            }
        }];
        [directionsTask resume];
    }
    return  YES;
}

/**
 *  Event tap in InfoWindowMarker
 *
 *  @return
 */
//- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
//{
//    NSString *message = [NSString stringWithFormat:@"You tapped the info window for the %@ market", marker.title];
//    UIAlertView *windowTapped = [[UIAlertView alloc]
//                                 initWithTitle:@"Info Window Tapped!"
//                                 message:message
//                                 delegate:nil
//                                 cancelButtonTitle:@"Alright!"
//                                 otherButtonTitles:nil];
//    [windowTapped show];
//}


/**
 *  Long press at map
 *
 *  @param mapView
 *  @param coordinate
 */
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self.userCreateMarker != nil) {
        self.userCreateMarker.map = nil;
        self.userCreateMarker = nil;
    }
    if (self.streetViewButton.alpha > 0.0) {
        self.streetViewButton.alpha = 0.0;
    }
    self.polyline.map = nil;
    self.polyline = nil;
    GMSGeocoder *geocoder = [GMSGeocoder geocoder];
    [geocoder reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        CSMarker *marker = [[CSMarker alloc] init];
        marker.position = coordinate;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.title = response.firstResult.thoroughfare;
        marker.snippet = response.firstResult.locality;
        marker.map = nil;
        self.userCreateMarker = marker;
        [self drawMarkers];
    }];
}

/**
 *  Event tap every where in map
 *
 *  @param mapView
 *  @param coordinate
 */
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self.directionsButton.alpha > 0.0) {
        self.directionsButton.alpha = 0.0;
    }
    if (self.streetViewButton.alpha > 0.0) {
        self.streetViewButton.alpha = 0.0;
    }
    self.polyline.map = nil;
    self.polyline = nil;
}

-(void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    if (self.directionsButton.alpha > 0.0) {
        self.directionsButton.alpha = 0.0;
    }
    mapView_.selectedMarker = nil;
//    self.polyline.map = nil;
//    self.polyline = nil;
}

@end



































