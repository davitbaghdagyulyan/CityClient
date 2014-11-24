//
//  ProfilViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/17/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "ProfilViewController.h"
#import "SendingDocumentsViewController.h"

@interface ProfilViewController ()
{

    NSInteger flag;
    LeftMenu*leftMenu;
    
    UIActivityIndicatorView* indicator;
    
    DriverAllInfoResponse* jsonResponseObject;
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
    self.segmentedControll.selectedSegmentIndex = 0;
    
    flag=0;
    leftMenu=[LeftMenu getLeftMenu:self];
    self.scrollView.userInteractionEnabled=YES;
    self.segmentedControll.userInteractionEnabled=YES;
    self.segmentedControll.userInteractionEnabled=YES;
    
    
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];
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
    request.timeoutInterval = 10;
    
    
    
    NSError* err;
    NSURLResponse *response = [[NSURLResponse alloc]init];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"------------======= = = == -%@",jsonString);
    jsonResponseObject = [[DriverAllInfoResponse alloc]initWithString:jsonString error:&err];
    jsonResponseObject.delegate = self;

}


-(void)setDriverInfo
{
    [self setAtributedString:self.lastName :jsonResponseObject.last_name];
    [self setAtributedString:self.name :jsonResponseObject.name];
    [self setAtributedString:self.middleName :jsonResponseObject.middle_name];
    
    [self setAtributedString:self.percentToCharge :jsonResponseObject.percenttocharge];
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
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0f]} range:range1];
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
    request.timeoutInterval = 10;
    
    
    
    NSError* err;
    NSURLResponse *response = [[NSURLResponse alloc]init];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"--%@",jsonString);
    ResponseGetDocScansUrl* jsonResponseGetUrlObject = [[ResponseGetDocScansUrl alloc]initWithString:jsonString error:&err];
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


#pragma mark - left Menu

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
             self.scrollView.userInteractionEnabled = NO;
             self.segmentedControll.userInteractionEnabled = NO;
         }
         else
         {
             flag=0;
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
             self.scrollView.userInteractionEnabled = YES;
             self.segmentedControll.userInteractionEnabled = YES;
             
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             self.scrollView.userInteractionEnabled = NO;
             self.segmentedControll.userInteractionEnabled = NO;
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
    
    self.scrollView.userInteractionEnabled = NO;
    self.segmentedControll.userInteractionEnabled = NO;
    
    flag=1;
    
    
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

@end
