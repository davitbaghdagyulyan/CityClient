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
#import "CustomView2.h"
#import "SetDriverPaymentJson.h"
#import "SetDriverPaymentResponse.h"

@interface ReplenishmentViewController ()
{
    OpenMapButtonHandler*openMapButtonHandlerObject;
    CustomWebView*view2;
    CustomView*view1;
    CustomView2*view1_2;
    UIActivityIndicatorView* indicator;
    GetQiwiBillsUrlResponse*getQiwiBillsUrlResponseObject;
    GetCardsResponse*getCardsResponseObject;
    BindCardResponse*bindCardResponseObject;
    NSInteger loadcount;
     NSInteger loadcount2;
    LeftMenu*leftMenu;
    ComboBoxTableView*comboBoxTableView;
    BOOL isPressedCloseButton;
    NSUInteger indexOfCard;
    BOOL view1IsLoad;
    BOOL view1_2ScrollIsLoad;
    UIScrollView*view1_2ScrollView;

}
@end

@implementation ReplenishmentViewController
-(void)viewDidAppear:(BOOL)animated
{
     [super viewDidAppear:animated];
    
    if([ApiAbilitiesSingleTon sharedApiAbilities].yandex_enabled)
    {
        self.yandexButton.hidden=NO;
    }
    else
    {
        self.yandexButton.hidden=YES;
    }
    
    [self registerForKeyboardNotifications];
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
    view1IsLoad=YES;
    view1_2ScrollIsLoad=YES;
    isPressedCloseButton=NO;
   
    loadcount=0;
    loadcount2=0;
   
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
            [view1_2 removeFromSuperview];
            if (!loadcount2)
            {
                
                CGPoint point;
                point.x=0;
                point.y=93;
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomWebView" owner:self options:nil];
                view2 = [nib objectAtIndex:0];
               view2.customWebView.delegate=self;
                view2.frame = CGRectMake(5,98, self.view.frame.size.width-10, self.view.frame.size.height - 98);
                [self.view addSubview:view2];
                
                [self requestGetQiwiBillsUrl];
                
            }
            else
            {
                
                [self.view addSubview:view2];
                [self.view bringSubviewToFront:leftMenu];
            }
            
         
        }
            break;
        default:
            break;
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   
    
    if ([webView isEqual:view1.webView])
    {
//        if (![webView.request.URL isEqual:[NSURL URLWithString:@"about:blank"]])
//        {
//            
//        }
        
        NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        BOOL isEmpty = string==nil || [string length]==0;
        if(isEmpty)
        {
            
            isPressedCloseButton=YES;
            [view1.customView bringSubviewToFront:view1.addCardButton];
            [self requestGetCards];
            
        }
        else
        {
          loadcount=1;
        }
    }
    else
    {
        loadcount2=1;
    }
   
        [indicator stopAnimating];
    
    
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
        NSLog(@"getCardsJsonString:%@",jsonString);
        NSError*err;
        getCardsResponseObject = [[GetCardsResponse alloc] initWithString:jsonString error:&err];

/*********************************Karen Change*********************************************************************/
//*
      
       BadRequest* badRequest = [[BadRequest alloc]init];
       badRequest.delegate = self;
      [badRequest showErrorAlertMessage:getCardsResponseObject.text code:getCardsResponseObject.code];

//*
/*********************************End Karen Change**********************************************************************/
        
      if(getCardsResponseObject.cards.count==0)
      {
          [view1 removeFromSuperview];
         
          if (view1IsLoad)
          {
              NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil];
              view1 = [nib objectAtIndex:0];
              view1.delegate=self;
               view1IsLoad=NO;
              view1.frame = CGRectMake(5,98, self.view.frame.size.width-10, self.view.frame.size.height - 98);
              view1.webView.delegate=self;
              [view1.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
          }
          
          [self.view addSubview:view1];
          view1.checkCardLabel.text=@"нет привязанных карт";
          
          
          [view1.customView bringSubviewToFront:view1.addCardButton];
          
          
          
        
         
      }
      else
        {
            [view1 removeFromSuperview];
             if (view1_2ScrollIsLoad)
             {
            view1_2ScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(5,98, self.view.frame.size.width-10, self.view.frame.size.height - 98)];
                     view1_2ScrollIsLoad=NO;
             }
            CGSize size={view1_2ScrollView.bounds.size.width,view1_2ScrollView.bounds.size.height};
            view1_2ScrollView.contentSize=size;
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomView2" owner:self options:nil];
            view1_2 = [nib objectAtIndex:0];
            view1_2.frame =view1_2ScrollView.bounds;
            
            [view1_2ScrollView addSubview:view1_2];
            
         
              [self.view addSubview:view1_2ScrollView];
                 
            view1_2.chooseCardLabel.text=[[getCardsResponseObject.cards objectAtIndex:0] getPan];

            UITapGestureRecognizer* tapGasture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showComboBox)];
            [view1_2.cardsView addGestureRecognizer:tapGasture1];
            
            UITapGestureRecognizer* tapGasture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
            [view1_2 addGestureRecognizer:tapGasture2];
            
            view1_2.delegate=self;
            view1_2.priceTextField.keyboardType=UIKeyboardTypeNumberPad;
            indexOfCard=0;
            view1_2.priceTextField.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
            

        }

        [indicator stopAnimating];
        
        
        [self.view bringSubviewToFront:leftMenu];
    }];
    
}

