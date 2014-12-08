//
//  CustomTableView.h
//  CityMobilDriver
//
//  Created by Intern on 11/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TariffCustomCell.h"
#import "CustomLabel.h"
@interface CustomTableView : UITableView
@property(nonatomic,assign)NSInteger i;
@property(nonatomic,assign)NSInteger j;
-(void)setXmlDictionary:(NSDictionary*)dictionary;
@end
