//
//  infoViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "infoViewController.h"
#import "SendingMessageViewController.h"
#import "OpenMapButtonHandler.h"
@interface infoViewController ()
{
    NSInteger flag;
    LeftMenu* leftMenu;

    UIButton* answerButton;
    NSString* HTMLString;
    
    textResponse* jsonResponseObject;
    OpenMapButtonHandler*openMapButtonHandlerObject;
}
@end

@implementation infoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.web.scrollView.delegate = self;
    self.web.scrollView.showsHorizontalScrollIndicator = NO;
    [self textJsonRequest];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.web.userInteractionEnabled=YES;
    flag = 0;
    leftMenu=[LeftMenu getLeftMenu:self];
}
-(void)textJsonRequest
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    textRequest* textJsonObject=[[textRequest alloc]init];
    textJsonObject.key = [SingleDataProvider sharedKey].key;
    textJsonObject.id_mail = self.id_mail;
    NSDictionary* jsonDictionary = [textJsonObject toDictionary];
    
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
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            return ;
        }
        
        NSError* err;
        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",jsonString);
        jsonResponseObject = [[textResponse alloc]initWithString:jsonString error:&err];
        
        NSURL* url = [[NSURL alloc]init];
        
        NSString *str = [[NSString alloc]init];
        self.descriptionLabel.text = [NSString stringWithFormat:@" %@", self.titleText];
        self.web.opaque = NO;//????
        for (int i = 0; i < [jsonResponseObject.messages count]; ++i) {
            if ([[jsonResponseObject.messages objectAtIndex:i] from_me] == 0) {
                str = [str stringByAppendingString:@"<b><font size=\"4\">От: </font></b> Сити мобил</br>"];
            }
            else{
                str = [str stringByAppendingString:@"<b><font size=\"4\">От: </font></b> Вас</br>"];
            }
            
            
            NSString* dateString = [[jsonResponseObject.messages objectAtIndex:i] getDate];
            dateString = [self TimeFormat:dateString];
            dateString = [dateString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            str = [str stringByAppendingString:@"<b><font size=\"4\">Когда: </font></b>"];
            str = [str stringByAppendingFormat:@"<font size=\"4\"> %@ </font><br>" ,dateString];
            str = [str stringByAppendingString:[[jsonResponseObject.messages objectAtIndex:i] text]];
            str = [str stringByAppendingString:@"</font><br>"];
            
//            if (i%2 == 1) {
//                UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 65*i,CGRectGetWidth(self.web.frame), 65)];
//                view.userInteractionEnabled = NO;
//                
//                view.backgroundColor = [UIColor grayColor];
//                view.alpha = 0.09;
//                [self.web.scrollView addSubview:view];
//            }
        }
        
        if ([jsonResponseObject.messages count] < 8) {
            self.web.scrollView.scrollEnabled = NO;
        }
        
        HTMLString = str;
        
        if (jsonResponseObject.can_answer == 1) {
            answerButton = [[UIButton alloc]initWithFrame:CGRectMake(8, self.view.frame.size.height - 44, self.view.frame.size.width - 16, 36)];
            answerButton.backgroundColor = [UIColor orangeColor];
            [answerButton addTarget:self action:@selector(pushSendingMessage) forControlEvents:UIControlEventTouchUpInside];
            [answerButton setTitle:@"Ответить" forState:UIControlStateNormal];
            [self.view addSubview:answerButton];
        }
        
        //str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
        [self.web loadHTMLString:str baseURL:url];
        self.web.delegate = self;
        
        [indicator stopAnimating];
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    if (sender.contentOffset.x != 0)
    {
        CGPoint offset = sender.contentOffset;
        offset.x = 0;
        sender.contentOffset = offset;
    }
}

-(void)pushSendingMessage{
    SendingMessageViewController* contorller = [self.storyboard instantiateViewControllerWithIdentifier:@"SendingMessageViewController"];
    contorller.isPushWidthInfoController = YES;
    contorller.titleText = self.titleText;
    contorller.id_mail = self.id_mail;
    
    [self.navigationController pushViewController:contorller animated:NO];
}

-(NSString*)TimeFormat:(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:string];
    /////////convert nsdata To NSString////////////////////////////////////
    [dateFormatter setDateFormat:@"dd-MM-yy HH:mm"];
    
    if(date==nil) return @"";
    
    return [dateFormatter stringFromDate:date];
    
}


#pragma mark - rotation

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         NSURL* url = [[NSURL alloc]init];
         [self.web loadHTMLString:HTMLString baseURL:url];
          answerButton.frame = CGRectMake(8, self.view.frame.size.height - 44, self.view.frame.size.width - 16, 36);
     }
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
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
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
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



/////////////////////////


- (IBAction)openAndCloseLeftMenu:(UIButton *)sender
{
    [self.view bringSubviewToFront:leftMenu];
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
             self.web.userInteractionEnabled=NO;
             answerButton.userInteractionEnabled=NO;
             
         }
         else
         {
             flag=0;
             self.web.userInteractionEnabled=YES;
             answerButton.userInteractionEnabled=YES;
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
    [self.view bringSubviewToFront:leftMenu];
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
             self.web.userInteractionEnabled=YES;
             answerButton.userInteractionEnabled=YES;
             
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             self.web.userInteractionEnabled=NO;
             answerButton.userInteractionEnabled=NO;
             
             flag=1;
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
    if (flag==0 && touchLocation.x>((float)1/16 *self.view.frame.size.width))
        return;
    CGPoint point;
    point.x= touchLocation.x- (CGFloat)leftMenu.frame.size.width/2;
    point.y=leftMenu.center.y;
    if (point.x>leftMenu.frame.size.width/2)
    {
        return;
    }
    leftMenu.center=point;
    self.web.userInteractionEnabled=NO;
    answerButton.userInteractionEnabled=NO;
    flag=1;
}

- (IBAction)openMap:(UIButton*)sender
{
    openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
}



@end

