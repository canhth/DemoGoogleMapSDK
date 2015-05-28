//
//  DirectionsListVC.m
//  GoogleMapSDK
//
//  Created by QC_Test on 5/27/15.
//  Copyright (c) 2015 QC_Test. All rights reserved.
//

#import "DirectionsListVC.h"
#import "CSMarker.h"

@interface DirectionsListVC ()
{
    CSMarker *marker;
    NSMutableArray *arraysMarker;
}

@property (strong, nonatomic) NSMutableArray *arrays;

@end

@implementation DirectionsListVC
@synthesize steps;

- (void)viewDidLoad
{
    [super viewDidLoad];
    marker = [[CSMarker alloc] init];

    arraysMarker = [NSMutableArray array];
    
    // Create back button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(backTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    button.frame = CGRectMake(80, 500, 80, 40);
    [self.tableView addSubview:button];
    
    // Getdata form array by dicts
    [self convertData];
    [self.tableView reloadData];
}

- (void)backTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) convertData
{
    for (NSDictionary *dict in self.steps)
    {
        marker.startAdd = dict[@"duration"][@"text"];
        marker.textDistance = dict[@"distance"][@"text"] ;
        marker.polyline = dict[@"end_location"] ;
        [arraysMarker addObject:marker];
    }
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (arraysMarker.count == 0) {
        [self convertData];
    }
    return arraysMarker.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        
    }
    marker = [arraysMarker objectAtIndex:indexPath.row];
    cell.textLabel.text = marker.textDistance;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
