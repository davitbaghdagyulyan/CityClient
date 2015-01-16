//
//  TakenOrderViewController.m
//  CityMobilDriver
//
//  Created by Intern on 11/13/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "TakenOrderViewController.h"
#import "LeftMenu.h"
#import "GetOrderJson.h"
#import "GetOrderResponse.h"
#import "LabelUnderLine.h"
#import "CustomViewForMaps.h"
#import "SetStatusJson.h"
#import "SetStatusResponse.h"
#import "MyOrdersViewController.h"
#import "TachometerViewController.h"
#import "SingleDataProvider.h"
#import "OpenMapButtonHandler.h"

@interface TakenOrderViewController ()

{
     OpenMapButtonHandler*openMapButtonHandlerObject;
    LeftMenu*leftMenu;
   
    GetOrderResponse*getOrderResponseObject;
    GetOrderJson*getOrderJsonObject;
    UIView*cellUnderView;
    UILabel*blackLineLabel;
    UIView*labelView;
    NSMutableArray*buttonArray;
    NSMutableArray*buttons;
    LabelUnderLine*clientPhoneLabel;
    UIButton*refuseTheOrderButton;
    UIButton*chatWithaCustomerButton;
   UIView *contentView;
    CGFloat yCoord;
    UILabel*textLabel;
    CustomViewForMaps*viewMap;
    NSUInteger number;
    CLLocation* currentLocation;
    CLLocationManager *locationManager;
    SetStatusJson*setStatusJsonObject;
    SetStatusResponse*setStatusResponseObject;
    BOOL isRefuseTheOrderButtonPressed;
    BOOL isOnTheWayButtonPressed;
    NSInteger count;
    NSString* googleMapUrl;
    NSString* yandexMapUrl;
}

@end

@implementation TakenOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    gestureRecognizer.delegate=self;
    [self.scrollView addGestureRecognizer:gestureRecognizer];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
     [GPSConection showGPSConection:self];
     [[SingleDataProvider sharedKey]setGpsButtonHandler:self.gpsButton];
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
    setStatusJsonObject=[[SetStatusJson alloc]init];
    [self requestGetOrder];
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint velocity = [panGestureRecognizer velocityInView:self.scrollView];
    return fabs(velocity.y) < fabs(velocity.x);
}
-(void)swipeHandler:(UIPanGestureRecognizer *)sender
{
    static BOOL isMove;
    
    CGPoint touchLocation = [sender locationInView:sender.view];
    
    NSLog(@"x=%f",touchLocation.x);
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        isMove=leftMenu.flag==0 && touchLocation.x>30;
        if (isMove)
            return;
    }
    if (sender.state == UIGestureRecognizerStateChanged)
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
    if (sender.state == UIGestureRecognizerStateEnded)
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

}

-(void)setIdHash:(NSString*)idhash andUnderView:(UIView*)underView
{
    getOrderJsonObject=[[GetOrderJson alloc]init];
    getOrderJsonObject.idhash=idhash;
 
    cellUnderView=underView;
    
    count=0;
    
    
    viewMap=[[CustomViewForMaps alloc] init];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomViewForMaps" owner:self options:nil];
    viewMap = [nib objectAtIndex:0];
    
    
    viewMap.frame=self.view.frame;
    viewMap.center=self.view.center;
    
//    viewMap.smallMapView.layer.cornerRadius = 30;
//    viewMap.smallMapView.layer.borderWidth = 2;
//    viewMap.smallMapView.layer.borderColor=[UIColor clearColor].CGColor;
//    viewMap.smallMapView.layer.masksToBounds = YES;
    
    [viewMap.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *singleTapYandex =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openYandexMap)];
    [singleTapYandex setNumberOfTapsRequired:1];
    
    UITapGestureRecognizer *singleTapGoogle =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openGoogleMap)];
    [singleTapYandex setNumberOfTapsRequired:1];
    
    viewMap.yandexImageView.userInteractionEnabled=YES;
    viewMap.googleImageView.userInteractionEnabled=YES;
    [viewMap.yandexImageView addGestureRecognizer:singleTapYandex];
    [viewMap.googleImageView addGestureRecognizer:singleTapGoogle];
    
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
    [self.navigationController popViewControllerAnimated:NO];
    
}
-(void)requestGetOrder
{
        isRefuseTheOrderButtonPressed=NO;
        isOnTheWayButtonPressed=NO;
        count++;
        UIActivityIndicatorView*indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center = self.view.center;
        indicator.color=[UIColor blackColor];
        [indicator startAnimating];
        [self.view addSubview:indicator];
        
    
    
        NSDictionary*jsonDictionary=[getOrderJsonObject toDictionary];
        NSString*jsons=[getOrderJsonObject toJSONString];
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
                [indicator stopAnimating];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:@"Нет соединения с интернетом!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                            
                                         
                                        }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
               return ;
            }
            NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"responseString:%@",jsonString);
            NSError*err;
            
