//
//  OrdersHistoryViewController.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "OrdersHistoryViewController.h"
#import "CustomCellOrdersHistory.h"
#import "SingleDataProviderForEndDate.h"
#import "SingleDataProviderForStartDate.h"
#import "OrdersHistoryResponse.h"
#import "OrdersHistoryJson.h"
#import "LeftMenu.h"

@interface OrdersHistoryViewController ()
{
 LeftMenu*leftMenu;
 NSInteger flag;
}
@end

@implementation OrdersHistoryViewController
{
    UITableView * tableViewInterval;
    UIButton *  buttonCancell;
    UIButton * buttonSetStartDate;
    UIDatePicker * datePicker;
    NSArray*intervalArray;
    UIView * pickerView;
    UILabel * labelSettingTheDate;
    NSDateFormatter *df;
    NSString *stringEndDate;
    UILabel * designLabel;
    UIAlertView *alertForNoInternetCon;
    UIAlertView *alertWrongData;
    OrdersHistoryResponse * ordersHistoryResponseObject;
    UIActivityIndicatorView* indicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    stringEndDate = nil;
    datePicker =[[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date] animated:YES];
    df = [[NSDateFormatter alloc] init];
    df.dateStyle =NSDateFormatterMediumStyle;
    [df setDateFormat:@"yyyy-MM-dd"];
    self.labelSelectedDate.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    intervalArray =[ [NSArray alloc]initWithObjects:@"один день",@"три дня",@"одна неделя",@"две недели",@"месяц", nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
     leftMenu=[LeftMenu getLeftMenu:self];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView ==tableViewInterval )
    {
        return intervalArray.count;
    }
    return 10;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView==tableViewInterval)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        }
        cell.textLabel.text = [intervalArray objectAtIndex:indexPath.row];
        return cell;
    }
    NSString *simpleTableIdentifierIphone = @"SimpleTableCellIphone";
    CustomCellOrdersHistory * cell = (CustomCellOrdersHistory *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierIphone];
    if (cell == nil)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellOrdersHistory" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
if (tableView == tableViewInterval)
{
 [tableViewInterval removeFromSuperview];
 self.labelInterval.text = [intervalArray objectAtIndex:indexPath.row];
 NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
 switch (indexPath.row) {
            case 0:
                [dateComponents setDay:1];
                break;
            case 1:
                [dateComponents setDay:3];
                break;
            case 2:
                [dateComponents setDay:7];
                break;
            case 3:
                [dateComponents setDay:14];
                break;
            case 4:
                [dateComponents setMonth:1];
                break;
            default:
                break;
 }
NSCalendar *calendar = [NSCalendar currentCalendar];
NSDate *endDate = [calendar dateByAddingComponents:dateComponents toDate:datePicker.date options:0];
stringEndDate = [df stringFromDate:endDate];
self.buttonIntervalTableView.userInteractionEnabled = YES;
}
else
{
[tableView deselectRowAtIndexPath:indexPath animated:NO];
}
}

- (IBAction)pickFromDate:(id)sender
{
    self.tableViewOrdersHistory.userInteractionEnabled = NO;
    self.buttonDatePicker.userInteractionEnabled = NO;
    [self.view addSubview:datePicker];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = NO;
    [datePicker addTarget:self action:@selector(changeDateInLabel:)forControlEvents:UIControlEventValueChanged];
    datePicker.backgroundColor = [UIColor whiteColor];
    if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
       [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
    {
        datePicker.frame =CGRectMake(self.tableViewOrdersHistory.frame.origin.x ,self.GreyView.frame.origin.y+65,0,0);
    }
    else
    {
    datePicker.frame =CGRectMake(self.tableViewOrdersHistory.frame.origin.x ,self.GreyView.frame.origin.y+5,0,0);
    }
    labelSettingTheDate = [[UILabel alloc]init];
    labelSettingTheDate.frame  = CGRectMake(self.tableViewOrdersHistory.frame.origin.x ,datePicker.frame.origin.y-25,datePicker.frame.size.width,25);
    labelSettingTheDate.backgroundColor = [UIColor whiteColor];
    labelSettingTheDate.text = @"Настройка даты";
    labelSettingTheDate.textColor = [UIColor blackColor];
    labelSettingTheDate.textAlignment =NSTextAlignmentCenter;
    labelSettingTheDate.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:labelSettingTheDate];
    buttonCancell = [[UIButton alloc]initWithFrame:CGRectMake(0,datePicker.frame.origin.y+datePicker.frame.size.height, datePicker.frame.size.width/2,25)];
    buttonCancell.backgroundColor = [UIColor whiteColor];
    [buttonCancell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonCancell  addTarget:self action:@selector(Cancell) forControlEvents:UIControlEventTouchUpInside];
    [buttonCancell setTitle:@"Отмена" forState:UIControlStateNormal];
    [self.view addSubview:buttonCancell];
    buttonSetStartDate = [[UIButton alloc]initWithFrame:CGRectMake(buttonCancell.frame.size.width,datePicker.frame.origin.y+datePicker.frame.size.height, datePicker.frame.size.width/2,25)];
    buttonSetStartDate.backgroundColor = [UIColor whiteColor];
    [buttonSetStartDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonSetStartDate addTarget:self action:@selector(setTime) forControlEvents:UIControlEventTouchUpInside];
    [buttonSetStartDate setTitle:@"Установить" forState:UIControlStateNormal];
    [self.view addSubview:buttonSetStartDate];

}