-(void)closeKeyboard
{
    [view1_2.priceTextField resignFirstResponder];
}
-(void)showComboBox
{
    static int i=1;
    if (i)
    {
        comboBoxTableView=[[ComboBoxTableView alloc] init];
        comboBoxTableView.myDelegate = self;
        NSLog(@"%@",getCardsResponseObject.cards);
        NSLog(@"%@",NSStringFromCGPoint(self.view.center));
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        for(int j=0;j<getCardsResponseObject.cards.count;j++)
        {
            [arr addObject:[[getCardsResponseObject.cards objectAtIndex:j] getPan]];
        }
        comboBoxTableView.titles = arr;
        [comboBoxTableView func];
        
    }
    else
    {
        [comboBoxTableView.superview setHidden:NO];
    }
    i=0;
}

#pragma mark - ComboBoxDelegate
-(void) didSelectWithIndex:(NSUInteger)index andTitle:(NSString*)title
{
    [comboBoxTableView.superview setHidden:YES];
    view1_2.chooseCardLabel.text=title;
    indexOfCard=index;
    
}
#pragma mark - View1_2Delegate

-(void)setDriverPaymentRequest
{
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    SetDriverPaymentJson* setDriverPaymentJsonObject=[[SetDriverPaymentJson alloc]init];
    setDriverPaymentJsonObject.id_card=[[getCardsResponseObject.cards objectAtIndex:indexOfCard]getMyCardId];
    setDriverPaymentJsonObject.sum=view1_2.priceTextField.text;
    
    NSDictionary*jsonDictionary=[setDriverPaymentJsonObject toDictionary];
    NSString*jsons=[setDriverPaymentJsonObject toJSONString];
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
        NSLog(@"responseString:%@",jsonString);
        NSError*err;
        
        SetDriverPaymentResponse*setDriverPaymentResponseObject = [[SetDriverPaymentResponse alloc] initWithString:jsonString error:&err];
        
        
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:setDriverPaymentResponseObject.text code:setDriverPaymentResponseObject.code];
        if(setDriverPaymentResponseObject.code==nil)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "" message:setDriverPaymentResponseObject.message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
       [indicator stopAnimating];
    }];

}


-(void)setDriverPayment
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Подтвердите платеж" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
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
                                [self setDriverPaymentRequest];
                                
                            }];
    [alert addAction:ok];
    
    
    [self presentViewController:alert animated:YES completion:nil];

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
             view1.userInteractionEnabled=NO;
             view2.userInteractionEnabled=NO;
             view1_2ScrollView.userInteractionEnabled=NO;
             
             view1.tag=1;
             view2.tag=2;
             view1_2ScrollView.tag=3;
             
             [leftMenu.disabledViewsArray removeAllObjects];
          
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:view1.tag]];
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:view2.tag]];
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:view1_2ScrollView.tag]];
         }
         else
         {
             view1.userInteractionEnabled=YES;
             view2.userInteractionEnabled=YES;
             view1_2ScrollView.userInteractionEnabled=YES;
             leftMenu.flag=0;
         }
     }
     ];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view bringSubviewToFront:leftMenu];
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
              view1_2ScrollView.userInteractionEnabled=YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             leftMenu.flag=1;
             view1.userInteractionEnabled=NO;
             view2.userInteractionEnabled=NO;
              view1_2ScrollView.userInteractionEnabled=NO;
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
    view1_2ScrollView.userInteractionEnabled=NO;
}


- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:nil
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
                                     view1_2ScrollView.contentOffset=CGPointZero;
                                     [view1_2.priceTextField resignFirstResponder];
                                             view1.frame = CGRectMake(5,98, self.view.frame.size.width-10, self.view.frame.size.height - 98);
                                              view2.frame = CGRectMake(5,98, self.view.frame.size.width-10, self.view.frame.size.height-98);
                                     view1_2ScrollView.frame=CGRectMake(5,98, self.view.frame.size.width-10, self.view.frame.size.height - 98);
                                     CGSize size={view1_2ScrollView.bounds.size.width,view1_2ScrollView.bounds.size.height};
                                     view1_2ScrollView.contentSize=size;
                                     view1_2.frame =view1_2ScrollView.bounds;
                                    
                                     comboBoxTableView.center=self.view.center;
                                     CGFloat x;
                                    
                                         if(leftMenu.flag==0)
                                         {
                                             x=320*(CGFloat)5/6*(-1);
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

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height+20, 0.0);
   view1_2ScrollView.contentInset = contentInsets;
    view1_2ScrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
  
   if (!CGRectContainsPoint(aRect, view1_2.priceTextField.frame.origin) )
    {
        [view1_2ScrollView scrollRectToVisible:view1_2.priceTextField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    view1_2ScrollView.contentInset = contentInsets;
    view1_2ScrollView.scrollIndicatorInsets = contentInsets;
}




@end