//            //**************************test
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"JsonString" ofType:@"txt"];
//            NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//            //***************************test
            
            getOrderResponseObject = [[GetOrderResponse alloc] initWithString:jsonString error:&err];
           
            BadRequest* badRequest = [[BadRequest alloc]init];
            badRequest.delegate = self;
            [badRequest showErrorAlertMessage:getOrderResponseObject.text code:getOrderResponseObject.code];
          

//            if(getOrderResponseObject.code!=nil)
//            {
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:getOrderResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction * action)
//                                        {
//                                            [alert dismissViewControllerAnimated:YES completion:nil];
//                                            
//                                        }];
//                [alert addAction:cancel];
//                [self presentViewController:alert animated:YES completion:nil];
//            }
//            else
//            {
                UILabel*label=(UILabel*)[cellUnderView viewWithTag:250];
                 label.font=[UIFont fontWithName:@"Roboto-Bold" size:15];
                label.text=[self TimeFormat:getOrderResponseObject.CollDate];
                label.text=[NSString stringWithFormat:@" %@ %@",label.text,getOrderResponseObject.shortname];
              if(count==1)
                [self drawPage];
                else
                    [self drawButtons];
//            }
             [indicator stopAnimating];
           
        }];
        
}
-(NSString*)TimeFormat:(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:string];
    /////////convert nsdata To NSString////////////////////////////////////
    [dateFormatter setDateFormat:@"HH:mm"];
    if(date==nil) return @"00:00";
    return [dateFormatter stringFromDate:date];
    
}
-(void)drawPage
{
    
    
    
    contentView = [[UIView alloc] init];
    [self.scrollView addSubview:contentView];
    CGFloat xCoord=0;
    
    buttonArray=[[NSMutableArray alloc]init];

    [contentView addSubview:cellUnderView];
    
    
    NSLog(@"%@",NSStringFromCGRect(cellUnderView.frame));
   
   
    
    
    
    

    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:cellUnderView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:contentView
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0]];
    
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:cellUnderView
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:cellUnderView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:contentView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    
    [cellUnderView addConstraint:[NSLayoutConstraint constraintWithItem:cellUnderView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:cellUnderView.frame.size.height]];
    
    
  
    labelView=[[UIView alloc] init];
    labelView.backgroundColor=[UIColor whiteColor];
    
    
    for (UIView*view in cellUnderView.subviews )
    {
        int i=-1;

        if([view viewWithTag:111])
        {
            i++;
            [buttonArray addObject:[view viewWithTag:61]];
            [[view viewWithTag:111] removeFromSuperview];
            
        }
        for (UIView*viewsub in view.subviews )
        {
            
            
            
            if ([viewsub isKindOfClass:[UIButton class]])
            {
                i++;
               [viewsub removeFromSuperview];
                [buttonArray addObject:viewsub];
            }
        }
        if(i==0)
        {
            UIButton*button=[buttonArray objectAtIndex:i];
        labelView.frame=CGRectMake(2,cellUnderView.frame.size.height-(i+1)*button.frame.size.height-8, self.view.frame.size.width-14, button.frame.size.height+4);
        labelView.backgroundColor=[UIColor whiteColor];
        }
        else
        {
            UIButton*button=[buttonArray objectAtIndex:i];
            labelView.frame=CGRectMake(2,cellUnderView.frame.size.height-(i+1)*button.frame.size.height-8, self.scrollView.frame.size.width-4, button.frame.size.height+4);
            labelView.backgroundColor=[UIColor whiteColor];
            cellUnderView.frame=CGRectMake(cellUnderView.frame.origin.x, cellUnderView.frame.origin.x, cellUnderView.frame.size.width, cellUnderView.frame.size.height-button.frame.size.height-8);
            [cellUnderView removeConstraint:[NSLayoutConstraint constraintWithItem:cellUnderView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeHeight
                                                                        multiplier:1.0
                                                                          constant:cellUnderView.frame.size.height]];
            
            [cellUnderView addConstraint:[NSLayoutConstraint constraintWithItem:cellUnderView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeHeight
                                                                     multiplier:1.0
                                                                       constant:cellUnderView.frame.size.height]];
        }
    }
  
    [contentView addSubview:labelView];
    blackLineLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, labelView.frame.size.width-16,1)];
    blackLineLabel.backgroundColor=[UIColor blackColor];
    
    [labelView addSubview:blackLineLabel];
    [cellUnderView updateConstraints];
    UILabel*clientLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, labelView.frame.size.height/2-12, 50, 25)];
    xCoord=60;
    clientLabel.font=[UIFont fontWithName:@"Roboto-Bold" size:12];
    clientLabel.textColor=[UIColor blackColor];
    clientLabel.text=@"Клиент:";
