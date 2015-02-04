//
//  PullDownToRefresh.h
//  CityMobilDriver
//
//  Created by Intern on 2/4/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeftMenu.h"
#import "RootViewController.h"
#import "SelectedOrdersViewController.h"
@interface PullDownToRefresh : NSObject

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer andView:(UITableView*)tableView;
-(void)swipeHandler:(UIPanGestureRecognizer *)sender andSelf:(UIViewController*)currentSelf andTableView:(UITableView*)tableView andLeftMenu:(LeftMenu*)leftMenu andClassName:(NSString*)className;
@end
