//
//  CardsViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/31/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "CardsViewController.h"
#import "RequestStandart.h"
#import "OpenMapButtonHandler.h"
#import "ProfilViewController.h"
#import "BindCardJson.h"
#import "BindCardResponse.h"
#import "GetCardsJson.h"
#import "GetCardsResponse.h"
#import "CardView.h"

#import "UnbindCardRequest.h"

@interface CardsViewController ()
{
    OpenMapButtonHandler*openMapButtonHandlerObject;
    UIActivityIndicatorView* indicator;
    GetCardsResponse* getCardsResponseObject;
    BindCardResponse*bindCardResponseObject;
    
    UIWebView* webView;
    
    LeftMenu* leftMenu;
    
    UIScrollView* scrollView;
    CAGradientLayer* gradientLayer;
    
    NSMutableArray* cardsArray;
}
@end

@implementation CardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasCards.hidden = YES;
    cardsArray = [[NSMutableArray alloc]init];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     [[SingleDataProvider sharedKey]setGpsButtonHandler:self.gpsButton];
    if ([SingleDataProvider sharedKey].isGPSEnabled)
    {
        [self.gpsButton setImage:[UIImage imageNamed:@"gps_green.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [self.gpsButton setImage:[UIImage imageNamed:@"gps.png"] forState:UIControlStateNormal];
    }
    self.segmentControll.selectedSegmentIndex = 2;
    [self.yandexButton setNeedsDisplay];
    [self.cityButton setNeedsDisplay];
    
    leftMenu=[LeftMenu getLeftMenu:self];
    
    
    [self requestGetCards];
}




#pragma mark - Requsts

-(void)requestUnbindCardWithID:(NSString*) id_card
{
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    UnbindCardRequest* getCardsJsonObject=[[UnbindCardRequest alloc]init];
    getCardsJsonObject.id_card = id_card;
    
    NSDictionary*jsonDictionary=[getCardsJsonObject toDictionary];
    NSString*jsons=[getCardsJsonObject toJSONString];
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
                                        
                                    }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            
            [indicator stopAnimating];
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"getCardsJsonString:%@",jsonString);
        NSError*err;
        getCardsResponseObject = [[GetCardsResponse alloc] initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:getCardsResponseObject.text code:getCardsResponseObject.code];
        
        
        
        [indicator stopAnimating];
        
        
        
    }];
    
}


-(void)requestGetCards
{
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    GetCardsJson* getCardsJsonObject=[[GetCardsJson alloc]init];
    
    NSDictionary*jsonDictionary=[getCardsJsonObject toDictionary];
    NSString*jsons=[getCardsJsonObject toJSONString];
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
                                        
                                    }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            
            [indicator stopAnimating];
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"getCardsJsonString:%@",jsonString);
        NSError*err;
        getCardsResponseObject = [[GetCardsResponse alloc] initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:getCardsResponseObject.text code:getCardsResponseObject.code];
        
        
        
        if (getCardsResponseObject.cards.count != 0) {
            self.hasCards.hidden = YES;
            
            
            scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(self.segmentControll.frame) , CGRectGetWidth(self.view.frame) - 16, CGRectGetHeight(self.view.frame) - 155)];//64 - 29 - 16 - 30 - 16
            scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) - 16, getCardsResponseObject.cards.count * (264 + 8));
            [self.view addSubview:scrollView];
            
            for (int i = 0; i < getCardsResponseObject.cards.count; ++i) {
                CardView* cardView = [[NSBundle mainBundle] loadNibNamed:@"CardView" owner:self options:nil][0];
                cardView.frame = CGRectMake(0, i*264 + 8, CGRectGetWidth(scrollView.frame), 264);
                cardView.pan.text = [getCardsResponseObject.cards[i] pan];
                
                NSString* string = [getCardsResponseObject.cards[i] cardholder];
                string = [string uppercaseString];
                cardView.cardholder.text = string;
                
                
                NSString* str = (NSMutableString*)cardView.expiration.text;
                str = [str stringByAppendingFormat:@"  %@",[getCardsResponseObject.cards[i] expiration]];
                NSMutableString* aString = [[NSMutableString alloc]initWithString:str];
                NSUInteger location = aString.length;
                [aString insertString:@" / " atIndex:location - 2];
                cardView.expiration.text = aString;
                //- (void)insertString:(NSString *)aString atIndex:(NSUInteger)loc;
                
                gradientLayer = [self greyGradient:cardView.backgroundView widthFrame:CGRectMake(0, 0, CGRectGetWidth(scrollView.frame), 264)];
                [cardView.backgroundView.layer insertSublayer:gradientLayer atIndex:0];
                
                [cardsArray addObject:cardView];
                
                [scrollView addSubview:cardView];
                
                cardView.deleteButton.tag = 100 + i;
            }
        }
        else
        {
            self.hasCards.hidden = NO;
        }
        
        
        
        
        
        
        [indicator stopAnimating];
        
        
        
    }];
    
}


