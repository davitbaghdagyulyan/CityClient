//
//  ProfilViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/17/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "ProfilViewController.h"


@interface ProfilViewController ()
{
    FirstView* firstObj;
    secondView* secondObj;
    CreateProfile* createObj;
    UIWebView* webView;
    UIActivityIndicatorView* indicator;
}
@end

@implementation ProfilViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    firstObj = [[[NSBundle mainBundle]loadNibNamed:@"FirstView" owner:self options:nil] objectAtIndex:0];
    firstObj.delegate = self;
    firstObj.frame = self.view.frame;
    [self.view addSubview:firstObj];    
}






- (void)segmentControlAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 1)
    {
        secondObj = [[[NSBundle mainBundle]loadNibNamed:@"secondView" owner:self options:nil] objectAtIndex:0];
        secondObj.frame = self.view.frame;
        [self.view addSubview:secondObj];
    }
}

- (void)edit:(UIButton *)sender
{
    createObj = [[[NSBundle mainBundle]loadNibNamed:@"CreateProfil" owner:self options:nil] objectAtIndex:0];
    createObj.frame = self.view.frame;
    createObj.delegate = self;

    [self removeSubViews];
    [self.view addSubview:createObj];
}
-(BOOL)IsPhotoEqual
{
    NSData* data1 = UIImagePNGRepresentation(firstObj.profilPhoto.image);
    NSData* data2 = UIImagePNGRepresentation(createObj.createPhotoImageView.image);
    return [data1 isEqual:data2];
}




- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
     }
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
                                     firstObj.frame = self.view.frame;
                                     secondObj.frame = self.view.frame;
                                     createObj.frame = self.view.frame;
                                 }];
    
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
}


-(void)removeSubViews
{
    for (UIView* subView in [self.view subviews])
    {
        [subView removeFromSuperview];
    }
}


-(NSString*)getLink
{
    RequestDocScansUrl* RequestDocScansUrlObject=[[RequestDocScansUrl alloc]init];
    RequestDocScansUrlObject.key = [SingleDataProvider sharedKey].key;
    NSDictionary* jsonDictionary = [RequestDocScansUrlObject toDictionary];
    
    
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
    //NSLog(@"--%@",jsonString);
    ResponseGetDocScansUrl* jsonResponseObject = [[ResponseGetDocScansUrl alloc]initWithString:jsonString error:&err];
    //NSLog(@"******* %@",jsonResponseObject.doc_scans_url);
    return jsonResponseObject.doc_scans_url;
}

- (void)sendDocumentsAction:(UIButton *)sender
{
    webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    webView.delegate = self;
    [self removeSubViews];
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self getLink]]]];
    [self.view addSubview:webView];
    [webView addSubview:indicator];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [indicator stopAnimating];
}


@end
