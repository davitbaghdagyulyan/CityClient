//
//  MessagesViewController.h
//  CityMobilDriver
//
//  Created by Intern on 10/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LeftViewCellObject.h"


@interface UITableView(touchMove)

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
@property(nonatomic,strong)id pointer;

@end
@interface MessagesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UIButton *theNewMessageButton;




@property (strong, nonatomic) IBOutlet UITableView *messagesTableView;
-(void)touch:(NSSet *)touches withEvent:(UIEvent *)event;
@end
