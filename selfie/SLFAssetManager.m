//
//  SLFAssetManager.m
//  selfie
//
//  Created by Sean Conrad on 6/25/13.
//  Copyright (c) 2013 Sean Conrad. All rights reserved.
//

#import "SLFAssetManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

////////////////////////////////////////////////////////////////////////////////

@interface SLFAssetManager ()

@property ALAssetsLibrary *assetLibrary;

@end

////////////////////////////////////////////////////////////////////////////////

@implementation SLFAssetManager

+ (id)sharedManager {
    // TODO: make threadsafe
    static SLFAssetManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SLFAssetManager alloc] init];
    });
	return manager;
}

- (id)init
{
    self = [super init];
    if ( self != nil )
    {
        
    }
    return self;
}

#pragma mark - Getters & Setters

- (BOOL)authorizationStatus {
    
    return [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized;
    
}

#pragma mark - Public Methods

@end
