//
//  SessionManager.m
//  LocationTest
//
//  Created by John Karabinos on 10/19/15.
//  Copyright © 2015 Pineapple Workshops, LLC. All rights reserved.
//

#import "SessionManager.h"

@implementation SessionManager


+ (instancetype)sharedClient {
    static SessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://aqueous-bastion-4067.herokuapp.com"]];
        
        //_sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        // TODO: must remove this for production once our certificates for the webservice are created
        _sharedClient.securityPolicy.allowInvalidCertificates = YES;
        
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        [_sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [_sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        
        _sharedClient.securityPolicy = [AFSecurityPolicy defaultPolicy];
        
        /*
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        [_sharedClient.securityPolicy setValidatesDomainName:NO];
        [_sharedClient.securityPolicy setAllowInvalidCertificates:YES];*/
    });
    
    return _sharedClient;
}

@end
