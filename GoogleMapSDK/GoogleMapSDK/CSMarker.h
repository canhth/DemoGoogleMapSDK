//
//  CSMarker.h
//  GoogleMapSDK
//
//  Created by QC_Test on 5/27/15.
//  Copyright (c) 2015 QC_Test. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@interface CSMarker : GMSMarker
@property (nonatomic, copy) NSString *objectID;

@property (nonatomic, strong) NSString *startAdd;
@property (nonatomic, strong) NSString *polyline;
@property (nonatomic, strong) NSString *textDistance;


@end
