//
//  EndUpViewController.m
//  CityMobilDriver
//
//  Created by Intern on 12/9/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "EndUpViewController.h"
#import "RequestSetBill.h"
#import "ResponseSetBill.h"
#import "GetOrderJson.h"
#import "GetOrderResponse.h"
#import "SetStatusJson.h"
#import "SetStatusResponse.h"
#import "LeftMenu.h"
#import "SingleDataProvider.h"
#import "OpenMapButtonHandler.h"
@interface EndUpViewController ()
{
    ResponseSetBill* billResponse;
    CGFloat bgViewHeigth;
    UIView* bgView;
    SetStatusJson*setStatusObject;
    SetStatusResponse*setStatusResponseObject;
    UIAlertController *alertController;
    NSTimer* myTimer;
    
    
    UIButton* priceButton;
    UILabel* getPriceLabel;
    UITextField* billTextField;
    UILabel* clientBonus;
    UILabel* billDifference;
    UIButton* PaymentOnBonusesButton;
    UIButton* continueToOrder;
    UIButton* cashPaymentButton;
    CAGradientLayer* gradientLayer;

    OpenMapButtonHandler*openMapButtonHandlerObject;
  

    LeftMenu* leftMenu;
    
    
    UIImageView* cashImage;
    UIImageView* bonusImage;
    
}

@end

@implementation EndUpViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self requestSetBill];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
     [GPSConection showGPSConection:self];
    
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];
    [self.gpsButton setNeedsDisplay];
    bgViewHeigth = 0.f;
    [bgView removeFromSuperview];
     bgView = [[UIView alloc]init];
    leftMenu=[LeftMenu getLeftMenu:self];
    
    setStatusObject=[[SetStatusJson alloc]init];
    setStatusObject.elements=self.elements;
    
    priceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.endUpScrollView.frame), 60)];
    [priceButton addTarget:self action:@selector(priceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [priceButton setTitle:self.bill forState:UIControlStateNormal];
    [priceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [priceButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:30]];
    [bgView addSubview:priceButton];

    bgViewHeigth += CGRectGetHeight(priceButton.frame);
    
    
    
    getPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(priceButton.frame) + 10, 120, 25)];
    getPriceLabel.text = @"Получено:";
    [getPriceLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:15]];
    [bgView addSubview:getPriceLabel];
    bgViewHeigth += CGRectGetHeight(getPriceLabel.frame) + 10;
    
    
    billTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.endUpScrollView.frame) - (CGRectGetWidth(self.endUpScrollView.frame) - 16)/2 - 8, CGRectGetMinY(getPriceLabel.frame), (CGRectGetWidth(self.endUpScrollView.frame) - 16)/2, 25)];
    billTextField.delegate = self;
    billTextField.keyboardType =  UIKeyboardTypeNumberPad;
    billTextField.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:billTextField];
    
    
    clientBonus = [[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(billTextField.frame) + 10, 120, 25)];
    clientBonus.text = @"Бонус клиенту:";
    [clientBonus setFont:[UIFont fontWithName:@"Roboto-Regular" size:15]];
    [bgView addSubview:clientBonus];
    bgViewHeigth += CGRectGetHeight(clientBonus.frame) + 30;
    
    
    billDifference = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(billTextField.frame), CGRectGetMinY(clientBonus.frame), CGRectGetWidth(billTextField.frame), 25)];
    [billDifference setFont:[UIFont fontWithName:@"Roboto-Regular" size:15]];
    [bgView addSubview:billDifference];
    
    
    
    if ([self.orderResponse.payment_method isEqualToString:@"cash"]) {
        [self drowCashButton];
    }
    else if ([self.orderResponse.payment_method isEqualToString:@"card"]) {
        myTimer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                   target:self
                                                 selector:@selector(requestGetOrder)
                                                 userInfo:nil
                                                  repeats:YES];
        
        [self addAlertView:@"Выполняется оплата по карте"];
    }
    
    else if ([self.orderResponse.payment_method isEqualToString:@"corporate"]) {
        myTimer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                   target:self
                                                 selector:@selector(requestGetOrder)
                                                 userInfo:nil
                                                  repeats:YES];
        [self addAlertView:@"Выполняется безналичная оплата"];
    }
    
}

