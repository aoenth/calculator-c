//
//  CCButton.h
//  CalculatorC
//
//  Created by Kevin Peng on 2019-11-02.
//  Copyright © 2019 Kevin Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE
@interface CCButton : UIButton
@property IBInspectable (nonatomic) UIColor *customBorderColor;
@property IBInspectable (nonatomic) CGFloat customBorderWidth;
@property IBInspectable (nonatomic) CGFloat customCornerRadius;
@property IBInspectable (nonatomic) UIColor *customBackground;
@end

NS_ASSUME_NONNULL_END