//    clientLabel.backgroundColor=[UIColor greenColor];
    [labelView addSubview:clientLabel];
    
   
    clientPhoneLabel=[[LabelUnderLine alloc] init];
   
    clientPhoneLabel.font=[UIFont fontWithName:@"Roboto" size:12];
    clientPhoneLabel.textColor=[UIColor blueColor];
    clientPhoneLabel.text=getOrderResponseObject.ClientPhone;
    clientPhoneLabel.numberOfLines=0;
    clientPhoneLabel.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *singlecall =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callAction)];
    [singlecall setNumberOfTapsRequired:1];
    
    


    [clientPhoneLabel addGestureRecognizer:singlecall];

    
    CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width,25);
    CGSize expectSizeForLabel = [clientPhoneLabel sizeThatFits:maximumLabelSize];
    clientPhoneLabel.frame=CGRectMake(xCoord, labelView.frame.size.height/2-12, expectSizeForLabel.width, 25);
    [labelView addSubview:clientPhoneLabel];
    xCoord=xCoord+expectSizeForLabel.width;
    
    UILabel*commaLabel=[[UILabel alloc] init];
    
    commaLabel.font=[UIFont fontWithName:@"Roboto" size:12];
    commaLabel.textColor=[UIColor blackColor];
    commaLabel.text=@",";
    commaLabel.numberOfLines=0;
    
     maximumLabelSize = CGSizeMake(self.view.frame.size.width,25);
     expectSizeForLabel = [commaLabel sizeThatFits:maximumLabelSize];
    commaLabel.frame=CGRectMake(xCoord, labelView.frame.size.height/2-10, expectSizeForLabel.width, 25);
    [labelView addSubview:commaLabel];
    

    
  xCoord=xCoord+expectSizeForLabel.width;
  
    UILabel* clientPhoneAdditionalLabel=[[UILabel alloc] init];
    if (![getOrderResponseObject.ClientPhoneAdditional isEqual:[NSNull null]])
    
    {
        
        clientPhoneAdditionalLabel.font=[UIFont fontWithName:@"Roboto" size:12];
        clientPhoneAdditionalLabel.textColor=[UIColor blackColor];
        clientPhoneAdditionalLabel.text=getOrderResponseObject.ClientPhoneAdditional;
        clientPhoneAdditionalLabel.numberOfLines=0;
        
        maximumLabelSize=CGSizeMake(self.view.frame.size.width,25);
        expectSizeForLabel = [clientPhoneAdditionalLabel sizeThatFits:maximumLabelSize];

        
        clientPhoneAdditionalLabel.frame=CGRectMake(xCoord, labelView.frame.size.height/2-12, expectSizeForLabel.width, 25);
        xCoord=xCoord+expectSizeForLabel.width;
        [labelView addSubview:clientPhoneAdditionalLabel];
        
        commaLabel.frame=CGRectMake(xCoord, labelView.frame.size.height/2-10,commaLabel.frame.size.width, 25);
        [labelView addSubview:commaLabel];
        xCoord=xCoord+expectSizeForLabel.width+5;
        

    }
    
    
    
    UILabel* clientFullNameLabel=[[UILabel alloc]init];
    
    clientFullNameLabel.font=[UIFont fontWithName:@"Roboto" size:12];
    clientFullNameLabel.textColor=[UIColor blackColor];
    clientFullNameLabel.text=getOrderResponseObject.ClientFullName;
    clientFullNameLabel.numberOfLines=0;
    maximumLabelSize=CGSizeMake(self.view.frame.size.width,25);
    expectSizeForLabel = [clientFullNameLabel sizeThatFits:maximumLabelSize];
    clientFullNameLabel.frame=CGRectMake(xCoord, labelView.frame.size.height/2-12, expectSizeForLabel.width, 25);
    [labelView addSubview:clientFullNameLabel];
   
    xCoord=xCoord+expectSizeForLabel.width+5;
    
    UILabel*clientStarsLabel=[[UILabel alloc]init];
    
    clientStarsLabel.font=[UIFont fontWithName:@"Roboto" size:12];
    clientStarsLabel.textColor=[UIColor orangeColor];
    clientStarsLabel.text=getOrderResponseObject.ClientStars;
    clientStarsLabel.numberOfLines=0;
   
    maximumLabelSize=CGSizeMake(self.view.frame.size.width,25);
    expectSizeForLabel = [clientStarsLabel sizeThatFits:maximumLabelSize];
    clientStarsLabel.frame=CGRectMake(xCoord, labelView.frame.size.height/2-16,expectSizeForLabel.width, 25);
    [labelView addSubview:clientStarsLabel];
    xCoord=xCoord+expectSizeForLabel.width+5;
    
    [self drawButtons];
    
    
}

