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
#import "ServicesViewController.h"
#import "LeftMenu.h"
#import "EndUpViewController.h"


//@property (weak, nonatomic) IBOutlet UIButton *additionalServices;
//@property (weak, nonatomic) IBOutlet UILabel *metroNames;
//@property (weak, nonatomic) IBOutlet UILabel *delliveryComments;


@interface TachometerViewController ()
{
    ResponseGetTachometer* tachometerResponse;
    NSMutableArray* tachoSubViews1;
    NSMutableArray* tachoSubViews2;
    CGFloat scrollViewContentHeight;
    
    NSMutableArray* idArray;
    
    NSInteger flag;
    LeftMenu*leftMenu;
    
    UILabel* additionalServices;
    UIButton* additionalServicesButton;
    
    
    UILabel* metroNamesLabel;
    UILabel* ourCommentLabel;
    UIView* lineView;
    
    
    UILabel* upLabel;
    UILabel* underLabel;
    
    
    NSTimer* timer;
}
@end

@implementation TachometerViewController

#pragma mark - life cicle
- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self initPropertys];
    
    
    
    //[self getTaximeter];
    
  
    
    
//    
//    NSMutableArray* numberArray = [[NSMutableArray alloc]init];
//    for (int i = 0; i < 5; ++i) {
//        [numberArray addObject:@"0"];
//    }
//    [self settachoelements:numberArray];
//

    
    
    metroNamesLabel = [[UILabel alloc]init];
    ourCommentLabel = [[UILabel alloc]init];
    lineView = [[UIView alloc]init];
    additionalServices = [[UILabel alloc]init];
    additionalServicesButton = [[UIButton alloc]init];
    
    

    
    flag=0;
    leftMenu=[LeftMenu getLeftMenu:self];
    [self getOrSetTaximeter:0 value:@"a" isSet:NO];
    idArray = [[NSMutableArray alloc]init];
    
    

    
}


-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}





-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:10.f target: self
                                           selector: @selector(animateTachometer)
                                           userInfo: nil repeats: YES];
    
    
    
    NSMutableArray* numberArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 5; ++i) {
        [numberArray addObject:@"0"];
    }
    [self settachoelements:numberArray];
    
}


-(void) settachoelements:(NSArray*)numbers{
    static int x = 0;
    for (int i = 0; i < 5; ++i) {
        UIImageView* tachoView = self.tachoElements[i];
        
        if (x == 0) {
            upLabel = [[UILabel alloc]init];
            underLabel = [[UILabel alloc]init];
        }
        
        
        
        upLabel.frame = tachoView.bounds;
        upLabel.tag = 150 + i;
        upLabel.text = @"0";
        [upLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:CGRectGetHeight(upLabel.bounds)]];
        upLabel.textColor = [UIColor whiteColor];
        upLabel.textAlignment = NSTextAlignmentCenter;
        [tachoView addSubview:upLabel];
        
        CGRect underLabelRect = tachoView.bounds;
        underLabelRect.origin.y = CGRectGetHeight(tachoView.bounds);
        underLabel.frame = underLabelRect;
        underLabel.tag = 200 + i;
        underLabel.text = @"0";
        [underLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:CGRectGetHeight(upLabel.bounds)]];
        underLabel.textColor = [UIColor whiteColor];
        underLabel.textAlignment = NSTextAlignmentCenter;
        [tachoView addSubview:underLabel];
    }
    ++x;
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [additionalServices removeFromSuperview];
}

-(void)initPropertys{
    self.collMetroName = self.orderResponse.CollMetroName;
    self.shortname = self.orderResponse.shortname;
    self.deliveryMetroName = self.orderResponse.DeliveryMetroName;
    self.collComment = self.orderResponse.CollComment;
    self.idHash = self.orderResponse.idhash;
    self.ourComment = self.orderResponse.OurComment;
    self.collDate = self.orderResponse.collDate;
    self.tariff = self.orderResponse.tariff;
}



