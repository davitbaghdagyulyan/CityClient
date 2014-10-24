//
//  SelectedOrdersViewController.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/9/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SelectedOrdersViewController.h"
#import "CustomCellSelectedOrders.h"
#import "SingleDataProvider.h"
#import "SingleDataProviderForFilter.h"
#import "SelectedOrdersDetailsResponse.h"
#import "SelectedOrdersDetailsJson.h"
#import "JSONModel.h"
#import "LeftMenu.h"
#import "CustomCellSelectORDER.h"



@interface SelectedOrdersViewController ()
{
    NSInteger flag;
    LeftMenu*leftMenu;
    


}

@end

@implementation SelectedOrdersViewController
{

    SelectedOrdersDetailsResponse * selectedOrdersDetailsResponseObject;
    NSString * percent;
    
   // NSString * callDateText;
    NSString * callDate;
    NSString * callDateFormat;
    NSString * deliveryMetroName;
    NSString * callMetroName;
    NSString * shortName;
    NSString * NoSmoking;
    NSString * G_Width;
    NSString * payment_method;
    NSString * conditioner;
    NSString * animal;
    NSString * ourComment;
    float height;
    NSString * stringForLabelShortName;
    NSString * stringForLabelPercent;
    NSString * stringForLabelCallMetroName;
    NSString * stringForLabelDeliveryMetroName;
    
    NSInteger selectedRow;

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:20];
    self.titleLabel.text = self.titleString;
    flag=0;
    self.tableViewOrdersDetails.userInteractionEnabled = YES;
    leftMenu=[LeftMenu getLeftMenu:self];
    [self requestOrder];
    
    selectedRow = -1;
}