-(void)drawButtons
{
    yCoord=labelView.frame.origin.y+labelView.frame.size.height;
    CGFloat heightForButton=40;
    if (count!=1) {
        for (UIButton*button in buttons)
        {
            [button removeFromSuperview];
        }
        [refuseTheOrderButton removeFromSuperview];
        [chatWithaCustomerButton removeFromSuperview];
    }
    
    
    buttons=[[NSMutableArray alloc]init];
    UIButton*buttonMap1=(UIButton*)[cellUnderView viewWithTag:10];
    UIButton*buttonMap2=(UIButton*)[cellUnderView viewWithTag:11];
    [buttonMap1 addTarget:self action:@selector(collMap) forControlEvents:UIControlEventTouchUpInside];
    [buttonMap2  addTarget:self action:@selector(deliveryMapp) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([getOrderResponseObject.PossibleStatuses containsObject:@"OW"])
    {
        UIButton*onTheWayButton=[[UIButton alloc] initWithFrame:CGRectMake(10, yCoord, self.scrollView.frame.size.width-20, heightForButton)];
        onTheWayButton.backgroundColor=[UIColor orangeColor];
        [onTheWayButton setTitle:@"В пути" forState:UIControlStateNormal];
        [onTheWayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contentView addSubview:onTheWayButton];
        [onTheWayButton addTarget:self action:@selector(onTheWayAction) forControlEvents:UIControlEventTouchUpInside];
        yCoord=yCoord+heightForButton+5;
        [buttons addObject:onTheWayButton];
        
    }
    
    if ([getOrderResponseObject.status isEqualToString:@"OW"])
    {
        
        
        UIButton*returnToTheTaximeterButton=[[UIButton alloc] initWithFrame:CGRectMake(10, yCoord, self.scrollView.frame.size.width-20, heightForButton)];
        returnToTheTaximeterButton.backgroundColor=[UIColor orangeColor];
        [returnToTheTaximeterButton setTitle:@"Вернуться к таксометру" forState:UIControlStateNormal];
        [returnToTheTaximeterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contentView addSubview:returnToTheTaximeterButton];
        [returnToTheTaximeterButton addTarget:self action:@selector(returnToTheTaximeterAction) forControlEvents:UIControlEventTouchUpInside];
        yCoord=yCoord+heightForButton+5;
        [buttons addObject:returnToTheTaximeterButton];
    }
    
    if ([getOrderResponseObject.PossibleStatuses containsObject:@"MV"])
    {
        UIButton*foodToTheCustomerButton=[[UIButton alloc] initWithFrame:CGRectMake(10, yCoord, self.scrollView.frame.size.width-20, heightForButton)];
        foodToTheCustomerButton.backgroundColor=[UIColor orangeColor];
        [foodToTheCustomerButton setTitle:@"Еду к клиенту" forState:UIControlStateNormal];
        [foodToTheCustomerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contentView addSubview:foodToTheCustomerButton];
        [foodToTheCustomerButton addTarget:self action:@selector(foodToTheCustomerAction) forControlEvents:UIControlEventTouchUpInside];
        yCoord=yCoord+heightForButton+5;
        [buttons addObject:foodToTheCustomerButton];
    }
    
    if ([getOrderResponseObject.PossibleStatuses containsObject:@"RC"])
    {
        UIButton*machineAccordingToAddressButton=[[UIButton alloc] initWithFrame:CGRectMake(10, yCoord, self.scrollView.frame.size.width-20, heightForButton)];
        machineAccordingToAddressButton.backgroundColor=[UIColor orangeColor];
        [machineAccordingToAddressButton setTitle:@"Машина по адресу" forState:UIControlStateNormal];
        [machineAccordingToAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contentView addSubview:machineAccordingToAddressButton];
        [machineAccordingToAddressButton addTarget:self action:@selector(machineAccordingToAddressAction) forControlEvents:UIControlEventTouchUpInside];
        yCoord=yCoord+heightForButton+5;
        [buttons addObject:machineAccordingToAddressButton];
    }
    
    if ([getOrderResponseObject.PossibleStatuses containsObject:@"FS"])
    {
        UIButton*willBeIn5MinutesButton=[[UIButton alloc] initWithFrame:CGRectMake(10, yCoord, self.scrollView.frame.size.width-20, heightForButton)];
        willBeIn5MinutesButton.backgroundColor=[UIColor lightGrayColor];
        [willBeIn5MinutesButton setTitle:@"Буду через 5 минут" forState:UIControlStateNormal];
        [willBeIn5MinutesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contentView addSubview:willBeIn5MinutesButton];
        [willBeIn5MinutesButton addTarget:self action:@selector(willBeIn5MinutesAction) forControlEvents:UIControlEventTouchUpInside];
        yCoord=yCoord+heightForButton+5;
        [buttons addObject:willBeIn5MinutesButton];
    }
    
    if ([getOrderResponseObject.PossibleStatuses containsObject:@"RFS"])
    {
        UIButton*DoNotHaveTimeTo5MinutesButton=[[UIButton alloc] initWithFrame:CGRectMake(10, yCoord, self.scrollView.frame.size.width-20, heightForButton)];
        DoNotHaveTimeTo5MinutesButton.backgroundColor=[UIColor lightGrayColor];
        [DoNotHaveTimeTo5MinutesButton setTitle:@"Не успеваю через 5 минут" forState:UIControlStateNormal];
        [DoNotHaveTimeTo5MinutesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contentView addSubview:DoNotHaveTimeTo5MinutesButton];
        [DoNotHaveTimeTo5MinutesButton addTarget:self action:@selector(DoNotHaveTimeTo5MinutesAction) forControlEvents:UIControlEventTouchUpInside];
        yCoord=yCoord+heightForButton+5;
        [buttons addObject:DoNotHaveTimeTo5MinutesButton];
    }
    
    if ([getOrderResponseObject.PossibleStatuses containsObject:@"HD"])
    {
        UIButton*safetyNetButton=[[UIButton alloc] initWithFrame:CGRectMake(10, yCoord, self.scrollView.frame.size.width-20, heightForButton)];
        safetyNetButton.backgroundColor=[UIColor grayColor];
        [safetyNetButton setTitle:@"Подстраховка" forState:UIControlStateNormal];
        [safetyNetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contentView addSubview:safetyNetButton];
        [safetyNetButton addTarget:self action:@selector(safetyNetAction) forControlEvents:UIControlEventTouchUpInside];
        yCoord=yCoord+heightForButton+5;
        [buttons addObject:safetyNetButton];
    }
    
    if ([getOrderResponseObject.PossibleStatuses containsObject:@"RHD"])
    {
        UIButton*removeFromHedgingButton=[[UIButton alloc] initWithFrame:CGRectMake(10, yCoord, self.scrollView.frame.size.width-20, heightForButton)];
        removeFromHedgingButton.backgroundColor=[UIColor grayColor];
        [removeFromHedgingButton setTitle:@"Снять с подстраховки" forState:UIControlStateNormal];
        [removeFromHedgingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contentView addSubview:removeFromHedgingButton];
        [removeFromHedgingButton addTarget:self action:@selector(removeFromHedgingAction) forControlEvents:UIControlEventTouchUpInside];
        yCoord=yCoord+heightForButton+5;
        [buttons addObject:removeFromHedgingButton];
    }
    
    if ([getOrderResponseObject.PossibleStatuses containsObject:@"RJ"])
    {
        refuseTheOrderButton=[[UIButton alloc] initWithFrame:CGRectMake(10, yCoord, self.scrollView.frame.size.width/2-15, heightForButton+10)];
        refuseTheOrderButton.titleLabel. numberOfLines = 0;
        refuseTheOrderButton.titleLabel.lineBreakMode = 0;
        refuseTheOrderButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        refuseTheOrderButton.backgroundColor=[UIColor lightGrayColor];
        [refuseTheOrderButton setTitle:@"Отказаться от заказа" forState:UIControlStateNormal];
        [refuseTheOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contentView addSubview:refuseTheOrderButton];
        [refuseTheOrderButton addTarget:self action:@selector(refuseTheOrderAction) forControlEvents:UIControlEventTouchUpInside];
        
        
     
        
        UIImageView*chatImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 12, 32, 26)];
        chatImageView.image=[UIImage imageNamed:@"chat1.png"];
        
        chatWithaCustomerButton=[[UIButton alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width/2+5, yCoord, self.scrollView.frame.size.width/2-15, heightForButton+10)];
        textLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, chatWithaCustomerButton.frame.size.width-40, chatWithaCustomerButton.frame.size.height)];
        chatWithaCustomerButton.backgroundColor=[UIColor grayColor];
        textLabel. numberOfLines = 0;
        textLabel.lineBreakMode = 0;
        [chatWithaCustomerButton addSubview:chatImageView];
        textLabel.textAlignment=NSTextAlignmentCenter;
        textLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:18];
        textLabel.text=@"Чат с клиентом";
        textLabel.textColor=[UIColor whiteColor];
        [chatWithaCustomerButton addSubview:textLabel];
        [contentView addSubview:chatWithaCustomerButton];
        [chatWithaCustomerButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        yCoord=yCoord+heightForButton+10+5;
        
       
        
    }
    else
    {
        UIImageView*chatImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 8, 32, 26)];
        chatImageView.image=[UIImage imageNamed:@"chat1.png"];
        
        chatWithaCustomerButton=[[UIButton alloc] initWithFrame:CGRectMake(10, yCoord, self.scrollView.frame.size.width-20, heightForButton)];
        
       
        
        textLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, chatWithaCustomerButton.frame.size.width-40, chatWithaCustomerButton.frame.size.height)];
        chatWithaCustomerButton.backgroundColor=[UIColor grayColor];
        textLabel. numberOfLines = 0;
        textLabel.lineBreakMode = 0;
        [chatWithaCustomerButton addSubview:chatImageView];
        textLabel.textAlignment=NSTextAlignmentCenter;
        textLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:18];
        textLabel.text=@"Чат с клиентом";
        textLabel.textColor=[UIColor whiteColor];
        [chatWithaCustomerButton addSubview:textLabel];
        [contentView addSubview:chatWithaCustomerButton];
        [chatWithaCustomerButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        yCoord=yCoord+heightForButton+5;
        
         [buttons addObject:chatWithaCustomerButton];

    }
    self.scrollView.contentSize=CGSizeMake(self.view.frame.size.width-10, yCoord);
    contentView.frame=CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    
    setStatusJsonObject.lat=getOrderResponseObject.latitude;
    setStatusJsonObject.lon=getOrderResponseObject.longitude;
    setStatusJsonObject.idhash=getOrderResponseObject.idhash;

}
-(void)requestSetStatus
{
    setStatusJsonObject.time=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].time];
    setStatusJsonObject.direction=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].direction];
    setStatusJsonObject.speed=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].speed];

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
        
     
        
        setStatusResponseObject = [[SetStatusResponse alloc] initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:getOrderResponseObject.text code:getOrderResponseObject.code];
        
        
        
