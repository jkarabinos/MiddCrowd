//
//  SessionManager.h
//  LocationTest
//
//  Created by John Karabinos on 10/19/15.
//  Copyright © 2015 Pineapple Workshops, LLC. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface SessionManager : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
