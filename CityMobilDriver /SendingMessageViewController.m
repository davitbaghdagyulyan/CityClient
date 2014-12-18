//
//  SendingMessageViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/16/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//
#import "WriteLetterJson.h"
#import "WriteLetterResponse.h"
#import "SendingMessageViewController.h"
#import "OpenMapButtonHandler.h"

@interface SendingMessageViewController ()
{
    WriteLetterResponse*writeLetterResponseObject;
    LeftMenu*leftMenu;
    CGFloat yCord;
    OpenMapButtonHandler*openMapButtonHandlerObject;
    CGSize expectSize;
    BOOL isOpenKeyboard;
    CGSize keyboardSize ;
}
@end
@implementation SendingMessageViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    isOpenKeyboard=NO;
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];
    
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(10, 66, self.view.frame.size.width-20, self.view.frame.size.height-116)];
    self.writeLetterLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 50)];
    self.underView=[[UIView alloc]initWithFrame:CGRectMake(0, 50, self.scrollView.frame.size.width, self.scrollView.frame.size.height-50)];
     self.titleTextView=[[UITextView alloc] initWithFrame:CGRectMake(10, 8, self.scrollView.frame.size.width-20, 40)];
     self.messageTextView=[[UITextView alloc] initWithFrame:CGRectMake(10, 60, self.scrollView.frame.size.width-20, 80)];
    yCord=CGRectGetMaxY(self.messageTextView.frame);
    self.sendButton=[[UIButton alloc]initWithFrame:CGRectMake(10, self.scrollView.frame.origin.y+self.scrollView.frame.size.height+5, self.scrollView.frame.size.width,40)];
    [self.view addSubview:self.scrollView];
    
 
    self.writeLetterLabel.text=@"Написать письмо";
    self.writeLetterLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
    self.writeLetterLabel.textColor=[UIColor blackColor];
    self.writeLetterLabel.textAlignment=NSTextAlignmentCenter;
    
    
    self.underView.backgroundColor=[UIColor colorWithRed:(float)217/255 green:(float)217/255 blue:(float)217/255 alpha:1];
    
    
   
    
    
    [self.sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    self.sendButton.backgroundColor=[UIColor orangeColor];
    [self.sendButton setTitle:@"Отправить" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.scrollView addSubview:self.writeLetterLabel];
    [self.scrollView addSubview:self.underView];
    [self.underView addSubview:self.titleTextView];
    [self.underView addSubview:self.messageTextView];
    [self.view addSubview:self.sendButton];
    
    [self.scrollView addSubview:self.writeLetterLabel];
    [self.scrollView addSubview:self.underView];
    self.titleTextView.delegate=self;
    self.messageTextView.delegate=self;
    self.messageTextView.scrollEnabled=NO;
    self.titleTextView.text = @" Заголовок";
    self.messageTextView.text = @" Текст сообщения";
    self.titleTextView.textColor = [UIColor lightGrayColor];
    self.messageTextView.textColor = [UIColor lightGrayColor];
    UITapGestureRecognizer*recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchForCloseKeyboard)];
    recognizer.numberOfTapsRequired=1;
    self.writeLetterLabel.userInteractionEnabled=YES;
    [(UIView*)self.writeLetterLabel addGestureRecognizer:recognizer];
    self.scrollView.contentSize=CGSizeMake(self.scrollView.frame.size.width, yCord);
    [self registerForKeyboardNotifications];
    // Do any additional setup after loading the view.
    
    if (self.isPushWidthInfoController)
    {
        self.titleTextView.text = [NSString stringWithFormat:@"Re: %@",self.titleText];
        self.titleTextView.userInteractionEnabled = NO;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    leftMenu.flag=0;
    leftMenu=[LeftMenu getLeftMenu:self];
    
    //self.titleTextView.userInteractionEnabled=YES;
    self.messageTextView.userInteractionEnabled=YES;
    
}

- (IBAction)back:(id)sender
    {
        if (leftMenu.flag)
        {
            CGPoint point;
            point.x=leftMenu.center.x-leftMenu.frame.size.width;
            point.y=leftMenu.center.y;
            leftMenu.center=point;
        }
        [self.navigationController popViewControllerAnimated:NO];
        
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    if ([textView isEqual:self.messageTextView])
         {

    CGSize maximumLabelSize = CGSizeMake(self.messageTextView.frame.size.width,800);
    expectSize = [self.messageTextView sizeThatFits:maximumLabelSize];
             
             NSLog(@"%f",CGRectGetMaxY(self.underView.frame));
             if (expectSize.height>80)
             {
                 self.messageTextView.frame=CGRectMake(self.messageTextView.frame.origin.x, self.messageTextView.frame.origin.y, self.messageTextView.frame.size.width,expectSize.height);
                 yCord=CGRectGetMaxY(self.messageTextView.frame);
                 
                 if ((yCord+60>self.scrollView.frame.size.height))
                 {
                 self.underView.frame=CGRectMake(self.underView.frame.origin.x, self.underView.frame.origin.y, self.underView.bounds.size.width, yCord+10);
                 }
             }
             if (isOpenKeyboard)
             {
                 self.scrollView.contentSize=CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+keyboardSize.height-(self.scrollView.frame.size.height-(self.messageTextView.frame.origin.y+self.messageTextView.frame.size.height))+10);

             }
             else
             {
             self.scrollView.contentSize=CGSizeMake(self.scrollView.frame.size.width, yCord+60);
             }
             
             CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
             [self.scrollView setContentOffset:bottomOffset animated:YES];
   
         }
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
   
     if([textView.text isEqualToString:@" Заголовок"]||[textView.text isEqualToString:@" Текст сообщения"])
     {
       textView.text = @"";
       textView.textColor = [UIColor blackColor];
     }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length == 0)
    {
        textView.textColor = [UIColor lightGrayColor];
        if (textView==self.titleTextView)
        {
             textView.text = @" Заголовок";
        }
        else
        {
            textView.text = @" Текст сообщения";
        }
       
    }
}

