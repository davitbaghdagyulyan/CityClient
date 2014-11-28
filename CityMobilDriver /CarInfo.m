//
//  CarInfo.m
//  CityMobilDriver
//
//  Created by Intern on 10/27/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "CarInfo.h"
#import "EditCarInfoView.h"

@implementation CarInfo
{
    EditCarInfoView* carInfo;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */



- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self = [[[NSBundle mainBundle]loadNibNamed:@"CarInfo" owner:self options:nil] objectAtIndex:0];
        self.carInfoTable.delegate = self;
        self.carInfoTable.dataSource = self;
        //self.carInfoTable.contentInset = UIEdgeInsetsMake(-20, 0, -20, 0);
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc]init];
    cell.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"марка";
            break;
        case 1:
            cell.textLabel.text = @"модель";
            break;
        case 2:
            cell.textLabel.text = @"год производства";
            break;
        case 3:
            cell.textLabel.text = @"цвет";
            break;
        case 4:
            cell.textLabel.text = @"гос.номер";
            break;
        case 5:
            cell.textLabel.text = @"vin-код";
            break;
        case 6:
            cell.textLabel.text = @"лицензия -";
            break;
            
        default:
            break;
    }
    
    
    return cell;
}

- (void)didAddSubview:(UIView *)subview
{
    self.isSubview = YES;
}

- (void)willRemoveSubview:(UIView *)subview
{
    self.isSubview = NO;
}

- (IBAction)editCarInfo:(id)sender
{
    carInfo = [[[NSBundle mainBundle]loadNibNamed:@"EditCarInfoView" owner:self options:nil] objectAtIndex:1];
    carInfo.frame = self.frame;
    [self addSubview:carInfo];
}








@end
