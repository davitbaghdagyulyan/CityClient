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
        label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
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
             self.designationTableView.userInteractionEnabled=NO;
         }
         else
         {
             self.designationTableView.userInteractionEnabled=YES;
             flag=0;
         }
         
     }
     ];
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
             self.designationTableView.userInteractionEnabled=YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             flag=1;
             self.designationTableView.userInteractionEnabled=NO;
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
    {
        return;
    }
    CGPoint point;
    point.x= touchLocation.x- (CGFloat)leftMenu.frame.size.width/2;
    point.y=leftMenu.center.y;
    if (point.x>leftMenu.frame.size.width/2)
    {
        return;
    }
    leftMenu.center=point;
    flag=1;
    self.designationTableView.userInteractionEnabled=NO;
}

@end
