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

@interface SendingMessageViewController ()
{
    WriteLetterResponse*writeLetterResponseObject;
    LeftMenu*leftMenu;
    NSInteger flag;
}
@end
@implementation SendingMessageViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleTextView.delegate=self;
    self.messageTextView.delegate=self;
    self.titleTextView.text = @"Заголовок";
    self.messageTextView.text = @"Текст сообщения";
    self.titleTextView.textColor = [UIColor lightGrayColor];
    self.messageTextView.textColor = [UIColor lightGrayColor];
    UITapGestureRecognizer*recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchForCloseKeyboard)];
    recognizer.numberOfTapsRequired=1;
    self.writeLetterLabel.userInteractionEnabled=YES;
    [(UIView*)self.writeLetterLabel addGestureRecognizer:recognizer];
    
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    flag=0;
    leftMenu=[LeftMenu getLeftMenu:self];
    
    self.titleTextView.userInteractionEnabled=YES;
    self.messageTextView.userInteractionEnabled=YES;
   
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
   
     if([textView.text isEqualToString:@"Заголовок"]||[textView.text isEqualToString:@"Текст сообщения"])
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
             textView.text = @"Заголовок";
        }
        else
        {
            textView.text = @"Текст сообщения";
        }
       
    }
}
-(void)touchForCloseKeyboard
{
    [self.titleTextView resignFirstResponder];
    [self.messageTextView resignFirstResponder];
}
- (IBAction)sendAction:(UIButton *)sender
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    WriteLetterJson* writeLetterJsonObject=[[WriteLetterJson alloc]init];
    if((![self.titleTextView.text isEqualToString:@"Заголовок"])&&(![self.messageTextView.text isEqualToString:@"Текст сообщения"]))
    {
    writeLetterJsonObject.title=self.titleTextView.text;
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
        NSLog(@"MessagesString%@",jsonString);
        NSError*err;
        writeLetterResponseObject = [[WriteLetterResponse alloc] initWithString:jsonString error:&err];
        

        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        if([writeLetterResponseObject.result isEqual:@1])
        {
            alert.message=@"Запрос успешно отправлен!";
        }
        else if(writeLetterResponseObject.text !=nil)
        {
            alert.title=@"Ошибка запроса";
            alert.message=writeLetterResponseObject.text;
            
        }
        [alert show];
        
        [indicator stopAnimating];
        
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:NO];
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
             self.titleTextView.userInteractionEnabled=NO;
             self.messageTextView.userInteractionEnabled=NO;
         }
         else
         {
             self.titleTextView.userInteractionEnabled=YES;
             self.messageTextView.userInteractionEnabled=YES;
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
             self.titleTextView.userInteractionEnabled=YES;
             self.messageTextView.userInteractionEnabled=YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             flag=1;
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
    self.titleTextView.userInteractionEnabled=NO;
    self.messageTextView.userInteractionEnabled=NO;
}
@end
