//
//  NINavigationController.m
//  Nizer
//
//  Created by Mauro Bolis on 10/18/13.
//  Copyright (c) 2013 Plasticpanda. All rights reserved.
//

#import "NINavigationController.h"

@interface NINavigationController ()

@end

@implementation NINavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    [self.frostedViewController panGestureRecognized:sender];
}

@end