- (void)viewDidLoad {
    [super viewDidLoad];

       // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return  selectedOrdersDetailsResponseObject.orders.count;
    

}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(selectedRow==indexPath.row)
    {
        
        ourComment =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getOurComment];
        CGSize expectSize;
        UILabel *labelOurComment;
        if(ourComment)
        {
            if ([ourComment isEqualToString:@""])
            {
                height = 200;
            }
            
            else
                
            {
                
                labelOurComment  = [[UILabel alloc] init];
                labelOurComment.font = [UIFont fontWithName:@"RobotoCondensed-Regular" size:14];
                labelOurComment.text =ourComment;
                labelOurComment.numberOfLines = 0;
                labelOurComment.lineBreakMode = NSLineBreakByWordWrapping;
                CGSize maximumLabelSize = CGSizeMake(290,400);
                CGSize expectSize = [labelOurComment sizeThatFits:maximumLabelSize];
                height = 200+expectSize.height;
                
                
            }
            
        }
        
        else
        {
            height=200;
            
        }
        
        NSString *simpleTableIdentifierIphone = [NSString stringWithFormat: @"SimpleTableORDERSelected%d",indexPath.row];
        
        CustomCellSelectORDER * cell = (CustomCellSelectORDER *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierIphone];
        if (cell == nil)
        {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellSelectORDER" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSString *deviceType = [UIDevice currentDevice].model;
        NSString * localizedModel =[UIDevice currentDevice].localizedModel;
        //Image1 construction and initialization
        UIImageView * imgView1;
        imgView1 = [[UIImageView alloc]initWithImage:nil];
        imgView1.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView1];
        NSLayoutConstraint * imgView1ConstraintWidth;
        NSLayoutConstraint * imgView1ConstraintHeight;
        NSLayoutConstraint *imgView1X;
        NSLayoutConstraint *imgView1Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView1X = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -50];
            imgView1Y = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
        }
        
        else
        {
            imgView1X = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView1Y = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:6];
            
            
            
        }
        
        
        [cell.View1 addConstraint:imgView1X];
        [cell.View1 addConstraint:imgView1Y];
        
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getNoSmoking])
        {
            
            
            
            NoSmoking =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getNoSmoking];
            
            
            if ([NoSmoking isEqualToString:@"Y"])
            {
                
                imgView1.image = [UIImage imageNamed: @"ic_no_smoking_lounge_small.png"];
                
                imgView1ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
                imgView1ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                
                [cell.View1   addConstraint:imgView1ConstraintWidth];
                [cell.View1 addConstraint:imgView1ConstraintHeight];
                
            }
            
            else if([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getG_width])
            {
                G_Width =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getG_width];
                if ([G_Width integerValue] ==1)
                {
                    imgView1ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                    imgView1ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                    
                    
                    imgView1.image = [UIImage imageNamed: @"ic_smoking_lounge_small.png"];
                    [cell.View1 addConstraint:imgView1ConstraintHeight];
                    [cell.View1 addConstraint:imgView1ConstraintWidth];
                    
                    
                    
                }
                else if([G_Width integerValue] ==0)
                {
                    imgView1.image = nil;
                    
                }
                
                else
                {
                    imgView1.image = nil;
                    
                }
            }
            
            
        }
        
        
        
        
        
        //Image2 construction and initialization
        UIImageView * imgView2;
        imgView2 = [[UIImageView alloc]initWithImage:nil];
        imgView2.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView2];
        NSLayoutConstraint * imgView2ConstraintWidth;
        NSLayoutConstraint * imgView2ConstraintHeight;
        NSLayoutConstraint *imgView2X;
        NSLayoutConstraint *imgView2Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView2X = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView1 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -30];
            imgView2Y = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
        }
        
        else
        {
            imgView2X = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView1 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView2Y = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
            
            
            
        }
        
        
        [cell.View1 addConstraint:imgView2X];
        [cell.View1 addConstraint:imgView2Y];
        
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getPayment_method])
        {
            
            payment_method =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getPayment_method];
            
            if ([payment_method isEqualToString:@"cash"])
            {
                imgView2.image = [UIImage imageNamed:@"ic_cash_payment_small.png"];
                
                imgView2ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:24];
                imgView2ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
                
                [cell.View1 addConstraint:imgView2ConstraintHeight];
                [cell.View1 addConstraint:imgView2ConstraintWidth];
                
                
            }
            
            
            else if  ([payment_method isEqualToString:@"card"])
            {
                
                imgView2.image = [UIImage imageNamed:@"ic_credit_card_payment_small.png"];
                
                imgView2ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:19];
                imgView2ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
                
                [cell.View1 addConstraint:imgView2ConstraintHeight];
                [cell.View1 addConstraint:imgView2ConstraintWidth];
                
                
                
            }
            
            else if([payment_method isEqualToString:@"corporate"]   )
                
            {
                
                imgView2.image = [UIImage imageNamed:@"ic_non_cash_payment_small.png"];
                
                imgView2ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:21];
                imgView2ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                
                [cell.View1 addConstraint:imgView2ConstraintHeight];
                [cell.View1 addConstraint:imgView2ConstraintWidth];
                
                
            }
            
            else
            {
                imgView2.image = nil;
                
            }
            
            
            
        }
        
        
        //********Image3 construction and initialization
        UIImageView * imgView3;
        imgView3 = [[UIImageView alloc]initWithImage:nil];
        imgView3.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView3];
        NSLayoutConstraint * imgView3ConstraintWidth;
        NSLayoutConstraint * imgView3ConstraintHeight;
        NSLayoutConstraint *imgView3X;
        NSLayoutConstraint *imgView3Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView3X = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView2 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -30];
            imgView3Y = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
        }
        
        else
        {
            imgView3X = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView2 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView3Y = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
            
            
            
        }
        
        
        [cell.View1 addConstraint:imgView3X];
        [cell.View1 addConstraint:imgView3Y];
        
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getConditioner])
            
            
        {
            conditioner =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getConditioner];
            if ([conditioner integerValue]==1)
            {
                imgView3.image = [UIImage imageNamed:@"ic_air_conditioning_small.png"];
                
                imgView3ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:15];
                imgView3ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                
                [cell.View1 addConstraint:imgView3ConstraintHeight];
                [cell.View1 addConstraint:imgView3ConstraintWidth];
                
                
            }
            else
            {
                imgView3.image = nil;
                
            }
            
            
        }
        
        
        //********Image4 construction and initialization
        
        
        UIImageView * imgView4;
        imgView4 = [[UIImageView alloc]initWithImage:nil];
        imgView4.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView4];
        NSLayoutConstraint * imgView4ConstraintWidth;
        NSLayoutConstraint * imgView4ConstraintHeight;
        NSLayoutConstraint *imgView4X;
        NSLayoutConstraint *imgView4Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView4X = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView3 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -30];
            imgView4Y = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
        }
        
        else
        {
            imgView4X = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView3 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView4Y = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
            
            
            
        }
        
        
        [cell.View1 addConstraint:imgView4X];
        [cell.View1 addConstraint:imgView4Y];
        
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getAnimal])
            
            
        {
            animal =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getAnimal];
            if ([animal integerValue]==1)
            {
                imgView4.image = [UIImage imageNamed:@"ic_transportation_of_animals_small.png"];
                
                imgView4ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
                imgView4ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                
                [cell.View1 addConstraint:imgView4ConstraintHeight];
                [cell.View1 addConstraint:imgView4ConstraintWidth];
                
                
            }
            else
            {
                imgView4.image = nil;
                
            }
            
            
        }
        
        
        
        //********Image5 construction and initialization
        
        
        UIImageView * imgView5;
        imgView5 = [[UIImageView alloc]initWithImage:nil];
        imgView5.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView5];
        NSLayoutConstraint * imgView5ConstraintWidth;
        NSLayoutConstraint * imgView5ConstraintHeight;
        NSLayoutConstraint *imgView5X;
        NSLayoutConstraint *imgView5Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView5X = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView4 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -30];
            imgView5Y = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
        }
        
        else
        {
            imgView5X = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView4 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView5Y = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
            
            
            
        }
        
        
        [cell.View1 addConstraint:imgView5X];
        [cell.View1 addConstraint:imgView5Y];
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getBaby_seat])
            
            
        {
            NSString * babySeat;
            babySeat =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getBaby_seat];
            if ([babySeat integerValue]>0)
            {
                imgView5.image = [UIImage imageNamed:@"ic_child_seat_small.png"];
                
                imgView5ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:15];
                imgView5ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                
                [cell.View1 addConstraint:imgView5ConstraintHeight];
                [cell.View1 addConstraint:imgView5ConstraintWidth];
                
                
            }
            else
            {
                imgView5.image = nil;
                
            }
            
            
        }
        
        
        
        //********Image6 construction and initialization
        
        
        UIImageView * imgView6;
        imgView6 = [[UIImageView alloc]initWithImage:nil];
        imgView6.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView6];
        NSLayoutConstraint * imgView6ConstraintWidth;
        NSLayoutConstraint * imgView6ConstraintHeight;
        NSLayoutConstraint *imgView6X;
        NSLayoutConstraint *imgView6Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView6X = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView5 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -30];
            imgView6Y = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
        }
        
        else
        {
            imgView6X = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView5 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView6Y = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
            
            
            
        }
        
        
        [cell.View1 addConstraint:imgView6X];
        [cell.View1 addConstraint:imgView6Y];
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getLuggage])
            
            
        {
            NSString * luggage;
            luggage =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getLuggage];
            if ([luggage integerValue]==1)
            {
                imgView6.image = [UIImage imageNamed:@"ic_baggage_small.png"];
                
                imgView6ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
                imgView6ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
                
                [cell.View1 addConstraint:imgView6ConstraintHeight];
                [cell.View1 addConstraint:imgView6ConstraintWidth];
                
                
            }
            else
            {
                imgView6.image = nil;
                
            }
            
            
        }
        
        
        
        //********Image7 construction and initialization
        
        
        UIImageView * imgView7;
        imgView7 = [[UIImageView alloc]initWithImage:nil];
        imgView7.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView7];
        NSLayoutConstraint * imgView7ConstraintWidth;
        NSLayoutConstraint * imgView7ConstraintHeight;
        NSLayoutConstraint *imgView7X;
        NSLayoutConstraint *imgView7Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView7X = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView6 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -30];
            imgView7Y = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
        }
        
        else
        {
            imgView7X = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView6 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView7Y = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
            
            
            
        }
        
        
        
        [cell.View1 addConstraint:imgView7X];
        [cell.View1 addConstraint:imgView7Y];
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getUseBonus])
            
            
        {
            NSString * useBonus;
            useBonus =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getUseBonus];
            if ([useBonus isEqualToString:@"Y"])
            {
                imgView7.image = [UIImage imageNamed:@"ic_on_bonuses_payment_small.png"];
                
                imgView7ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:15];
                imgView7ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                
                [cell.View1 addConstraint:imgView7ConstraintHeight];
                [cell.View1 addConstraint:imgView7ConstraintWidth];
                
                
            }
            else
            {
                imgView7.image = nil;
                
            }
            
            
        }
        
        
        
        //********Image8 construction and initialization
        
        
        UIImageView * imgView8;
        imgView8 = [[UIImageView alloc]initWithImage:nil];
        imgView8.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView8];
        NSLayoutConstraint * imgView8ConstraintWidth;
        NSLayoutConstraint * imgView8ConstraintHeight;
        NSLayoutConstraint *imgView8X;
        NSLayoutConstraint *imgView8Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView8X = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView7 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -30];
            imgView8Y = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
        }
        
        else
        {
            imgView8X = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView7 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView8Y = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
            
            
            
        }
        
        
        
        [cell.View1 addConstraint:imgView8X];
        [cell.View1 addConstraint:imgView8Y];
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getNeed_wifi])
            
            
        {
            NSString * need_WiFi;
            need_WiFi =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getNeed_wifi];
            if ([need_WiFi integerValue]==1)
            {
                imgView8.image = [UIImage imageNamed:@"ic_wifi_small.png"];
                
                imgView8ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                imgView8ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
                
                [cell.View1 addConstraint:imgView8ConstraintHeight];
                [cell.View1 addConstraint:imgView8ConstraintWidth];
                
                
            }
            else
            {
                imgView8.image = nil;
                
            }
            
            
        }
        
        
        //********Image9 construction and initialization
        
        
        UIImageView * imgView9;
        imgView9 = [[UIImageView alloc]initWithImage:nil];
        imgView9.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView9];
        NSLayoutConstraint * imgView9ConstraintWidth;
        NSLayoutConstraint * imgView9ConstraintHeight;
        NSLayoutConstraint *imgView9X;
        NSLayoutConstraint *imgView9Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView9X = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView8 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -30];
            imgView9Y = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
        }
        
        else
        {
            imgView9X = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView8 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView9Y = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
            
            
            
        }
        
        
        
        [cell.View1 addConstraint:imgView9X];
        [cell.View1 addConstraint:imgView9Y];
        
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getYellow_reg_num])
            
            
        {
            NSString * yellowNumber;
            yellowNumber =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getYellow_reg_num];
            if ([yellowNumber integerValue]==1)
            {
                imgView9.image = [UIImage imageNamed:@"ic_order_with_visiting_small.png"];
                
                imgView9ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                imgView9ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
                
                [cell.View1 addConstraint:imgView9ConstraintHeight];
                [cell.View1 addConstraint:imgView9ConstraintWidth];
                
                
            }
            else
            {
                imgView9.image = nil;
                
            }
            
            
        }
        
        NSMutableArray * arrayOfImages =[[NSMutableArray alloc]initWithObjects:imgView1,imgView2,imgView3,imgView4,imgView5,imgView6,imgView7,imgView8,imgView9,nil];
        
        NSMutableArray * arrayOfImages2 =[[NSMutableArray alloc]init];
        for (int i =0; i<arrayOfImages.count; i++)
        {
            UIImageView * imgViewCurrent =[arrayOfImages objectAtIndex:i];
            if (imgViewCurrent.image!=nil)
            {
                [arrayOfImages2 addObject:[arrayOfImages objectAtIndex:i]];
            }
        }
        
        if (arrayOfImages2.count != 0)
        {
            if ([deviceType isEqualToString:@"iPhone Simulator"])
                
            {
                NSLayoutConstraint *constForX0 = [NSLayoutConstraint constraintWithItem:[arrayOfImages2 objectAtIndex:0] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:cell.labelPercent attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-25];
                [cell.View1 addConstraint:constForX0];
                
                
                for (int i =0; i<arrayOfImages2.count; i++)
                {
                    if (i!=0)
                    {
                        NSLayoutConstraint *constForX = [NSLayoutConstraint constraintWithItem:[arrayOfImages2 objectAtIndex:i] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:[arrayOfImages2 objectAtIndex:i-1]attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-25];
                        [cell.View1 addConstraint:constForX];
                    }
                }
                
            }
            
            else
                
            {
                NSLayoutConstraint *constForX0 = [NSLayoutConstraint constraintWithItem:[arrayOfImages2 objectAtIndex:0] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:cell.labelPercent attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-50];
                [cell.View1 addConstraint:constForX0];
                
                
                for (int i =0; i<arrayOfImages2.count; i++)
                {
                    if (i!=0)
                    {
                        NSLayoutConstraint *constForX = [NSLayoutConstraint constraintWithItem:[arrayOfImages2 objectAtIndex:i] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:[arrayOfImages2 objectAtIndex:i-1]attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-50];
                        [cell.View1 addConstraint:constForX];
                    }
                }
                
            }
            
            
            
            
        }
        
        else
            
        {
            for (int i =0; i<arrayOfImages.count; i++)
            {
                NSLayoutConstraint *constForXhide = [NSLayoutConstraint constraintWithItem:[arrayOfImages objectAtIndex:i] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:cell.labelPercent attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:20];
                [cell.View1 addConstraint:constForXhide];
                
                
            }
            
        }
        
        //The Part when the string ourcomment is not nil or is not void is in progress
        if(height !=200)
        {
            
            NSLog(@"The Part when the string ourcomment is not nil or is not void is in progress ");
           
//            cell.View1.translatesAutoresizingMaskIntoConstraints =NO;
//            cell.View3.translatesAutoresizingMaskIntoConstraints =NO;
//            cell.View2.translatesAutoresizingMaskIntoConstraints =NO;
//            NSLayoutConstraint * View1Height =[NSLayoutConstraint constraintWithItem:cell.View1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.OrangeView attribute:NSLayoutAttributeHeight multiplier:0.1 constant:0];
//            NSLayoutConstraint * View2Height =[NSLayoutConstraint constraintWithItem:cell.View2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.OrangeView attribute:NSLayoutAttributeHeight multiplier:0.2 constant:0];
//            NSLayoutConstraint * View3Height =[NSLayoutConstraint constraintWithItem:cell.View3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.OrangeView attribute:NSLayoutAttributeHeight multiplier:0.4 constant:0];
//            
//            [cell.OrangeView addConstraint:View1Height];
//            [cell.OrangeView addConstraint:View2Height];
//            [cell.OrangeView addConstraint:View3Height];
            //     cell.labelDeliveryMetroName.text = @"kuku";
            //    cell.labelDeliveryMetroName.translatesAutoresizingMaskIntoConstraints =NO;
            //    cell.labelDeliveryMetroAddress.translatesAutoresizingMaskIntoConstraints = NO;
            //    NSLayoutConstraint * heightLDelMetroName =[NSLayoutConstraint constraintWithItem:cell.labelDeliveryMetroName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View3 attribute:NSLayoutAttributeHeight multiplier:0.35 constant:0];
            //    NSLayoutConstraint *heightLDelMetroAddress =[NSLayoutConstraint constraintWithItem:cell.labelDeliveryMetroAddress attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View3 attribute:NSLayoutAttributeHeight multiplier:0.35 constant:0];
            //
            //
            //    [cell.View3 addConstraint:heightLDelMetroAddress];
            //    [cell.View3 addConstraint:heightLDelMetroName];
            //    labelOurComment.translatesAutoresizingMaskIntoConstraints =NO;
            //    [cell.View3 addSubview:labelOurComment];
            //     NSLayoutConstraint * labOurCH;
            //     NSLayoutConstraint * labOurCW;
            //     NSLayoutConstraint *labOurCX;
            //     NSLayoutConstraint *labOurCY;
            //     labOurCX = [NSLayoutConstraint constraintWithItem:labelOurComment attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.View3 attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-7];
            //     labOurCY = [NSLayoutConstraint constraintWithItem:labelOurComment attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View3 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:70];
            //    [cell.View3 addConstraint:labOurCX];
            //    [cell.View3 addConstraint:labOurCY];
            //    labOurCW  = [NSLayoutConstraint constraintWithItem:labelOurComment attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View3 attribute:NSLayoutAttributeWidth multiplier:0.f constant:295];
            //    labOurCH = [NSLayoutConstraint constraintWithItem:labelOurComment attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View3 attribute:NSLayoutAttributeWidth multiplier:0.f constant:expectSize.height];
            //       [cell.View3 addConstraint:labOurCW];
            //       [cell.View3 addConstraint:labOurCH];
            //       labelOurComment.backgroundColor = [UIColor greenColor];
            //       labelOurComment.text = ourComment;
            
            
        }
        
        cell.labelPercent.text = stringForLabelPercent;
        cell.labelShortName.text=[NSString stringWithFormat:@"  %@", stringForLabelShortName];
        cell.labelCallMetroName.text=[NSString stringWithFormat:@"%@",stringForLabelCallMetroName];
        cell.labelDeliveryMetroName.text=[NSString stringWithFormat:@"%@",stringForLabelDeliveryMetroName];
        if([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getDeliveryAddressText])
        {
            NSString * callAddressText =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getDeliveryAddressText];
            NSString *  stringForCallAddress =[NSString stringWithFormat:@"%@",callAddressText];
            cell.labelCallMetroAddress.text=stringForCallAddress;
            
        }
        else
        {
            
            
            cell.labelDeliveryMetroAddress.text=@"";
            
        }
        
        
        if([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getCollAddresstext])
        {
            
            NSString * delAddresstext =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getCollAddresstext];
            NSString *   stringForDelAddress =[NSString stringWithFormat:@"%@",delAddresstext];
            cell.labelDeliveryMetroAddress.text=stringForDelAddress;
        }
        
        else
        {
            cell.labelCallMetroAddress.text=@"";
        }
        return  cell;
        
    }
    
    else
    {
        NSString *simpleTableIdentifierIphone = [NSString stringWithFormat: @"SimpleTableOrders%d",indexPath.row];
        CustomCellSelectedOrders * cell = (CustomCellSelectedOrders *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierIphone];
        if (cell == nil)
        {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellSelectedOrders" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getShortname])
        {
            shortName =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getShortname];
        }
        else
        {
            shortName = @"";
            
        }
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getCollDate])
        {
            callDate =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getCollDate];
            callDateFormat = [self TimeFormat:callDate];
        }
        else
        {
            callDate = @"";
            
        }
        
        stringForLabelShortName = [NSString stringWithFormat:@"  %@ %@ %@",self.stringForSrochno,callDateFormat,shortName];
        cell.labelShortName.text = stringForLabelShortName;
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getPercent])
        {
            percent =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getPercent];
        }
        else
        {
            percent = @"";
            
        }
        
        
        if([percent length]>3)
        {
            stringForLabelPercent= [percent substringToIndex:2];
        }
        else
        {
            stringForLabelPercent = percent;
        }
        stringForLabelPercent = [stringForLabelPercent stringByAppendingString:@"%"];
        cell.labelPercent.font = [UIFont fontWithName:@"RobotoCondensed-Regular" size:19];
        cell.labelPercent.textColor = [UIColor whiteColor];
        cell.labelPercent.text = stringForLabelPercent;
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getCollMetroName])
        {
            callMetroName =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getCollMetroName];
        }
        else
        {
            callMetroName = @"";
            
        }
        
        stringForLabelCallMetroName =[NSString stringWithFormat:@"  %@",callMetroName] ;
        cell.labelCollMetroName.text = stringForLabelCallMetroName;
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getDeliveryMetroName])
        {
            deliveryMetroName =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getDeliveryMetroName];
        }
        else
        {
            deliveryMetroName = @"";
            
        }
        
        stringForLabelDeliveryMetroName = deliveryMetroName;
        cell.labelDeliveryMetroName.text = [NSString stringWithFormat:@"%@",stringForLabelCallMetroName];
        
        
        
        NSString *deviceType = [UIDevice currentDevice].model;
        NSString * localizedModel =[UIDevice currentDevice].localizedModel;
        //Image1 construction and initialization
        UIImageView * imgView1;
        imgView1 = [[UIImageView alloc]initWithImage:nil];
        imgView1.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView1];
        NSLayoutConstraint * imgView1ConstraintWidth;
        NSLayoutConstraint * imgView1ConstraintHeight;
        NSLayoutConstraint *imgView1X;
        NSLayoutConstraint *imgView1Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView1X = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -50];
            imgView1Y = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
        }
        
        else
        {
            imgView1X = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView1Y = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:6];
            
            
            
        }
        
        
        [cell.View1 addConstraint:imgView1X];
        [cell.View1 addConstraint:imgView1Y];
        
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getNoSmoking])
        {
            
            
            
            NoSmoking =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getNoSmoking];
            
            
            if ([NoSmoking isEqualToString:@"Y"])
            {
                
                imgView1.image = [UIImage imageNamed: @"ic_no_smoking_lounge_small.png"];
                
                imgView1ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
                imgView1ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                
                [cell.View1   addConstraint:imgView1ConstraintWidth];
                [cell.View1 addConstraint:imgView1ConstraintHeight];
                
            }
            
            else if([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getG_width])
            {
                G_Width =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getG_width];
                if ([G_Width integerValue] ==1)
                {
                    imgView1ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                    imgView1ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                    
                    
                    imgView1.image = [UIImage imageNamed: @"ic_smoking_lounge_small.png"];
                    [cell.View1 addConstraint:imgView1ConstraintHeight];
                    [cell.View1 addConstraint:imgView1ConstraintWidth];
                    
                    
                    
                }
                else if([G_Width integerValue] ==0)
                {
                    imgView1.image = nil;
                    
                }
                
                else
                {
                    imgView1.image = nil;
                    
                }
            }
            
            
        }
        
        
        
        
        
        //Image2 construction and initialization
        UIImageView * imgView2;
        imgView2 = [[UIImageView alloc]initWithImage:nil];
        imgView2.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView2];
        NSLayoutConstraint * imgView2ConstraintWidth;
        NSLayoutConstraint * imgView2ConstraintHeight;
        NSLayoutConstraint *imgView2X;
        NSLayoutConstraint *imgView2Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView2X = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView1 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -30];
            imgView2Y = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
        }
        
        else
        {
            imgView2X = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView1 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView2Y = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
            
            
            
        }
        
        
        [cell.View1 addConstraint:imgView2X];
        [cell.View1 addConstraint:imgView2Y];
        
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getPayment_method])
        {
            
            payment_method =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getPayment_method];
            
            if ([payment_method isEqualToString:@"cash"])
            {
                imgView2.image = [UIImage imageNamed:@"ic_cash_payment_small.png"];
                
                imgView2ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:24];
                imgView2ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
                
                [cell.View1 addConstraint:imgView2ConstraintHeight];
                [cell.View1 addConstraint:imgView2ConstraintWidth];
                
                
            }
            
            
            else if  ([payment_method isEqualToString:@"card"])
            {
                
                imgView2.image = [UIImage imageNamed:@"ic_credit_card_payment_small.png"];
                
                imgView2ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:19];
                imgView2ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
                
                [cell.View1 addConstraint:imgView2ConstraintHeight];
                [cell.View1 addConstraint:imgView2ConstraintWidth];
                
                
                
            }
            
            else if([payment_method isEqualToString:@"corporate"]   )
                
            {
                
                imgView2.image = [UIImage imageNamed:@"ic_non_cash_payment_small.png"];
                
                imgView2ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:21];
                imgView2ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                
                [cell.View1 addConstraint:imgView2ConstraintHeight];
                [cell.View1 addConstraint:imgView2ConstraintWidth];
                
                
            }
            
            else
            {
                imgView2.image = nil;
                
            }
            
            
            
        }
        
        
        //********Image3 construction and initialization
        UIImageView * imgView3;
        imgView3 = [[UIImageView alloc]initWithImage:nil];
        imgView3.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView3];
        NSLayoutConstraint * imgView3ConstraintWidth;
        NSLayoutConstraint * imgView3ConstraintHeight;
        NSLayoutConstraint *imgView3X;
        NSLayoutConstraint *imgView3Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView3X = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView2 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -30];
            imgView3Y = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
        }
        
        else
        {
            imgView3X = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView2 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView3Y = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
            
            
            
        }
        
        
        [cell.View1 addConstraint:imgView3X];
        [cell.View1 addConstraint:imgView3Y];
        
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getConditioner])
            
            
        {
            conditioner =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getConditioner];
            if ([conditioner integerValue]==1)
            {
                imgView3.image = [UIImage imageNamed:@"ic_air_conditioning_small.png"];
                
                imgView3ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:15];
                imgView3ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                
                [cell.View1 addConstraint:imgView3ConstraintHeight];
                [cell.View1 addConstraint:imgView3ConstraintWidth];
                
                
            }
            else
            {
                imgView3.image = nil;
                
            }
            
            
        }
        
        
        //********Image4 construction and initialization
        
        
        UIImageView * imgView4;
        imgView4 = [[UIImageView alloc]initWithImage:nil];
        imgView4.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView4];
        NSLayoutConstraint * imgView4ConstraintWidth;
        NSLayoutConstraint * imgView4ConstraintHeight;
        NSLayoutConstraint *imgView4X;
        NSLayoutConstraint *imgView4Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView4X = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView3 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -30];
            imgView4Y = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
        }
        
        else
        {
            imgView4X = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView3 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView4Y = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
            
            
            
        }
        
        
        [cell.View1 addConstraint:imgView4X];
        [cell.View1 addConstraint:imgView4Y];
        
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getAnimal])
            
            
        {
            animal =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getAnimal];
            if ([animal integerValue]==1)
            {
                imgView4.image = [UIImage imageNamed:@"ic_transportation_of_animals_small.png"];
                
                imgView4ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
                imgView4ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                
                [cell.View1 addConstraint:imgView4ConstraintHeight];
                [cell.View1 addConstraint:imgView4ConstraintWidth];
                
                
            }
            else
            {
                imgView4.image = nil;
                
            }
            
            
        }
        
        
        
        //********Image5 construction and initialization
        
        
        UIImageView * imgView5;
        imgView5 = [[UIImageView alloc]initWithImage:nil];
        imgView5.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView5];
        NSLayoutConstraint * imgView5ConstraintWidth;
        NSLayoutConstraint * imgView5ConstraintHeight;
        NSLayoutConstraint *imgView5X;
        NSLayoutConstraint *imgView5Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView5X = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView4 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -30];
            imgView5Y = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
        }
        
        else
        {
            imgView5X = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView4 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView5Y = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
            
            
            
        }
        
        
        [cell.View1 addConstraint:imgView5X];
        [cell.View1 addConstraint:imgView5Y];
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getBaby_seat])
            
            
        {
            NSString * babySeat;
            babySeat =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getBaby_seat];
            if ([babySeat integerValue]>0)
            {
                imgView5.image = [UIImage imageNamed:@"ic_child_seat_small.png"];
                
                imgView5ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:15];
                imgView5ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                
                [cell.View1 addConstraint:imgView5ConstraintHeight];
                [cell.View1 addConstraint:imgView5ConstraintWidth];
                
                
            }
            else
            {
                imgView5.image = nil;
                
            }
            
            
        }
        
        
        
        //********Image6 construction and initialization
        
        
        UIImageView * imgView6;
        imgView6 = [[UIImageView alloc]initWithImage:nil];
        imgView6.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView6];
        NSLayoutConstraint * imgView6ConstraintWidth;
        NSLayoutConstraint * imgView6ConstraintHeight;
        NSLayoutConstraint *imgView6X;
        NSLayoutConstraint *imgView6Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView6X = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView5 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -30];
            imgView6Y = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
        }
        
        else
        {
            imgView6X = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView5 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView6Y = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
            
            
            
        }
        
        
        [cell.View1 addConstraint:imgView6X];
        [cell.View1 addConstraint:imgView6Y];
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getLuggage])
            
            
        {
            NSString * luggage;
            luggage =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getLuggage];
            if ([luggage integerValue]==1)
            {
                imgView6.image = [UIImage imageNamed:@"ic_baggage_small.png"];
                
                imgView6ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
                imgView6ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
                
                [cell.View1 addConstraint:imgView6ConstraintHeight];
                [cell.View1 addConstraint:imgView6ConstraintWidth];
                
                
            }
            else
            {
                imgView6.image = nil;
                
            }
            
            
        }
        
        
        
        //********Image7 construction and initialization
        
        
        UIImageView * imgView7;
        imgView7 = [[UIImageView alloc]initWithImage:nil];
        imgView7.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView7];
        NSLayoutConstraint * imgView7ConstraintWidth;
        NSLayoutConstraint * imgView7ConstraintHeight;
        NSLayoutConstraint *imgView7X;
        NSLayoutConstraint *imgView7Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView7X = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView6 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -30];
            imgView7Y = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
        }
        
        else
        {
            imgView7X = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView6 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView7Y = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
            
            
            
        }
        
        
        
        [cell.View1 addConstraint:imgView7X];
        [cell.View1 addConstraint:imgView7Y];
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getUseBonus])
            
            
        {
            NSString * useBonus;
            useBonus =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getUseBonus];
            if ([useBonus isEqualToString:@"Y"])
            {
                imgView7.image = [UIImage imageNamed:@"ic_on_bonuses_payment_small.png"];
                
                imgView7ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:15];
                imgView7ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                
                [cell.View1 addConstraint:imgView7ConstraintHeight];
                [cell.View1 addConstraint:imgView7ConstraintWidth];
                
                
            }
            else
            {
                imgView7.image = nil;
                
            }
            
            
        }
        
        
        
        //********Image8 construction and initialization
        
        
        UIImageView * imgView8;
        imgView8 = [[UIImageView alloc]initWithImage:nil];
        imgView8.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView8];
        NSLayoutConstraint * imgView8ConstraintWidth;
        NSLayoutConstraint * imgView8ConstraintHeight;
        NSLayoutConstraint *imgView8X;
        NSLayoutConstraint *imgView8Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView8X = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView7 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -30];
            imgView8Y = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
        }
        
        else
        {
            imgView8X = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView7 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView8Y = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
            
            
            
        }
        
        
        
        [cell.View1 addConstraint:imgView8X];
        [cell.View1 addConstraint:imgView8Y];
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getNeed_wifi])
            
            
        {
            NSString * need_WiFi;
            need_WiFi =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getNeed_wifi];
            if ([need_WiFi integerValue]==1)
            {
                imgView8.image = [UIImage imageNamed:@"ic_wifi_small.png"];
                
                imgView8ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                imgView8ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
                
                [cell.View1 addConstraint:imgView8ConstraintHeight];
                [cell.View1 addConstraint:imgView8ConstraintWidth];
                
                
            }
            else
            {
                imgView8.image = nil;
                
            }
            
            
        }
        
        
        //********Image9 construction and initialization
        
        
        UIImageView * imgView9;
        imgView9 = [[UIImageView alloc]initWithImage:nil];
        imgView9.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View1 addSubview:imgView9];
        NSLayoutConstraint * imgView9ConstraintWidth;
        NSLayoutConstraint * imgView9ConstraintHeight;
        NSLayoutConstraint *imgView9X;
        NSLayoutConstraint *imgView9Y;
        
        
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            imgView9X = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView8 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -30];
            imgView9Y = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
        }
        
        else
        {
            imgView9X = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView8 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                         -100];
            imgView9Y = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
            
            
            
        }
        
        
        
        [cell.View1 addConstraint:imgView9X];
        [cell.View1 addConstraint:imgView9Y];
        
        
        
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getYellow_reg_num])
            
            
        {
            NSString * yellowNumber;
            yellowNumber =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getYellow_reg_num];
            if ([yellowNumber integerValue]==1)
            {
                imgView9.image = [UIImage imageNamed:@"ic_order_with_visiting_small.png"];
                
                imgView9ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                imgView9ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
                
                [cell.View1 addConstraint:imgView9ConstraintHeight];
                [cell.View1 addConstraint:imgView9ConstraintWidth];
                
                
            }
            else
            {
                imgView9.image = nil;
                
            }
            
            
        }
        
        NSMutableArray * arrayOfImages =[[NSMutableArray alloc]initWithObjects:imgView1,imgView2,imgView3,imgView4,imgView5,imgView6,imgView7,imgView8,imgView9,nil];
        
        NSMutableArray * arrayOfImages2 =[[NSMutableArray alloc]init];
        for (int i =0; i<arrayOfImages.count; i++)
        {
            UIImageView * imgViewCurrent =[arrayOfImages objectAtIndex:i];
            if (imgViewCurrent.image!=nil)
            {
                [arrayOfImages2 addObject:[arrayOfImages objectAtIndex:i]];
            }
        }
        
        if (arrayOfImages2.count != 0)
        {
            if ([deviceType isEqualToString:@"iPhone Simulator"])
                
            {
                NSLayoutConstraint *constForX0 = [NSLayoutConstraint constraintWithItem:[arrayOfImages2 objectAtIndex:0] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:cell.labelPercent attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-25];
                [cell.View1 addConstraint:constForX0];
                
                
                for (int i =0; i<arrayOfImages2.count; i++)
                {
                    if (i!=0)
                    {
                        NSLayoutConstraint *constForX = [NSLayoutConstraint constraintWithItem:[arrayOfImages2 objectAtIndex:i] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:[arrayOfImages2 objectAtIndex:i-1]attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-25];
                        [cell.View1 addConstraint:constForX];
                    }
                }
                
            }
            
            else
                
            {
                NSLayoutConstraint *constForX0 = [NSLayoutConstraint constraintWithItem:[arrayOfImages2 objectAtIndex:0] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:cell.labelPercent attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-50];
                [cell.View1 addConstraint:constForX0];
                
                
                for (int i =0; i<arrayOfImages2.count; i++)
                {
                    if (i!=0)
                    {
                        NSLayoutConstraint *constForX = [NSLayoutConstraint constraintWithItem:[arrayOfImages2 objectAtIndex:i] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:[arrayOfImages2 objectAtIndex:i-1]attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-50];
                        [cell.View1 addConstraint:constForX];
                    }
                }
                
            }
            
            
            
            
        }
        
        else
            
        {
            for (int i =0; i<arrayOfImages.count; i++)
            {
                NSLayoutConstraint *constForXhide = [NSLayoutConstraint constraintWithItem:[arrayOfImages objectAtIndex:i] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:cell.labelPercent attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:20];
                [cell.View1 addConstraint:constForXhide];
                
                
            }
            
        }
        
        
        
        
        return  cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(selectedRow==indexPath.row)
    {
        selectedRow =-1;
        
    }
    else
    {
        selectedRow =indexPath.row;
    }
    [self.tableViewOrdersDetails reloadData];
    
    [self.tableViewOrdersDetails scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];


}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deviceType = [UIDevice currentDevice].model;
    if(selectedRow==indexPath.row)
        
    {
        return 200;
    }
    
    else
    {
        if ([deviceType isEqualToString:@"iPhone Simulator"])
        {
            if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
               
               [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown
               
               )
            {return  self.view.frame.size.height*146/1136;
            }
            else
            {
                
                return self.view.frame.size.height/4;
            }
            
        }
        else
        {
            
            if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
               
               [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown
               
               )
            {return  self.view.frame.size.height*146/1136;
            }
            else
            {
                
                return self.view.frame.size.height/6;
            }
            
        }
        

        
    }

    
}



