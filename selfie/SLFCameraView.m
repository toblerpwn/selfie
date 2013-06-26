//
//  SLFCameraView.m
//  selfie
//
//  Created by Sean Conrad on 6/25/13.
//  Copyright (c) 2013 Sean Conrad. All rights reserved.
//

#import "SLFCameraView.h"

#import <AVFoundation/AVFoundation.h>

////////////////////////////////////////////////////////////////////////////////

@interface SLFCameraView ()

@property AVCaptureVideoPreviewLayer *cameraPreviewLayer;
@property AVCaptureStillImageOutput *liveCameraImageOutput;

@end

////////////////////////////////////////////////////////////////////////////////

@implementation SLFCameraView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // get front camera (if exists)
        NSArray *devices = [AVCaptureDevice devices];
        AVCaptureDevice *frontCamera;
        AVCaptureDevice *backCamera;
        
        for (AVCaptureDevice *device in devices) {
            
            if ([device hasMediaType:AVMediaTypeVideo]) {
                
                if ([device position] == AVCaptureDevicePositionBack) {
                    backCamera = device;
                }
                else {
                    frontCamera = device;
                }
            }
        }
        
        AVCaptureDevice *bestCamera;
        if (frontCamera) {
            bestCamera = frontCamera;
        } else if (backCamera) {
            bestCamera = backCamera;
        }
        
        if (bestCamera) {
            // make session
            AVCaptureSession *session = [[AVCaptureSession alloc] init];
            
            // make container layer
            CALayer *containerLayer = [CALayer layer];
            CALayer *parentLayer = self.layer;
            [containerLayer setFrame:parentLayer.bounds];
            [containerLayer setMasksToBounds:YES];
            [containerLayer setCornerRadius:parentLayer.cornerRadius];
            [parentLayer addSublayer:containerLayer];
            
            // make an output buffer that we can capture from
            self.liveCameraImageOutput = [[AVCaptureStillImageOutput alloc] init];
            NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG};
            [self.liveCameraImageOutput setOutputSettings:outputSettings];
            
            [session addOutput:self.liveCameraImageOutput];
            
            // set the videoMirrored property for later useconnections);
            AVCaptureConnection *connection = [self.liveCameraImageOutput.connections lastObject];
            connection.videoMirrored = (bestCamera == frontCamera) ? YES : NO;
            
            // get make the input to preview
            NSError *error;
            AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:bestCamera
                                                                                     error:&error];
            
            if (error) {
                SLFLog(@"error: %@",error);
            }
            
            [session addInput:videoInput];
            
            // make the preview
            self.cameraPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
            [self.cameraPreviewLayer setFrame:self.bounds];
            [self.cameraPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            [containerLayer addSublayer:self.cameraPreviewLayer];
            
            [session startRunning];
            
            
        } else { // no camera found!
            SLFLog(@"No camera found; cannot add live camera preview!");
        }
        
    }
    return self;
}

#pragma mark - Private Methods

@end
