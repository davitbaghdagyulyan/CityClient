//
//  ComboBoxTableView.m
//  CityMobilDriver
//
//  Created by Intern on 1/8/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "ComboBoxTableView.h"
#import "CustomTableViewCell.h"

@interface ComboBoxTableView()
{
    
}
@end

@implementation ComboBoxTableView


//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    
//    
//
//    
//}


-(id)init{
    self = [super init];
    if (self) {

        

        
        
    }
    return self;
}


-(void)func{
    
    self.delegate = self;
    self.dataSource = self;
    
    UIView* bgView = [[UIView alloc]init];
    [self.myDelegate.view addSubview:bgView];
    bgView.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.myDelegate.view addConstraint:[NSLayoutConstraint constraintWithItem:bgView
                                                                attribute:NSLayoutAttributeLeading
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.myDelegate.view
                                                                attribute:NSLayoutAttributeLeading
                                                               multiplier:1.0
                                                                 constant:0]];
    
    
    [self.myDelegate.view addConstraint:[NSLayoutConstraint constraintWithItem:bgView
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.myDelegate.view
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1.0
                                                                 constant:0]];
    
    [self.myDelegate.view addConstraint:[NSLayoutConstraint constraintWithItem:bgView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.myDelegate.view
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:0]];
    
    [self.myDelegate.view addConstraint:[NSLayoutConstraint constraintWithItem:bgView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.myDelegate.view
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:0]];
    
    [bgView addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints=NO;
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.myDelegate.view.frame) - 40, self.titles.count * 60);
    self.center = bgView.center;
    
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:bgView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0]];
    
    
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:bgView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0
                                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:1.0
                                                                      constant:CGRectGetWidth(self.myDelegate.view.frame) - 40]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:1.0
                                                                      constant:self.titles.count * 60]];

    
    
    bgView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    
 
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}
- (CustomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* simpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableViewCell_%ld" , (long)indexPath.row];
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if( cell == nil )
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil][0];
        cell.cellText.text = self.titles[indexPath.row];
        if (indexPath.row==0)
        {
            cell.selectedCell.image = [UIImage imageNamed:@"rb_2.png"];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    
//    
    
    
    CustomTableViewCell* selectedCell = (CustomTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    selectedCell.selectedCell.image = [UIImage imageNamed:@"rb_2.png"];
    for (UIView *view in tableView.subviews) {
        for (UITableViewCell* cell in view.subviews) {
            if ( [cell isKindOfClass:[CustomTableViewCell class]] && cell != selectedCell) {
                CustomTableViewCell* celll = (CustomTableViewCell*)cell;
                celll.selectedCell.image = [UIImage imageNamed:@"rb.png"];
            }
        }
    }
    
    [self.myDelegate didSelectWithIndex:indexPath.row andTitle:selectedCell.cellText.text];

}

@end