-(void)requestOrder
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    SelectedOrdersDetailsJson* detailsJsonObject=[[SelectedOrdersDetailsJson alloc]init];
    
    
    
    NSDictionary*jsonDictionary=[detailsJsonObject toDictionary];
    NSString*jsons=[detailsJsonObject toJSONString];
    NSLog(@"%@",jsons);
    
    
    NSURL* url = [NSURL URLWithString:@"https://driver-msk.city-mobil.ru/taxiserv/api/driver/"];
    
    NSError* error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    request.timeoutInterval = 10;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"NO INTERNET CONECTION"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            
            [alert show];
            return ;
        }
        NSString* jsonString1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"selectedOrdersDetails =%@",jsonString1);
        NSError*err;
      
        selectedOrdersDetailsResponseObject = [[SelectedOrdersDetailsResponse alloc] initWithString:jsonString1 error:&err];
        
       
        
        if(selectedOrdersDetailsResponseObject.code!=nil)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
            
        }
        [indicator stopAnimating];
       
        [self.tableViewOrdersDetails reloadData];
    }];
    
    
}


- (IBAction)openAndCloseLeftMenu:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void)
     {
         CGPoint point;
         if (flag==0)
             point.x=(CGFloat)leftMenu.frame.size.width/2;
         else
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         point.y=leftMenu.center.y;
         leftMenu.center=point;
         
     }
                     completion:^(BOOL finished)
     {
         
         if (flag==0)
         {
             flag=1;
             self.tableViewOrdersDetails.userInteractionEnabled=NO;
            
         }
         else
         {
             flag=0;
             self.tableViewOrdersDetails.userInteractionEnabled=YES;
           
         }
         
     }
     
     
     ];
    
}

