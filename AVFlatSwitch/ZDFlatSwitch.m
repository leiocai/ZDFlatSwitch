//
//  ZDFlatSwitch.m
//  AVFlatSwitch
//
//  Created by Alexcai on 15/6/12.
//  Copyright (c) 2015年 zhidier. All rights reserved.
//

#import "ZDFlatSwitch.h"


@interface ZDFlatSwitch ()

@property (nonatomic, strong) CAShapeLayer *trailCircle;
@property (nonatomic, strong) CAShapeLayer *circle;
@property (nonatomic, strong) CAShapeLayer *checkmark;
@property (nonatomic, assign) CGPoint checkmarkMidPoint;
@property (nonatomic, assign) BOOL selected_internal;

@end

@implementation ZDFlatSwitch

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self configure];
}
-(instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self configure];
    
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    if (layer == self.layer) {
        CGPoint offset = CGPointZero;
        CGFloat radius = fmin(self.bounds.size.width, self.bounds.size.height) / 2;
        offset.x = (self.bounds.size.width - radius * 2) / 2.0;
        offset.y = (self.bounds.size.height - radius * 2) / 2.0;
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        CGRect ovalRect = CGRectMake(offset.x, offset.y, radius * 2, radius * 2);
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
        _trailCircle.path = circlePath.CGPath;
        
        _circle.transform = CATransform3DIdentity;
        _circle.frame = self.bounds;
        _circle.path = [UIBezierPath bezierPathWithOvalInRect:ovalRect].CGPath;
        _circle.transform = CATransform3DMakeRotation((212 * M_PI / 180), 0, 0, 1);
        CGPoint origin = CGPointMake(offset.x + radius, offset.y + radius);
        CGPoint checkStartPoint = CGPointZero;
        checkStartPoint.x = origin.x + radius * (cos(212 * M_PI / 180));
        checkStartPoint.y = origin.y + radius * (sin(212 * M_PI / 180));
        UIBezierPath *checkmarkPath = [UIBezierPath new];
        [checkmarkPath moveToPoint:checkStartPoint];
        self.checkmarkMidPoint = CGPointMake(offset.x + radius * 0.9, offset.y + radius * 1.4);
        [checkmarkPath addLineToPoint:self.checkmarkMidPoint];
        CGPoint checkEndPoint = CGPointZero;
        checkEndPoint.x = origin.x + radius * (cos(320 * M_PI / 180));
        checkEndPoint.y = origin.y + radius * (sin(320 * M_PI / 180));
        
        [checkmarkPath addLineToPoint:checkEndPoint];
        
        _checkmark.frame = self.bounds;
        _checkmark.path = checkmarkPath.CGPath;
        [CATransaction commit];
    }

}

- (void)configure{
    self.lineWidth = 4.0;
    self.strokeColor = [UIColor redColor];
    self.trailStrokeColor = [UIColor greenColor];
    
    self.backgroundColor = [UIColor clearColor];
    [self configureShapeLayer:self.trailCircle];
    self.trailCircle.strokeColor = self.trailStrokeColor.CGColor;
    
    [self configureShapeLayer:self.circle];
    self.circle.strokeColor = self.strokeColor.CGColor;
    
    [self configureShapeLayer:self.checkmark];
    self.checkmark.strokeColor = self.strokeColor.CGColor;
    [self setSelect:NO Animated:NO];
    
    [self addTarget:self action:@selector(onTouchUpInside) forControlEvents:UIControlEventTouchUpInside];

}

- (void)configureShapeLayer:( CAShapeLayer *)shapeLayer {
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineWidth = self.lineWidth;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:shapeLayer];
}