//        if(setStatusResponseObject.code!=nil)
//        {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:setStatusResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
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
//        }
        if ([setStatusResponseObject.result isEqualToString:@"1"])
        {
            if(isRefuseTheOrderButtonPressed)
            {
                MyOrdersViewController* movc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrdersViewController"];
                [self.navigationController pushViewController:movc animated:NO];
            }
            else if(isOnTheWayButtonPressed)
            {
                TachometerViewController* tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TachometerViewController"];
                [self.navigationController pushViewController:tvc animated:NO];
                 tvc.payment_method=self.payment_method;
                ////Karen change////
                
                tvc.orderResponse = getOrderResponseObject;
                //// end Karen change ////
            }
            else
            {
                [self requestGetOrder];
            }
        }
         [indicator stopAnimating];
    }];
}
-(void)machineAccordingToAddressAction
{
    setStatusJsonObject.status=@"RC";
    [self requestSetStatus];
 
    
}

-(void)onTheWayAction
{
    setStatusJsonObject.status=@"OW";
    isOnTheWayButtonPressed=YES;
    [self requestSetStatus];
}

-(void)returnToTheTaximeterAction
{
    TachometerViewController* tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TachometerViewController"];
    [self.navigationController pushViewController:tvc animated:NO];
    ////Karen change////
    tvc.orderResponse = getOrderResponseObject;
    tvc.payment_method=self.payment_method;
    //// end Karen change ////
}

