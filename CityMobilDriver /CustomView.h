//
//  CustomView.h
//  CityMobilDriver
//
//  Created by Intern on 10/20/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//
@protocol view1Delegate

-(void)requestBindCard;

@end

#import <UIKit/UIKit.h>

@interface CustomView : UIView
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *addCardButton;

- (IBAction)actionAdd:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *checkCardLabel;
@property (strong, nonatomic) IBOutlet UIView *customView;
@property(weak,nonatomic)id<view1Delegate> delegate;

@end
