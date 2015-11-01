//
//  ViewController.m
//  LocationTest
//
//  Created by John Karabinos on 10/11/15.
//  Copyright © 2015 Pineapple Workshops, LLC. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "SessionManager.h"

@interface ViewController ()

@property (strong, nonatomic) MKMapView* map;

@end

@implementation ViewController


@synthesize map;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    //create a dictionary containing the coordinates of the user
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"ross", @"current",
                          @"outside", @"previous"
                          ,nil];
    
    
    
    //create a post request for the coordinates
    [[SessionManager sharedClient] POST:@"" parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"YAY!!!");
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"ERROR: %@",error);
    }];
    
    
    /*
    [[SessionManager sharedClient] GET:@"" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id JSON) {
        
        
        NSLog(@"YAY!!! %@", JSON);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"ERROR: %@",error);
    }];*/
    
    

    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    //set the frame of the map to cover the top half of the screen
    CGRect mapFrame = self.view.frame;
    mapFrame = CGRectMake(mapFrame.origin.x, mapFrame.origin.y, mapFrame.size.width, self.view.frame.size.height/2);
    
    
    
    //instantiate the map and add it to the view
    map = [[MKMapView alloc] initWithFrame:self.view.frame];
    //[self.view addSubview:map];
    
    
    CGRect tableFrame = mapFrame;
    tableFrame = CGRectMake(tableFrame.origin.x, 0, tableFrame.size.width, tableFrame.size.height/2);
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    
    
    
    [self. view addSubview:map];
    //[self.view addSubview:tableView];
    //[tableView.backgroundView addSubview:map];
    
    
    //get the location of the user if they allow it
    [self getLocation];
    
    [self getOtherLocations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//get the locations of the other users on campus
-(void)getOtherLocations{
    
    //create a GET request to find the other user's locations
    
    
    
    //call this method recursively after a set amount of time to update the locations
    [self performSelector:@selector(getOtherLocations) withObject:nil afterDelay:60];
    
}

-(void)getLocation{

    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedAlways){
        NSLog(@"request auth");
        [locationManager requestAlwaysAuthorization];
    }else{
        //if the phone is old enough that we don't need permission
        [locationManager startUpdatingLocation];
        [self updateMap];
    }
    
    
}

-(void)updateMap{
    
    CLLocationCoordinate2D middLocation = CLLocationCoordinate2DMake(44.013868, -73.178710);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(middLocation, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [map regionThatFits:viewRegion];
    [map setRegion:adjustedRegion animated:YES];
    map.showsUserLocation = YES;
    
    
    [self addDiningHalls];
}

//add the dining hall regions on the map
-(void)addDiningHalls{
    
    CLLocationCoordinate2D atwaterLocation = CLLocationCoordinate2DMake(44.013411, -73.177242);
    MKPointAnnotation *annotation1 = [[MKPointAnnotation alloc] init];
    [annotation1 setCoordinate:atwaterLocation];
    [annotation1 setTitle:@"Atwater"]; //You can set the subtitle too
    [map addAnnotation:annotation1];
    
    
    CLLocationCoordinate2D rossLocation = CLLocationCoordinate2DMake(44.010640, -73.181132);
    MKPointAnnotation *annotation2 = [[MKPointAnnotation alloc] init];
    [annotation2 setCoordinate:rossLocation];
    [annotation2 setTitle:@"Ross"]; //You can set the subtitle too
    [map addAnnotation:annotation2];
    
    CLLocationCoordinate2D proctorLocation = CLLocationCoordinate2DMake(44.009202, -73.179930);
    MKPointAnnotation *annotation3 = [[MKPointAnnotation alloc] init];
    [annotation3 setCoordinate:proctorLocation];
    [annotation3 setTitle:@"Proctor"]; //You can set the subtitle too
    [map addAnnotation:annotation3];
}

#pragma mark - Location Manager Delegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    //if we have authorization
    if(status==kCLAuthorizationStatusAuthorizedAlways){
        [locationManager startUpdatingLocation];
        [self updateMap];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation* locationObj = [locations lastObject];
    CLLocationCoordinate2D coord =  locationObj.coordinate;
    NSLog(@"coord: %f, %f", coord.longitude, coord.latitude);
    
    
}



//table view data source
#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row==0){
        [cell.textLabel setText:@"Proctor:"];
    }else if(indexPath.row==1){
        [cell.textLabel setText:@"Ross:"];
    }else if(indexPath.row==2){
        [cell.textLabel setText:@"Atwater:"];
    }
    
    
    
    return cell;
}

@end
