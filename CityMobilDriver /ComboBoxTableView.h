//
//  ComboBoxTableView.h
//  CityMobilDriver
//
//  Created by Intern on 1/8/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ComboBoxDelegate <NSObject>

-(void)didSelectWithIndex:(NSUInteger)index andTitle:(NSString*)title;

@end

@interface ComboBoxTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak) UIViewController<ComboBoxDelegate>* myDelegate;
//@property(nonatomic,assign) NSUInteger numberOfRows;
@property(nonatomic,strong) NSArray* titles;


-(void)func;


@end