- (IBAction)back:(id)sender
{
    if (flag)
    {
        CGPoint point;
        point.x=leftMenu.center.x-leftMenu.frame.size.width;
        point.y=leftMenu.center.y;
        leftMenu.center=point;
        
    }
   
    [self.navigationController popViewControllerAnimated:NO];
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    
    
    if (flag==0 && touchLocation.x>((float)1/16 *self.view.frame.size.width))
        return;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void)
     {
         
         
         
         CGPoint point;
         
         NSLog(@"\n%f", 2*leftMenu.center.x);
         NSLog(@"\n%f",leftMenu.frame.size.width/2);
         
         if (touchLocation.x<=leftMenu.frame.size.width/2)
         {
             flag=0;
             self.tableViewOrdersDetails.userInteractionEnabled=YES;
            
             
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             self.tableViewOrdersDetails.userInteractionEnabled=NO;
           
             flag=1;
         }
         point.y=leftMenu.center.y;
         
         
         
         
         leftMenu.center=point;
         NSLog(@"\n%f",leftMenu.frame.size.width);
         
     }
                     completion:nil
     
     
     ];
    
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    
    
    
    
    
    
    
    
    
    
    if (flag==0 && touchLocation.x>((float)1/16 *self.view.frame.size.width))
        return;
    
    CGPoint point;
    
    
    
    point.x= touchLocation.x- (CGFloat)leftMenu.frame.size.width/2;
    point.y=leftMenu.center.y;
    if (point.x>leftMenu.frame.size.width/2)
    {
        return;
    }
    leftMenu.center=point;
    
    
    
    
    
    
    
    
    self.tableViewOrdersDetails.userInteractionEnabled=NO;
   
    
    flag=1;
    
    
    
    
    
    
}


-(NSString*)TimeFormat:(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    
    
    
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:string];
    
    /////////convert nsdata To NSString////////////////////////////////////
    [dateFormatter setDateFormat:@"HH:mm"];
    if(date==nil) return @"00:00";
    return [dateFormatter stringFromDate:date];
    
}
@end