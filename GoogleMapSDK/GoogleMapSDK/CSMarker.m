//
//  CSMarker.m
//  GoogleMapSDK
//
//  Created by QC_Test on 5/27/15.
//  Copyright (c) 2015 QC_Test. All rights reserved.
//

#import "CSMarker.h"
#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@implementation CSMarker

@synthesize startAdd;
@synthesize polyline;
@synthesize textDistance;

/**
 *  Check ID marker. If it's haven return No and don't add.
 *
 *  @param object object from JSON
 *
 *  @return YES:NO
 */
-(BOOL) isEqual:(id)object
{
    CSMarker *otherMarker = (CSMarker *)object;
    if (self.objectID == otherMarker.objectID) {
        return YES;
    }
    return NO;
}

/**
 *  I dom't understand it?
 *
 *  @return object hash
 */
- (NSUInteger) hash
{
    return [self.objectID hash];
}

@end
