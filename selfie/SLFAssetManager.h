//
//  SLFAssetManager.h
//  selfie
//
//  Created by Sean Conrad on 6/25/13.
//  Copyright (c) 2013 Sean Conrad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLFAssetManager : NSObject

+ (id)sharedManager;

@property (readonly) BOOL authorizationStatus;

@end