-(void) animateTachometer{
    [self getOrSetTaximeter:0 value:@"" isSet:NO];
    
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
    __block UITextField* textLabel;
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textLabel = textField;
     }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   if (button.tag == 100) {
                                       [self.elements[0] setTitle:[tachometerResponse.elements[0] name] forState:UIControlStateNormal];
                                       NSString* str = [[tachometerResponse.elements[0] name] stringByAppendingString:[NSString stringWithFormat:@"\n%@",textLabel.text]];
                                       [self.elements[0] setTitle:str forState:UIControlStateNormal];
                                       
                                       [self getOrSetTaximeter:11 value:textLabel.text isSet:YES];
                                   }
                                   
                                   if (button.tag == 101) {
                                       [self.elements[1] setTitle:[tachometerResponse.elements[1] name] forState:UIControlStateNormal];
                                       NSString* str = [[tachometerResponse.elements[1] name] stringByAppendingString:[NSString stringWithFormat:@"\n%@",textLabel.text]];
                                       [self.elements[1] setTitle:str forState:UIControlStateNormal];
                                       
                                       
                                       [self getOrSetTaximeter:12 value:textLabel.text isSet:YES];
                                   }
                                   
                                   if (button.tag == 102) {
                                       [self.elements[2] setTitle:[tachometerResponse.elements[2] name] forState:UIControlStateNormal];
                                       NSString* str = [[tachometerResponse.elements[2] name] stringByAppendingString:[NSString stringWithFormat:@"\n%@",textLabel.text]];
                                       [self.elements[2] setTitle:str forState:UIControlStateNormal];
                                       
                                       [self getOrSetTaximeter:10 value:textLabel.text isSet:YES];
                                   }
                                   
                               }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark - Requests

-(void)getOrSetTaximeter:(NSInteger)ID  value:(NSString*)value isSet:(BOOL)isSet{
    RequestGetTaximeter* requestObject = [[RequestGetTaximeter alloc]init];
    requestObject.idhash = self.idHash;
    NSDictionary* jsonDictionary=[requestObject toDictionary];
    

    NSURL* url = [NSURL URLWithString:@"https://driver-msk.city-mobil.ru/taxiserv/api/driver/"];
    NSError* error;
    NSData *jsonData;
    
    

    if (isSet) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:jsonDictionary];
        [dict removeObjectForKey:@"elements"];
        [dict setObject:[NSMutableDictionary dictionaryWithObject:value forKey:[NSString stringWithFormat:@"%li",(long)ID]] forKey:@"elements"];
        jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    }
    else{
        jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    }
    NSString* str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);

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
        
        if (tachometerResponse.code) {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@""
                                                  message:tachometerResponse.text
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alertController dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else{
            if (!isSet) {
                [self setTachometerViews];
            }

            NSLog(@"-=-=-=-=-=-=-=-=-=-=-=-=- -=-= %ld -=-=-=-=-=-=-=--=",(long)tachometerResponse.calcOrderPrice);
            NSArray*calcArray=[self divideInteger:tachometerResponse.calcOrderPrice];
            for (int i = 0; i < calcArray.count; ++i) {
                UILabel* label = (UILabel*)[self.view viewWithTag:200 + i];
                label.text = [NSString stringWithFormat:@"%ld",(long)[(NSNumber*)calcArray[i] integerValue]];
                if (![label.text isEqualToString:[(UILabel*)[self.view viewWithTag:(150+i)]text]])
                {
                    [self moveLabel1:(UILabel*)[self.view viewWithTag:(150+i)]];
                    [self moveLabel2:label index:i];
                }
                
            }
            
        }
    }];
}