-(void)foodToTheCustomerAction
{
    setStatusJsonObject.status=@"MV";
    [self requestSetStatus];
}

-(void)willBeIn5MinutesAction
{
     setStatusJsonObject.status=@"FS";
    [self requestSetStatus];
    
}

-(void)DoNotHaveTimeTo5MinutesAction
{
     setStatusJsonObject.status=@"RFS";
    [self requestSetStatus];
}

-(void)safetyNetAction
{
     setStatusJsonObject.status=@"HD";
    [self requestSetStatus];
}

-(void)removeFromHedgingAction
{
     setStatusJsonObject.status=@"RHD";
    [self requestSetStatus];
}

-(void)refuseTheOrderAction
{
   isRefuseTheOrderButtonPressed=YES;
    setStatusJsonObject.status=@"RJ";
    [self requestSetStatus];
}
#pragma mark-viewMap functions

- (IBAction)openMap:(UIButton*)sender
{
  openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
}


-(void)collMap
{
    [self.view addSubview:viewMap];
    viewMap.smallMapView.transform = CGAffineTransformMakeScale(0,0);
    number=0;
    googleMapUrl=[NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f&directionsmode=driving",
                  [SingleDataProvider sharedKey].lat,
                  [SingleDataProvider sharedKey].lon,
                  [getOrderResponseObject.latitude doubleValue],
                  [getOrderResponseObject.del_longitude doubleValue]];
    
    yandexMapUrl=[NSString stringWithFormat:@"yandexnavi://build_route_on_map?lat_from=%f&lon_from=%f&lat_to=%f&lon_to=%f",
                  [SingleDataProvider sharedKey].lat,
                  [SingleDataProvider sharedKey].lon,
                  [getOrderResponseObject.latitude doubleValue],
                  [getOrderResponseObject.del_longitude doubleValue]];

    [self animation];
}

