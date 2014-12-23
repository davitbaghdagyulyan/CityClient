//
//  CreateProfilViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/28/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "CreateProfilViewController.h"
#import "ProfilViewController.h"
#import "OpenMapButtonHandler.h"
#import "CardsViewController.h"

@interface CreateProfilViewController ()
{
    LeftMenu*leftMenu;
    
    
    UIImagePickerController* imagePicker;
    UITextField* activeTextFeild;
    UIAlertView* succeedAlert;
    
    CAGradientLayer* gradientLaye1;
    CAGradientLayer* gradientLaye2;
    CAGradientLayer* gradientLaye3;
    OpenMapButtonHandler*openMapButtonHandlerObject;
}
@end

@implementation CreateProfilViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(actionHandleTapOnCreateImageView)];
    [singleTap setNumberOfTapsRequired:1];
    self.createPhotoImageView.userInteractionEnabled = YES;
    [self.createPhotoImageView addGestureRecognizer:singleTap];
    
    
    self.lastName.returnKeyType = UIReturnKeyNext;
    self.lastName.delegate = self;
    self.lastName.text = self.lastNameText;
    self.lastName.textColor = [UIColor lightGrayColor];
    
    self.name.returnKeyType = UIReturnKeyNext;
    self.name.delegate = self;
    self.name.text = self.nameText;
    self.name.textColor = [UIColor lightGrayColor];
    
    self.middleName.returnKeyType = UIReturnKeyNext;
    self.middleName.delegate = self;
    self.middleName.text = self.middleNameText;
    self.middleName.textColor = [UIColor lightGrayColor];
    
    self.pasportSer.returnKeyType = UIReturnKeyNext;
    self.pasportSer.delegate = self;
    self.pasportSer.text = self.pasportSerText;
    self.pasportSer.textColor = [UIColor lightGrayColor];
    
    self.pasportNum.returnKeyType = UIReturnKeyNext;
    self.pasportNum.delegate = self;
    self.pasportNum.text = self.pasportNumText;
    self.pasportNum.textColor = [UIColor lightGrayColor];
    
    self.pasportWho.returnKeyType = UIReturnKeyNext;
    self.pasportWho.delegate = self;
    self.pasportWho.text = self.pasportWhoText;
    self.pasportWho.textColor = [UIColor lightGrayColor];
    
    self.pasportAdress.returnKeyType = UIReturnKeyNext;
    self.pasportAdress.delegate = self;
    self.pasportAdress.text = self.pasportAdressText;
    self.pasportAdress.textColor = [UIColor lightGrayColor];
    
    self.passportDate.returnKeyType = UIReturnKeyNext;
    self.passportDate.delegate = self;
    self.passportDate.text = self.passportDateText;
    self.passportDate.textColor = [UIColor lightGrayColor];
    
    self.driverLicenseSerial.returnKeyType = UIReturnKeyNext;
    self.driverLicenseSerial.delegate = self;
    self.driverLicenseSerial.text = self.driverLicenseSerialText;
    self.driverLicenseSerial.textColor = [UIColor lightGrayColor];
    
    self.driverLicenseNumber.returnKeyType = UIReturnKeyNext;
    self.driverLicenseNumber.delegate = self;
    self.driverLicenseNumber.text = self.driverLicenseNumberText;
    self.driverLicenseNumber.textColor = [UIColor lightGrayColor];
    
    self.driverLicenseClass.returnKeyType = UIReturnKeyDone;
    self.driverLicenseClass.delegate = self;
    self.driverLicenseClass.text = self.driverLicenseClassText;
    self.driverLicenseClass.textColor = [UIColor lightGrayColor];
    
    [self registerForKeyboardNotifications];
    UITapGestureRecognizer* tapBeganFirstView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchRecognizer)];
    [self.firstView addGestureRecognizer:tapBeganFirstView];
    
    
    UITapGestureRecognizer* tapBeganSecondView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchRecognizer)];
    [self.secondView addGestureRecognizer:tapBeganSecondView];
 
    /// gradients ////
    for (int  i = 0; i < self.bgViews.count; ++i) {
        
        UIView* bgView = [self.bgViews objectAtIndex:i];
        bgView.backgroundColor = [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1];
        
        if (i == 0) {
            gradientLaye1 = [self greyGradient:bgView widthFrame:CGRectMake(0, 0, CGRectGetWidth(bgView.frame), CGRectGetHeight(bgView.frame)*9.f/34)];
            [bgView.layer insertSublayer:gradientLaye1 atIndex:0];
        }
        if (i == 1) {
            gradientLaye2 = [self greyGradient:bgView widthFrame:CGRectMake(0, 0, CGRectGetWidth(bgView.frame), CGRectGetHeight(bgView.frame)*9.f/52)];
            [bgView.layer insertSublayer:gradientLaye2 atIndex:0];
        }
        if (i == 2) {
            gradientLaye3 = [self greyGradient:bgView widthFrame:CGRectMake(0, 0, CGRectGetWidth(bgView.frame), CGRectGetHeight(bgView.frame)*9.f/19)];
            [bgView.layer insertSublayer:gradientLaye3 atIndex:0];
        }
    }
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    leftMenu=[LeftMenu getLeftMenu:self];
     [GPSConection showGPSConection:self];
    self.scrollView.userInteractionEnabled=YES;
    self.segmentControll.userInteractionEnabled=YES;
    self.scrollView.userInteractionEnabled=YES;
    
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

