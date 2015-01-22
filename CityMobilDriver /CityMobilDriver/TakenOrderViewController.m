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
    NSString * deviceType;
    NSString *deviceStringIphone;
    NSString *deviceStringIphoneSimulator;
    NSString * NoSmoking;
    NSString * G_Width;
    NSString * payment_method;
    NSString * conditioner;
    NSString * animal;
    NSString * need_WiFi;
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
    deviceType= [UIDevice currentDevice].model;
    deviceStringIphone=@"iPhone";
    deviceStringIphoneSimulator=@"iPhone Simulator";
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
          


              if(getOrderResponseObject.code==nil)
              {
                [self drawPage];
              }
            
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
    self.phoneLabel.text=getOrderResponseObject.ClientPhone;
    self.phoneLabel.numberOfLines=0;
    self.phoneLabel.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *singlecall =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callAction)];
    [singlecall setNumberOfTapsRequired:1];
    [self.phoneLabel addGestureRecognizer:singlecall];

    self.klientNameLabel.text=getOrderResponseObject.ClientFullName;
    self.klientNameLabel.numberOfLines=0;
    

    
   self.asteriskLabel.text=getOrderResponseObject.ClientStars;
   self.asteriskLabel.numberOfLines=0;
   self.shortNameLabel.text=[NSString stringWithFormat:@"%@ %@",[self TimeFormat:getOrderResponseObject.CollDate],getOrderResponseObject.shortname];

    
    //arus changes///
    //Updating Constraints
    float heightOrange=2+25+1+50+1+100+1+45;
    self.orangeView.translatesAutoresizingMaskIntoConstraints=NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.contentView removeConstraint:[self.contentView.constraints objectAtIndex:0]];
    NSLayoutConstraint * orangeViewHeight;
    orangeViewHeight =[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.f constant:heightOrange
    ];
    [self.contentView addConstraint:orangeViewHeight];
   
    //VIEW1
    self.view1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view1 removeConstraint:[self.view1.constraints objectAtIndex:0]];
     NSLayoutConstraint * view11Height;
     view11Height =[NSLayoutConstraint constraintWithItem:self.view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.whiteView attribute:NSLayoutAttributeHeight multiplier:0.f constant:25                   ];
    [self.view1 addConstraint:view11Height];
    self.percentLabel.text=[NSString stringWithFormat:@"%ld%%",(long)getOrderResponseObject.percent];
    //[self addImages:self.view1  withLabel:self.percentLabel];
    
    //VIEW2
    self.view2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view2 removeConstraint:[self.view2.constraints objectAtIndex:0]];
    
    NSLayoutConstraint * view22Height;
    view22Height =[NSLayoutConstraint constraintWithItem:self.view2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.whiteView attribute:NSLayoutAttributeHeight multiplier:0.f constant:50
                   ];
    [self.view2 addConstraint:view22Height];
    //VIEW3
    self.view3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view3 removeConstraint:[self.view3.constraints objectAtIndex:0]];
    NSLayoutConstraint * view33Height;
     view33Height =[NSLayoutConstraint constraintWithItem:self.view3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.whiteView attribute:NSLayoutAttributeHeight multiplier:0.f constant:100];
    view33Height.priority=250;
    [self.whiteView addConstraint:view33Height];

    
