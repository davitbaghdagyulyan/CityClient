//
//  StatisticsViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "StatisticsViewController.h"
#import "LeftMenu.h"
#import "OpenMapButtonHandler.h"

@interface StatisticsViewController ()
{
    LeftMenu*leftMenu;

    GetInfoResponse*getInfoResponseObject;
    CGFloat yCord,y1Cord;
    NSMutableArray*titleLabelArray;
    NSMutableArray*textsLabelArray;
    OpenMapButtonHandler*openMapButtonHandlerObject;
}
@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([ApiAbilitiesSingleTon sharedApiAbilities].yandex_enabled)
    {
        self.yandexButton.userInteractionEnabled=NO;
    }
    else
    {
        self.yandexButton.userInteractionEnabled=YES;
    }
    
     [[SingleDataProvider sharedKey]setGpsButtonHandler:self.gpsButton];
    if ([SingleDataProvider sharedKey].isGPSEnabled)
    {
        [self.gpsButton setImage:[UIImage imageNamed:@"gps_green.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [self.gpsButton setImage:[UIImage imageNamed:@"gps.png"] forState:UIControlStateNormal];
    }
    for (UIView*view in self.statisticsScrollView.subviews)
    {
        [view removeFromSuperview];
    }
   
    
    [GPSConection showGPSConection:self];
    
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];
    
    yCord=0;
    y1Cord=yCord;
 
    leftMenu=[LeftMenu getLeftMenu:self];
    [self requestGetInfo];
    titleLabelArray=[[NSMutableArray alloc]init];
    textsLabelArray=[[NSMutableArray alloc]init];
     self.statisticsScrollView.userInteractionEnabled=YES;
    


   
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
-(void)requestGetInfo
{
    UIActivityIndicatorView*indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    GetInfoJson* getInfoJsonObject=[[GetInfoJson alloc]init];
    
    NSDictionary*jsonDictionary=[getInfoJsonObject toDictionary];
    NSString*jsons=[getInfoJsonObject toJSONString];
    NSLog(@"%@",jsons);
    NSURL* url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"api_url"]];
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
    request.timeoutInterval = 30;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:@"Нет соединения с интернетом!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            

            [indicator stopAnimating];
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"GetInfoResponseString:%@",jsonString);
        NSError*err;
        getInfoResponseObject = [[GetInfoResponse alloc] initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:getInfoResponseObject.text code:getInfoResponseObject.code];
        
        
//        if(getInfoResponseObject.code!=nil)
//        {
//       
//            
//            
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:getInfoResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action)
//                                    {
//                                        [alert dismissViewControllerAnimated:YES completion:nil];
//                                        
//                                    }];
//            [alert addAction:cancel];
//            [self presentViewController:alert animated:YES completion:nil];
//            
//
//     
//            [indicator stopAnimating];
//        }
        [indicator stopAnimating];
       
        for (int i=0;i<getInfoResponseObject.info.count; i++)
        {
            UILabel*titleLabel=[[UILabel alloc]init];
            titleLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
            titleLabel.textColor=[UIColor orangeColor];
            titleLabel.textAlignment=NSTextAlignmentCenter;
            titleLabel.numberOfLines = 0;
            titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            titleLabel.text=[[getInfoResponseObject.info objectAtIndex:i]getTitle];
            CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width-50,600);
            CGSize expectSizeFortitleLabel = [titleLabel sizeThatFits:maximumLabelSize];
           
            y1Cord=yCord+expectSizeFortitleLabel.height/2;
            CGPoint x=self.view.center;
            x=CGPointMake(x.x-10, y1Cord);
            titleLabel.frame=CGRectMake(0, yCord, expectSizeFortitleLabel.width, expectSizeFortitleLabel.height);
            titleLabel.center=x;
            [self.statisticsScrollView addSubview:titleLabel];
            yCord=yCord+expectSizeFortitleLabel.height+10;
            CGSize newContentSize={self.view.frame.size.width-20,yCord};
          
            self.statisticsScrollView.contentSize=newContentSize;
            [titleLabelArray addObject:titleLabel];
            for (int j=0;j<[[[getInfoResponseObject.info objectAtIndex:i] texts]count]; j++)
            {
                UILabel*textsLabel=[[UILabel alloc]init];
                textsLabel.numberOfLines = 0;
                textsLabel.lineBreakMode = NSLineBreakByWordWrapping;
                textsLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
                textsLabel.text=[[[getInfoResponseObject.info objectAtIndex:i]texts]objectAtIndex:j];
                CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width-20,100);
                CGSize expectSizeFortitleLabel = [textsLabel sizeThatFits:maximumLabelSize];
                textsLabel.frame=CGRectMake(0, yCord, expectSizeFortitleLabel.width, expectSizeFortitleLabel.height);
                [self.statisticsScrollView addSubview:textsLabel];
                yCord=yCord+expectSizeFortitleLabel.height;
                CGSize newContentSize={self.view.frame.size.width-20,yCord};
                self.statisticsScrollView.contentSize=newContentSize;
                [textsLabelArray addObject:textsLabel];

            }
            yCord=yCord+10;
           
        }
        
       
        
 }];
    
}

