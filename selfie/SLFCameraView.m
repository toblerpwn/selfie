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
@property BOOL liveCameraIsFrontFacingCamera;

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
        
        AVCaptureDevice *bestCamera = (frontCamera) ? frontCamera : backCamera;
        self.liveCameraIsFrontFacingCamera = (bestCamera == frontCamera) ? YES : NO;
        
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
            
            // set the videoMirrored property for later use
            AVCaptureConnection *connection = [self.liveCameraImageOutput.connections lastObject];
            connection.videoMirrored = (bestCamera == frontCamera) ? YES : NO;
            
            // get make the input to preview
            NSError *error;
            AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:bestCamera
                                                                                     error:&error];
            
            if (error) {
                SLFWarning(@"error: %@",error);
            }
            
            [session addInput:videoInput];
            
            // make the preview
            self.cameraPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
            [self.cameraPreviewLayer setFrame:self.bounds];
            [self.cameraPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            [containerLayer addSublayer:self.cameraPreviewLayer];
            
            [session startRunning];
            
        } else { // no camera found!
            SLFError(@"No camera found; cannot add live camera preview!");
        }
        
    }
    return self;
}

#pragma mark - Public Methods

- (void)captureStillImageWithCompletion:(void (^)(UIImage *))completionBlock {
    
    // TODO: handle devices that don't have the hardware we're expecting
    AVCaptureConnection *videoConnection = nil;
    AVCaptureStillImageOutput *stillImageCapture = self.liveCameraImageOutput;
    for (AVCaptureConnection *connection in stillImageCapture.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    if (videoConnection) {
        
        [stillImageCapture captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
            
            if (!error) {
                
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                UIImage *image = [UIImage imageWithData:imageData];
                
                // if camera is front, flip image - benchmarked flip @ 0.05 seconds on iPhone 4S
                if (self.liveCameraIsFrontFacingCamera) {
                    image = [UIImage imageWithCGImage:image.CGImage
                                                scale:1.0
                                          orientation:UIImageOrientationLeftMirrored];
                    imageData = UIImageJPEGRepresentation(image,
                                                          0.8);
                    
                }
                
                // now send completion callback if it exists
                if (completionBlock) {
                    completionBlock(image);
                }
                
            } else {
                SLFError(@"error capturing image: %@",error);
                if (completionBlock) {
                    completionBlock(nil);
                }
            }
            
        }];
    } else {
        SLFError(@"no video connection! unable to capture still image.");
        if (completionBlock) {
            completionBlock(nil);
        }
    }
    
}

@end