-(void)actionHandleTapOnCreateImageView
{
    imagePicker = [[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* img = info[UIImagePickerControllerOriginalImage];
    
    int min = MIN(img.size.height, img.size.width);
    int max = MAX(img.size.height, img.size.width);
    
    int y = (max - min) / 2;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.createPhotoImageView setImage:[self imageWithImage:info[UIImagePickerControllerOriginalImage] scaledToSize:CGRectMake(0, y, min, min)]];
    self.createPhotoImageView.layer.cornerRadius = self.createPhotoImageView.frame.size.height /2;
    self.createPhotoImageView.layer.masksToBounds = YES;
    self.createPhotoImageView.layer.borderWidth = 0;
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGRect)newRect;
{
    CGImageRef tempImage = CGImageCreateWithImageInRect([image CGImage], newRect);
    UIImage *newImage = [UIImage imageWithCGImage:tempImage];
    CGImageRelease(tempImage);
    
    return newImage;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 100:
            [self.name becomeFirstResponder];
            break;
        case 101:
            [self.middleName becomeFirstResponder];
            break;
        case 102:
            [self.pasportSer becomeFirstResponder];
            break;
        case 103:
            [self.pasportNum becomeFirstResponder];
            break;

        case 104:
            [self.pasportWho becomeFirstResponder];
            break;

        case 105:
            [self.passportDate becomeFirstResponder];
            break;
        case 106:
            [self.pasportAdress becomeFirstResponder];
            break;
        case 107:
            [self.driverLicenseNumber becomeFirstResponder];
            break;
        case 108:
            [self.driverLicenseSerial becomeFirstResponder];
            break;
        case 109:
            [self.driverLicenseClass becomeFirstResponder];
            break;
        case 110:
            [self.driverLicenseClass resignFirstResponder];
            break;
        default:
            break;
    }

    return YES;
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + 20, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    NSLog(@"%@",NSStringFromCGRect(activeTextFeild.frame));
////    if (!CGRectContainsPoint(aRect, activeTextFeild.frame.origin) ) {
//        [self.scrollView scrollRectToVisible:activeTextFeild.frame animated:YES];
////    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}



- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    activeTextFeild = textField;
}


-(void)touchRecognizer
{
    [activeTextFeild resignFirstResponder];
}


-(void)pushOrPopViewController:(UIViewController*)controller
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



- (IBAction)segmentContollAction:(UISegmentedControl*)sender;
{
    if (sender.selectedSegmentIndex == 0)
    {
    }
    if (sender.selectedSegmentIndex == 1)
    {
        CarInfoViewController* carInfoController=[self.storyboard instantiateViewControllerWithIdentifier:@"CarInfoViewController"];
        //[self.navigationController pushViewController:createProfilController animated:NO];
        [self pushOrPopViewController:carInfoController];
    }
    
    if (sender.selectedSegmentIndex == 2) {
        CardsViewController* carInfoController=[self.storyboard instantiateViewControllerWithIdentifier:@"CardsViewController"];
        [self pushOrPopViewController:carInfoController];
    }
}

