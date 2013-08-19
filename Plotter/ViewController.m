//
//  ViewController.m
//  Plotter
//
//  Created by Jon Guan on 8/19/13.
//  Copyright (c) 2013 Scanadu, Inc. All rights reserved.
//

#import "ViewController.h"
#import "GraphView.h"
#import "PointerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.scrollView.contentSize = CGSizeMake(kDefaultGraphWidth, kGraphHeight);
    
    CGRect rect = CGRectMake(0, 0, kDefaultGraphWidth, kGraphHeight);
    self.graphView = [[GraphView alloc] initWithFrame:rect];
    [self.scrollView addSubview:self.graphView];
    
    PointerView *pointView = [[PointerView alloc] initWithFrame:rect];
    [self.scrollView addSubview:pointView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
