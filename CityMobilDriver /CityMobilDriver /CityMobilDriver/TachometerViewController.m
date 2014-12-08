//
//  TachometerViewController.m
//  CityMobilDriver
//
//  Created by Intern on 11/19/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "TachometerViewController.h"
#import "RequestGetTaximeter.h"
#import "ResponseGetTachometer.h"



@interface TachometerViewController ()
{
    ResponseGetTachometer* tachometerResponse;
    NSMutableArray* tachoSubViews1;
    NSMutableArray* tachoSubViews2;
}
@end

@implementation TachometerViewController

#pragma mark - life cicle
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self getTaximeter];
    
//    [NSTimer scheduledTimerWithTimeInterval:5.f target: self
//                                   selector: @selector(getTaximeter)
//                                   userInfo: nil repeats: YES];
    
}


-(void)viewDidAppear:(BOOL)animated{
    tachoSubViews1 = [[NSMutableArray alloc]init];
    tachoSubViews2 = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.tachoElements.count; ++i) {
        UIImageView* tachoImage = self.tachoElements[i];
        UILabel* label1 = [[UILabel alloc] initWithFrame:tachoImage.bounds];
        [label1 setTextColor:[UIColor whiteColor]];
        [label1 setTextAlignment:NSTextAlignmentCenter];
        [label1 setFont:[UIFont fontWithName:@"Roboto-Regular" size:50.f]];
        label1.text = [NSString stringWithFormat:@"%i",0];
        [self.tachoElements[i] addSubview:label1];
        [tachoSubViews1 addObject:label1];
        
        
        UILabel* label2 = [[UILabel alloc] initWithFrame:
                           CGRectMake(0, 2*CGRectGetHeight(tachoImage.frame),
                                      CGRectGetWidth(tachoImage.frame),
                                      CGRectGetHeight(tachoImage.frame))];
        [label2 setTextColor:[UIColor whiteColor]];
        [label2 setTextAlignment:NSTextAlignmentCenter];
        [label2 setFont:[UIFont fontWithName:@"Roboto-Regular" size:50.f]];
        label2.text = [NSString stringWithFormat:@"%i",0];
        [self.tachoElements[i] addSubview:label2];
        [tachoSubViews2 addObject:label2];
    }
    
    
}






-(void) animateTachometer:(NSInteger) number{

    [UIView animateWithDuration:2.f animations:^{
        [self.view bringSubviewToFront:self.navigationView];
        //[self.view bringSubviewToFront:self.bgView];
        
        UIImageView* tachoImage = self.tachoElements[0];
        UILabel* label1 = tachoSubViews1[0];
        CGRect rect = label1.frame;
        rect.origin.y = -CGRectGetHeight(tachoImage.frame);
        label1.frame = rect;
    } completion:^(BOOL finished) {

        if (finished) {
            UIImageView* tachoImage = self.tachoElements[0];
            UILabel* label1 = tachoSubViews1[0];
            label1.frame = CGRectMake(0, 2*CGRectGetHeight(tachoImage.frame),
                                      CGRectGetWidth(tachoImage.frame),
                                      CGRectGetHeight(tachoImage.frame));
        }

    }];
    
    //}
    
}


- (IBAction)elementAction:(id)sender {
    UIButton* button = (UIButton*) sender;
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    if (button.tag == 100) {
        alertController.message = [tachometerResponse.elements[0] name];
    }
    
    if (button.tag == 101) {
        alertController.message = [tachometerResponse.elements[1] name];
    }
    
    if (button.tag == 102) {
        alertController.message = [tachometerResponse.elements[2] name];
    }

    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         //textField.placeholder = NSLocalizedString(@"LoginPlaceholder", @"Login");
     }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark - Requests


-(void)getTaximeter
{
    RequestGetTaximeter* requestObject = [[RequestGetTaximeter alloc]init];
    NSDictionary* jsonDictionary=[requestObject toDictionary];
    //NSLog(@"%@",jsonDictionary);
    
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
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        NSError*err;
        tachometerResponse = [[ResponseGetTachometer alloc]initWithString:jsonString error:&err];
        
        //[self animateTachometer:tachometerResponse.calcOrderPrice];
        self.distance.text = [self setAtributedString:tachometerResponse.distance];

        for (int i = 0; i < self.elements.count; ++i) {
            UIButton* button = self.elements[i];
            button.titleLabel.numberOfLines = 3;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitle:[tachometerResponse.elements[i] name] forState:UIControlStateNormal];
        }
        
//        UIButton* button = self.elements[0];button.titleLabel.n
//        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [button setTitle:@"aaa" forState:UIControlStateNormal];
    }];
}

#pragma mark help Functions
-(NSString*)setAtributedString:(NSInteger)number{
    NSInteger count = 0;
    
    NSInteger newNumber = number;
    
    BOOL b = YES;
    while (b) {
        newNumber /= 10;
        ++count;
        if (!newNumber) {
            b = NO;
        }
    }
    NSString* str = [[NSString alloc]init];
    switch (count) {
        case 1:
        {
            str = [NSString stringWithFormat:@"00%li,0",(long)number];
        }
            break;
            
        case 2:
        {
            str = [NSString stringWithFormat:@"0%li,0",(long)number];
        }
            break;
        case 3:
        {
            str = [NSString stringWithFormat:@"%li,0",(long)number];
        }
            break;
            
        default:
            break;
    }
    
    return str;
}


-(NSMutableArray*)divideInteger:(NSInteger)number{
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    BOOL b = YES;
    while (b) {
        NSInteger lastNumber = number%10;
        [arr addObject:[NSNumber numberWithInteger:lastNumber]];
        number /= 10;
        if (!number) {
            b = NO;
        }
    }
    return arr;
}


@end
