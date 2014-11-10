//
//  DesignationIconsViewController.m
//  CityMobilDriver
//
//  Created by Intern on 11/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "DesignationIconsViewController.h"
#import "LeftMenu.h"
#import "DesignationCustomCell.h"
#import "CustomLabel.h"
@interface DesignationIconsViewController ()
{
    LeftMenu*leftMenu;
    NSInteger flag;
    CAGradientLayer *gradLayer;
    NSArray*textArray;
}
@end

@implementation DesignationIconsViewController



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
    flag=0;
    leftMenu=[LeftMenu getLeftMenu:self];
    
   
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.designationTableView.delegate=self;
    self.designationTableView.dataSource=self;
    textArray=[NSArray arrayWithObjects:@"курящий салон",@"не курящий салон",@"наличный расчет",@"безналичный расчет",@"оплата по бонусам",@"оплата по карте",@"Wi-Fi",@"детское кресло",@"перевозка животного",@"багаж",@"заказ с заездом",@"кондиционер",@"желтые номера", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return  13;
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    
    NSString* simpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableViewCell_%ld" , (long)indexPath.row];
    DesignationCustomCell *cell = (DesignationCustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    CustomLabel*label;
   
   
    if( cell == nil )
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DesignationCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
       
        gradLayer=[CAGradientLayer layer];
        gradLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, 57);
       
        [gradLayer setColors:[NSArray arrayWithObjects:(id)([UIColor lightGrayColor].CGColor), (id)([UIColor whiteColor].CGColor),nil]];
        label=[[CustomLabel alloc]initWithFrame:cell.designationView.frame];
        label.backgroundColor=[UIColor clearColor];

    }
    cell.userInteractionEnabled=NO;
    

    
    [cell.designationView.layer addSublayer:gradLayer];
    label.text=[textArray objectAtIndex:indexPath.row];
    label.textColor=[UIColor blackColor];
    [cell.designationView addSubview:label];
    
    

    cell.designationImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",(long)indexPath.row]];
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60;
}
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:nil
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
         
         [self.designationTableView reloadData];
         CGFloat xx;
         
         if(flag==0)
         {
             xx=self.view.frame.size.width*(CGFloat)5/6*(-1);
         }
         else
         {
             xx=0;
         }
         
         leftMenu.frame =CGRectMake(xx, leftMenu.frame.origin.y, self.view.frame.size.width*(CGFloat)5/6, self.view.frame.size.height-64);
         
     }];
    
    [super viewWillTransitionToSize: size withTransitionCoordinator:coordinator];
}

@end
