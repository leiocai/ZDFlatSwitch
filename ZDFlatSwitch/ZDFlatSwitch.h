//
//  ZDFlatSwitch.h
//  AVFlatSwitch
//
//  Created by Alexcai on 15/6/12.
//  Copyright (c) 2015年 zhidier. All rights reserved.
//

#import <UIKit/UIKit.h>


static CGFloat finalStrokeEndForCheckmark = 0.85;
static CGFloat finalStrokeStartForCheckmark = 0.3;
static CGFloat checkmarkBounceAmount = 0.1;
static CFTimeInterval animationDuration = 0.3;


IB_DESIGNABLE
@interface ZDFlatSwitch : UIControl

/**
 *  线的宽度:默认为
 */
@property (nonatomic, assign)IBInspectable  CGFloat lineWidth;
/**
 *  设置符号颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *strokeColor;
/**
 *  设置外环颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *trailStrokeColor;
@property (nonatomic, assign) BOOL select;

@end