-(void)drowPage
{
    if ([self.orderResponse.useBonus isEqualToString:@"Y"]) {
        PaymentOnBonusesButton = [[UIButton alloc]initWithFrame:CGRectMake(8, bgViewHeigth , CGRectGetWidth(self.endUpScrollView.frame) - 16, 40)];
        PaymentOnBonusesButton.titleLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
        
        bonusImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(PaymentOnBonusesButton.frame)- 44 - 5, (CGRectGetHeight(PaymentOnBonusesButton.frame) - 38)/2, 44, 38)];
        [bonusImage setImage:[UIImage imageNamed:@"on_bonuses_payment.png"]];
        [PaymentOnBonusesButton addSubview:bonusImage];
        
        
        [PaymentOnBonusesButton setTitle:@"Оплата по бонусам" forState:UIControlStateNormal];
        PaymentOnBonusesButton.backgroundColor = [UIColor orangeColor];
        [PaymentOnBonusesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bgView addSubview:PaymentOnBonusesButton];
        [PaymentOnBonusesButton addTarget:self action:@selector(paymentOnBonusesAction) forControlEvents:UIControlEventTouchUpInside];
        bgViewHeigth += CGRectGetHeight(PaymentOnBonusesButton.frame)+ 8;
    }
    else{
        
    }
    
    
    continueToOrder = [[UIButton alloc]initWithFrame:CGRectMake(8, bgViewHeigth , CGRectGetWidth(self.endUpScrollView.frame) - 16, 40)];
    continueToOrder.titleLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    [continueToOrder setTitle:@"Продолжить  заказ" forState:UIControlStateNormal];
    continueToOrder.backgroundColor = [UIColor grayColor];
    [continueToOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgView addSubview:continueToOrder];
    [continueToOrder addTarget:self action:@selector(continueToOrderAction) forControlEvents:UIControlEventTouchUpInside];
    
    bgViewHeigth += CGRectGetHeight(continueToOrder.frame)+ 5;
    
    self.endUpScrollView.contentSize=CGSizeMake(CGRectGetWidth(self.endUpScrollView.frame), bgViewHeigth);
    bgView.frame = CGRectMake(0, 0, CGRectGetWidth(self.endUpScrollView.frame), bgViewHeigth);
    bgView.backgroundColor = [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1.f];
    gradientLayer = [self greyGradient:bgView widthFrame:priceButton.frame];
    [bgView.layer insertSublayer:gradientLayer atIndex:0];
    
    UITapGestureRecognizer* tapGasture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
    [bgView addGestureRecognizer:tapGasture];
    
    [self.endUpScrollView addSubview:bgView];
    
    [self.view addGestureRecognizer:tapGasture];
}

-(void)addAlertView:(NSString*)titleString{
    alertController = [UIAlertController alertControllerWithTitle:titleString
                                                                             message:@"Пожалуйста подождите"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    spinner.center = CGPointMake(30, 65.5);
    spinner.color = [UIColor blackColor];
    [spinner startAnimating];
    [alertController.view addSubview:spinner];
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                               actionWithTitle:@"Отмена"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [alertController dismissViewControllerAnimated:NO completion:nil];
                                   [myTimer invalidate];
                                   [self drowCashButton];
                               }];
    
    [alertController addAction:cancelAction];

    
    
    [self presentViewController:alertController animated:NO completion:nil];
}


-(void)drowCashButton{
    cashPaymentButton = [[UIButton alloc]initWithFrame:CGRectMake(8, bgViewHeigth , CGRectGetWidth(self.endUpScrollView.frame) - 16, 40)];
   
    
    cashImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(cashPaymentButton.frame)- 44 - 5, (CGRectGetHeight(cashPaymentButton.frame) - 38)/2, 44, 38)];
    [cashImage setImage:[UIImage imageNamed:@"cash.png"]];
    [cashPaymentButton addSubview:cashImage];
    
    
    [cashPaymentButton setTitle:@"Оплата за наличный расчет" forState:UIControlStateNormal];
    
    cashPaymentButton.titleLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    
    cashPaymentButton.backgroundColor = [UIColor orangeColor];
    [cashPaymentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgView addSubview:cashPaymentButton];
    bgViewHeigth += CGRectGetHeight(cashPaymentButton.frame)+ 8;
    [cashPaymentButton addTarget:self action:@selector(cashPaymentAction) forControlEvents:UIControlEventTouchUpInside];
    [self drowPage];
}



