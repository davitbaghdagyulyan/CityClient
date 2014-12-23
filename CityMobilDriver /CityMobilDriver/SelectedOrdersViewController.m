//
//  SelectedOrdersViewController.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/9/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SelectedOrdersViewController.h"
#import "CustomCellSelectedOrders.h"
#import "SingleDataProvider.h"

#import "SelectedOrdersDetailsResponse.h"
#import "SelectedOrdersDetailsJson.h"
#import "JSONModel.h"
#import "LeftMenu.h"
#import "CustomCellSelectORDER.h"
#import "CustomViewForMaps.h"
#import "AssignOrderJson.h"
#import "AssignOrderResponse.h"
#import "TakenOrderViewController.h"
#import "BuyDeliveryAddressJson.h"
#import "BuyDeliveryAddressResponse.h"
#import "OpenMapButtonHandler.h"

@interface SelectedOrdersViewController ()
{
    //LEFT MUENU

    LeftMenu*leftMenu;
    //ARUS
    NSInteger flag1;
    BOOL alertNoConIsCreated;
    BOOL  cancelOfAlertNoConIsClicked;
    BOOL alertServErrIsCreated;
    BOOL cancelOfAlertServErrIsClicked;
    //NAREK
    NSUInteger indexOfCell;
    CustomViewForMaps*viewMap;
    CGRect rect;
    NSUInteger number;
    AssignOrderResponse*assignOrderResponseObject;
    UIAlertView*confirmOrdersTakenAlert;
    UIView*underView;
    NSString *yandexMapUrl;
    NSString*googleMapUrl;
    //HANDLER
    SelectedOrdersTableViewHandler* selectedOrdersTableViewHandlerObject;
    CustomCellSelectORDER*cell;
    OpenMapButtonHandler*openMapButtonHandlerObject;
   }

@end

@implementation SelectedOrdersViewController
{
    //requestORDER
    SelectedOrdersDetailsResponse * selectedOrdersDetailsResponseObject;
    SelectedOrdersDetailsJson* detailsJsonObject;
    bool timerCreated;
    NSTimer * requestTimer;
    //SelectionOfCell
     NSInteger selectedRow;
    //requestBuyDeliveryAddress
    NSString * result;
   //User Interface
    NSTimer * timerForTitleLabel;
   
    
}

-(void)setFilter:(NSDictionary *)filter
{
    detailsJsonObject=[[SelectedOrdersDetailsJson alloc]init];
    detailsJsonObject.filter=filter;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [GPSConection showGPSConection:self];
    //Buttons color change for SettingsVC
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];
    //FONT TITLE LABEL
    selectedOrdersTableViewHandlerObject=[[SelectedOrdersTableViewHandler alloc]init];
    self.tableViewOrdersDetails.delegate=selectedOrdersTableViewHandlerObject;
    self.tableViewOrdersDetails.dataSource=selectedOrdersTableViewHandlerObject;
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:20];
    self.titleLabel.text = self.titleString;
    if ([self.titleString isEqualToString:@"СРОЧНЫЕ"])
    {
    timerForTitleLabel = [NSTimer scheduledTimerWithTimeInterval:5
                                                          target:self selector:@selector(toggleTitleLabel) userInfo:nil repeats:YES];
    self.titleLabel.textColor =[UIColor redColor];
    self.stringForSrochno=@"СРОЧНО";
    }
    else
    {
        self.titleLabel.textColor=[UIColor blackColor];
        self.stringForSrochno=@"";
    }
 
    self.tableViewOrdersDetails.userInteractionEnabled = YES;
    leftMenu=[LeftMenu getLeftMenu:self];
    timerCreated =NO;
    if (cancelOfAlertNoConIsClicked ==YES)
    {
        alertNoConIsCreated=NO;
    }
    else
    {
        alertNoConIsCreated=YES;
    }
    if (cancelOfAlertServErrIsClicked ==YES)
    {
        alertServErrIsCreated =NO;
    }
    else
    {
        alertServErrIsCreated =YES;
    }
    [self requestOrder];
    selectedRow = -1;
    //MAPVIEW
    viewMap=[[CustomViewForMaps alloc] init];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomViewForMaps" owner:self options:nil];
    viewMap = [nib objectAtIndex:0];
    viewMap.frame=self.view.frame;
    viewMap.center=self.view.center;
    viewMap.smallMapView.layer.cornerRadius = 30;
    viewMap.smallMapView.layer.borderWidth = 2;
    viewMap.smallMapView.layer.borderColor=[UIColor clearColor].CGColor;
    viewMap.smallMapView.layer.masksToBounds = YES;
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

