//
//  TariffsCustomView.h
//  CityMobilDriver
//
//  Created by Intern on 11/4/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableView.h"
#import "CustomLabel.h"
@interface TariffsCustomView : UIView

@property (strong, nonatomic) IBOutlet CustomLabel* customLabel;
@property (strong, nonatomic) IBOutlet CustomTableView *customTableView;

@end