-(void)moveLabel1:(UILabel*)label{
    
    
    [UIView animateWithDuration:1
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void) {
                           [self.view sendSubviewToBack:label];
                         label.frame = CGRectMake(label.frame.origin.x, -CGRectGetHeight(label.frame) ,label.frame.size.width, label.frame.size.height);
                     }
                     completion:^(BOOL finished)
     {
         
         [label removeFromSuperview];
     }
     ];
}
-(void)moveLabel2:(UILabel*)label index:(NSInteger)i
{
    
    
    [UIView animateWithDuration:1
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void)
     {
         label.frame = CGRectMake(label.frame.origin.x, 0,label.frame.size.width, label.frame.size.height);
         
         
     }
                     completion:^(BOOL finished)
     {
         
         switch (i) {
             case 0:
             {
                 
                 label.tag = 150 + i;
                 UIImageView* tachoView = self.tachoElements[i];
                 CGRect underLabelRect = tachoView.bounds;
                 underLabelRect.origin.y = CGRectGetHeight(tachoView.bounds);
                 UILabel* underLabel1 = [[UILabel alloc]initWithFrame:underLabelRect];
                 underLabel1.text = @"0";
                 underLabel1.tag = 200 + i;
                 [underLabel1 setFont:[UIFont fontWithName:@"Roboto-Regular" size:CGRectGetHeight(label.bounds)]];
                 underLabel1.textColor = [UIColor whiteColor];
                 underLabel1.textAlignment = NSTextAlignmentCenter;
                 [tachoView addSubview:underLabel1];
             }
                 break;
             case 1:
             {
                 label.tag = 150 + i;
                 UIImageView* tachoView = self.tachoElements[i];
                 CGRect underLabelRect = tachoView.bounds;
                 underLabelRect.origin.y = CGRectGetHeight(tachoView.bounds);
                 UILabel* underLabel1 = [[UILabel alloc]initWithFrame:underLabelRect];
                 underLabel1.tag = 200 + i;
                 [underLabel1 setFont:[UIFont fontWithName:@"Roboto-Regular" size:CGRectGetHeight(label.bounds)]];
                 underLabel1.textColor = [UIColor whiteColor];
                 underLabel1.textAlignment = NSTextAlignmentCenter;
                 [tachoView addSubview:underLabel1];
             }
                 break;
             case 2:
             {
                 label.tag = 150 + i;
                 UIImageView* tachoView = self.tachoElements[i];
                 CGRect underLabelRect = tachoView.bounds;
                 underLabelRect.origin.y = CGRectGetHeight(tachoView.bounds);
                 UILabel* underLabel1 = [[UILabel alloc]initWithFrame:underLabelRect];
                 underLabel1.tag = 200 + i;
                 [underLabel1 setFont:[UIFont fontWithName:@"Roboto-Regular" size:CGRectGetHeight(label.bounds)]];
                 underLabel1.textColor = [UIColor whiteColor];
                 underLabel1.textAlignment = NSTextAlignmentCenter;
                 [tachoView addSubview:underLabel1];
             }
                 break;
             case 3:
             {
                 label.tag = 150 + i;
                 UIImageView* tachoView = self.tachoElements[i];
                 CGRect underLabelRect = tachoView.bounds;
                 underLabelRect.origin.y = CGRectGetHeight(tachoView.bounds);
                 UILabel* underLabel1 = [[UILabel alloc]initWithFrame:underLabelRect];
                 underLabel1.tag = 200 + i;
                 [underLabel1 setFont:[UIFont fontWithName:@"Roboto-Regular" size:CGRectGetHeight(label.bounds)]];
                 underLabel1.textColor = [UIColor whiteColor];
                 underLabel1.textAlignment = NSTextAlignmentCenter;
                 [tachoView addSubview:underLabel1];
             }
                 break;
             case 4:
             {
                 label.tag = 150 + i;
                 UIImageView* tachoView = self.tachoElements[i];
                 CGRect underLabelRect = tachoView.bounds;
                 underLabelRect.origin.y = CGRectGetHeight(tachoView.bounds);
                 UILabel* underLabel1 = [[UILabel alloc]initWithFrame:underLabelRect];
                 underLabel1.tag = 200 + i;
                 [underLabel1 setFont:[UIFont fontWithName:@"Roboto-Regular" size:CGRectGetHeight(label.bounds)]];
                 underLabel1.textColor = [UIColor whiteColor];
                 underLabel1.textAlignment = NSTextAlignmentCenter;
                 [tachoView addSubview:underLabel1];
             }
                 break;
             default:
                 break;
         }
     }
     ];
    
}


