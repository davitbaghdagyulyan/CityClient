//
//  ReplenishmentViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/20/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "ReplenishmentViewController.h"
#import "CustomView.h"
#import "CustomWebView.h"
#import "GetQiwiBillsUrlJson.h"
#import "GetQiwiBillsUrlResponse.h"
#import "GetCardsJson.h"
#import "GetCardsResponse.h"
#import "BindCardJson.h"
#import "BindCardResponse.h"
#import "OpenMapButtonHandler.h"


@interface ReplenishmentViewController ()
{
    OpenMapButtonHandler*openMapButtonHandlerObject;
    CustomWebView*view2;
    CustomView*view1;
    UIActivityIndicatorView* indicator;
    GetQiwiBillsUrlResponse*getQiwiBillsUrlResponseObject;
    GetCardsResponse*getCardsResponseObject;
    BindCardResponse*bindCardResponseObject;
    NSInteger loadcount;
    LeftMenu*leftMenu;
  
    BOOL isPressedCloseButton;

}
@end

@implementation ReplenishmentViewController
-(void)viewDidAppear:(BOOL)animated
{
     [GPSConection showGPSConection:self];
    
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];
    
    isPressedCloseButton=NO;
    [super viewDidAppear:animated];
    loadcount=0;
   
    if (!loadcount)
    {
        [self requestGetCards];
    }
    else
    {
        
        [self.view addSubview:view1];
    }


    leftMenu=[LeftMenu getLeftMenu:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)replenishmentSegmentedControl:(UISegmentedControl *)sender
{
    
    switch (sender.selectedSegmentIndex)
    {
        case 0:
        {
            [view2 removeFromSuperview];
            if (!loadcount)
            {
                 [self requestGetCards];
            }
            else
            {
                
                [self.view addSubview:view1];
                [self.view bringSubviewToFront:leftMenu];
            }
        }
            break;
        case 1:
        {
            
            [view1 removeFromSuperview];
            
            if (!loadcount)
            {
                
                CGPoint point;
                point.x=0;
                point.y=93;
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomWebView" owner:self options:nil];
                view2 = [nib objectAtIndex:0];
               
                view2.frame = CGRectMake(0,93, self.view.frame.size.width, self.view.frame.size.height - 93);
                [self.view addSubview:view2];
                
                [self requestGetQiwiBillsUrl];
                view2.customWebView.delegate=self;
            }
            else
            {
                
                [self.view addSubview:view2];
                [self.view bringSubviewToFront:leftMenu];
            }
            
            loadcount=1;
        }
            break;
        default:
            break;
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [indicator stopAnimating];
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    if([request.URL isEqual:[NSURL URLWithString:@"http://city-mobil.ru/rbs/card_closed.html"]])
    {
        
        isPressedCloseButton=YES;
        [view1.customView bringSubviewToFront:view1.addCardButton];
        
        
    }
    return YES;
    
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
        NSLog(@"bindCardResponseJsonString:%@",jsonString);
        NSError*err;
        bindCardResponseObject = [[BindCardResponse alloc] initWithString:jsonString error:&err];

        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:bindCardResponseObject.text code:bindCardResponseObject.code];
        
//        if(bindCardResponseObject.code!=nil)
//        {
//           
//            [indicator stopAnimating];
//            
//            
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:bindCardResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action)
//                                    {
//                                        [alert dismissViewControllerAnimated:YES completion:nil];
//                                        
//                                    }];
//            [alert addAction:cancel];
//            [self presentViewController:alert animated:YES completion:nil];
//        }
        
        [view1.customView bringSubviewToFront:view1.webView];
        [view1.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:bindCardResponseObject.link]]];

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
        NSLog(@"getCardsJsonString:%@",jsonString);
        NSError*err;
        getCardsResponseObject = [[GetCardsResponse alloc] initWithString:jsonString error:&err];

        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:getCardsResponseObject.text code:getCardsResponseObject.code];
        
        
//        if(getCardsResponseObject.code!=nil)
//        {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:getCardsResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
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
//            [indicator stopAnimating];
//        }

        [indicator stopAnimating];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil];
        view1 = [nib objectAtIndex:0];
        view1.delegate=self;
        
        view1.frame = CGRectMake(0,93, self.view.frame.size.width, self.view.frame.size.height - 93);

       [self.view addSubview:view1];
         view1.checkCardLabel.text=@"нет привязанных карт";
        
        
        [view1.customView bringSubviewToFront:view1.addCardButton];
        
        view1.webView.delegate=self;
      
        [view1.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        
        [self.view bringSubviewToFront:leftMenu];
    }];
    
}
-(void)requestGetQiwiBillsUrl
{
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    GetQiwiBillsUrlJson* getQiwiBillsUrlJsonObject=[[GetQiwiBillsUrlJson alloc]init];
    
    NSDictionary*jsonDictionary=[getQiwiBillsUrlJsonObject toDictionary];
    NSString*jsons=[getQiwiBillsUrlJsonObject toJSONString];
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
        NSLog(@"getQiwiBillsUrlJsonString:%@",jsonString);
        NSError*err;
        getQiwiBillsUrlResponseObject = [[GetQiwiBillsUrlResponse alloc] initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:getQiwiBillsUrlResponseObject.text code:getQiwiBillsUrlResponseObject.code];
        
        
//        if(getQiwiBillsUrlResponseObject.code!=nil)
//        {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:getQiwiBillsUrlResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
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
//            [indicator stopAnimating];
//        }
        
        
        [view2.customWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:getQiwiBillsUrlResponseObject.qiwi_bills_url]]];
         [self.view bringSubviewToFront:leftMenu];
        
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
             view1.userInteractionEnabled=NO;
             view2.userInteractionEnabled=NO;
         }
         else
         {
             view1.userInteractionEnabled=YES;
             view2.userInteractionEnabled=YES;
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
             view1.userInteractionEnabled=YES;
             view2.userInteractionEnabled=YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             leftMenu.flag=1;
             view1.userInteractionEnabled=NO;
             view2.userInteractionEnabled=NO;
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
    view1.userInteractionEnabled=NO;
    view2.userInteractionEnabled=NO;
}


- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:nil
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
                                    
                                             view1.frame = CGRectMake(0,93, self.view.frame.size.width, self.view.frame.size.height - 93);
                                              view2.frame = CGRectMake(0,93, self.view.frame.size.width, self.view.frame.size.height-93);
                                     CGFloat x;
                                    
                                         if(leftMenu.flag==0)
                                         {
                                             x=self.view.frame.size.width*(CGFloat)5/6*(-1);
                                         }
                                         else
                                         {
                                             x=0;
                                         }
                                         
                                         leftMenu.frame =CGRectMake(x, leftMenu.frame.origin.y, leftMenu.frame.size.width, self.view.frame.size.height-64);
                                          
                                 }];
    
    [super viewWillTransitionToSize: size withTransitionCoordinator:coordinator];
}
//**********************  openMap  add func your class (.m)*********************//
- (IBAction)openMap:(UIButton*)sender
{
    openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
}

@end