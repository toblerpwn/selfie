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

@property SLFCameraView *cameraView;

- (void)_viewWasTapped:(UITapGestureRecognizer *)tapRecognizer;

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
    
    // add camera prview
    self.cameraView = [[SLFCameraView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.cameraView];
    
    // add tap recognizer
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(_viewWasTapped:)];
    
    [self.view addGestureRecognizer:tapRecognizer];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    // check for asset group (album) & act accordingly
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)_viewWasTapped:(UITapGestureRecognizer *)tapRecognizer {
    
    [self.cameraView captureStillImageWithCompletion:^(UIImage *image) {
        
        if (image) {
            
        } else {
            SLFWarning(@"No image returned from live camera.");
        }
        
    }];
    
}

@end
