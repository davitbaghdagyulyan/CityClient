//
//  infoViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "infoViewController.h"
@interface infoViewController ()
{
    int loadCount;
    NSArray* subviewsArray;
}
@end

@implementation infoViewController
@synthesize web;
@synthesize HTMLString;
@synthesize backButton;
@synthesize key;
@synthesize id_mail;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self textJsonRequest];
    
    NSURL* url = [[NSURL alloc]init];
    NSString* str = @"<h3>";
    str =[str stringByAppendingString: self.titleText];
    str =[str stringByAppendingString: @"</h3>"];
    str = [str stringByAppendingString:@"<br><br>"];
    str = [str stringByAppendingString:self.text];
    [web loadHTMLString:str baseURL:url];
    web.delegate = self;
    loadCount = 1;
    HTMLString = str;

    
}



-(void)textJsonRequest
{
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
    
    
    
    NSError* err;
    NSURLResponse *response = [[NSURLResponse alloc]init];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    textResponse* jsonResponseObject = [[textResponse alloc]initWithString:jsonString error:&err];
    
    
    self.text = [[jsonResponseObject.messages objectAtIndex:0] text];

}


- (IBAction)backAction:(id)sender
{
    NSURL* url = [[NSURL alloc]init];
    [web loadHTMLString:HTMLString baseURL:url];
    [backButton removeFromSuperview];
    
    for (int i = 0; i < [subviewsArray count]; ++i)
    {
        UIButton* button = [subviewsArray objectAtIndex:i];
        button.hidden = NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (loadCount % 2 == 0)
    {
        subviewsArray = [self.navigationView subviews];
        for (int i = 0; i < [subviewsArray count]; ++i)
        {
            UIButton* button = [subviewsArray objectAtIndex:i];
            button.hidden = YES;
        }
        
        
        backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 100, 40)];
        backButton.backgroundColor = [UIColor redColor];
        [backButton setTitle:@"BACK" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backButton];
        
    }
    ++loadCount;
}


@end

