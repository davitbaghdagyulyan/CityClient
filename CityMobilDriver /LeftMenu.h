//
//  LeftMenu.h
//  CityMobilDriver
//
//  Created by Intern on 10/10/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenu : UITableView <UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UIViewController* curentViewController;
@property(strong,nonatomic)NSMutableArray*nameArray;
+(LeftMenu*)getLeftMenu:(id)curentSelf;
@property(nonatomic,assign)NSUInteger flag;
@property(nonatomic,strong)NSMutableArray*disabledViewsArray;
@end
