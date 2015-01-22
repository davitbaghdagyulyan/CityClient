//
//  IncomingOrderViewController.m
//  CityMobilDriver
//
//  Created by Intern on 1/19/15.
//  Copyright (c) 2015 Davit Baghdagyulyan. All rights reserved.
//

#import "IncomingOrderViewController.h"
#import "AssignOrderJson.h"
#import "AssignOrderResponse.h"
#import "TakenOrderViewController.h"
#import "SetStatusJson.h"
#import "SetStatusResponse.h"
#import "LeftMenu.h"

#import "SingleDataProvider.h"
#import "OpenMapButtonHandler.h"

@interface IncomingOrderViewController ()
{
    NSUInteger time;
    OpenMapButtonHandler*openMapButtonHandlerObject;
    LeftMenu*leftMenu;
}
@end

@implementation IncomingOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:@"alarm" ofType:@"mp3"];
    NSURL *pathAsURL = [[NSURL alloc] initFileURLWithPath:audioFilePath];
    
//    // Init the audio player.
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:pathAsURL error:&error];
    [self.player play];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    [[SingleDataProvider sharedKey]setGpsButtonHandler:self.gpsButton];
    [GPSConection showGPSConection:self];
    if ([SingleDataProvider sharedKey].isGPSEnabled)
    {
        [self.gpsButton setImage:[UIImage imageNamed:@"gps_green.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [self.gpsButton setImage:[UIImage imageNamed:@"gps.png"] forState:UIControlStateNormal];
    }
    
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];
    leftMenu=[LeftMenu getLeftMenu:self];
    
    time=11;
    [self addCommentAction];
    [self drowPage];
    if ([self.order.canReject intValue]==1)
    {
        self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeDecrement) userInfo:nil repeats:YES];
    }
    else
        [self requestAssignOrder];
    
}

-(void)requestAssignOrder
{
    UIActivityIndicatorView*indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    AssignOrderJson* assignOrderJsonObject=[[AssignOrderJson alloc]init];
    assignOrderJsonObject.idhash=self.order.idhash;
    if (time==0)
    {
        assignOrderJsonObject.manualaction=@"none";
    }
    else if  (time!=0 && time<11)
    {
        assignOrderJsonObject.manualaction=@"accept";
    }
//    else
//    {
//        assignOrderJsonObject.manualaction=@"";
//    }
    
    NSDictionary*jsonDictionary=[assignOrderJsonObject toDictionary];
    NSString*jsons=[assignOrderJsonObject toJSONString];
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
    request.timeoutInterval = 30;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@ "Нет соединения с интернетом!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                          }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            [indicator stopAnimating];
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",jsonString);
        NSError*err;
        AssignOrderResponse*assignOrderResponseObject = [[AssignOrderResponse alloc] initWithString:jsonString error:&err];
        
        NSLog(@"result=%@",assignOrderResponseObject.result);
        
        
        if(assignOrderResponseObject.code!=nil)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:
                                        [NSString stringWithFormat:@"%@\n%@",assignOrderResponseObject.text,assignOrderResponseObject.desc]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        [self.navigationController popToRootViewControllerAnimated:NO];
                                        
                                    }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
            [indicator stopAnimating];
        }
        else
        {
            
            for (id controller in self.navigationController.viewControllers)
            {
                if ([controller isKindOfClass:[TakenOrderViewController class]])
                {
                    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                    [allViewControllers removeObjectIdenticalTo:controller];
                    self.navigationController.viewControllers = allViewControllers;
                     break;
                }
            }
           
            TakenOrderViewController* tovc = [self.storyboard instantiateViewControllerWithIdentifier:@"TakenOrderViewController"];
            tovc.idhash=self.order.idhash;
            [self.navigationController pushViewController:tovc animated:NO];
            
            
            [indicator stopAnimating];
            
        }
        
    }];
    
}

