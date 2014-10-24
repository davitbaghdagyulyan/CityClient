//
//  FirstScrollView.m
//  CityMobilDriver
//
//  Created by Intern on 10/24/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "FirstScrollView.h"
#import "LeftMenu.h"
#import "FirstView.h"
@implementation FirstScrollView
{
    NSInteger flag;
    LeftMenu*leftMenu;
    FirstView*firstObj;
}

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        flag=0;
        leftMenu=[LeftMenu getLeftMenu:self.curentViewController];
        firstObj = [[[NSBundle mainBundle]loadNibNamed:@"FirstView" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    
    
    if (flag==0 && touchLocation.x>((float)1/16 *self.curentViewController.view.frame.size.width))
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
             firstObj.FirstScrollView.userInteractionEnabled=YES;
             firstObj.segmentControlView.userInteractionEnabled=YES;
             
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             firstObj.FirstScrollView.userInteractionEnabled=NO;
             firstObj.segmentControlView.userInteractionEnabled=NO;
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
    
    
    
    if (flag==0 && touchLocation.x>((float)1/16 *self.curentViewController.view.frame.size.width))
        return;
    
    CGPoint point;
    
    
    
    point.x= touchLocation.x- (CGFloat)leftMenu.frame.size.width/2;
    point.y=leftMenu.center.y;
    if (point.x>leftMenu.frame.size.width/2)
    {
        return;
    }
    leftMenu.center=point;
    
    
    
    
    
    
    
    
    firstObj.FirstScrollView.userInteractionEnabled=NO;
    firstObj.segmentControlView.userInteractionEnabled=NO;
    
    flag=1;
    
    
}


@end
