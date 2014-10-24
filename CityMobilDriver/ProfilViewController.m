//
//  ProfilViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/17/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "ProfilViewController.h"
#import "FirstScrollView.h"

@interface ProfilViewController ()
{

    NSInteger flag;
    LeftMenu*leftMenu;
    
    FirstView* firstObj;
    secondView* secondObj;
    CreateProfile* createObj;
    UIWebView* webView;
    UIActivityIndicatorView* indicator;
    //FirstScrollView*firstScroll;
    
}
@end

@implementation ProfilViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    firstScroll=[[FirstScrollView alloc]init];
//    firstScroll.curentViewController=self;
    
    
    
    firstObj = [[[NSBundle mainBundle]loadNibNamed:@"FirstView" owner:self options:nil] objectAtIndex:0];
    firstObj.delegate = self;
    firstObj.frame = self.view.frame;
    [self.view addSubview:firstObj];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    flag=0;
    
    leftMenu=[LeftMenu getLeftMenu:self];
    
    firstObj.FirstScrollView.userInteractionEnabled=YES;
    firstObj.segmentControlView.userInteractionEnabled=YES;
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

- (void)showSettingViewController:(UIButton *)sender
{
        SettingsViewController*svc=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        [self.navigationController pushViewController:svc animated:NO];
}
- (void)openAndCloseLeftMenu:(UIButton *)sender
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
             firstObj.FirstScrollView.userInteractionEnabled=NO;
             firstObj.segmentControlView.userInteractionEnabled=NO;
            
         }
         else
         {
             flag=0;
             firstObj.FirstScrollView.userInteractionEnabled=YES;
             firstObj.segmentControlView.userInteractionEnabled=YES;
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
             firstObj.FirstScrollView.userInteractionEnabled=YES;
             firstObj.segmentControlView.userInteractionEnabled=YES;
             
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             firstObj.FirstScrollView.userInteractionEnabled=NO;
             firstObj.segmentControlView.userInteractionEnabled=NO;
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
    
    
    
    
    
    
    
    
    firstObj.FirstScrollView.userInteractionEnabled=NO;
    firstObj.segmentControlView.userInteractionEnabled=NO;
    
    flag=1;
    
    
}


@end
