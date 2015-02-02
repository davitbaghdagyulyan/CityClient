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
#import "WebViewCell.h"
@interface infoViewController ()
{
    LeftMenu* leftMenu;
    
    UIButton* answerButton;
    
    textResponse* jsonResponseObject;
    OpenMapButtonHandler*openMapButtonHandlerObject;
    
    
    UITableView* infoTable;
    
    NSMutableArray* cellArray;
    UIWebView* requestWebView;
    
}
@end

@implementation infoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    [GPSConection showGPSConection:self];
    leftMenu=[LeftMenu getLeftMenu:self];
    
    
    [self textJsonRequest];
    
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* str = @"";
    
    if ([[jsonResponseObject.messages objectAtIndex:indexPath.row] from_me] == 0) {
        str = [str stringByAppendingString:@"От: Сити мобил</br>"];
    }
    else{
        str = [str stringByAppendingString:@"От: Вас</br>"];
    }
    
//    NSString* dateString = [[jsonResponseObject.messages objectAtIndex:indexPath.row] getDate];
//    str = [str stringByAppendingString:dateString];
    
    
    
    NSString* dateString = [[jsonResponseObject.messages objectAtIndex:indexPath.row] getDate];
    dateString = [self TimeFormat:dateString];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
//    str = [str stringByAppendingString:@"Когда: "];
    str = [str stringByAppendingFormat:@"Когда: %@ </br>",dateString];
    
    
    str = [str stringByAppendingString:[jsonResponseObject.messages[indexPath.row] text]];
    

    
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"</br>"];
    NSLog(@"str = %@",str);
    CGSize maximumLabelSize = CGSizeMake(CGRectGetWidth(infoTable.frame), CGFLOAT_MAX);
    CGRect textRect = [str boundingRectWithSize:maximumLabelSize
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f]}
                                        context:nil];
    

    return textRect.size.height + 30;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [jsonResponseObject.messages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    WebViewCell* cell;
    if([cellArray[indexPath.row] isEqual:@"NO"])
    {
    
        cell = [[NSBundle mainBundle] loadNibNamed:@"WebViewCell" owner:self options:nil][0];
        [cellArray replaceObjectAtIndex:indexPath.row withObject:cell];
        
    
        if (indexPath.row % 2 == 1) {
            [cell.webView setBackgroundColor:[UIColor colorWithRed:240.f/255 green:240.f/255 blue:240.f/255 alpha:1]];
            [cell.webView setOpaque:NO];
        }
        
        NSString* str = @"";
        
        if ([[jsonResponseObject.messages objectAtIndex:indexPath.row] from_me] == 0) {
            str = [str stringByAppendingString:@"<font face=\"Roboto-Bold\">От: </font> <font face=\"Roboto-Regular\">Сити мобил</font></br>"];
        }
        else{
            str = [str stringByAppendingString:@"<font face=\"Roboto-Bold\">От:</font> <font face=\"Roboto-Regular\">Вас</font></br>"];
        }
        
        
        
        NSString* dateString = [[jsonResponseObject.messages objectAtIndex:indexPath.row] getDate];
        dateString = [self TimeFormat:dateString];
        dateString = [dateString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        str = [str stringByAppendingString:@"<font face=\"Roboto-Bold\">Когда: </font>"];
        
        str = [str stringByAppendingFormat:@"<font face=\"Roboto-Regular\"> %@ </font><br>" ,dateString];
        str = [str stringByAppendingFormat:@"<font face=\"Roboto-Regular\"> %@ </font><br>" ,[[jsonResponseObject.messages objectAtIndex:indexPath.row] text]];
        str = [str stringByAppendingString:@"<br>"];
        
        
        
        //str = [str stringByAppendingString:[jsonResponseObject.messages[indexPath.row] text]];
        
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"</br>"];
        
        ///// TEST ////
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"linkFile" ofType:@"txt"];
//        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//        
//        str = [str stringByAppendingString:content];
        
        ////// END TEST ////
        
        
        [cell.webView loadHTMLString:str baseURL:nil];
        cell.webView.scrollView.scrollEnabled = NO;
        cell.webView.delegate = self;

    
    }
    else{
        return cellArray[indexPath.row];
    }
    return cell;
}


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    if(navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        requestWebView = [[UIWebView alloc]initWithFrame:
                              CGRectMake(5, 65,
                              CGRectGetWidth(self.view.frame) - 10,
                              CGRectGetHeight(self.view.frame) - 65)];
        requestWebView.backgroundColor = [UIColor whiteColor];
        [requestWebView loadHTMLString:@"" baseURL:nil];
        [requestWebView loadRequest:request];
        [self.view addSubview:requestWebView];
        
    }
    return YES;
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
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:jsonResponseObject.text code:jsonResponseObject.code];
        

        self.descriptionLabel.text = [NSString stringWithFormat:@" %@", self.titleText];
        
        if (jsonResponseObject.can_answer == 1) {
            answerButton = [[UIButton alloc]initWithFrame:CGRectMake(5, self.view.frame.size.height - 41, self.view.frame.size.width - 10, 36)];
            answerButton.backgroundColor = [UIColor orangeColor];
            [answerButton addTarget:self action:@selector(pushSendingMessage) forControlEvents:UIControlEventTouchUpInside];
            [answerButton setTitle:@"Ответить" forState:UIControlStateNormal];
            [self.view addSubview:answerButton];
        }
        

        
        
        cellArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < [jsonResponseObject.messages count]; ++i) {
            [cellArray addObject:@"NO"];
        }
        
        infoTable = [[UITableView alloc]initWithFrame:CGRectMake(5, 94, CGRectGetWidth(self.view.frame) - 10, CGRectGetHeight(self.view.frame) - 64 - 30 - 36 - 10)];
        infoTable.separatorColor = [UIColor whiteColor];
        infoTable.delegate = self;
        infoTable.dataSource = self;
        infoTable.backgroundColor = [UIColor whiteColor];
        infoTable.tintColor = [UIColor whiteColor];
        [self.view addSubview:infoTable];
        [indicator stopAnimating];
    }];
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


#pragma mark - Rotation
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         answerButton.frame = CGRectMake(5, self.view.frame.size.height - 41, self.view.frame.size.width - 10, 36);
         infoTable.frame = CGRectMake(5, 94, CGRectGetWidth(self.view.frame) - 10, CGRectGetHeight(self.view.frame) - 64 - 30 - 36 - 10);
         
         [infoTable reloadData];
         
         requestWebView.frame = CGRectMake(5, 65,
                                CGRectGetWidth(self.view.frame) - 10,
                                CGRectGetHeight(self.view.frame) - 65);
         
         

         for (int i = 0; i < cellArray.count; ++i) {
             [cellArray replaceObjectAtIndex:i withObject:@"NO"];
         }
         
     }
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
         
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



/////////////////////////


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
             answerButton.userInteractionEnabled=NO;
             
             answerButton.tag=2;
             
             [leftMenu.disabledViewsArray removeAllObjects];
             
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:answerButton.tag]];
             
         }
         else
         {
             leftMenu.flag=0;
             answerButton.userInteractionEnabled=YES;
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
             leftMenu.flag=0;
             answerButton.userInteractionEnabled=YES;
             
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             answerButton.userInteractionEnabled=NO;
             
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
    answerButton.userInteractionEnabled=NO;
    leftMenu.flag=1;
}

- (IBAction)openMap:(UIButton*)sender
{
    openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
}



@end