- (IBAction)seveUserInformation:(UIButton *)sender
{
    
    if (![self.createPhotoImageView.image isEqual:self.profilImage]) {
        [self RequestSetDriverInfoWithPoto];
    }
    
    else
    {
        [self RequestSetDriverInfo];
    }
}

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}


-(void)RequestSetDriverInfoWithPoto
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    RequestSetDriverInfoWithPhoto* request = [[RequestSetDriverInfoWithPhoto alloc]init];
    request.driver_license_class = self.driverLicenseClass.text;
    request.passport_date = self.passportDate.text;
    request.middle_name = self.middleName.text;
    request.passport_address = self.pasportAdress.text;
    request.driver_license_number = self.driverLicenseNumber.text;
    request.passport_num = self.pasportNum.text;
    request.driver_license_serial = self.driverLicenseSerial.text;
    request.passport_ser = self.pasportSer.text;
    request.name = self.name.text;
    request.last_name = self.lastName.text;
    request.passport_who = self.pasportWho.text;
    NSString* imageString = [self encodeToBase64String:self.createPhotoImageView.image];
    request.photo = imageString;
    
    NSDictionary* jsonDictionary = [request toDictionary];
    NSURL* url = [NSURL URLWithString:@"https://driver-msk.city-mobil.ru/taxiserv/api/driver/"];
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    
    NSMutableURLRequest* requestInfo = [NSMutableURLRequest requestWithURL:url];
    [requestInfo setURL:url];
    [requestInfo setHTTPMethod:@"POST"];
    [requestInfo setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestInfo setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestInfo setHTTPBody:jsonData];
    requestInfo.timeoutInterval = 10;
    
    
//    
//    NSURLResponse *response = [[NSURLResponse alloc]init];
//    NSData* data = [NSURLConnection sendSynchronousRequest:requestInfo returningResponse:&response error:&error];
//    
    
    [NSURLConnection sendAsynchronousRequest:requestInfo queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
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
            [indicator stopAnimating];
            return ;
        }
        
        
        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"- = = == = = == = = == -%@",jsonString);
        NSError* err;
        DriverInfoResponse* jsonResponseObject = [[DriverInfoResponse alloc]initWithString:jsonString error:&err];
//        if (jsonResponseObject.code) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:jsonResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                           handler:^(UIAlertAction * action)
//                                     {
//                                         [alert dismissViewControllerAnimated:YES completion:nil];
//                                         
//                                     }];
//            [alert addAction:cancel];
//            [self presentViewController:alert animated:YES completion:nil];
//            [indicator stopAnimating];
//        }
//        
//        else
//        {
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:jsonResponseObject.text code:jsonResponseObject.code];
        
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:jsonResponseObject.msg preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         ProfilViewController* profilController=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfilViewController"];
                                         [self pushOrPopViewController:profilController];
                                     }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            [indicator stopAnimating];
//        }

    }];

    
    
}

//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (alertView == succeedAlert) {
//
//    }
//}

-(void)RequestSetDriverInfo
{
    
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    RequestSetDriverInfo* request = [[RequestSetDriverInfo alloc]init];
    request.driver_license_class = self.driverLicenseClass.text;
    request.passport_date = self.passportDate.text;
    request.middle_name = self.middleName.text;
    request.passport_address = self.pasportAdress.text;
    request.driver_license_number = self.driverLicenseNumber.text;
    request.passport_num = self.pasportNum.text;
    request.driver_license_serial = self.driverLicenseSerial.text;
    request.passport_ser = self.pasportSer.text;
    request.name = self.name.text;
    request.last_name = self.lastName.text;
    request.passport_who = self.pasportWho.text;
    
    NSDictionary* jsonDictionary = [request toDictionary];
    NSLog(@"%@",jsonDictionary);
    NSURL* url = [NSURL URLWithString:@"https://driver-msk.city-mobil.ru/taxiserv/api/driver/"];
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSMutableURLRequest* requestInfo = [NSMutableURLRequest requestWithURL:url];
    [requestInfo setURL:url];
    [requestInfo setHTTPMethod:@"POST"];
    [requestInfo setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestInfo setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestInfo setHTTPBody:jsonData];
    requestInfo.timeoutInterval = 10;
    
    
    
//    NSURLResponse *response = [[NSURLResponse alloc]init];
//    NSData* data = [NSURLConnection sendSynchronousRequest:requestInfo returningResponse:&response error:&error];
//    
//    if (data)
//    {
//        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"- = = == = = == = = == -%@",jsonString);
//        NSError* err;
//        DriverInfoResponse* jsonResponseObject = [[DriverInfoResponse alloc]initWithString:jsonString error:&err];
//        
//        succeedAlert = [[UIAlertView alloc]initWithTitle:nil message:jsonResponseObject.msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//        [succeedAlert show];
//    }
//    
//    else
//    {
//        succeedAlert = [[UIAlertView alloc]initWithTitle:nil message:@"NO INTERNET CONECTION" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//        [succeedAlert show];
//    }
    
    [NSURLConnection sendAsynchronousRequest:requestInfo queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
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
            [indicator stopAnimating];
            return ;

        }
        
        
        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"- = = == = = == = = == -%@",jsonString);
        NSError* err;
        DriverInfoResponse* jsonResponseObject = [[DriverInfoResponse alloc]initWithString:jsonString error:&err];
