//
//  CreateProfilViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/28/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "CreateProfilViewController.h"
#import "ProfilViewController.h"

@interface CreateProfilViewController ()
{
    UIImagePickerController* imagePicker;
    UITextField* activeTextFeild;
    UIAlertView* succeedAlert;
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
    self.name.returnKeyType = UIReturnKeyNext;
    self.name.delegate = self;
    self.middleName.returnKeyType = UIReturnKeyNext;
    self.middleName.delegate = self;
    
    self.pasportSer.returnKeyType = UIReturnKeyNext;
    self.pasportSer.delegate = self;
    self.pasportNum.returnKeyType = UIReturnKeyNext;
    self.pasportNum.delegate = self;
    self.pasportWho.returnKeyType = UIReturnKeyNext;
    self.pasportWho.delegate = self;
    self.pasportAdress.returnKeyType = UIReturnKeyNext;
    self.pasportAdress.delegate = self;
    
    self.passportDate.returnKeyType = UIReturnKeyNext;
    self.passportDate.delegate = self;
    self.driverLicenseSerial.returnKeyType = UIReturnKeyNext;
    self.driverLicenseSerial.delegate = self;
    self.driverLicenseNumber.returnKeyType = UIReturnKeyNext;
    self.driverLicenseNumber.delegate = self;
    self.driverLicenseClass.returnKeyType = UIReturnKeyDone;
    self.driverLicenseClass.delegate = self;
    
    
    [self registerForKeyboardNotifications];
    UITapGestureRecognizer* tapBeganFirstView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchRecognizer)];
    [self.firstView addGestureRecognizer:tapBeganFirstView];
    
    
    UITapGestureRecognizer* tapBeganSecondView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchRecognizer)];
    [self.secondView addGestureRecognizer:tapBeganSecondView];
    
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

//-(void)setScrollViewContentOffSet
//{
//    CGPoint offset = self.scrollView.contentOffset;
//    offset.y+=48;
//    [self.scrollView setContentOffset:offset animated:YES];
//}



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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(aRect, activeTextFeild.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeTextFeild.frame animated:YES];
    }
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
//        ProfilViewController* profilViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfilViewController"];
//        [self.navigationController pushViewController:profilViewController animated:NO];
    }
    if (sender.selectedSegmentIndex == 1)
    {
        CarInfoViewController* carInfoController=[self.storyboard instantiateViewControllerWithIdentifier:@"CarInfoViewController"];
        //[self.navigationController pushViewController:createProfilController animated:NO];
        [self pushOrPopViewController:carInfoController];
    }
    
}

- (IBAction)seveUserInformation:(UIButton *)sender
{

    if (![self image:self.createPhotoImageView.image isEqualTo:self.profilImage])
    {
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
    
    
    
    NSURLResponse *response = [[NSURLResponse alloc]init];
    NSData* data = [NSURLConnection sendSynchronousRequest:requestInfo returningResponse:&response error:&error];
    
    if (data)
    {
        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"- = = == = = == = = == -%@",jsonString);
        NSError* err;
        DriverInfoResponse* jsonResponseObject = [[DriverInfoResponse alloc]initWithString:jsonString error:&err];
        
        succeedAlert = [[UIAlertView alloc]initWithTitle:nil message:jsonResponseObject.msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [succeedAlert show];
    }
    
    else
    {
        UIAlertView* sucsedAlert = [[UIAlertView alloc]initWithTitle:nil message:@"NO INTERNET CONECTION" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [sucsedAlert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == succeedAlert) {
        ProfilViewController* profilController=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfilViewController"];
        [self pushOrPopViewController:profilController];
    }
}

-(void)RequestSetDriverInfo
{
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
    
    
    
    NSURLResponse *response = [[NSURLResponse alloc]init];
    NSData* data = [NSURLConnection sendSynchronousRequest:requestInfo returningResponse:&response error:&error];
    
    if (data)
    {
        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"- = = == = = == = = == -%@",jsonString);
        NSError* err;
        DriverInfoResponse* jsonResponseObject = [[DriverInfoResponse alloc]initWithString:jsonString error:&err];
        
        succeedAlert = [[UIAlertView alloc]initWithTitle:nil message:jsonResponseObject.msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [succeedAlert show];
    }
    
    else
    {
        succeedAlert = [[UIAlertView alloc]initWithTitle:nil message:@"NO INTERNET CONECTION" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [succeedAlert show];
    }
}




@end