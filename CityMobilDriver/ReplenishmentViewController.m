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

@interface ReplenishmentViewController ()
{
    
    CustomWebView*view2;
    CustomView*view1;
    UIActivityIndicatorView* indicator;
    GetQiwiBillsUrlResponse*getQiwiBillsUrlResponseObject;
    GetCardsResponse*getCardsResponseObject;
    BindCardResponse*bindCardResponseObject;
    NSInteger loadcount;
    LeftMenu*leftMenu;
    NSInteger flag;
    BOOL isPressedCloseButton;
}
@end

@implementation ReplenishmentViewController
-(void)viewDidAppear:(BOOL)animated
{
    
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

    flag=0;
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"NO INTERNET CONECTION"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            
            [alert show];
            [indicator stopAnimating];
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"bindCardResponseJsonString:%@",jsonString);
        NSError*err;
        bindCardResponseObject = [[BindCardResponse alloc] initWithString:jsonString error:&err];

        if(bindCardResponseObject.code!=nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка запроса"
                                                            message:bindCardResponseObject.text
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [indicator stopAnimating];
        }
        
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"NO INTERNET CONECTION"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            
            [alert show];
            [indicator stopAnimating];
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"getCardsJsonString:%@",jsonString);
        NSError*err;
        getCardsResponseObject = [[GetCardsResponse alloc] initWithString:jsonString error:&err];

        if(getCardsResponseObject.code!=nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка запроса"
                                                            message:getCardsResponseObject.text
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [indicator stopAnimating];
        }

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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"NO INTERNET CONECTION"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            
            [alert show];
            [indicator stopAnimating];
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"getQiwiBillsUrlJsonString:%@",jsonString);
        NSError*err;
        getQiwiBillsUrlResponseObject = [[GetQiwiBillsUrlResponse alloc] initWithString:jsonString error:&err];
        
        
        
        
        if(getQiwiBillsUrlResponseObject.code!=nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка запроса"
                                                            message:getQiwiBillsUrlResponseObject.text
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [indicator stopAnimating];
        }
        
        
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
             view1.userInteractionEnabled=NO;
             view2.userInteractionEnabled=NO;
         }
         else
         {
             view1.userInteractionEnabled=YES;
             view2.userInteractionEnabled=YES;
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
             view1.userInteractionEnabled=YES;
             view2.userInteractionEnabled=YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             flag=1;
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
                                    
                                         if(flag==0)
                                         {
                                             x=self.view.frame.size.width*(CGFloat)5/6*(-1);
                                         }
                                         else
                                         {
                                             x=0;
                                         }
                                         
                                         leftMenu.frame =CGRectMake(x, leftMenu.frame.origin.y, self.view.frame.size.width*(CGFloat)5/6, self.view.frame.size.height-64);
                                          
                                 }];
    
    [super viewWillTransitionToSize: size withTransitionCoordinator:coordinator];
}
@end