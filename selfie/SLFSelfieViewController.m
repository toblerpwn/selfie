//
//  SLFPhotoViewController.m
//  selfie
//
//  Created by Sean Conrad on 6/25/13.
//  Copyright (c) 2013 Sean Conrad. All rights reserved.
//

#import "SLFSelfieViewController.h"
#import "SLFAssetManager.h"
#import "SLFCameraView.h"

////////////////////////////////////////////////////////////////////////////////

@interface SLFSelfieViewController ()

@property UIView *cameraView;

@end

////////////////////////////////////////////////////////////////////////////////

@implementation SLFSelfieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor cloudsColor];
    
    self.cameraView = [[SLFCameraView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:self.cameraView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    BOOL albumCreated = [[SLFAssetManager sharedManager] authorizationStatus];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
