//
//  CCButton.m
//  CalculatorC
//
//  Created by Kevin Peng on 2019-11-02.
//  Copyright © 2019 Kevin Peng. All rights reserved.
//

#import "CCButton.h"

@implementation CCButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    [self sharedInit];
}

- (void)sharedInit {
    [self setCustomBorderColor:[UIColor blackColor]];
    [self setCustomBorderWidth:1.0f];
    [self setCustomCornerRadius:22.0f];
    [self setCustomBackground:UIColor.grayColor];
}

- (void)setCustomBorderColor:(UIColor *)borderColor {
    _customBorderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}
- (void)setCustomBorderWidth:(CGFloat)borderWidth {
    _customBorderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}
- (void)setCustomCornerRadius:(CGFloat)cornerRadius {
    _customCornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}
- (void)setCustomBackground:(UIColor *)backgroundColor {
    _customBackground = backgroundColor;
    self.layer.backgroundColor = backgroundColor.CGColor;
}

@end