//    //end Arus changes///
   
    //[self drawButtons];
    
    
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
    //self.orangeView.translatesAutoresizingMaskIntoConstraints=YES;
   // self.contentView.translatesAutoresizingMaskIntoConstraints=YES;
    [coordinator animateAlongsideTransition:nil
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
         //self.contentView.translatesAutoresizingMaskIntoConstraints=NO;
           //self.contentView.frame=self.orangeView.frame;
      
        
         //[self.contentView updateConstraints];
         
//         self.scrollView.contentSize=CGSizeMake(self.view.frame.size.width-10, yCoord);
//          contentView.frame=CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
//         
//         labelView.frame=CGRectMake(labelView.frame.origin.x,labelView.frame.origin.y, self.view.frame.size.width-14, labelView.frame.size.height);
//          blackLineLabel.frame=CGRectMake(10, 0, labelView.frame.size.width-16,1);
         
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
- (IBAction)deliveryMapAction:(UIButton *)sender {
}

- (IBAction)collMapAction:(UIButton *)sender {
}

-(void)addImages:(UIView *)view
   withLabel :(UILabel *)label
{
    
    UIImageView * imgView1;
    if (!imgView1)
    {
        imgView1 = [[UIImageView alloc]initWithImage:nil];
    }
    imgView1.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:imgView1];
    NSLayoutConstraint * imgView1ConstraintWidth;
    NSLayoutConstraint * imgView1ConstraintHeight;
    NSLayoutConstraint *imgView1X;
    NSLayoutConstraint *imgView1Y;
    if ([deviceType isEqualToString:deviceStringIphone]||[deviceType isEqualToString:deviceStringIphoneSimulator])
    {
        imgView1X = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -50];
        imgView1Y = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
    else
    {
        imgView1X = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:-100];
        imgView1Y = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:7];
    }
    [view addConstraint:imgView1X];
    [view addConstraint:imgView1Y];
    
    if ([getOrderResponseObject getNoSmoking])
    {
        NoSmoking =[getOrderResponseObject getNoSmoking];
        if ([NoSmoking isEqualToString:@"Y"])
        {
            imgView1.image = [UIImage imageNamed: @"ic_no_smoking_lounge_small.png"];
            imgView1ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
            imgView1ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
            [view   addConstraint:imgView1ConstraintWidth];
            [view addConstraint:imgView1ConstraintHeight];
        }
        else if([getOrderResponseObject  getG_width])
        {
            G_Width =[getOrderResponseObject getG_width];
            if ([G_Width integerValue] ==1)
            {
                imgView1ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                imgView1ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                imgView1.image = [UIImage imageNamed: @"ic_smoking_lounge_small.png"];
                [view addConstraint:imgView1ConstraintHeight];
                [view addConstraint:imgView1ConstraintWidth];
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
    //Image2 construction and initializatio
    UIImageView * imgView2;
    if (!imgView2)
    {
        imgView2 = [[UIImageView alloc]initWithImage:nil];
    }
    imgView2.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:imgView2];
    NSLayoutConstraint * imgView2ConstraintWidth;
    NSLayoutConstraint * imgView2ConstraintHeight;
    NSLayoutConstraint *imgView2X;
    NSLayoutConstraint *imgView2Y;
    if ([deviceType isEqualToString:deviceStringIphone]||[deviceType isEqualToString:deviceStringIphoneSimulator])
    {
        imgView2X = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView1 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -30];
        imgView2Y = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
    else
    {
        imgView2X = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView1 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -100];
        imgView2Y = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:7];
        
    }
    [view addConstraint:imgView2X];
    [view addConstraint:imgView2Y];
    if ([getOrderResponseObject getPayment_method])
    {
        payment_method =[getOrderResponseObject getPayment_method];
        if ([payment_method isEqualToString:@"cash"])
        {
            imgView2.image = [UIImage imageNamed:@"ic_cash_payment_small.png"];
            imgView2ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:24];
            imgView2ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
            [view addConstraint:imgView2ConstraintHeight];
            [view addConstraint:imgView2ConstraintWidth];
        }
        else if  ([payment_method isEqualToString:@"card"])
        {
            imgView2.image = [UIImage imageNamed:@"ic_credit_card_payment_small.png"];
            imgView2ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:19];
            imgView2ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
            [view addConstraint:imgView2ConstraintHeight];
            [view addConstraint:imgView2ConstraintWidth];
        }
        else if([payment_method isEqualToString:@"corporate"]   )
        {
            imgView2.image = [UIImage imageNamed:@"ic_non_cash_payment_small.png"];
            imgView2ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:21];
            imgView2ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
            [view addConstraint:imgView2ConstraintHeight];
            [view addConstraint:imgView2ConstraintWidth];
        }
        else
        {
            imgView2.image = nil;
        }
        
    }
    
    
    //********Image3 construction and initialization
    UIImageView * imgView3;
    if (!imgView3)
    {
        imgView3 = [[UIImageView alloc]initWithImage:nil];
    }
    imgView3.translatesAutoresizingMaskIntoConstraints = NO;
    [view  addSubview:imgView3];
    NSLayoutConstraint * imgView3ConstraintWidth;
    NSLayoutConstraint * imgView3ConstraintHeight;
    NSLayoutConstraint *imgView3X;
    NSLayoutConstraint *imgView3Y;
    if ([deviceType isEqualToString:deviceStringIphone]||[deviceType isEqualToString:deviceStringIphoneSimulator])
    {
        imgView3X = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView2 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -30];
        imgView3Y = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
    else
    {
        imgView3X = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView2 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:-100];
        imgView3Y = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:7];
    }
    
    [view addConstraint:imgView3X];
    [view addConstraint:imgView3Y];
    
    if ([getOrderResponseObject getConditioner])
        
    {
        conditioner =[getOrderResponseObject getConditioner];
        if ([conditioner integerValue]==1)
        {
            imgView3.image = [UIImage imageNamed:@"ic_air_conditioning_small.png"];
            imgView3ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:15];
            imgView3ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
            [view addConstraint:imgView3ConstraintHeight];
            [view addConstraint:imgView3ConstraintWidth];
            
        }
        else
        {
            imgView3.image = nil;
        }
    }
    //********Image4 construction and initialization
    UIImageView * imgView4;
    if (!imgView4)
    {
        imgView4 = [[UIImageView alloc]initWithImage:nil];
    }
    imgView4.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:imgView4];
    NSLayoutConstraint * imgView4ConstraintWidth;
    NSLayoutConstraint * imgView4ConstraintHeight;
    NSLayoutConstraint *imgView4X;
    NSLayoutConstraint *imgView4Y;
    if ([deviceType isEqualToString:deviceStringIphone]||[deviceType isEqualToString:deviceStringIphoneSimulator])
    {
        imgView4X = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView3 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -30];
        imgView4Y = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
    
    else
    {
        imgView4X = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView3 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -100];
        imgView4Y = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:7];
    }
    [view addConstraint:imgView4X];
    [view addConstraint:imgView4Y];
    if ([getOrderResponseObject getAnimal])
    {
        animal =[getOrderResponseObject getAnimal];
        if ([animal integerValue]==1)
        {
            imgView4.image = [UIImage imageNamed:@"ic_transportation_of_animals_small.png"];
            imgView4ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
            imgView4ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
            [view addConstraint:imgView4ConstraintHeight];
            [view addConstraint:imgView4ConstraintWidth];
        }
        else
        {
            imgView4.image = nil;
        }
        
        
    }
    //********Image5 construction and initialization
    UIImageView * imgView5;
    if (!imgView5)
    {
        imgView5 = [[UIImageView alloc]initWithImage:nil];
    }
    imgView5.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:imgView5];
    NSLayoutConstraint * imgView5ConstraintWidth;
    NSLayoutConstraint * imgView5ConstraintHeight;
    NSLayoutConstraint *imgView5X;
    NSLayoutConstraint *imgView5Y;
    if ([deviceType isEqualToString:deviceStringIphone]||[deviceType isEqualToString:deviceStringIphoneSimulator])
    {
        imgView5X = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView4 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -30];
        imgView5Y = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
    
    else
    {
        imgView5X = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView4 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -100];
        imgView5Y = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:7];
    }
    [view addConstraint:imgView5X];
    [view addConstraint:imgView5Y];
    if ([getOrderResponseObject getBaby_seat])
    {
        NSString * babySeat;
        babySeat =[getOrderResponseObject getBaby_seat];
        if ([babySeat integerValue]>0)
        {
            imgView5.image = [UIImage imageNamed:@"ic_child_seat_small.png"];
            
            imgView5ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:15];
            imgView5ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
            [view addConstraint:imgView5ConstraintHeight];
            [view addConstraint:imgView5ConstraintWidth];
            
            
        }
        else
        {
            imgView5.image = nil;
            
        }
        
    }
    //********Image6 construction and initialization
    UIImageView * imgView6;
    if (!imgView6)
    {
        imgView6 = [[UIImageView alloc]initWithImage:nil];
    }
    imgView6.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:imgView6];
    NSLayoutConstraint * imgView6ConstraintWidth;
    NSLayoutConstraint * imgView6ConstraintHeight;
    NSLayoutConstraint *imgView6X;
    NSLayoutConstraint *imgView6Y;
    if ([deviceType isEqualToString:deviceStringIphone]||[deviceType isEqualToString:deviceStringIphoneSimulator])
    {
        imgView6X = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView5 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:-30];
        imgView6Y = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
    else
    {
        imgView6X = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView5 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:-100];
        imgView6Y = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:7];
    }
    [view addConstraint:imgView6X];
    [view addConstraint:imgView6Y];
    if ([getOrderResponseObject getLuggage])
    {
        NSString * luggage;
        luggage =[getOrderResponseObject getLuggage];
        if ([luggage integerValue]==1)
        {
            imgView6.image = [UIImage imageNamed:@"ic_baggage_small.png"];
            imgView6ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
            imgView6ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
            [view addConstraint:imgView6ConstraintHeight];
            [view addConstraint:imgView6ConstraintWidth];
        }
        else
        {
            imgView6.image = nil;
        }
    }
    //********Image7 construction and initialization
    UIImageView * imgView7;
    if (!imgView7)
    {
        imgView7 = [[UIImageView alloc]initWithImage:nil];
    }
    imgView7.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:imgView7];
    NSLayoutConstraint * imgView7ConstraintWidth;
    NSLayoutConstraint * imgView7ConstraintHeight;
    NSLayoutConstraint *imgView7X;
    NSLayoutConstraint *imgView7Y;
    if ([deviceType isEqualToString:deviceStringIphone]||[deviceType isEqualToString:deviceStringIphoneSimulator])
    {
        imgView7X = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView6 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:-30];
        imgView7Y = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
    else
    {
        imgView7X = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView6 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:-100];
        imgView7Y = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:7];
    }
    
    [view addConstraint:imgView7X];
    [view addConstraint:imgView7Y];
    if ([getOrderResponseObject getUseBonus])
    {
        NSString * useBonus;
        useBonus =[getOrderResponseObject getUseBonus];
        if ([useBonus isEqualToString:@"Y"])
        {
            imgView7.image = [UIImage imageNamed:@"ic_on_bonuses_payment_small.png"];
            imgView7ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:15];
            imgView7ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
            [view addConstraint:imgView7ConstraintHeight];
            [view addConstraint:imgView7ConstraintWidth];
        }
        else
        {
            imgView7.image = nil;
        }
    }
    //********Image8 construction and initialization
    UIImageView * imgView8;
    if (!imgView8)
    {
        imgView8 = [[UIImageView alloc]initWithImage:nil];
    }
    imgView8.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:imgView8];
    NSLayoutConstraint * imgView8ConstraintWidth;
    NSLayoutConstraint * imgView8ConstraintHeight;
    NSLayoutConstraint *imgView8X;
    NSLayoutConstraint *imgView8Y;
    if ([deviceType isEqualToString:deviceStringIphone]||[deviceType isEqualToString:deviceStringIphoneSimulator])
    {
        imgView8X = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView7 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -30];
        imgView8Y = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
    else
    {
        imgView8X = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView7 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:-100];
        imgView8Y = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:7];
    }
    [view addConstraint:imgView8X];
    [view addConstraint:imgView8Y];
    if ([getOrderResponseObject getNeed_wifi])
    {
        NSString * need_WiFi;
        need_WiFi =[getOrderResponseObject getNeed_wifi];
        if ([need_WiFi integerValue]==1)
        {
            imgView8.image = [UIImage imageNamed:@"ic_wifi_small.png"];
            
            imgView8ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
            imgView8ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
            [view addConstraint:imgView8ConstraintHeight];
            [view addConstraint:imgView8ConstraintWidth];
            
        }
        else
        {
            imgView8.image = nil;
        }
    }
    //********Image9 construction and initialization
    UIImageView * imgView9;
    if (!imgView9)
    {
        imgView9 = [[UIImageView alloc]initWithImage:nil];
    }
    imgView9.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:imgView9];
    NSLayoutConstraint * imgView9ConstraintWidth;
    NSLayoutConstraint * imgView9ConstraintHeight;
    NSLayoutConstraint *imgView9X;
    NSLayoutConstraint *imgView9Y;
    if ([deviceType isEqualToString:deviceStringIphone]||[deviceType isEqualToString:deviceStringIphoneSimulator])
    {
        imgView9X = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView8 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -30];
        imgView9Y = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:7];
    }
    else
    {
        imgView9X = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView8 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:-100];
        imgView9Y = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
    [view addConstraint:imgView9X];
    [view addConstraint:imgView9Y];
    if ([getOrderResponseObject getYellow_reg_num])
    {
        NSString * yellowNumber;
        yellowNumber =[getOrderResponseObject getYellow_reg_num];
        if ([yellowNumber integerValue]==1)
        {
            imgView9.image = [UIImage imageNamed:@"n_color copy.png"];
            imgView9ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
            imgView9ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
            [view addConstraint:imgView9ConstraintHeight];
            [view addConstraint:imgView9ConstraintWidth];
            
            
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
        if ([deviceType isEqualToString:deviceStringIphone]||[deviceType isEqualToString:deviceStringIphoneSimulator])
        {
            NSLayoutConstraint *constForX0 = [NSLayoutConstraint constraintWithItem:[arrayOfImages2 objectAtIndex:0] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-25];
            [view addConstraint:constForX0];
            for (int i =0; i<arrayOfImages2.count; i++)
            {
                if (i!=0)
                {
                    NSLayoutConstraint *constForX = [NSLayoutConstraint constraintWithItem:[arrayOfImages2 objectAtIndex:i] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:[arrayOfImages2 objectAtIndex:i-1]attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-25];
                    [view addConstraint:constForX];
                }
            }
            
        }
        else
        {
            NSLayoutConstraint *constForX0 = [NSLayoutConstraint constraintWithItem:[arrayOfImages2 objectAtIndex:0] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-50];
            [view addConstraint:constForX0];
            for (int i =0; i<arrayOfImages2.count; i++)
            {
                if (i!=0)
                {
                    NSLayoutConstraint *constForX = [NSLayoutConstraint constraintWithItem:[arrayOfImages2 objectAtIndex:i] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:[arrayOfImages2 objectAtIndex:i-1]attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-50];
                    [view addConstraint:constForX];
                }
            }
        }
    }
    
    else
        
    {
        
        
        for (int i =0; i<arrayOfImages.count; i++)
        {
            NSLayoutConstraint *constForXhide = [NSLayoutConstraint constraintWithItem:[arrayOfImages objectAtIndex:i] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:20];
            [view addConstraint:constForXhide];
            
        }
        
    }
    
    if (arrayOfImages2.count >=5 && ([[UIApplication sharedApplication]statusBarOrientation]==UIDeviceOrientationPortrait || [[UIApplication sharedApplication]statusBarOrientation]==UIDeviceOrientationPortraitUpsideDown))
    {
        for (int i =5; i<arrayOfImages2.count; i++)
        {
            UIImageView * imgViewCurrentHid =[arrayOfImages2 objectAtIndex:i];
            imgViewCurrentHid.hidden=YES;
        }
    }
    
}

@end