-(void)setTachometerViews{
    self.shortLabel.text = self.shortname;
    self.distance.text = [self setAtributedString:tachometerResponse.distance];
    
    for (int i = 0; i < self.elements.count; ++i) {
        UIButton* button = self.elements[i];
        button.titleLabel.numberOfLines = 3;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.elements[i] setTitle:[tachometerResponse.elements[i] name] forState:UIControlStateNormal];
        NSString* str = [[tachometerResponse.elements[0] name] stringByAppendingString:[NSString stringWithFormat:@"\n%@",[tachometerResponse.elements[i] getValue]]];
        [self.elements[i] setTitle:str forState:UIControlStateNormal];
    }
    

    NSMutableArray* array = [[NSMutableArray alloc]init];
    
    [array addObject:[self timeFormat:self.orderResponse.collDate]];
    [array addObject:[self timeFormat:tachometerResponse.ClientCollected]];
    [array addObject:[NSString stringWithFormat:@"%li",(long)tachometerResponse.waitTime]];
    [array addObject:[self timeFormat:tachometerResponse.ReadyForCollection]];
    [array addObject:[self timeFormat:tachometerResponse.GoodArrived]];
    [array addObject:[NSString stringWithFormat:@"%li",(long)tachometerResponse.wayPrice]];
    
    [self cutStringsInArray:array];
    
    UILabel* label0 = self.labelsColoection[0];
    label0.text = array[0];//[self timeFormat:self.orderResponse.collDate];
    
    UILabel* label1 = self.labelsColoection[1];
    label1.text = array[1];//[self timeFormat:tachometerResponse.ClientCollected];
    
    UILabel* label2 = self.labelsColoection[2];
    label2.text = array[2];//[NSString stringWithFormat:@"%li",(long)tachometerResponse.waitTime];
    
    UILabel* label3 = self.labelsColoection[3];
    label3.text = array[3];//[self timeFormat:tachometerResponse.ReadyForCollection];
    
    UILabel* label4 = self.labelsColoection[4];
    label4.text = array[4];//[self timeFormat:tachometerResponse.GoodArrived];
    
    UILabel* label5 = self.labelsColoection[5];
    label5.text = array[5];//[NSString stringWithFormat:@"%li",(long)tachometerResponse.wayPrice];
    NSLog(@"%li",(long)tachometerResponse.wayPrice);
    
    
    

    if (self.collMetroName.length) {
        metroNamesLabel.frame = CGRectMake(8, CGRectGetMaxY(self.informationView.frame) + 8, CGRectGetWidth(self.scrollView.frame) - 16, CGRectGetHeight(self.scrollView.frame)/5);
        metroNamesLabel.numberOfLines = 2;
        NSString* str = self.collMetroName;
        if (self.deliveryMetroName) {
            str = [str stringByAppendingFormat:@"\n%@",self.deliveryMetroName];
        }
        metroNamesLabel.text = str;
        [self.scrollView addSubview:metroNamesLabel];
    }
    
    
    ourCommentLabel.frame = CGRectMake(8, CGRectGetMaxY(metroNamesLabel.frame) + 8, CGRectGetWidth(self.scrollView.frame) - 16, CGRectGetHeight(self.scrollView.frame)/10);
    if (self.ourComment.length) {
        ourCommentLabel.backgroundColor = [UIColor whiteColor];
        ourCommentLabel.text = self.ourComment;
        [self.scrollView addSubview:ourCommentLabel];
    }
    
    
    
    lineView.frame = CGRectMake(8, CGRectGetMinY(ourCommentLabel.frame) - 8, CGRectGetWidth(self.scrollView.frame) - 16, 2);
    lineView.backgroundColor = [UIColor grayColor];
    [self.scrollView addSubview:lineView];
    
    
    
    
    NSString* str = [[NSString alloc]init];
    for (int i = 0; i < tachometerResponse.services.count; ++i) {
        str = [str stringByAppendingFormat:@" %@ - %@ \n",[tachometerResponse.services[i] name],[tachometerResponse.services[i] prices]];
        [idArray addObject:[tachometerResponse.services[i] name]];
    }
    

    
//    additionalServices = [[UILabel alloc]init];
    additionalServices.text = str;
    additionalServices.numberOfLines = tachometerResponse.services.count;
    
    
    [additionalServices sizeToFit];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.informationView.frame) + 8 + CGRectGetHeight(metroNamesLabel.frame) + 8 + CGRectGetHeight(ourCommentLabel.frame) + 8 + 2 + 8 + CGRectGetHeight(additionalServices.frame));
    

    
    scrollViewContentHeight = self.scrollView.contentSize.height;
    
    if (tachometerResponse.services.count == 0) {
        additionalServices.text = @"Дополнительные услуги";
        additionalServices.frame = CGRectMake(8, CGRectGetMaxY(ourCommentLabel.frame), CGRectGetWidth(self.scrollView.frame) - 16, 40);
    }
    else{
        
        CGRect rect = additionalServices.frame;
        rect.size.width = CGRectGetWidth(self.scrollView.frame);
        rect.origin.y = self.scrollView.contentSize.height - 8 - CGRectGetHeight(additionalServices.frame);
        additionalServices.frame = rect;

        
    }
    


    
    [self.scrollView addSubview:additionalServices];
    
    additionalServicesButton.frame = CGRectMake(CGRectGetWidth(additionalServices.frame) - 19, additionalServices.frame.size.height/2 - 10,11, 19);
    [additionalServicesButton setBackgroundImage:[UIImage imageNamed:@"tachometer_arrow.png"] forState:UIControlStateNormal];
    
    [additionalServicesButton addTarget:self action:@selector(pushAdditionalServices) forControlEvents:UIControlEventTouchUpInside];
    [additionalServices addSubview:additionalServicesButton];

    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushAdditionalServices)];
    additionalServices.userInteractionEnabled = YES;
    [additionalServices addGestureRecognizer:tapRecognizer];
    
    
   
}

