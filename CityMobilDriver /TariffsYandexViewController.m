//
//  TariffsYandexViewController.m
//  CityMobilDriver
//
//  Created by Intern on 11/7/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "TariffsYandexViewController.h"
#import "OpenMapButtonHandler.h"
#import "LeftMenu.h"
@implementation TariffsYandexViewController
{

    LeftMenu*leftMenu;
    CAGradientLayer *gradient;
    OpenMapButtonHandler*openMapButtonHandlerObject;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    
    [GPSConection showGPSConection:self];
    for (UIScrollView* scroll in self.tarifsYandexScrollView.subviews)
    {
        [scroll removeFromSuperview];
    }
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];
    leftMenu=[LeftMenu getLeftMenu:self];
    self.tarifsYandexScrollView.userInteractionEnabled=YES;
    [self drawPage];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)drawPage
{
    gradient = [CAGradientLayer layer];
    
    //    CGColorRef darkColor = [[self.scrollView.backgroundColor colorWithAlphaComponent:0.5] CGColor];
    //    CGColorRef lightColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.6] CGColor];
    
    gradient.frame =self.tarifsYandexScrollView.bounds;
    
    
    [gradient setColors:[NSArray arrayWithObjects:(id)([UIColor lightGrayColor].CGColor), (id)([UIColor whiteColor].CGColor),nil]];
    [self.tarifsYandexScrollView.layer addSublayer:gradient];

}
- (IBAction)back:(id)sender
{
    if (leftMenu.flag)
    {
        CGPoint point;
        point.x=leftMenu.center.x-leftMenu.frame.size.width;
        point.y=leftMenu.center.y;
        leftMenu.center=point;
        leftMenu.flag=0;
    }
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void)
     {
         CGPoint point;
         if (leftMenu.flag==0)
             point.x=(CGFloat)leftMenu.frame.size.width/2;
         else
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         point.y=leftMenu.center.y;
         leftMenu.center=point;
         
     }
                     completion:^(BOOL finished)
     {
         
         if (leftMenu.flag==0)
         {
             leftMenu.flag=1;
             self.tarifsYandexScrollView.userInteractionEnabled=NO;
            
             
             self.tarifsYandexScrollView.tag=1;
           
             
             
             [leftMenu.disabledViewsArray removeAllObjects];
             
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc]initWithLong:self.tarifsYandexScrollView.tag]];
          
         }
         else
         {
             leftMenu.flag=0;
             self.tarifsYandexScrollView.userInteractionEnabled=YES;
           
         }
         
     }
     
     
     ];
    
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if (leftMenu.flag==0 && touchLocation.x>((float)1/16 *self.view.frame.size.width))
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
             leftMenu.flag=0;
             self.tarifsYandexScrollView.userInteractionEnabled=YES;
          
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             self.tarifsYandexScrollView.userInteractionEnabled=NO;
          
             leftMenu.flag=1;
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
    if (leftMenu.flag==0 && touchLocation.x>((float)1/16 *self.view.frame.size.width))
        return;
    CGPoint point;
    point.x= touchLocation.x- (CGFloat)leftMenu.frame.size.width/2;
    point.y=leftMenu.center.y;
    if (point.x>leftMenu.frame.size.width/2)
    {
        return;
    }
    leftMenu.center=point;
    self.tarifsYandexScrollView.userInteractionEnabled=NO;
  
    leftMenu.flag=1;
    
}
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:nil
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {

         CGFloat xx;
         
         if(leftMenu.flag==0)
         {
             xx=self.view.frame.size.width*(CGFloat)5/6*(-1);
         }
         else
         {
             xx=0;
         }
         
         leftMenu.frame =CGRectMake(xx, leftMenu.frame.origin.y, leftMenu.frame.size.width, self.view.frame.size.height-64);
         
         
     }];
    [super viewWillTransitionToSize: size withTransitionCoordinator:coordinator];
}
- (IBAction)openMap:(UIButton*)sender
{
    openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
}
@end
