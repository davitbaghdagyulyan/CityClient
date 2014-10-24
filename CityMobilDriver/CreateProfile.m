//
//  CreateProfile.m
//  CityMobilDriver
//
//  Created by Intern on 10/22/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "CreateProfile.h"

@interface CreateProfile()
{
    UIImagePickerController* imagePicker;
}
@end


@implementation CreateProfile

- (void)drawRect:(CGRect)rect
{
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    

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

    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(actionHandleTapOnCreateImageView)];
    [singleTap setNumberOfTapsRequired:1];
    self.createPhotoImageView.userInteractionEnabled = YES;///???????
    [self.createPhotoImageView addGestureRecognizer:singleTap];
    
    
}




-(void)actionHandleTapOnCreateImageView
{
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self addSubview:imagePicker.view];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imagePicker.view removeFromSuperview];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* img = info[UIImagePickerControllerOriginalImage];
    
    int min = MIN(img.size.height, img.size.width);
    int max = MAX(img.size.height, img.size.width);
    
    int y = (max - min) / 2;
    [self.createPhotoImageView setImage:[self imageWithImage:info[UIImagePickerControllerOriginalImage] scaledToSize:CGRectMake(0, y, min, min)]];
    
    [imagePicker.view removeFromSuperview];
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
        {
            [self setScrollViewContentOffSet];
            [self.pasportWho becomeFirstResponder];
        }
            break;
            
        case 105:
        {
            [self setScrollViewContentOffSet];
            [self.passportDate becomeFirstResponder];
        }
            break;
        case 106:
        {
            [self setScrollViewContentOffSet];
            [self.pasportAdress becomeFirstResponder];
        }
            break;
        case 107:
        {
            CGPoint offset = self.scrollView.contentOffset;
            offset.y+=96;
            [self.scrollView setContentOffset:offset animated:YES];
            [self.driverLicenseNumber becomeFirstResponder];
        }
            break;
        case 108:
        {
            [self setScrollViewContentOffSet];
            [self.driverLicenseSerial becomeFirstResponder];
        }
            break;
        case 109:
        {
            [self setScrollViewContentOffSet];
            [self.driverLicenseClass becomeFirstResponder];
        }
            break;
        case 110:
        {
            [self.driverLicenseClass resignFirstResponder];
            CGPoint offset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.frame.size.height);
            [self.scrollView setContentOffset:offset animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

-(void)setScrollViewContentOffSet
{
    CGPoint offset = self.scrollView.contentOffset;
    offset.y+=48;
    [self.scrollView setContentOffset:offset animated:YES];
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







- (IBAction)seveUserInformation:(UIButton *)sender
{
    [self RequestSetDriverInfo];
//    if ([self IsPhotoEqual])
//    {
//        [self RequestSetDriverInfo];
//    }
//    else
//    {
//        [self RequestSetDriverInfoWithPoto];
//    }
}

-(BOOL)IsPhotoEqual
{
    return [self.delegate IsPhotoEqual];
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
    NSData *dataImage = UIImagePNGRepresentation(self.createPhotoImageView.image);
    NSLog(@"%@",dataImage);
    request.photo = nil;
    
    
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
        
        UIAlertView* sucsedAlert = [[UIAlertView alloc]initWithTitle:nil message:jsonResponseObject.msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [sucsedAlert show];
    }
    
    else
    {
        UIAlertView* sucsedAlert = [[UIAlertView alloc]initWithTitle:nil message:@"NO INTERNET CONECTION" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [sucsedAlert show];
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
        
        UIAlertView* sucsedAlert = [[UIAlertView alloc]initWithTitle:nil message:jsonResponseObject.msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [sucsedAlert show];
    }
    
    else
    {
        UIAlertView* sucsedAlert = [[UIAlertView alloc]initWithTitle:nil message:@"NO INTERNET CONECTION" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [sucsedAlert show];
    }
}





@end