-(void)priceButtonAction:(UIButton*)sender{
    billTextField.text = sender.titleLabel.text;
    billDifference.text=@"0";
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

        NSString* str = textField.text;
    if ([string isEqualToString:@""])
    {
        str=[str substringToIndex:[str length] - 1];
    }
    else
    {
        str = [str stringByAppendingString:string];
    }
        int a = [str intValue];
        int b = [priceButton.titleLabel.text intValue];
        int diference = a - b;
        if (diference > 0)
        {
            billDifference.text = [NSString stringWithFormat:@"%i",diference];
        }
        else
        {
            billDifference.text = @"0";
        }

    return YES;
}



#pragma mark - Requests
-(void)requestSetBill
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    RequestSetBill* jsonObject=[[RequestSetBill alloc]init];
    jsonObject.idhash = self.orderResponse.idhash;
    jsonObject.bill = self.bill;
    NSDictionary* jsonDictionary=[jsonObject toDictionary];
    NSString*jsons=[jsonObject toJSONString];
    NSLog(@"%@",jsons);
    
    
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
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"NO INTERNET CONECTION"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            
            [alert show];
            [indicator stopAnimating];
            return ;
        }
        
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        NSError* err;
        billResponse = [[ResponseSetBill alloc] initWithString:jsonString error:&err];
       
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:billResponse.text code:billResponse.code];
        
        setStatusObject.time=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].time];
        setStatusObject.direction=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].direction];
        setStatusObject.speed=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].speed];
        
        setStatusObject.lat=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].lat];
        setStatusObject.lon=[NSString stringWithFormat:@"%f",[SingleDataProvider sharedKey].lon];
        
        setStatusObject.idhash=self.orderResponse.idhash;
        setStatusObject.bill=self.bill;
        setStatusObject.creditlimit=billResponse.creditlimit;
        setStatusObject.commision=billResponse.commision;
        setStatusObject.balance=billResponse.balance;
        setStatusObject.status=@"CP";
        
        [indicator stopAnimating];
    }];
    
}


-(void)requestGetOrder
{
    
    GetOrderJson* getOrderJsonObject = [[GetOrderJson alloc]init];
    getOrderJsonObject.idhash = self.orderResponse.idhash;
    
    NSDictionary*jsonDictionary=[getOrderJsonObject toDictionary];
    NSString*jsons=[getOrderJsonObject toJSONString];
    NSLog(@"%@",jsons);
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
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:@"Нет соединения с интернетом!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                        
                                    }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",jsonString);
        NSError*err;
        GetOrderResponse* getOrderResponseObject = [[GetOrderResponse alloc] initWithString:jsonString error:&err];

        if(getOrderResponseObject.code!=nil)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:getOrderResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            
            BadRequest* badRequest = [[BadRequest alloc]init];
            badRequest.delegate = self;
            [badRequest showErrorAlertMessage:getOrderResponseObject.text code:getOrderResponseObject.code];
            
            if ([getOrderResponseObject.status isEqualToString:@"CP"]) {
                [alertController dismissViewControllerAnimated:NO completion:nil];
                [myTimer invalidate];
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
        }

    }];
    
}


#pragma mark - rotation
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         bgViewHeigth=0;
         priceButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.endUpScrollView.frame), 60);
         bgViewHeigth+=60;
         billTextField.frame = CGRectMake(CGRectGetWidth(self.endUpScrollView.frame) - (CGRectGetWidth(self.endUpScrollView.frame) - 16)/2 - 8, CGRectGetMinY(getPriceLabel.frame), (CGRectGetWidth(self.endUpScrollView.frame) - 16)/2, 25);
         bgViewHeigth+=35;
         
        billDifference.frame = CGRectMake(CGRectGetMinX(billTextField.frame), CGRectGetMaxY(clientBonus.frame), CGRectGetWidth(billTextField.frame), 25);
         bgViewHeigth+=55;
         
        PaymentOnBonusesButton.frame = CGRectMake(8, bgViewHeigth , CGRectGetWidth(self.endUpScrollView.frame) - 16, 40);
         bgViewHeigth+=50;
         
         cashPaymentButton.frame = CGRectMake(8, bgViewHeigth, CGRectGetWidth(self.endUpScrollView.frame) - 16, 40);
         bgViewHeigth+=50;
         
         continueToOrder.frame = CGRectMake(8, bgViewHeigth, CGRectGetWidth(self.endUpScrollView.frame) - 16, 40);
         bgViewHeigth+=45;
         
         bgView.frame = CGRectMake(0, 0, CGRectGetWidth(self.endUpScrollView.frame), bgViewHeigth);
         self.endUpScrollView.contentSize=CGSizeMake(CGRectGetWidth(self.endUpScrollView.frame), bgViewHeigth);
         gradientLayer.frame = priceButton.frame;
         
         
        bonusImage.frame = CGRectMake(CGRectGetWidth(PaymentOnBonusesButton.frame)- 44 - 5, (CGRectGetHeight(PaymentOnBonusesButton.frame) - 38)/2, 44, 38);
        cashImage.frame = CGRectMake(CGRectGetWidth(cashPaymentButton.frame)- 44 - 5, (CGRectGetHeight(cashPaymentButton.frame) - 38)/2, 44, 38);
     }
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
         
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
//
//         additionalServicesButton.frame = CGRectMake(CGRectGetWidth(additionalServices.frame) - 19, additionalServices.frame.size.height/2 - 10,11, 19);
//         
//
         
     }];
    
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
}