- (IBAction)openAndCloseLeftMenu:(UIButton *)sender
{
    [UIView animateWithDuration:0.2
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
             self.statisticsScrollView.userInteractionEnabled=NO;
             
             self.statisticsScrollView.tag=1;
             
             [leftMenu.disabledViewsArray removeAllObjects];
             
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.statisticsScrollView.tag]];
         }
         else
         {
             self.statisticsScrollView.userInteractionEnabled=YES;
             leftMenu.flag=0;
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
             self.statisticsScrollView.userInteractionEnabled=YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             leftMenu.flag=1;
             self.statisticsScrollView.userInteractionEnabled=NO;
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
    leftMenu.flag=1;
    self.statisticsScrollView.userInteractionEnabled=NO;
}


- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:nil
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
                            
        yCord=0;
        for (int i=0,k=0;i<getInfoResponseObject.info.count; i++)
                   {
                                 UILabel*label1=[titleLabelArray objectAtIndex:i];
                       
                                 CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width-20,600);
                                 CGSize expectSizeFortitleLabel = [label1 sizeThatFits:maximumLabelSize];
                                 
                                 y1Cord=yCord+expectSizeFortitleLabel.height/2;
                                 CGPoint x=self.view.center;
                                 x=CGPointMake(x.x-10, y1Cord);
                                 label1.frame=CGRectMake(0, yCord, expectSizeFortitleLabel.width, expectSizeFortitleLabel.height);
                                 label1.center=x;
                       
                                 yCord=yCord+expectSizeFortitleLabel.height+10;
                                 CGSize newContentSize={self.view.frame.size.width-20,yCord};
                                 
                                 self.statisticsScrollView.contentSize=newContentSize;


                             
                                 for (int j=0;j<[[[getInfoResponseObject.info objectAtIndex:i] texts]count];j++,k++)
                          {
                             
                              UILabel*label2=[[UILabel alloc]init];
                              label2=[textsLabelArray objectAtIndex:k];
                             
                              CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width-20,100);
                              CGSize expectSizeFortitleLabel = [label2 sizeThatFits:maximumLabelSize];
                              label2.frame=CGRectMake(0, yCord, expectSizeFortitleLabel.width, expectSizeFortitleLabel.height);
                              yCord=yCord+expectSizeFortitleLabel.height;
                              CGSize newContentSize={self.view.frame.size.width-20,yCord};
                              self.statisticsScrollView.contentSize=newContentSize;

                          }
                         yCord=yCord+10;
                    }
                                     CGFloat xx;
                                     
                                     if(leftMenu.flag==0)
                                     {
                                         xx=320*(CGFloat)5/6*(-1);
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