-(void)toggleTitleLabel
{
[self.titleLabel setHidden:(!self.titleLabel.hidden)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableViewOrdersDetails.separatorStyle = UITableViewCellSeparatorStyleNone;
    cancelOfAlertNoConIsClicked =YES;
    cancelOfAlertServErrIsClicked=YES;
    // Do any additional setup after loading the view
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

-(void)requestOrder
{
    flag1=-1;
    [selectedOrdersTableViewHandlerObject setResponseObject:selectedOrdersDetailsResponseObject andStringforSroch:self.stringForSrochno andFlag1:flag1 andCurentSelf:self andNumberOfClass:0];
    self.view.backgroundColor = [UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
    self.tableViewOrdersDetails.backgroundColor =[UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
    self.titleLabel.backgroundColor =[UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
    [self.tableViewOrdersDetails reloadData];
    NSDictionary*jsonDictionary=[detailsJsonObject toDictionary];
    NSString*jsons=[detailsJsonObject toJSONString];
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
        if (!data && alertNoConIsCreated ==NO)
        {
            UIAlertController *alertNoCon = [UIAlertController alertControllerWithTitle:@ "Нет соединения с интернетом!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            alertNoConIsCreated =YES;
            cancelOfAlertNoConIsClicked =NO;
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              cancelOfAlertNoConIsClicked=YES;
                                                              [alertNoCon dismissViewControllerAnimated:YES completion:nil];
                                                          }];
            [alertNoCon addAction:cancel];
            [self presentViewController:alertNoCon animated:YES completion:nil];
        }
        else if(data)
        {
            alertNoConIsCreated =NO;
            NSString* jsonString1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"selectedOrdersDetails =%@",jsonString1);
            NSError*err;
            selectedOrdersDetailsResponseObject = [[SelectedOrdersDetailsResponse alloc] initWithString:jsonString1 error:&err];
        }
        if(selectedOrdersDetailsResponseObject.code!=nil && alertServErrIsCreated==NO)
        {
            UIAlertController *alertServerErr = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:selectedOrdersDetailsResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
            alertServErrIsCreated =YES;
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              cancelOfAlertServErrIsClicked = YES;
                                                              [alertServerErr dismissViewControllerAnimated:YES completion:nil];
                                                          }];
            [alertServerErr addAction:cancel];
            [self presentViewController:alertServerErr animated:YES completion:nil];
        }
        else if(selectedOrdersDetailsResponseObject.code==nil)
        {
            alertServErrIsCreated=NO;
        }
        flag1=1;
        [selectedOrdersTableViewHandlerObject setResponseObject:selectedOrdersDetailsResponseObject andStringforSroch:self.stringForSrochno andFlag1:flag1 andCurentSelf:self andNumberOfClass:0];
        if (selectedOrdersDetailsResponseObject.code==nil && data)
        {
            self.view.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
            self.tableViewOrdersDetails.backgroundColor =[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
            self.titleLabel.backgroundColor =[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
            [selectedOrdersTableViewHandlerObject setResponseObject:selectedOrdersDetailsResponseObject andStringforSroch:self.stringForSrochno andFlag1:flag1 andCurentSelf:self andNumberOfClass:0];
            [selectedOrdersTableViewHandlerObject setResponseObject:selectedOrdersDetailsResponseObject andStringforSroch:self.stringForSrochno andFlag1:flag1 andCurentSelf:self andNumberOfClass:0];
            [self.tableViewOrdersDetails reloadData];
        }
        if (timerCreated ==NO)
        {
            requestTimer= [NSTimer scheduledTimerWithTimeInterval:30
                                                           target:self
                                                         selector:@selector(requestOrder)
                                                         userInfo:nil
                                                          repeats:YES];
            timerCreated =YES;
        }
        
    }];
    
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [requestTimer invalidate];
}



- (IBAction)refresh:(id)sender
{
    if (cancelOfAlertNoConIsClicked ==YES)
    {
        alertNoConIsCreated=NO;
    }
    else
    {
        alertNoConIsCreated=YES;
    }
    
    if (cancelOfAlertServErrIsClicked ==YES)
    {
        alertServErrIsCreated =NO;
    }
    else
    {
        alertServErrIsCreated =YES;
    }
    
    [self requestOrder];

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
             self.tableViewOrdersDetails.userInteractionEnabled=NO;
             
             self.tableViewOrdersDetails.tag=1;
             [leftMenu.disabledViewsArray removeAllObjects];
             NSNumber*num;
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.tableViewOrdersDetails.tag]];
           
             
         }
         else
         {
             leftMenu.flag=0;
             self.tableViewOrdersDetails.userInteractionEnabled=YES;
             
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
[self.navigationController popViewControllerAnimated:NO];
    
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
             self.tableViewOrdersDetails.userInteractionEnabled=YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             self.tableViewOrdersDetails.userInteractionEnabled=NO;
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
    self.tableViewOrdersDetails.userInteractionEnabled=NO;
    leftMenu.flag=1;
}


