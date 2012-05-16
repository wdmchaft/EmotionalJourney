//
//  CustomNavBar.m
//  EmotionalJourney
//
//  Created by Administrator on 13/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomNavBar.h"

@implementation CustomNavBar

- (void)drawRect:(CGRect)rect {
    // Drawing code 
    UIImage *img = [UIImage imageNamed: @"Texture_RedCanvas.png"];
    [img drawInRect:CGRectMake(0, 
                               0, 
                               self.frame.size.width, 
                               self.frame.size.height)];
}

@end