-(void)closeKeyBoard{
    [billTextField resignFirstResponder];
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

-(void)continueToOrderAction
{
    [self.navigationController popViewControllerAnimated:NO];
    
}

-(void)cashPaymentAction
{
    setStatusObject.bonus=@"0";
    setStatusObject.received=billTextField.text;
    
    if ((([billTextField.text intValue]<[priceButton.titleLabel.text intValue])) || [billDifference.text isEqualToString:@""]||(billDifference.text==nil))
    {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Операция невозможна" message:@"Полученная сумма меньше стоимости поездки" preferredStyle:UIAlertControllerStyleAlert];
        
            UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
        
                                    }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
    }
    else if([billDifference.text intValue] == 0 || [billResponse.balance intValue] - [billDifference.text intValue] - [billResponse.commision intValue] >= [billResponse.creditlimit intValue])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Выберите действие"
                                                                       message:
                                    [NSString stringWithFormat:@"Стоимость поездки:%@\nПолучено:%@\nБонус клиенту:%@",self.bill,billTextField.text,billDifference.text]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Подвердить" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       [self requestSetStatus];
                                       
                                   }];
        [alert addAction:okAction];
        
        UIAlertAction* cancel =[UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                   }];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Операция невозможна"
                                                                       message:
                                    [NSString stringWithFormat:@"Лимит превышен\nна:%ld\nСтоимость поездки:%@\nПолучено:%@\nБонус клиенту:%@\nКомиссия с заказа:%@\nМин. необходимый остаток:%@\nТекущий баланс:%@", [billResponse.creditlimit integerValue] - ([billResponse.balance integerValue] - [billDifference.text integerValue] - [billResponse.commision integerValue]),
                                     self.bill,billTextField.text,billDifference.text,billResponse.commision,billResponse.creditlimit,billResponse.balance]
                                    
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }

}

-(void)paymentOnBonusesAction
{
    setStatusObject.bonus=@"1";
    setStatusObject.received=billTextField.text;
    [self requestSetStatus];
}

-(void)requestSetStatus
{
    UIActivityIndicatorView*indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    
    NSDictionary*jsonDictionary=[setStatusObject toDictionary];
    NSString*jsons=[setStatusObject toJSONString];
    NSLog(@"%@",jsons);
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
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:@"Нет соединения с интернетом!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        [indicator stopAnimating];
                                        return ;
                                    }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",jsonString);
        NSError*err;
        
        
        
        setStatusResponseObject = [[SetStatusResponse alloc] initWithString:jsonString error:&err];
        
        
        
        
        if(setStatusResponseObject.code!=nil)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:setStatusResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else if ([setStatusResponseObject.result isEqualToString:@"1"])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:setStatusResponseObject.message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        [self.navigationController popToRootViewControllerAnimated:NO];
                                    }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];

        }
        [indicator stopAnimating];
    }];
}


- (IBAction)openAndCloseLeftMenu:(UIButton *)sender
{
    [self.view bringSubviewToFront:leftMenu];
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
             self.endUpScrollView.userInteractionEnabled=NO;
             self.endUpScrollView.tag=1;
             [leftMenu.disabledViewsArray removeAllObjects];
            
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong: self.endUpScrollView.tag]];
             
         }
         else
         {
             leftMenu.flag=0;
             self.endUpScrollView.userInteractionEnabled=YES;
         
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
    [self.view bringSubviewToFront:leftMenu];
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
             self.endUpScrollView.userInteractionEnabled=YES;
       
             
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             self.endUpScrollView.userInteractionEnabled=NO;
         
             
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
    [self.view bringSubviewToFront:leftMenu];
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
    self.endUpScrollView.userInteractionEnabled=NO;
   
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