-(void)pushAdditionalServices{
    ServicesViewController* svc = [self.storyboard instantiateViewControllerWithIdentifier:@"ServicesViewController"];
    svc.tariff = self.tariff;
    svc.idHash = self.idHash;
    svc.selectedID = idArray;
    [self.navigationController pushViewController:svc animated:NO];
}





#pragma mark help Functions

-(NSString*)timeFormat:(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:string];
    /////////convert nsdata To NSString////////////////////////////////////
    [dateFormatter setDateFormat:@"HH.mm"];
    if(date==nil) return @"00.00";
    return [dateFormatter stringFromDate:date];
    
}

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



-(void)cutStringsInArray:(NSMutableArray*)array{
    for (int i = 0; i < array.count; ++i) {
        NSString* str = array[i];
        NSRange range = [str rangeOfString:@"."];
        
        if (range.location == NSNotFound) {
            return;
        }
        
        NSRange substringRange1 = range;
        substringRange1.location += 1;
        
        NSRange substringRange2 = range;
        substringRange2.location += 2;
        
        if ([[str substringWithRange:substringRange2] isEqualToString:@"0"]) {
            str = [str stringByReplacingCharactersInRange:substringRange2 withString:@""];
            [array replaceObjectAtIndex:i withObject:str];
        }
        
        if ([[str substringWithRange:substringRange1] isEqualToString:@"0"]) {
            str = [str stringByReplacingCharactersInRange:substringRange1 withString:@""];
            [array replaceObjectAtIndex:i withObject:str];
        }
        
        NSRange range1 = [str rangeOfString:@"."];
        str = [str stringByReplacingCharactersInRange:range1 withString:@""];
        [array replaceObjectAtIndex:i withObject:str];
    }
}


#pragma mark - button actions
- (IBAction)goingToOrder:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)endOrderAction:(UIButton *)sender {
    [timer invalidate];
    EndUpViewController* euvc=[self.storyboard instantiateViewControllerWithIdentifier:@"EndUpViewController"];
    euvc.orderResponse = self.orderResponse;
    euvc.bill = [NSString stringWithFormat:@"%ld",(long)tachometerResponse.calcOrderPrice];
    euvc.elements = tachometerResponse.elements;
    [self.navigationController pushViewController:euvc animated:NO];
}



#pragma mark - rotation
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         CGSize rect = self.scrollView.contentSize;
         rect.height = scrollViewContentHeight;
         self.scrollView.contentSize = rect;
         
         
         
         for (int i=0 ; i<self.tachoElements.count; ++i)
         {
             UIImageView* imageView = self.tachoElements[i];
             [[self.view viewWithTag:(150+i)] setFrame:imageView.bounds];
             
             
             CGRect rect = imageView.bounds;
             rect.origin.y = CGRectGetHeight(imageView.frame);
             [[self.view viewWithTag:(200+i)] setFrame:rect];
             
         }
         
         
     }
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
        
        
                                     CGFloat xx;
                                     
                                     if(flag==0)
                                     {
                                         xx=self.view.frame.size.width*(CGFloat)5/6*(-1);
                                     }
                                     else
                                     {
                                         xx=0;
                                     }
                                     leftMenu.frame =CGRectMake(xx, leftMenu.frame.origin.y, self.view.frame.size.width*(CGFloat)5/6, self.view.frame.size.height-64);
                                     
                                     additionalServicesButton.frame = CGRectMake(CGRectGetWidth(additionalServices.frame) - 19, additionalServices.frame.size.height/2 - 10,11, 19);
                                     

        
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
             //self.segmentedControll.userInteractionEnabled = NO;
         }
         else
         {
             flag=0;
             self.scrollView.userInteractionEnabled = YES;
             //self.segmentedControll.userInteractionEnabled = YES;
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
             //self.segmentedControll.userInteractionEnabled = YES;
             
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             self.scrollView.userInteractionEnabled = NO;
             //self.segmentedControll.userInteractionEnabled = NO;
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
    //self.segmentedControll.userInteractionEnabled = NO;
    
    flag=1;
    
    
}

- (IBAction)back:(id)sender
{
    if (flag)
    {
        CGPoint point;
        point.x=leftMenu.center.x-leftMenu.frame.size.width;
        point.y=leftMenu.center.y;
        leftMenu.center=point;
    }
    [self.navigationController popViewControllerAnimated:NO];
    
}



@end
