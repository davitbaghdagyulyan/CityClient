///Users/intern/Documents/Projects/CityMobilDriver/CityMobilDriver/MessagesViewController.h
//  MessagesViewController.h
//  CityMobilDriver
//
//  Created by Intern on 10/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "MessagesCell.h"
#import "infoViewController.h"
#import "LeftMenu.h"

@interface MessagesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

- (IBAction)theNewMessage:(UIButton *)sender;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UIButton *theNewMessageButton;
@property (strong, nonatomic) IBOutlet UITableView *messagesTableView;
- (IBAction)back:(id)sender;
@end
