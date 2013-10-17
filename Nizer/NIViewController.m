//
//  NIViewController.m
//  Nizer
//
//  Created by Mauro Bolis on 10/17/13.
//  Copyright (c) 2013 Plasticpanda. All rights reserved.
//

#import "NIViewController.h"
#import "GPUImage.h"

@interface NIViewController () {
    GPUImageVideoCamera *videoCamera;
}
@property IBOutlet GPUImageView* filterView;
@end

@implementation NIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupInterface];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setupInterface {
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    //    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    //    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    //    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1920x1080 cameraPosition:AVCaptureDevicePositionBack];
    
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    GPUImageBilateralFilter* bilateralFilter  = [[GPUImageBilateralFilter alloc] init];
    [bilateralFilter setValue:@5 forKey:@"blurSize"];
    [bilateralFilter setValue:@5 forKey:@"distanceNormalizationFactor"];

    GPUImageToonFilter* toonFilter = [[GPUImageToonFilter alloc] init];
    [toonFilter setValue:@0.7 forKey:@"threshold"];
    [toonFilter setValue:@15 forKey:@"quantizationLevels"];
    
    
    self.filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    
    [videoCamera addTarget:bilateralFilter];
    [bilateralFilter addTarget:toonFilter];
    [toonFilter addTarget:self.filterView];
    
    [videoCamera startCameraCapture];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"rotated");
    // Map UIDeviceOrientation to UIInterfaceOrientation.
    UIInterfaceOrientation orient = UIInterfaceOrientationPortrait;
    switch ([[UIDevice currentDevice] orientation])
    {
        case UIDeviceOrientationLandscapeLeft:
            orient = UIInterfaceOrientationLandscapeLeft;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            orient = UIInterfaceOrientationLandscapeRight;
            break;
            
        case UIDeviceOrientationPortrait:
            orient = UIInterfaceOrientationPortrait;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            orient = UIInterfaceOrientationPortraitUpsideDown;
            break;
            
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationUnknown:
            // When in doubt, stay the same.
            orient = fromInterfaceOrientation;
            break;
    }
    videoCamera.outputImageOrientation = orient;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES; // Support all orientations.
}

@end