- (void)onTouchUpInside{
    self.select = !self.select;
    [self setSelect:self.select Animated:YES];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setSelect:(BOOL)select Animated:(BOOL)animation{
    self.selected_internal = select;
    [_checkmark removeAllAnimations];
    [_circle removeAllAnimations];
    [_trailCircle removeAllAnimations];
    
    [self resetValuesWithAnimation:animation];
    
    if (animation) {
        [self addAnimationsForSelected:_selected_internal];
    }
}

- (void)resetValuesWithAnimation:(BOOL)animation{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if ((_selected_internal && animation) || (_selected_internal == NO && animation == NO) ) {
        _checkmark.strokeEnd = 0.0;
        _checkmark.strokeStart = 0.0;
        _trailCircle.opacity = 0.0;
        _circle.strokeStart = 0.0;
        _circle.strokeEnd = 1.0;
    } else {
        _checkmark.strokeEnd = finalStrokeEndForCheckmark;
        _checkmark.strokeStart = finalStrokeStartForCheckmark;
        _trailCircle.opacity = 1.0;
        _circle.strokeStart = 0.0;
        _circle.strokeEnd = 0.0;
    }
    [CATransaction commit];
}

- (void)addAnimationsForSelected:(BOOL)selection{
    CGFloat circleAnimationDuration = animationDuration * 0.5;
    CGFloat checkmarkEndDuration = animationDuration * 0.8;
    CGFloat checkmarkStartDuration = checkmarkEndDuration - circleAnimationDuration;
    CGFloat  checkmarkBounceDuration = animationDuration - checkmarkEndDuration;
    
   CAAnimationGroup *checkmarkAnimationGroup = [CAAnimationGroup new];
    checkmarkAnimationGroup.removedOnCompletion = NO;
    checkmarkAnimationGroup.fillMode = kCAFillModeForwards;
    checkmarkAnimationGroup.duration = animationDuration;
    checkmarkAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    
    CAKeyframeAnimation *checkmarkStrokeEnd = [CAKeyframeAnimation new];
    checkmarkStrokeEnd.keyPath = @"strokeEnd";
    checkmarkStrokeEnd.duration = checkmarkEndDuration + checkmarkBounceDuration;
    checkmarkStrokeEnd.removedOnCompletion = NO;
    checkmarkStrokeEnd.fillMode = kCAFillModeForwards;
    checkmarkStrokeEnd.calculationMode = kCAAnimationPaced;
    
    if (selection) {
        checkmarkStrokeEnd.values = @[@(0.0), @((finalStrokeEndForCheckmark + checkmarkBounceAmount)), @((finalStrokeEndForCheckmark))];
        checkmarkStrokeEnd.keyTimes = @[@(0.0), @(checkmarkEndDuration),@(checkmarkEndDuration + checkmarkBounceDuration)];
        
    } else {
        checkmarkStrokeEnd.values = @[@(finalStrokeEndForCheckmark), @(finalStrokeEndForCheckmark + checkmarkBounceAmount), @(-0.1)];
        checkmarkStrokeEnd.keyTimes = @[@(0.0), @(checkmarkBounceDuration), @(checkmarkEndDuration + checkmarkBounceDuration)];
    }
    
    CAKeyframeAnimation *checkmarkStrokeStart = [CAKeyframeAnimation  new]; //(keyPath: "strokeStart")
    checkmarkStrokeStart.keyPath = @"strokeStart";
    checkmarkStrokeStart.duration = checkmarkStartDuration + checkmarkBounceDuration;
    checkmarkStrokeStart.removedOnCompletion = NO;
    checkmarkStrokeStart.fillMode = kCAFillModeForwards;
    checkmarkStrokeStart.calculationMode = kCAAnimationPaced;
    
    if (selection) {
        checkmarkStrokeStart.values = @[@(0.0), @(finalStrokeStartForCheckmark + checkmarkBounceAmount), @(finalStrokeStartForCheckmark)];
        checkmarkStrokeStart.keyTimes = @[@(0.0), @(checkmarkStartDuration), @(checkmarkStartDuration + checkmarkBounceDuration)];
    } else {
        checkmarkStrokeStart.values = @[@(finalStrokeStartForCheckmark), @(finalStrokeStartForCheckmark + checkmarkBounceAmount), @(0.0)];
        checkmarkStrokeStart.keyTimes = @[@(0.0), @(checkmarkBounceDuration), @(checkmarkStartDuration + checkmarkBounceDuration)];
    }
    
    if (selection) {
        checkmarkStrokeStart.beginTime = circleAnimationDuration;
    }
    
    checkmarkAnimationGroup.animations = @[checkmarkStrokeEnd, checkmarkStrokeStart];
    [_checkmark addAnimation:checkmarkAnimationGroup forKey:@"checkmarkAnimation"];
    
    CAAnimationGroup *circleAnimationGroup = [CAAnimationGroup new];
    circleAnimationGroup.duration = animationDuration;
    circleAnimationGroup.removedOnCompletion = NO;
    circleAnimationGroup.fillMode = kCAFillModeForwards;
    circleAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *circleStrokeEnd = [CABasicAnimation new];
    circleStrokeEnd.keyPath = @"strokeEnd";
    circleStrokeEnd.duration = circleAnimationDuration;
    if (selection) {
        circleStrokeEnd.beginTime = 0.0;
        
        circleStrokeEnd.fromValue = @(1.0);
        circleStrokeEnd.toValue = @(-0.1);
    } else {
        circleStrokeEnd.beginTime = animationDuration - circleAnimationDuration;
        
        circleStrokeEnd.fromValue = @(0.0);
        circleStrokeEnd.toValue = @(1.0);
    }
    circleStrokeEnd.removedOnCompletion = NO;
    circleStrokeEnd.fillMode = kCAFillModeForwards;
    
    circleAnimationGroup.animations = @[circleStrokeEnd];
    [self.circle addAnimation:circleAnimationGroup forKey:@"circleStrokeEnd"];
    
    CABasicAnimation *trailCircleColor = [CABasicAnimation new]; //CABasicAnimation(keyPath: "opacity")
    trailCircleColor.keyPath = @"opacity";
    trailCircleColor.duration = animationDuration;
    if (selection) {
        trailCircleColor.fromValue = @(0.0);
        trailCircleColor.toValue = @(1.0);
    } else {
        trailCircleColor.fromValue = @(1.0);
        trailCircleColor.toValue = @(0.0);
    }
    trailCircleColor.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    trailCircleColor.fillMode = kCAFillModeForwards;
    trailCircleColor.removedOnCompletion = NO;
    [_trailCircle  addAnimation:trailCircleColor forKey:@"trailCircleColor"];
}


- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    self.circle.lineWidth = lineWidth;
    self.checkmark.lineWidth = lineWidth;
    self.trailCircle.lineWidth = lineWidth;
}

- (void)setStrokeColor:(UIColor *)strokeColor{
    _strokeColor = strokeColor;
        self.circle.strokeColor = strokeColor.CGColor;
        self.checkmark.strokeColor = strokeColor.CGColor;
}

- (void)setTrailStrokeColor:(UIColor *)trailStrokeColor{
    _trailStrokeColor = trailStrokeColor;
        self.trailCircle.strokeColor = trailStrokeColor.CGColor;
}

- (void)setSelect:(BOOL)select{
    super.selected = select;
    _select = select;
}
- (BOOL)selected{
    return _selected_internal;
}

- (CAShapeLayer *)trailCircle{
    if (_trailCircle == nil) {
        _trailCircle = [CAShapeLayer new];
    }
    return _trailCircle;
}
- (CAShapeLayer *)circle{
    if (_circle == nil) {
        _circle = [CAShapeLayer new];
    }
    return _circle;
}
- (CAShapeLayer *)checkmark{
    if (_checkmark == nil) {
        _checkmark = [CAShapeLayer new];
    }
    return _checkmark;
}


@end