-(void)deliveryMapp
{
    [self.view addSubview:viewMap];
    viewMap.smallMapView.transform = CGAffineTransformMakeScale(0,0);
    number=1;
    googleMapUrl=[NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f&directionsmode=driving",
                  [getOrderResponseObject.latitude doubleValue],
                  [getOrderResponseObject.longitude doubleValue],
                  [getOrderResponseObject.del_latitude doubleValue],
                  [getOrderResponseObject.del_longitude doubleValue]];
    
    yandexMapUrl=[NSString stringWithFormat:@"yandexnavi://build_route_on_map?lat_from=%f&lon_from=%f&lat_to=%f&lon_to=%f",  [getOrderResponseObject.latitude doubleValue],
                  [getOrderResponseObject.longitude doubleValue],
                  [getOrderResponseObject.del_latitude doubleValue],
                  [getOrderResponseObject.del_longitude doubleValue]];
    [self animation];
}
-(void)close
{
    [viewMap removeFromSuperview];
}

-(void)openYandexMap
{
    
    if (number)
    {
        NSString* urlStr= yandexMapUrl;
        NSURL* naviURL = [NSURL URLWithString:urlStr];
        NSLog(@"urlStr=%@",urlStr);
        if ([[UIApplication sharedApplication] canOpenURL:naviURL]) {
            // Если Навигатор установлен - открываем его
            [[UIApplication sharedApplication] openURL:naviURL];
        } else {
            // Если не установлен - открываем страницу в App Store
            NSURL* appStoreURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/yandex.navigator/id474500851?mt=8"];
            [[UIApplication sharedApplication] openURL:appStoreURL];
            
        }
        
    }
    else
    {
        NSString* urlStr=  yandexMapUrl;
        NSURL* naviURL = [NSURL URLWithString:urlStr];
        NSLog(@"urlStr=%@",urlStr);
        if ([[UIApplication sharedApplication] canOpenURL:naviURL]) {
            // Если Навигатор установлен - открываем его
            [[UIApplication sharedApplication] openURL:naviURL];
        } else {
            // Если не установлен - открываем страницу в App Store
            NSURL* appStoreURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/yandex.navigator/id474500851?mt=8"];
            [[UIApplication sharedApplication] openURL:appStoreURL];
        }
        
    }
}
-(void)openGoogleMap
{
    if (number)
    {
        NSString* urlStr= googleMapUrl;
        NSURL* naviURL = [NSURL URLWithString:urlStr];
        NSLog(@"urlStr=%@",urlStr);
        if ([[UIApplication sharedApplication] canOpenURL:naviURL]) {
            // Если Навигатор установлен - открываем его
            [[UIApplication sharedApplication] openURL:naviURL];
        } else {
            // Если не установлен - открываем страницу в App Store
            NSURL* appStoreURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/google-maps/id585027354?mt=8"];
            [[UIApplication sharedApplication] openURL:appStoreURL];
        }
        
    }
    else
    {
        NSString* urlStr=  googleMapUrl;
        NSURL* naviURL = [NSURL URLWithString:urlStr];
        NSLog(@"urlStr=%@",urlStr);
        if ([[UIApplication sharedApplication] canOpenURL:naviURL]) {
            // Если Навигатор установлен - открываем его
            [[UIApplication sharedApplication] openURL:naviURL];
        } else {
            // Если не установлен - открываем страницу в App Store
            NSURL* appStoreURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/google-maps/id585027354?mt=8"];
            [[UIApplication sharedApplication] openURL:appStoreURL];
        }
        
        
    }
}

