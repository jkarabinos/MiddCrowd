//
//  ViewController.h
//  LocationTest
//
//  Created by John Karabinos on 10/11/15.
//  Copyright © 2015 Pineapple Workshops, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>{
    CLLocationManager* locationManager;
    
    
}


@end