-(void)requestBindCard
{
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    BindCardJson* bindCardJsonObject=[[BindCardJson alloc]init];
    
    NSDictionary*jsonDictionary=[bindCardJsonObject toDictionary];
    NSString*jsons=[bindCardJsonObject toJSONString];
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
                                        
                                    }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
            [indicator stopAnimating];
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"bindCardResponseJsonString:%@",jsonString);
        NSError*err;
        bindCardResponseObject = [[BindCardResponse alloc] initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:bindCardResponseObject.text code:bindCardResponseObject.code];
        
        
        webView = [[UIWebView alloc]initWithFrame:
                   CGRectMake(8, CGRectGetMaxY(self.segmentControll.frame) + 8,
                              CGRectGetWidth(self.view.frame) - 16,
                              CGRectGetHeight(self.view.frame)
                              - 64 - CGRectGetHeight(self.segmentControll.frame) - 3*8)];
        
        webView.backgroundColor = [UIColor whiteColor];
        
        [webView loadHTMLString:@"" baseURL:nil];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:bindCardResponseObject.link]]];
        [self.view addSubview:webView];
        
        
        [indicator stopAnimating];
    }];
    
}


- (IBAction)addCard:(UIButton *)sender {
    [self requestBindCard];
}

- (IBAction)deleteCard:(UIButton *)sender {
    NSString* id_card = [NSString stringWithFormat:@"%ld",(sender.tag - 100)];
    [self requestUnbindCardWithID:id_card];
}



#pragma mark - gradient
- (CAGradientLayer*) greyGradient:(UIView*)view widthFrame:(CGRect) rect{
    UIColor *colorOne = [UIColor colorWithRed:198.f/255 green:198.f/255 blue:198.f/255 alpha:1.f];
    UIColor *colorTwo = [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1.f];
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.frame = rect;
    
    return headerLayer;
}


#pragma mark - rotation
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         

         
         scrollView.frame = CGRectMake(8, CGRectGetMaxY(self.segmentControll.frame), CGRectGetWidth(self.view.frame) - 16, CGRectGetHeight(self.view.frame) - 155);
         

         for (int i = 0; i < cardsArray.count; ++i) {
             CardView* cardView = (CardView*)cardsArray[i];
             cardView.frame = CGRectMake(0, i*264 + 8, CGRectGetWidth(scrollView.frame), 264);
             
             gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(scrollView.frame), 264);
         }
         
         
         webView.frame = CGRectMake(8, CGRectGetMaxY(self.segmentControll.frame) + 8,
                               CGRectGetWidth(self.view.frame) - 16,
                               CGRectGetHeight(self.view.frame)
                               - 64 - CGRectGetHeight(self.segmentControll.frame) - 3*8);
         
         
     }
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
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
    
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
}


#pragma mark - Segment Action
- (IBAction)segmentControllAction:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        ProfilViewController* profilViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfilViewController"];
        [self pushOrPopViewController:profilViewController];
    }
    if (sender.selectedSegmentIndex == 1)
    {
        CarInfoViewController* createProfilController=[self.storyboard instantiateViewControllerWithIdentifier:@"CarInfoViewController"];
        [self.navigationController pushViewController:createProfilController animated:NO];
    }
    if (sender.selectedSegmentIndex == 2) {
    }
}

-(void)pushOrPopViewController:(UIViewController*)controller
{
    NSArray *viewControlles = self.navigationController.viewControllers;
    
    for (UIViewController* currentController in viewControlles) {
        if ([controller isKindOfClass:currentController.class]) {
            [self.navigationController popToViewController:currentController animated:NO];
            return;
        }
    }
    [self.navigationController pushViewController:controller animated:NO];
}


#pragma mark - left Menu



- (IBAction)openAndCloseLeftMenu:(UIButton *)sender
{
    [self.view bringSubviewToFront:leftMenu];
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
//             self.scrollView.userInteractionEnabled = NO;
             self.segmentControll.userInteractionEnabled = NO;
             webView.userInteractionEnabled = NO;
//             self.scrollView.tag=1;
             self.segmentControll.tag=2;
             [leftMenu.disabledViewsArray removeAllObjects];
             
//             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.scrollView.tag]];
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.segmentControll.tag]];
         }
         else
         {
             leftMenu.flag=0;
             self.segmentControll.userInteractionEnabled = YES;
             webView.userInteractionEnabled = YES;
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
             self.segmentControll.userInteractionEnabled = YES;
             webView.userInteractionEnabled = YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             self.segmentControll.userInteractionEnabled = NO;
             webView.userInteractionEnabled = NO;
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
    [self.view bringSubviewToFront:leftMenu];
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
    self.segmentControll.userInteractionEnabled = NO;
    webView.userInteractionEnabled = NO;
    leftMenu.flag=1;
}


#pragma mark - Navigation View Actions
- (IBAction)openMap:(UIButton*)sender
{
    openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
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
@end