-(NSString*)TimeFormat:(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:string];
    /////////convert nsdata To NSString////////////////////////////////////
    [dateFormatter setDateFormat:@"HH:mm"];
    if(date==nil) return @"00:00";
    return [dateFormatter stringFromDate:date];
    
}

-(void)showAddress
{
    UIAlertController *alertConfirmPurchaseVC = [UIAlertController alertControllerWithTitle:@"Подтвердите покупку" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action) {
                                                      [alertConfirmPurchaseVC dismissViewControllerAnimated:YES completion:nil];
                                                      [self requestOrder];
                                                  }];
    UIAlertAction*confirmPurchase = [UIAlertAction actionWithTitle:@"ОК" style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action) {
                                                      [self requestBuyDeliveryAddress];
                                                      if ([result integerValue]==1)
                                                      {
                                                          [self requestOrder];
                                                      }
                                                  }];

    [alertConfirmPurchaseVC addAction:cancel];
    [alertConfirmPurchaseVC addAction:confirmPurchase];
    [self presentViewController:alertConfirmPurchaseVC animated:YES completion:nil];
     return ;

}

-(void)requestBuyDeliveryAddress
{
    BuyDeliveryAddressJson* buyAddressJsonObject=[[BuyDeliveryAddressJson alloc]init];
    buyAddressJsonObject.idhash=self.idhash;
    NSDictionary*jsonDictionary=[buyAddressJsonObject toDictionary];
    NSString*jsons=[buyAddressJsonObject toJSONString];
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
            UIAlertController *alertNoCon = [UIAlertController alertControllerWithTitle:@ "Нет соединения с интернетом!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [alertNoCon dismissViewControllerAnimated:YES completion:nil];
                                                          }];
            [alertNoCon addAction:cancel];
            [self presentViewController:alertNoCon animated:YES completion:nil];
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"First Json String %@",jsonString);
        NSError*err;
        BuyDeliveryAddressResponse*buyDeliveryAddressResponseObject = [[BuyDeliveryAddressResponse alloc] initWithString:jsonString error:&err];
        if(buyDeliveryAddressResponseObject.code!=nil)
        {
            UIAlertController *alertServerErr = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:buyDeliveryAddressResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [alertServerErr dismissViewControllerAnimated:YES completion:nil];
                                                          }];
            [alertServerErr addAction:cancel];
            [self presentViewController:alertServerErr animated:YES completion:nil];
            
        }
        result=buyDeliveryAddressResponseObject.result;
        
    }];
    
}


- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        UIDeviceOrientation deviceOrientation   = [[UIDevice currentDevice] orientation];
        
      if (UIDeviceOrientationIsLandscape(deviceOrientation))
        {
            NSLog(@"Will change to Landscape");
            selectedRow = -1;
            [selectedOrdersTableViewHandlerObject setSelectedRow:selectedRow];
            [self requestOrder];
            [self.tableViewOrdersDetails reloadData];
        }
        
        else {
            NSLog(@"Will change to Portrait");
            selectedRow = -1;
            [selectedOrdersTableViewHandlerObject setSelectedRow:selectedRow];
            [self requestOrder];
            [self.tableViewOrdersDetails reloadData];

            }
        
        
    }
     completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         viewMap.frame=self.view.frame;
         viewMap.center=self.view.center;
        
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


-(void)collMap
{
    [self.view addSubview:viewMap];
    viewMap.smallMapView.transform = CGAffineTransformMakeScale(0,0);
    number=0;
    googleMapUrl= [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
                   [SingleDataProvider sharedKey].lat,
                    [SingleDataProvider sharedKey].lon,
                   [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexOfCell] latitude] doubleValue],
                   [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexOfCell] longitude] doubleValue]];
   
    yandexMapUrl=[NSString stringWithFormat:@"yandexnavi://build_route_on_map?lat_from=%f&lon_from=%f&lat_to=%f&lon_to=%f",
                  [SingleDataProvider sharedKey].lat,
                  [SingleDataProvider sharedKey].lon,
                  [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexOfCell] latitude] doubleValue],
                  [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexOfCell] longitude] doubleValue]];
    [self animation];
}

-(void)deliveryMapp
{
    [self.view addSubview:viewMap];
    viewMap.smallMapView.transform = CGAffineTransformMakeScale(0,0);
    number=1;
    googleMapUrl=[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",[[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexOfCell] latitude]doubleValue],
                  [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexOfCell] longitude] doubleValue],
                  [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexOfCell] del_latitude] doubleValue],
                  [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexOfCell] del_longitude] doubleValue]];

    
    yandexMapUrl=[NSString stringWithFormat:@"yandexnavi://build_route_on_map?lat_from=%f&lon_from=%f&lat_to=%f&lon_to=%f",[[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexOfCell] latitude]doubleValue],
                  [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexOfCell] longitude] doubleValue],
                  [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexOfCell] del_latitude] doubleValue],
                  [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexOfCell] del_longitude] doubleValue]];
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

-(void)setIndexOfCell:(NSUInteger)indexOf andCell:(CustomCellSelectORDER*)cel
{
    indexOfCell=indexOf;
    cell=cel;
    
    
};
-(void)setUnderView:(UIView*)under
{
    underView=under;
}

-(void)animation
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: 0
                     animations:^(void)
     {
       viewMap.smallMapView.transform = CGAffineTransformIdentity;
     }
                             completion:nil];
}

-(void)toTakeAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Подтверждение взятия заказа" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action)
                            {
                               
                                [alert dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
    [alert addAction:cancel];
    
    UIAlertAction*ok = [UIAlertAction actionWithTitle:@"ОК" style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action)
                            {
                                
                                [alert dismissViewControllerAnimated:YES completion:nil];
                                [self requestAssignOrder];
                                
                            }];
    [alert addAction:ok];

    
    
    [self presentViewController:alert animated:YES completion:nil];
    
  }
-(void)requestAssignOrder
{
UIActivityIndicatorView*indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
indicator.center = self.view.center;
indicator.color=[UIColor blackColor];
[indicator startAnimating];
[self.view addSubview:indicator];

AssignOrderJson* assignOrderJsonObject=[[AssignOrderJson alloc]init];
assignOrderJsonObject.idhash=[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexOfCell] idhash];
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
request.timeoutInterval = 10;
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
    assignOrderResponseObject = [[AssignOrderResponse alloc] initWithString:jsonString error:&err];
    
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
                                    
                                }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];

        
       
        [indicator stopAnimating];
    }
    else
    {
      
      
        [cell.updateLabelTimer invalidate];
        TakenOrderViewController* tovc = [self.storyboard instantiateViewControllerWithIdentifier:@"TakenOrderViewController"];
        
        
        [self.navigationController pushViewController:tovc animated:NO];
        [tovc setIdHash:assignOrderJsonObject.idhash andUnderView:underView];
        
        [indicator stopAnimating];

    }
    
}];

}
@end