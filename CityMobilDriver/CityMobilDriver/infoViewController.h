//
//  infoViewController.h
//  CityMobilDriver
//
//  Created by Intern on 10/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mailJson.h"
#import "textRequest.h"
#import "textResponse.h"
#import "SingleDataProvider.h"
#import "LeftMenu.h"

@interface infoViewController : UIViewController <UIWebViewDelegate>

@property(nonatomic,strong)NSString* key;
@property (weak, nonatomic) IBOutlet UIWebView *web;
@property(nonatomic,strong) NSString* text;
@property(nonatomic,strong) NSString* HTMLString;
@property(nonatomic,strong) UIButton* backButton;
@property(nonatomic,strong) NSString* id_mail;
@property(nonatomic,strong) NSString* titleText;
@property (weak, nonatomic) IBOutlet UIView *navigationView;



- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;

@end
