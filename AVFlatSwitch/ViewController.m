//
//  ViewController.m
//  AVFlatSwitch
//
//  Created by Alexcai on 15/6/12.
//  Copyright (c) 2015年 zhidier. All rights reserved.
//

#import "ViewController.h"
#import "ZDFlatSwitch.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ZDFlatSwitch *flatSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flatSwitch.lineWidth = 10;
    self.flatSwitch.strokeColor = [UIColor redColor];
    self.flatSwitch.trailStrokeColor = [UIColor grayColor];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
