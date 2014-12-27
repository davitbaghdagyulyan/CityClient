//
//  ProfilViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/17/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "ProfilViewController.h"
#import "SendingDocumentsViewController.h"
#import "OpenMapButtonHandler.h"
#import "CardsViewController.h"

@interface ProfilViewController ()
{

    LeftMenu*leftMenu;
    
    UIActivityIndicatorView* indicator;
    
    DriverAllInfoResponse* jsonResponseObject;
    
    CAGradientLayer* gradientLayer;
    OpenMapButtonHandler*openMapButtonHandlerObject;
}
@end

@implementation ProfilViewController

-(void)viewDidLoad
{
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self setDriverInfoRequest];
    [self setDriverInfo];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.gpsButton setNeedsDisplay];
    [GPSConection showGPSConection:self];
    leftMenu=[LeftMenu getLeftMenu:self];
    
    self.segmentedControll.selectedSegmentIndex = 0;
    self.scrollView.userInteractionEnabled=YES;
    self.segmentedControll.userInteractionEnabled=YES;
    
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];
    
    
    self.bgView.backgroundColor = [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1];
    gradientLayer = [self greyGradient];
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame)*9.f/97);
    [self.bgView.layer insertSublayer:gradientLayer atIndex:0];
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

-(void)setDriverInfoRequest
{
    RequestDocScansUrl* RequestDocScansUrlObject=[[RequestDocScansUrl alloc]init];
    RequestDocScansUrlObject.key = [SingleDataProvider sharedKey].key;
    RequestDocScansUrlObject.method = @"getDriverInfo";
    NSDictionary* jsonDictionary = [RequestDocScansUrlObject toDictionary];
    NSString* aa = [RequestDocScansUrlObject toJSONString];
    NSLog(@"%@",aa);
    
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
    request.timeoutInterval = 30;
    
    
    
    NSError* err;
    NSURLResponse *response = [[NSURLResponse alloc]init];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
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
    
    NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"------------======= = = == -%@",jsonString);
    jsonResponseObject = [[DriverAllInfoResponse alloc]initWithString:jsonString error:&err];
    
    BadRequest* badRequest = [[BadRequest alloc]init];
    badRequest.delegate = self;
    [badRequest showErrorAlertMessage:jsonResponseObject.text code:jsonResponseObject.code];

}


-(void)setDriverInfo
{
    [self setAtributedString:self.lastName :jsonResponseObject.last_name];
    [self setAtributedString:self.name :jsonResponseObject.name];
    [self setAtributedString:self.middleName :jsonResponseObject.middle_name];
    
    double percent = [jsonResponseObject.percenttocharge doubleValue];
    NSInteger aaa = round(percent);
    NSString* str = [NSString stringWithFormat:@"%ld",(long)aaa];
    
    [self setAtributedString:self.percentToCharge :[str stringByAppendingString:@"%"]];
    [self setAtributedString:self.passportSer :jsonResponseObject.passport_ser];
    
    [self setAtributedString:self.passportNum :jsonResponseObject.passport_num];
    [self setAtributedString:self.pasportDate :jsonResponseObject.passport_date];
    
    [self setAtributedString:self.dateRegister :jsonResponseObject.date_register];
    
    [self setAtributedString:self.passportWho :jsonResponseObject.passport_who];
    
    //[self setAtributedString:self.passportAddress :jsonResponseObject.passport_address];
    
    [self setAtributedString:self.driverLicenseSerial :jsonResponseObject.driver_license_serial];
    
    [self setAtributedString:self.driverLicenseNumber :jsonResponseObject.driver_license_number];
    
    [self setAtributedString:self.driverLicenseClass :jsonResponseObject.driver_license_class];
    
}


-(void)setAtributedString:(UILabel*)label  :(NSString*)appendingString
{
    if (appendingString) {
        label.text = [label.text stringByAppendingString:@" "];
        label.text = [label.text stringByAppendingString:appendingString];
        NSRange range1 = [label.text rangeOfString:appendingString];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:label.text];
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Bold" size:13]} range:range1];
        label.attributedText=attributedText;
    }
}


-(NSString*)getLink
{
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    
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
    request.timeoutInterval = 30;
    
    
    
    NSError* err;
    NSURLResponse *response = [[NSURLResponse alloc]init];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
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
        return @"";
    }
    NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"--%@",jsonString);
    ResponseGetDocScansUrl* jsonResponseGetUrlObject = [[ResponseGetDocScansUrl alloc]initWithString:jsonString error:&err];
    BadRequest* badRequest = [[BadRequest alloc]init];
    badRequest.delegate = self;
    [badRequest showErrorAlertMessage:jsonResponseGetUrlObject.text code:jsonResponseGetUrlObject.code];
    //NSLog(@"******* %@",jsonResponseObject.doc_scans_url);
    [indicator stopAnimating];
    return jsonResponseGetUrlObject.doc_scans_url;
    
}



