//
//  PullDownToRefresh.m
//  CityMobilDriver
//
//  Created by Intern on 2/4/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "PullDownToRefresh.h"

@implementation PullDownToRefresh
{
    BOOL swipeBool;
    BOOL refreshBool;
    BOOL firstRefresh;
    BOOL isMove;
    UILabel*loadLabel;
    UILabel*upLabel;
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer andView:(UITableView*)tableView
{
    CGPoint velocity = [panGestureRecognizer velocityInView:tableView];
    swipeBool=((fabs(velocity.y) < fabs(velocity.x)));
    refreshBool=(((fabs(velocity.y) > fabs(velocity.x)))&&(tableView.contentOffset.y==0)&&(velocity.y>0));
    firstRefresh=YES;
    return swipeBool||refreshBool;
}
-(void)swipeHandler:(UIPanGestureRecognizer *)sender andSelf:(UIViewController*)currentSelf andTableView:(UITableView*)tableView andLeftMenu:(LeftMenu*)leftMenu andClassName:(NSString*)className
{
    static CGFloat y0=0.0;
    static CGFloat y=0.0;
    CGPoint touchLocation = [sender locationInView:sender.view];
    
    NSLog(@"x=%f",touchLocation.x);
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        if (swipeBool)
        {
            isMove=leftMenu.flag==0 && touchLocation.x>30;
            if (isMove)
                return;
        }
        else if (refreshBool)
        {
            y0=touchLocation.y;
            loadLabel=[[UILabel alloc] initWithFrame:CGRectMake(currentSelf.view.frame.size.width/2, 68, 0, 4)];
            loadLabel.backgroundColor=[UIColor orangeColor];
            [currentSelf.view addSubview:loadLabel];
            upLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, currentSelf.view.frame.size.width, 0)];
            upLabel.backgroundColor=[UIColor colorWithRed:220.f/255 green:220.f/255 blue:220.f/255 alpha:1];
            upLabel.textColor=[UIColor blackColor];
            upLabel.textAlignment=NSTextAlignmentCenter;
            upLabel.text=@"Потините";
            upLabel.tag=144;
            upLabel.userInteractionEnabled=YES;
            [currentSelf.view addSubview:upLabel];
            //upLabel.transform = CGAffineTransformMakeScale(0,0);
            [self animationUpToDown:currentSelf.view.frame.size.width];
            
        }
    }
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        if (swipeBool)
        {
            if (isMove)
                return;
            CGPoint point;
            point.x= touchLocation.x- (CGFloat)leftMenu.frame.size.width/2;
            point.y=leftMenu.center.y;
            if (point.x>leftMenu.frame.size.width/2)
            {
                return;
            }
            leftMenu.center=point;
            
            leftMenu.flag=1;
        }
        else if (refreshBool)
        {
            CGPoint point=currentSelf.view.center;
            point.y=68;
            y=touchLocation.y;
            CGFloat delta=y-y0;
            CGFloat unit=currentSelf.view.bounds.size.width/150;
            CGPoint velocity = [sender velocityInView:tableView];
            if (delta<150)
            {
                if (velocity.y>0)
                {
                    loadLabel.bounds=CGRectMake(0,0, delta*unit, 4);
                    loadLabel.center=point;
                }
                else
                {
                    [self animationDownToUp:currentSelf.view.frame.size.width];
                    [loadLabel removeFromSuperview];
                }
                
            }
            if (delta>=150&&firstRefresh)
            {
                firstRefresh=NO;
                if ([className isEqualToString:@"RootViewController"])
                {
                  [(RootViewController*)currentSelf refreshAction];
                }
                else if ([className isEqualToString:@"SelectedOrdersViewController"])
                {
                    [(SelectedOrdersViewController*)currentSelf refreshAction];
                }
                [self animationDownToUp:currentSelf.view.frame.size.width];
                [loadLabel removeFromSuperview];
              
            }
        }
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (swipeBool)
        {
            
            if (isMove)
                return;
            isMove=NO;
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
                     leftMenu.flag=0;
                     
                     point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
                 }
                 else if (touchLocation.x>leftMenu.frame.size.width/2)
                 {
                     point.x=(CGFloat)leftMenu.frame.size.width/2;
                     
                     
                     leftMenu.flag=1;
                 }
                 point.y=leftMenu.center.y;
                 leftMenu.center=point;
                 NSLog(@"\n%f",leftMenu.frame.size.width);
                 
             }
                             completion:nil
             ];
            
        }
        else if (refreshBool)
        {
            [self animationDownToUp:currentSelf.view.frame.size.width];
            [loadLabel removeFromSuperview];
        }
        
        
    }
 
}

-(void)animationUpToDown:(CGFloat)width
{
   
    {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options: 0
                         animations:^(void)
         {
            
             upLabel.frame=CGRectMake(0, 0,width, 67);
             
         }
                         completion:nil];
    }

}

-(void)animationDownToUp:(CGFloat)width
{
    
    {
        [UIView animateWithDuration:0.8
                              delay:0
                            options: UIViewAnimationOptionTransitionFlipFromBottom
                         animations:^(void)
         {
             
             upLabel.frame=CGRectMake(0, -67,width, 67);
             
         }
                         completion:^(BOOL finished){
                             [upLabel removeFromSuperview];
                         }];
    }
    
}

@end
