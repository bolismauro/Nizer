//
//  UIView+snap.m
//  Nizer
//
//  Created by Mauro Bolis on 10/17/13.
//  Copyright (c) 2013 Plasticpanda. All rights reserved.
//

#import "UIView+snap.h"

@implementation UIView (snap)

-(UIImage *) snapshot
{
    // Create the image context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, self.window.screen.scale);
    
    // There he is! The new API method
    [self drawViewHierarchyInRect:self.frame afterScreenUpdates:NO];
    
    // Get the snapshot
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    return snapshotImage;
}

@end