//        if (jsonResponseObject.code) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:jsonResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                           handler:^(UIAlertAction * action)
//                                     {
//                                         [alert dismissViewControllerAnimated:YES completion:nil];
//                                         
//                                     }];
//            [alert addAction:cancel];
//            [self presentViewController:alert animated:YES completion:nil];
//            [indicator stopAnimating];
//        }
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:jsonResponseObject.text code:jsonResponseObject.code];
        
//        else
//        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:jsonResponseObject.msg preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         ProfilViewController* profilController=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfilViewController"];
                                         [self pushOrPopViewController:profilController];
                                     }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            [indicator stopAnimating];
//        }
        

    }];
    
    
    
}

#pragma mark - gradient
- (CAGradientLayer*) greyGradient:(UIView*)view widthFrame:(CGRect) rect{
    UIColor *colorOne = [UIColor colorWithRed:198.f/255 green:198.f/255 blue:198.f/255 alpha:1.f];
    UIColor *colorTwo = [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1.f];
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.frame = rect;
    
    return headerLayer;
}

#pragma mark - rotation
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {

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
                                     leftMenu.frame =CGRectMake(xx,leftMenu.frame.origin.y,leftMenu.frame.size.width, self.view.frame.size.height-64);
                                     
                                     
                                     for (int  i = 0; i < self.bgViews.count; ++i) {
                                         UIView* bgView = [self.bgViews objectAtIndex:i];
                                         if (i == 0) {
                                             NSLog(@"%f",CGRectGetWidth(bgView.frame));
                                             gradientLaye1.frame =CGRectMake(0, 0, CGRectGetWidth(bgView.frame), CGRectGetHeight(bgView.frame)*9.f/34);
                                         }
                                         if (i == 1) {
                                             NSLog(@"%f",CGRectGetWidth(bgView.frame));
                                             gradientLaye2.frame = CGRectMake(0, 0, CGRectGetWidth(bgView.frame), CGRectGetHeight(bgView.frame)*9.f/52);
                                         }
                                         if (i == 2) {
                                             NSLog(@"%f",CGRectGetWidth(bgView.frame));
                                             gradientLaye3.frame = CGRectMake(0, 0, CGRectGetWidth(bgView.frame), CGRectGetHeight(bgView.frame)*9.f/19);
                                         }
                                         //NSLog(@"------>>> = %@",NSStringFromCGSize(bgView.frame.size));
                                     }
                                     
                                     
                                     
                                     //NSLog(@"size = %@",NSStringFromCGSize(size));
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
             self.segmentControll.userInteractionEnabled = NO;
             
             self.scrollView.tag=1;
             self.segmentControll.tag=2;
             [leftMenu.disabledViewsArray removeAllObjects];
             
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.scrollView.tag]];
            
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.segmentControll.tag]];
         }
         else
         {
             leftMenu.flag=0;
             self.scrollView.userInteractionEnabled = YES;
             self.segmentControll.userInteractionEnabled = YES;
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
             self.segmentControll.userInteractionEnabled = YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             self.scrollView.userInteractionEnabled = NO;
             self.segmentControll.userInteractionEnabled = NO;
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
    self.segmentControll.userInteractionEnabled = NO;
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
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (IBAction)openMap:(UIButton*)sender
{
    openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
}


@end
