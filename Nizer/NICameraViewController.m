//
//  NIViewController.m
//  Nizer
//
//  Created by Mauro Bolis on 10/17/13.
//  Copyright (c) 2013 Plasticpanda. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

#import "NICameraViewController.h"
#import "GPUImage.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

#define kAlbumName @"Nize"

@interface NICameraViewController () {
    GPUImageStillCamera *videoCamera;
    GPUImageBilateralFilter* bilateralFilter;
    GPUImageToonFilter* toonFilter;
    ALAssetsLibrary *library;
}

@property IBOutlet GPUImageView* filterView;
@end

@implementation NICameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    library = [[ALAssetsLibrary alloc] init];
	[self setupInterface];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setupInterface {
    videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    //    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    //    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    //    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1920x1080 cameraPosition:AVCaptureDevicePositionBack];
    
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    bilateralFilter  = [[GPUImageBilateralFilter alloc] init];
    [bilateralFilter setValue:@10 forKey:@"blurSize"];
    [bilateralFilter setValue:@5 forKey:@"distanceNormalizationFactor"];

    toonFilter = [[GPUImageToonFilter alloc] init];
    [toonFilter setValue:@0.0009 forKey:@"texelHeight"];
    [toonFilter setValue:@0.0009 forKey:@"texelWidth"];
    [toonFilter setValue:@0.3  forKey:@"threshold"];
    [toonFilter setValue:@10 forKey:@"quantizationLevels"];
    
    
    self.filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    
    [videoCamera addTarget:bilateralFilter];
    [bilateralFilter addTarget:toonFilter];
    [toonFilter addTarget:self.filterView];
    
    [videoCamera startCameraCapture];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage)];
    [self.filterView addGestureRecognizer:tapGesture];
}

-(void) saveImage {
    
    UIView* snap = [self.filterView snapshotViewAfterScreenUpdates:NO];
    [self.filterView addSubview:snap];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        float x = CGRectGetMidX(self.filterView.frame);
        [snap setFrame:CGRectMake(x, self.filterView.frame.size.height, 0, 0)];
    } completion:^(BOOL finished) {
        [snap removeFromSuperview];
    }];
    
    [videoCamera capturePhotoAsImageProcessedUpToFilter:toonFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        [library saveImage:processedImage toAlbum:kAlbumName completion:^(NSURL *assetURL, NSError *error) {
            NSLog(@"done %@", assetURL);
        } failure:^(NSError *error) {
            // TODO: let the user aware of this
            NSLog(@"error %@", error);
        }];
    }];
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
