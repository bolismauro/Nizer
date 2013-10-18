//
//  NIRootViewController.m
//  Nizer
//
//  Created by Mauro Bolis on 10/18/13.
//  Copyright (c) 2013 Plasticpanda. All rights reserved.
//

#import "NIRootViewController.h"

@interface NIRootViewController ()

@end

@implementation NIRootViewController

- (void)awakeFromNib {
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
    /*
     @property (assign, readwrite, nonatomic) REFrostedViewControllerDirection direction;
     @property (strong, readwrite, nonatomic) UIColor *blurTintColor;
     @property (assign, readwrite, nonatomic) CGFloat blurRadius; // Used only when live blur is off
     @property (assign, readwrite, nonatomic) CGFloat blurSaturationDeltaFactor; // Used only when live blur is off
     @property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;
     @property (assign, readwrite, nonatomic) BOOL limitMenuViewSize;
     @property (assign, readwrite, nonatomic) CGSize minimumMenuViewSize;
     @property (assign, readwrite, nonatomic) BOOL liveBlur;
     @property (assign, readwrite, nonatomic) REFrostedViewControllerLiveBackgroundStyle liveBlurBackgroundStyle;
     */
    
    self.liveBlur = YES;
    self.minimumMenuViewSize = self.view.bounds.size;
  //  self.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleDark;
}


@end
