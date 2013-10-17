//
//  NIViewController.m
//  Nizer
//
//  Created by Mauro Bolis on 10/17/13.
//  Copyright (c) 2013 Plasticpanda. All rights reserved.
//

#import "NIViewController.h"
#import "GPUImage.h"

@interface NIViewController ()
    @property IBOutlet UIImageView* imageView;
@end

@implementation NIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self elaborateImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) elaborateImage {
    UIImage* sourceImage = [UIImage imageNamed:@"parco"];
    
    /* Setup filters */
    GPUImageBilateralFilter* bilateralFilter = [[GPUImageBilateralFilter alloc] init];
    [bilateralFilter setValue:@5 forKey:@"blurSize"];
    [bilateralFilter setValue:@5 forKey:@"distanceNormalizationFactor"];
    
    GPUImageToonFilter* toonFilter = [[GPUImageToonFilter alloc] init];
    [toonFilter setValue:@0.7 forKey:@"threshold"];
    [toonFilter setValue:@8 forKey:@"quantizationLevels"];
    
    // setting up the chain
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:sourceImage];
    [stillImageSource addTarget:bilateralFilter];
    [bilateralFilter addTarget:toonFilter];
    
    // process
    [stillImageSource processImageWithCompletionHandler:^{
       // let's update the interface
        UIImage *currentFilteredVideoFrame = [toonFilter imageFromCurrentlyProcessedOutput];
        [self.imageView setImage:currentFilteredVideoFrame];
    }];
}

@end
