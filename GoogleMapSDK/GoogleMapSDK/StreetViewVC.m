//
//  StreetViewVC.m
//  GoogleMapSDK
//
//  Created by QC_Test on 5/28/15.
//  Copyright (c) 2015 QC_Test. All rights reserved.
//

#import "StreetViewVC.h"


@interface StreetViewVC ()

@end

@implementation StreetViewVC

- (void)viewDidLoad
{
    [super viewDidLoad];

}

/**
 *  Load Panorama camera
 *
 *  @param animated YES:NO
 */
- (void) viewDidAppear:(BOOL)animated
{
    GMSPanoramaService *service = [[GMSPanoramaService alloc] init];
    
    // Create requestPanorama.
    [service requestPanoramaNearCoordinate:self.coordinate callback:^(GMSPanorama *panorama, NSError *error) {
        
        if (panorama != nil)
        {
            GMSPanoramaCamera *camera = [GMSPanoramaCamera cameraWithHeading:180 pitch:0 zoom:1 FOV:90];
            GMSPanoramaView *panoView = [[GMSPanoramaView alloc] init];
            panoView.camera = camera;
            panoView.panorama = panorama;
            self.view = panoView;
            
            // Create back button
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self
                       action:@selector(backTapped:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"Back" forState:UIControlStateNormal];
            button.frame = CGRectMake(80, 500, 80, 40);
            [self.view addSubview:button];
        } else
            // Return view if panorama nill
            [self backTapped:nil];
       
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
