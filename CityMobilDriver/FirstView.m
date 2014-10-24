//
//  FirstView.m
//  CityMobilDriver
//
//  Created by Intern on 10/20/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "FirstView.h"
#import "LeftMenu.h"
@interface FirstView()
{
    DriverAllInfoResponse* jsonResponseObject;
    
    NSInteger flag;
    LeftMenu*leftMenu;
}
@end



@implementation FirstView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation
*/
- (void)drawRect:(CGRect)rect
{
    self.FirstScrollView.showsHorizontalScrollIndicator = NO;
    self.FirstScrollView.delegate = self;
    
    [self setDriverInfoRequest];
    [self setDriverInfo];
 
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

- (IBAction)edit:(UIButton *)sender
{
    [self.delegate edit:sender];
}
- (IBAction)segmentControlAction:(UISegmentedControl *)sender
{
        [self.delegate segmentControlAction:sender];
}


- (IBAction)sendDocumentsAction:(UIButton *)sender
{
    [self.delegate sendDocumentsAction:sender];
}


-(void)setDriverInfoRequest
{
    RequestDocScansUrl* RequestDocScansUrlObject=[[RequestDocScansUrl alloc]init];
    RequestDocScansUrlObject.key = [SingleDataProvider sharedKey].key;
    RequestDocScansUrlObject.method = @"getDriverInfo";
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
    NSLog(@"------------======= = = == -%@",jsonString);
    jsonResponseObject = [[DriverAllInfoResponse alloc]initWithString:jsonString error:&err];
    
    //NSLog(@"******* %@",jsonResponseObject.doc_scans_url);
    
}


-(void)setDriverInfo
{
    [self setAtributedString:self.lastName :jsonResponseObject.last_name];
    [self setAtributedString:self.name :jsonResponseObject.name];
    [self setAtributedString:self.middleName :jsonResponseObject.middle_name];
    
    [self setAtributedString:self.lastName :jsonResponseObject.last_name];//percentToCharge
    [self setAtributedString:self.passportSer :jsonResponseObject.passport_ser];
    
    [self setAtributedString:self.passportNum :jsonResponseObject.passport_num];
    
    [self setAtributedString:self.dateRegister :jsonResponseObject.date_register];
    
    [self setAtributedString:self.passportWho :jsonResponseObject.passport_who];
    
    //[self setAtributedString:self.passportAddress :jsonResponseObject.passport_address];
    
    [self setAtributedString:self.driverLicenseSerial :jsonResponseObject.driver_license_serial];
    
    [self setAtributedString:self.driverLicenseNumber :jsonResponseObject.driver_license_number];
    
    [self setAtributedString:self.driverLicenseClass :jsonResponseObject.driver_license_class];
    
}



-(void)setAtributedString:(UILabel*)textField  :(NSString*)appendingString
{
    textField.text = [textField.text stringByAppendingString:appendingString];
    NSRange range1 = [textField.text rangeOfString:appendingString];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0f]} range:range1];
    textField.attributedText=attributedText;
}


- (IBAction)showSettingViewController:(UIButton *)sender
{
    [self.delegate showSettingViewController:sender];
}

- (IBAction)openAndCloseLeftMenu:(UIButton *)sender
{
    [self.delegate openAndCloseLeftMenu:sender];
}






@end
