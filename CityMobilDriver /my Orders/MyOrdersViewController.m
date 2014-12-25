//
//  MyOrdersViewController.m
//  CityMobilDriver
//
//  Created by Intern on 11/20/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "SelectedOrdersDetailsResponse.h"
#import "GetMyOrdersJson.h"
#import "CustomViewForMaps.h"
#import "TakenOrderViewController.h"
#import "SingleDataProvider.h"
#import "OpenMapButtonHandler.h"

@interface MyOrdersViewController ()
{
    NSString*yandexMapUrl;
    NSString*googleMapUrl;
     OpenMapButtonHandler*openMapButtonHandlerObject;
    LeftMenu*leftMenu;
    
    SelectedOrdersDetailsResponse*getMyOrdersResponseObject;
    SelectedOrdersTableViewHandler*selectedOrdersTableViewHandlerObject;
    
    NSUInteger indexOfCell;
    NSUInteger number;
    UIView*underView;
     NSInteger selectedRow;
    CustomViewForMaps*viewMap;
    NSString*idhash;

}
@end

@implementation MyOrdersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.gpsButton setNeedsDisplay];
    [GPSConection showGPSConection:self];
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];
    selectedOrdersTableViewHandlerObject=[[SelectedOrdersTableViewHandler alloc]init];
    self.myOrdersTableView.delegate=selectedOrdersTableViewHandlerObject;
    self.myOrdersTableView.dataSource=selectedOrdersTableViewHandlerObject;
    

    leftMenu=[LeftMenu getLeftMenu:self];
   
    [self requestGetMyOrders];
    
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
    self.myOrdersTableView.userInteractionEnabled=YES;
     self.myOrdersTableView.hidden=NO;
  

}
- (IBAction)openMap:(UIButton*)sender
{
    openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
}

    


-(void)requestGetMyOrders
{
    UIActivityIndicatorView*indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    GetMyOrdersJson* getMyOrdersJsonObject=[[GetMyOrdersJson alloc]init];
    
    
    NSDictionary*jsonDictionary=[getMyOrdersJsonObject toDictionary];
    NSString*jsons=[getMyOrdersJsonObject toJSONString];
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
        
        
        
        getMyOrdersResponseObject = [[SelectedOrdersDetailsResponse alloc] initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:getMyOrdersResponseObject.text code:getMyOrdersResponseObject.code];
        
        if (!getMyOrdersResponseObject.orders.count)
        {
            self.myOrdersTableView.hidden=YES;
             [indicator stopAnimating];
            return;
        }
        
        
//        if(getMyOrdersResponseObject.code!=nil)
//        {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:getMyOrdersResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action)
//                                    {
//                                        [alert dismissViewControllerAnimated:YES completion:nil];
//                                        
//                                    }];
//            [alert addAction:cancel];
//            [self presentViewController:alert animated:YES completion:nil];
//            [indicator stopAnimating];
//            
//        }
//        else
//        {
            [selectedOrdersTableViewHandlerObject setResponseObject:getMyOrdersResponseObject andStringforSroch:@"" andFlag1:0 andCurentSelf:self andNumberOfClass:1];
         
            
            [self.myOrdersTableView reloadData];

            
            
            
            
//        }
        [indicator stopAnimating];
 }];
}
-(void)setIndexOfCell:(NSUInteger)indexOf
{
    indexOfCell=indexOf;
}
-(void)setUnderView:(UIView*)under
{
    underView=under;
}

-(void)closeOrderAction
{
    selectedRow=-1;
    [selectedOrdersTableViewHandlerObject setSelectedRow:selectedRow];
    [self.myOrdersTableView reloadData];
}
-(void)toOrderAction
{
    TakenOrderViewController* tovc = [self.storyboard instantiateViewControllerWithIdentifier:@"TakenOrderViewController"];
    [self.navigationController pushViewController:tovc animated:NO];
    idhash=[[getMyOrdersResponseObject.orders objectAtIndex:indexOfCell] idhash];
    [tovc setIdHash:idhash andUnderView:underView];
}

-(void)collMap
{
    [self.view addSubview:viewMap];
    viewMap.smallMapView.transform = CGAffineTransformMakeScale(0,0);
    number=0;
    googleMapUrl=[NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f&directionsmode=transit",
                  [SingleDataProvider sharedKey].lat,
                  [SingleDataProvider sharedKey].lon,
                  [[[getMyOrdersResponseObject.orders objectAtIndex:indexOfCell] latitude] doubleValue],
                  [[[getMyOrdersResponseObject.orders objectAtIndex:indexOfCell] longitude] doubleValue]];
    yandexMapUrl=[NSString stringWithFormat:@"yandexnavi://build_route_on_map?lat_from=%f&lon_from=%f&lat_to=%f&lon_to=%f",
                 [SingleDataProvider sharedKey].lat,
                 [SingleDataProvider sharedKey].lon,
                  [[[getMyOrdersResponseObject.orders objectAtIndex:indexOfCell] latitude] doubleValue],
                  [[[getMyOrdersResponseObject.orders objectAtIndex:indexOfCell] longitude] doubleValue]];
    [self animation];
}

-(void)deliveryMapp
{
    [self.view addSubview:viewMap];
    viewMap.smallMapView.transform = CGAffineTransformMakeScale(0,0);
    number=1;
    googleMapUrl=[NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f&directionsmode=transit",[[[getMyOrdersResponseObject.orders objectAtIndex:indexOfCell] latitude]doubleValue],
                  [[[getMyOrdersResponseObject.orders objectAtIndex:indexOfCell] longitude] doubleValue],
                  [[[getMyOrdersResponseObject.orders objectAtIndex:indexOfCell] del_latitude] doubleValue],
                  [[[getMyOrdersResponseObject.orders objectAtIndex:indexOfCell] del_longitude] doubleValue]];

    yandexMapUrl=[NSString stringWithFormat:@"yandexnavi://build_route_on_map?lat_from=%f&lon_from=%f&lat_to=%f&lon_to=%f",[[[getMyOrdersResponseObject.orders objectAtIndex:indexOfCell] latitude]doubleValue],
                  [[[getMyOrdersResponseObject.orders objectAtIndex:indexOfCell] longitude] doubleValue],
                  [[[getMyOrdersResponseObject.orders objectAtIndex:indexOfCell] del_latitude] doubleValue],
                  [[[getMyOrdersResponseObject.orders objectAtIndex:indexOfCell] del_longitude] doubleValue]];
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
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: 0
                     animations:^(void)
     {
         viewMap.smallMapView.transform = CGAffineTransformIdentity;
     }
                     completion:nil];
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
             self.myOrdersTableView.userInteractionEnabled=NO;
             
             self.myOrdersTableView.tag=1;
             [leftMenu.disabledViewsArray removeAllObjects];
             
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.myOrdersTableView.tag]];
         }
         else
         {
             self.myOrdersTableView.userInteractionEnabled=YES;
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
             self.myOrdersTableView.userInteractionEnabled=YES;
           
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             leftMenu.flag=1;
             self.myOrdersTableView.userInteractionEnabled=NO;
         
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
    self.myOrdersTableView.userInteractionEnabled=NO;

}
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:nil
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
         selectedRow = -1;
         [selectedOrdersTableViewHandlerObject setSelectedRow:selectedRow];
         [self.myOrdersTableView reloadData];
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

@end