-(void)openMap:(UIButton *)sender
{
    openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
}

-(void)touchForCloseKeyboard
{
    [self.titleTextView resignFirstResponder];
    [self.messageTextView resignFirstResponder];
}
- (void)sendAction
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    WriteLetterJson* writeLetterJsonObject=[[WriteLetterJson alloc]init];
    if((![self.titleTextView.text isEqualToString:@" Заголовок"])&&(![self.messageTextView.text isEqualToString:@" Текст сообщения"]))
    {
        if (self.isPushWidthInfoController) {
            writeLetterJsonObject.title=self.titleText;
            writeLetterJsonObject.id_mail = self.id_mail;
        }
        else{
            writeLetterJsonObject.title=self.titleTextView.text;
        }
    writeLetterJsonObject.text=self.messageTextView.text;
    }
    NSDictionary*jsonDictionary=[writeLetterJsonObject toDictionary];
    NSString*jsons=[writeLetterJsonObject toJSONString];
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
        NSLog(@"MessagesString%@",jsonString);
        NSError*err;
        writeLetterResponseObject = [[WriteLetterResponse alloc] initWithString:jsonString error:&err];
        

        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    [self.navigationController popViewControllerAnimated:NO];
                                }];
        [alert addAction:cancel];
       
        

        if([writeLetterResponseObject.result isEqual:@1])
        {
            alert.message=@"Запрос успешно отправлен!";
        }
        else if(writeLetterResponseObject.text !=nil)
        {
            alert.title=@"Ошибка запроса";
            alert.message=writeLetterResponseObject.text;
            
        }
         [self presentViewController:alert animated:YES completion:nil];
        
        [indicator stopAnimating];
        
    }];
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
    isOpenKeyboard=YES;
    NSDictionary* info = [aNotification userInfo];
   keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.scrollView.contentSize=CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+keyboardSize.height-(self.scrollView.frame.size.height-(self.messageTextView.frame.origin.y+self.messageTextView.frame.size.height))+10);
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    isOpenKeyboard=NO;
    self.scrollView.contentSize=CGSizeMake(self.scrollView.frame.size.width, yCord+60);
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
             self.titleTextView.userInteractionEnabled=NO;
             self.messageTextView.userInteractionEnabled=NO;
         }
         else
         {
             self.titleTextView.userInteractionEnabled=YES;
             self.messageTextView.userInteractionEnabled=YES;
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
             self.titleTextView.userInteractionEnabled=YES;
             self.messageTextView.userInteractionEnabled=YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             leftMenu.flag=1;
             self.titleTextView.userInteractionEnabled=NO;
             self.messageTextView.userInteractionEnabled=NO;
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
    self.titleTextView.userInteractionEnabled=NO;
    self.messageTextView.userInteractionEnabled=NO;
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:nil
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
         self.scrollView.frame=CGRectMake(10, 66, self.view.frame.size.width-20, self.view.frame.size.height-116);
         self.writeLetterLabel.frame=CGRectMake(0, 0, self.scrollView.frame.size.width, 50);
         self.messageTextView.frame=CGRectMake(10, 60, self.scrollView.frame.size.width-20, self.messageTextView.frame.size.height);
//         yCord=(CGRectGetMaxY(self.messageTextView.frame));
         if ((yCord+60<self.scrollView.frame.size.height-50))
         {
             self.underView.frame=CGRectMake(0, 50, self.scrollView.frame.size.width,self.scrollView.frame.size.height-50);
         }
         else
         {
             self.underView.frame=CGRectMake(0, 50, self.scrollView.frame.size.width, yCord+60);
         }
    
         
         self.titleTextView.frame=CGRectMake(10, 8, self.scrollView.frame.size.width-20, 40);
         
         self.sendButton.frame=CGRectMake(10, self.scrollView.frame.origin.y+self.scrollView.frame.size.height+5, self.scrollView.frame.size.width,40);
     self.scrollView.contentSize=CGSizeMake(self.scrollView.frame.size.width,yCord+60);
         CGFloat xx;
         
         if(leftMenu.flag==0)
         {
             xx=self.view.frame.size.width*(CGFloat)5/6*(-1);
         }
         else
         {
             xx=0;
         }
         
         leftMenu.frame =CGRectMake(xx, leftMenu.frame.origin.y,leftMenu.frame.size.width, self.view.frame.size.height-64);
         
     }];
    
    [super viewWillTransitionToSize: size withTransitionCoordinator:coordinator];
}

@end
