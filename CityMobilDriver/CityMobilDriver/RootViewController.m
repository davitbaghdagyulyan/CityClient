//
//  ViewController.m
//  CityMobilDriver
//
//  Created by Davit Baghdagyulyan on 9/22/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LoginViewController*log=[self.storyboard instantiateViewControllerWithIdentifier:@"View2"];
    [self.navigationController pushViewController:log animated:NO];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
