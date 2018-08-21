//
//  HomeViewController.m
//  抽屉效果
//
//  Created by corepress on 2018/8/21.
//  Copyright © 2018年 corepress. All rights reserved.
//

#import "HomeViewController.h"
#import "MainTableViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    MainTableViewController *tableVC = [[MainTableViewController alloc]init];
   
    tableVC.view.frame = self.view.bounds;
    
    [self addChildViewController:tableVC];
    
    [self.mainView addSubview:tableVC.view];
    
}



@end