- (IBAction)sendDocumentsAction:(UIButton *)sender
{
    SendingDocumentsViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SendingDocumentsViewController"];
    controller.urlString = [self getLink];
    [self.navigationController pushViewController:controller animated:NO];
    
}



- (IBAction)segmentContollAction:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
    }
    if (sender.selectedSegmentIndex == 1)
    {
        CarInfoViewController* carInfoController=[self.storyboard instantiateViewControllerWithIdentifier:@"CarInfoViewController"];
        [self pushOrPopViewController:carInfoController];
        
    }
    if (sender.selectedSegmentIndex == 2) {
        CardsViewController* carInfoController=[self.storyboard instantiateViewControllerWithIdentifier:@"CardsViewController"];
        [self pushOrPopViewController:carInfoController];
    }
}

-(void)pushOrPopViewController:(UIViewController*)controller//
{
    NSArray *viewControlles = self.navigationController.viewControllers;
    
    for (UIViewController* currentController in viewControlles) {
        if ([controller isKindOfClass:currentController.class]) {
            [self.navigationController popToViewController:currentController animated:NO];
            return;
        }
    }
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)edit:(UIButton *)sender
{
    CreateProfilViewController* createProfilController=[self.storyboard instantiateViewControllerWithIdentifier:@"CreateProfilViewController"];
    createProfilController.profilImage = self.profilImageView.image;
    
    createProfilController.middleNameText = jsonResponseObject.middle_name;
    createProfilController.nameText = jsonResponseObject.name;
    createProfilController.lastNameText = jsonResponseObject.last_name;
    
    createProfilController.pasportSerText = jsonResponseObject.passport_ser;
    createProfilController.pasportNumText = jsonResponseObject.passport_num;
    createProfilController.pasportWhoText = jsonResponseObject.passport_who;
    createProfilController.passportDateText = jsonResponseObject.passport_date;
    createProfilController.pasportAdressText = jsonResponseObject.passport_address;
    createProfilController.driverLicenseNumberText = jsonResponseObject.driver_license_number;
    createProfilController.driverLicenseSerialText = jsonResponseObject.driver_license_serial;
    createProfilController.driverLicenseClassText = jsonResponseObject.driver_license_class;
    
    
    
    [self pushOrPopViewController:createProfilController];
    
}


#pragma mark - gradient
- (CAGradientLayer*) greyGradient {
    UIColor *colorOne = [UIColor colorWithRed:198.f/255 green:198.f/255 blue:198.f/255 alpha:1.f];
    UIColor *colorTwo = [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1.f];
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    return headerLayer;
}


#pragma mark - rotation
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame)*9.f/97);
     }
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                                     CGFloat xx;
                                     
                                     if(leftMenu.flag==0)
                                     {
                                         xx=self.view.frame.size.width*(CGFloat)5/6*(-1);
                                     }
                                     else
                                     {
                                         xx=0;
                                     }
                                     leftMenu.frame =CGRectMake(xx, leftMenu.frame.origin.y, leftMenu.frame.size.width, self.view.frame.size.height-64);
                                 }];
    
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
}



#pragma mark - left Menu

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
             self.scrollView.userInteractionEnabled = NO;
             self.segmentedControll.userInteractionEnabled = NO;
             
             self.scrollView.tag=1;
             self.segmentedControll.tag=2;
             [leftMenu.disabledViewsArray removeAllObjects];
    
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.scrollView.tag]];
             
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.segmentedControll.tag]];
         }
         else
         {
             leftMenu.flag=0;
             self.scrollView.userInteractionEnabled = YES;
             self.segmentedControll.userInteractionEnabled = YES;
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
             self.scrollView.userInteractionEnabled = YES;
             self.segmentedControll.userInteractionEnabled = YES;
             
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             self.scrollView.userInteractionEnabled = NO;
             self.segmentedControll.userInteractionEnabled = NO;
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
    
    self.scrollView.userInteractionEnabled = NO;
    self.segmentedControll.userInteractionEnabled = NO;
    
    leftMenu.flag=1;
    
    
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


- (IBAction)openMap:(UIButton*)sender
{
    openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
}

@end