-(void)addCommentAction
{
    if (!(self.order.OrderComment==nil ||([self.order.OrderComment isEqualToString:@""])))
    {
        self.orderCommentLabel=[[UILabel alloc]init];
        self.orderCommentLabel.font = [UIFont fontWithName:@"Roboto-LightItalic" size:15];
        self.orderCommentLabel.textColor=[UIColor blackColor];
        self.orderCommentLabel.textAlignment=NSTextAlignmentCenter;
        self.orderCommentLabel.numberOfLines = 0;
        self.orderCommentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.orderCommentLabel.text=self.order.OrderComment;
        self.orderCommentLabel.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f];
        CGSize maximumLabelSize = CGSizeMake(self.self.whiteView.frame.size.width-20,600);
        CGSize expectSizeFortitleLabel = [self.orderCommentLabel sizeThatFits:maximumLabelSize];
        //expectSizeFortitleLabel.height=20;
        //expectSizeFortitleLabel.width=self.whiteView.frame.size.
        
        
        
        
        
        self.whiteView.translatesAutoresizingMaskIntoConstraints=NO;
        self.orderCommentLabel.translatesAutoresizingMaskIntoConstraints=NO;
        self.deliveryAdressText .translatesAutoresizingMaskIntoConstraints=NO;
        self.line1View.translatesAutoresizingMaskIntoConstraints=NO;
        
        self.orangeView.frame=CGRectMake(self.orangeView.frame.origin.x, self.orangeView.frame.origin.y, self.orangeView.bounds.size.width, self.orangeView.frame.size.height+expectSizeFortitleLabel.height+15);
        
        self.orangeView.translatesAutoresizingMaskIntoConstraints=YES;
        [self.orangeView updateConstraints];
        [self.whiteView addSubview:self.orderCommentLabel];
        
        [self.whiteView addConstraint:[NSLayoutConstraint constraintWithItem:self.orderCommentLabel
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.whiteView
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1
                                                                    constant:10]];
        
        
        [self.whiteView addConstraint:[NSLayoutConstraint constraintWithItem:self.orderCommentLabel
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.deliveryAdressText                                                                        attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0
                                                                    constant:5]];
        
        
        [self.whiteView addConstraint:[NSLayoutConstraint constraintWithItem:self.orderCommentLabel
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.whiteView
                                                                   attribute:NSLayoutAttributeTrailing
                                                                  multiplier:1.0
                                                                    constant:-10]];
        
        [self.whiteView addConstraint:[NSLayoutConstraint constraintWithItem:self.orderCommentLabel
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.line1View
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0
                                                                    constant:-5]];
        
        
        
        [self.orderCommentLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.orderCommentLabel
                                                                      attribute: NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute: NSLayoutAttributeHeight
                                                                     multiplier:1.0
                                                                       constant:expectSizeFortitleLabel.height+5]];
        
    }

}


-(void)drowPage
{
    self.deliveryAdressText.text=self.order.DeliveryAddressText;
    self.collAdressTextLabel.text=self.order.CollAddressText;
    self.shortNameAndTimeLabel.text=[NSString stringWithFormat:@"%@ %@",self.order.CollTime,self.order.shortname];
    self.dinamicTimeLabel.text=[NSString stringWithFormat:@"%d",(int)time];
    
}
-(void)timeDecrement
{
    time--;
    self.dinamicTimeLabel.text=[NSString stringWithFormat:@"%d",(int)time];
    if (time==0)
    {
        [self.timer invalidate];
        [self requestAssignOrder];
    }
    
}

- (IBAction)acceptAction:(UIButton *)sender
{
    if (time!=0 && time<11)
    {
        [self.timer invalidate];
        [self requestAssignOrder];
    }
}

- (IBAction)ToRefuseAction:(UIButton *)sender
{
    if (time!=0 && time<11)
    {
        
        [self requestSetStatus];
    }

}
-(void)requestSetStatus
{
    SetStatusJson*setStatusJsonObject=[[SetStatusJson alloc] init];
    setStatusJsonObject.time=[NSString stringWithFormat:@"%d",(int )time];
    setStatusJsonObject.idhash=self.order.idhash;
    setStatusJsonObject.status=@"RJ";
//    setStatusJsonObject.direction=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].direction];
//    setStatusJsonObject.speed=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].speed];
    
    UIActivityIndicatorView*indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    NSDictionary*jsonDictionary=[setStatusJsonObject toDictionary];
    NSString*jsons=[setStatusJsonObject toJSONString];
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
    request.timeoutInterval = 30;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:@"Нет соединения с интернетом!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        [indicator stopAnimating];
                                        return ;
                                    }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",jsonString);
        NSError*err;
        
        
        
        SetStatusResponse*setStatusResponseObject = [[SetStatusResponse alloc] initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:setStatusResponseObject.text code:setStatusResponseObject.code];
        
        if ([setStatusResponseObject.result isEqualToString:@"1"])
        {
            [self.navigationController popToRootViewControllerAnimated:NO];
            [self.timer invalidate];
        }
        [indicator stopAnimating];
    }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.player stop];
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
             self.contentView.userInteractionEnabled=NO;
             
             self.contentView.tag=1;
             [leftMenu.disabledViewsArray removeAllObjects];
             
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.contentView.tag]];
         }
         else
         {
             self.contentView.userInteractionEnabled=YES;
             leftMenu.flag=0;
         }
         
     }
     ];

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
- (IBAction)openMap:(UIButton*)sender
{
    openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
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
             self.contentView.userInteractionEnabled=YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             leftMenu.flag=1;
             self.contentView.userInteractionEnabled=NO;
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
    self.contentView.userInteractionEnabled=NO;
}

@end
