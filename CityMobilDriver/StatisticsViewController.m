//
//  StatisticsViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "StatisticsViewController.h"
#import "LeftMenu.h"

@interface StatisticsViewController ()
{
    LeftMenu*leftMenu;
    NSInteger flag;
    GetInfoResponse*getInfoResponseObject;
    CGFloat yCord,y1Cord;
    NSMutableArray*titleLabelArray;
    NSMutableArray*textsLabelArray;
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
    yCord=0;
    y1Cord=yCord;
    flag=0;
    leftMenu=[LeftMenu getLeftMenu:self];
    [self requestGetInfo];
    titleLabelArray=[[NSMutableArray alloc]init];
    textsLabelArray=[[NSMutableArray alloc]init];
     self.statisticsScrollView.userInteractionEnabled=YES;
   
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
        
        
        
        
        if(getInfoResponseObject.code!=nil)
        {
       
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:getInfoResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            

     
            [indicator stopAnimating];
        }
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
             self.statisticsScrollView.userInteractionEnabled=NO;
         }
         else
         {
             self.statisticsScrollView.userInteractionEnabled=YES;
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
             self.statisticsScrollView.userInteractionEnabled=YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             flag=1;
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