-(void)animation
{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: 0
                     animations:^(void)
     {
         viewMap.smallMapView.transform = CGAffineTransformIdentity;
     }
                     completion:nil];
}


-(void)callAction
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] )
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"tel:",clientPhoneLabel.text]]];
    }
    
    
    else
    {
        
        
      
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка" message:@"Your device doesn't support this feature."preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];

    }

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
             self.scrollView.userInteractionEnabled=NO;
             
             self.scrollView.tag=1;
             [leftMenu.disabledViewsArray removeAllObjects];
          
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.scrollView.tag]];
         }
         else
         {
             self.scrollView.userInteractionEnabled=YES;
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
             self.scrollView.userInteractionEnabled=YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             leftMenu.flag=1;
             self.scrollView.userInteractionEnabled=NO;
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
    self.scrollView.userInteractionEnabled=NO;
}



- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:nil
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
          self.scrollView.contentSize=CGSizeMake(self.view.frame.size.width-10, yCoord);
          contentView.frame=CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
         
         labelView.frame=CGRectMake(labelView.frame.origin.x,labelView.frame.origin.y, self.view.frame.size.width-14, labelView.frame.size.height);
          blackLineLabel.frame=CGRectMake(10, 0, labelView.frame.size.width-16,1);
         
         for(UIButton*button in buttons)
         {
             button.frame=CGRectMake(button.frame.origin.x, button.frame.origin.y, self.scrollView.frame.size.width-20, button.frame.size.height);
         }
       if ([getOrderResponseObject.PossibleStatuses containsObject:@"RJ"])
       {
       chatWithaCustomerButton.frame=CGRectMake(self.scrollView.frame.size.width/2+5, chatWithaCustomerButton.frame.origin.y, self.scrollView.frame.size.width/2-15, chatWithaCustomerButton.frame.size.height);
          textLabel.frame=CGRectMake(25, 0, chatWithaCustomerButton.frame.size.width-40, chatWithaCustomerButton.frame.size.height);
          
        refuseTheOrderButton.frame=CGRectMake(10, refuseTheOrderButton.frame.origin.y, self.scrollView.frame.size.width/2-15, refuseTheOrderButton.frame.size.height);
       }
       else
       {
           CGPoint point=CGPointMake(chatWithaCustomerButton.center.x, textLabel.center.y);
           textLabel.center=point;
       }
         viewMap.frame=self.view.frame;
         viewMap.center=self.view.center;
         
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
@end