-(void)Cancell
{
    self.buttonDatePicker.userInteractionEnabled = YES;
    [datePicker removeFromSuperview];
    [buttonSetStartDate removeFromSuperview];
    [buttonCancell removeFromSuperview];
    [labelSettingTheDate removeFromSuperview];
    self.tableViewOrdersHistory.userInteractionEnabled = YES;
}


-(void)setTime
{
    self.buttonDatePicker.userInteractionEnabled = YES;
    self.labelSelectedDate.text = [NSString stringWithFormat:@"%@",
                                  [df stringFromDate:datePicker.date]];
    [labelSettingTheDate removeFromSuperview];
    [datePicker removeFromSuperview];
    [buttonSetStartDate removeFromSuperview];
    [buttonCancell removeFromSuperview];
    self.tableViewOrdersHistory.userInteractionEnabled = YES;
    
}

- (void)changeDateInLabel:(id)sender{
    //Use NSDateFormatter to write out the date in a friendly format
  
    
    
}

- (IBAction)pickToDate:(id)sender
{
    if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
    [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
    {
     tableViewInterval = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViewOrdersHistory.frame.origin.x ,self.GreyView.frame.origin.y + self.buttonFind.frame.origin.y,self.tableViewOrdersHistory.frame.size.width,self.GreyView.frame.size.height*4)];
        self.buttonIntervalTableView.userInteractionEnabled = NO;
    }else
    {
     tableViewInterval = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViewOrdersHistory.frame.origin.x +self.GreyView.frame.size.width/4,self.GreyView.frame.origin.y-10,self.tableViewOrdersHistory.frame.size.width/2,self.GreyView.frame.size.height +self.tableViewOrdersHistory.frame.size.height+10)];
     self.buttonIntervalTableView.userInteractionEnabled = NO;
      }
    tableViewInterval.delegate = self;
    tableViewInterval.dataSource= self;
    [self.view addSubview:tableViewInterval];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL) shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    
    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait
        || fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        self.buttonDatePicker.userInteractionEnabled = YES;
        self.buttonIntervalTableView.userInteractionEnabled = YES;
        [labelSettingTheDate removeFromSuperview];
        [datePicker removeFromSuperview];
        [buttonCancell removeFromSuperview];
        [buttonSetStartDate removeFromSuperview];
        [tableViewInterval removeFromSuperview];
        indicator.center = self.view.center;
       
       
        
    }
    else if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft
             || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
        
    {
        self.buttonDatePicker.userInteractionEnabled = YES;
        self.buttonIntervalTableView.userInteractionEnabled = YES;
        [labelSettingTheDate removeFromSuperview];
        [datePicker removeFromSuperview];
        [tableViewInterval removeFromSuperview];
        [buttonCancell removeFromSuperview];
        [buttonSetStartDate removeFromSuperview];
        indicator.center = self.view.center;
    }
}


- (IBAction)findOrdersFromInterval:(id)sender
{
    [SingleDataProviderForStartDate sharedStartDate].startDate = self.labelSelectedDate.text;
    [SingleDataProviderForEndDate sharedEndDate].endDate = stringEndDate;
    [self requestOrdersHistory];
   
}

-(void)requestOrdersHistory
{

    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    OrdersHistoryJson * ordersHistoryJsonObject = [[OrdersHistoryJson alloc]init];
    NSDictionary*jsonDictionary=[ordersHistoryJsonObject  toDictionary];
    NSString*jsons=[ordersHistoryJsonObject  toJSONString];
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
    request.timeoutInterval = 10;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            alertForNoInternetCon = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"NO INTERNET CONECTION"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            
            [alertForNoInternetCon show];
            return ;
        }
        NSString* jsonString1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"selectedOrdersDetails =%@",jsonString1);
        NSError*err;
        ordersHistoryResponseObject  = [[OrdersHistoryResponse alloc] initWithString:jsonString1 error:&err];
        if(ordersHistoryResponseObject.code!=nil)
        {
            
            alertWrongData = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alertWrongData show];
            return;
            
        }
        [indicator stopAnimating];
        [self.tableViewOrdersHistory reloadData];
        
    }];
}

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
             self.tableViewOrdersHistory.userInteractionEnabled=NO;
             
         }
         else
         {
             flag=0;
             self.tableViewOrdersHistory.userInteractionEnabled=YES;
             
         }
         
     }
     
     
     ];
    
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
             self.tableViewOrdersHistory.userInteractionEnabled=YES;
             
             
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             self.tableViewOrdersHistory.userInteractionEnabled=NO;
             
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
    
    
    
    
    
    
    
    
    self.tableViewOrdersHistory.userInteractionEnabled=NO;
    
    
    flag=1;
    
    
    
    
    
    
}


@end
