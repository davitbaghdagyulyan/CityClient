//
//  OrdersHistoryViewController.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "OrdersHistoryViewController.h"
#import "CustomCellOrdersHistory.h"
#import "OrdersHistoryResponse.h"
#import "OrdersHistoryJson.h"
#import "LeftMenu.h"
#import "OpenMapButtonHandler.h"
@interface OrdersHistoryViewController ()
{
 LeftMenu*leftMenu;
 OpenMapButtonHandler*openMapButtonHandlerObject;
}
@end
@implementation OrdersHistoryViewController
{
    //Design For self.View
    CAGradientLayer *gradLayer;
    CAGradientLayer *gradLayerForSelfView;
    UIView * transparentView;
    //
    UITableView * tableViewInterval;
    NSArray*intervalArray;
    //Interface For the Views that surrounds datePicker
    UILabel * labelSettingTheDate;
    UIDatePicker * datePicker;
    UILabel * designLabel1;
    UIButton *  buttonCancell;
    UIButton * buttonSetStartDate;
    //Objects For Date Formating and Request
    NSDateFormatter *df;
    NSString *stringEndDate;
    OrdersHistoryJson * ordersHistoryJsonObject;
    OrdersHistoryResponse * ordersHistoryResponseObject;
    //Other
    UIAlertView *alertForNoInternetCon;
    UIAlertView *alertWrongData;
    UIActivityIndicatorView* indicator;
    NSInteger  ratingArray[5];
    NSMutableArray * arrayRateImageViews;
    float height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Setting Labels and Buttons clearColor
    self.GreyView.backgroundColor =[UIColor clearColor];
    self.labelInterval.backgroundColor =[UIColor clearColor];
    self.labelSelectedDate.backgroundColor=[UIColor clearColor];
    self.labelC.backgroundColor =[UIColor clearColor];
    self.labelPo.backgroundColor =[UIColor clearColor];
    //DatePickerPart
    stringEndDate = nil;
    datePicker =[[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date] animated:YES];
    df = [[NSDateFormatter alloc] init];
    df.dateStyle =NSDateFormatterMediumStyle;
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    self.labelSelectedDate.attributedText =[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]]attributes:underlineAttribute];
   intervalArray =[ [NSArray alloc]initWithObjects:@"один день",@"три дня",@"одна неделя",@"две недели",@"месяц", nil];
    self.tableViewOrdersHistory.hidden = YES;
    //FONTS VIEWDIDLOAD
    self.labelC.font =[UIFont fontWithName:@"Roboto-Regular" size:15];
    self.labelPo.font =[UIFont fontWithName:@"Roboto-Regular" size:15];
    self.labelSelectedDate.font =[UIFont fontWithName:@"Roboto-Regular" size:15];
    self.labelInterval.font =[UIFont fontWithName:@"Roboto-Regular" size:15];
    self.buttonFind.titleLabel.font =[UIFont fontWithName:@"Roboto-Regular" size:15];
    self.titleLabel.font =[UIFont fontWithName:@"Roboto-Regular" size:18];
    //
    for (int i=0; i<5; i++)
    {
        ratingArray[i]=0;
    }
}

-(void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:NO];
     [[SingleDataProvider sharedKey]setGpsButtonHandler:self.gpsButton];
    if ([SingleDataProvider sharedKey].isGPSEnabled)
    {
        [self.gpsButton setImage:[UIImage imageNamed:@"gps_green.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [self.gpsButton setImage:[UIImage imageNamed:@"gps.png"] forState:UIControlStateNormal];
    }
    [GPSConection showGPSConection:self];
    //Karen  Changing colours of icons
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];
    //Adding Gradient For self.view
    if (!gradLayerForSelfView)
    {
     gradLayerForSelfView =[CAGradientLayer layer];
    }
    UIColor * gradColStartSelView =[UIColor colorWithRed:223/255.0f green:223/255.0f blue:223/255.0f alpha:1.0f];
    UIColor * gradColFinSelView =[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1.0f];
    gradLayerForSelfView.frame =CGRectMake(0,65, self.view.frame.size.width,self.view.frame.size.height);
    [gradLayerForSelfView setColors:[NSArray arrayWithObjects:(id)(gradColStartSelView.CGColor), (id)(gradColFinSelView.CGColor),nil]];
    [self.view.layer insertSublayer:gradLayerForSelfView atIndex:0];
    //Adding Gradient For GreyView
    if (!gradLayer)
    {
    gradLayer=[CAGradientLayer layer];
    }
    UIColor * graColStart = [UIColor colorWithRed:212/255.0f green:212/255.0f blue:212/255.0f alpha:1.0f];
    UIColor * graColFin =[UIColor colorWithRed:233/255.0f green:233/255.0f blue:233/255.0f alpha:1.0f];
    gradLayer.frame = self.GreyView.bounds;
    [gradLayer setColors:[NSArray arrayWithObjects:(id)(graColStart.CGColor), (id)(graColFin.CGColor),nil]];
    [self.GreyView.layer insertSublayer:gradLayer atIndex:0];
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
    else
    {
    if (ordersHistoryResponseObject.orders.count !=0)
    {
        self.tableViewOrdersHistory.hidden = NO;
    }
     return ordersHistoryResponseObject.orders.count;
    }
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
        cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
        return cell;
    }
       NSString *simpleTableIdentifierIphone = @"SimpleTableCellIdentifier";
    CustomCellOrdersHistory * cell = (CustomCellOrdersHistory *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierIphone];
    if (cell == nil)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellOrdersHistory2" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    arrayRateImageViews = [[NSMutableArray alloc]initWithObjects:cell.rateImgView1,cell.rateImgView2,cell.rateImgView3,cell.rateImgView4,cell.rateImgView5, nil];
    cell.labelYandexReview.numberOfLines = 0;
    cell.labelYandexReview.font=[UIFont fontWithName:@"Roboto-Regular" size:12];
    cell.labelYandexReview.lineBreakMode =  NSLineBreakByWordWrapping;
    if ([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]yandex_review])
    {
     cell.labelYandexReview.text = [[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]yandex_review];
    }
    else
    {
     cell.labelYandexReview.text=@"";
    }
 
    cell.labelCallMetroName.font =[UIFont fontWithName:@"Roboto-Regular" size:12];
    if ([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]CollMetroName])
    {
        cell.labelCallMetroName.text =[[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]CollMetroName];
    }
    else
    {
        cell.labelCallMetroName.text = @"";
    }
    cell.deliveryMetroName.font =[UIFont fontWithName:@"Roboto-Regular" size:12];
    if ([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]DeliveryMetroName])
    {
        cell.deliveryMetroName.text =[[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]DeliveryMetroName];
    }
    else
    {
        cell.deliveryMetroName.text= @"";
    }
    cell.labelDate.textColor =[UIColor whiteColor];
    cell.labelDate.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    cell.labelDate.numberOfLines =2;
    NSString * collDate =[[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]OrderedDate];
    if (collDate)
    {
        NSString *collDate1 =[collDate substringToIndex:16];
        NSString * year1 =[collDate1 substringToIndex:4];
        NSString * year =[year1 substringFromIndex:2];
        NSString * day1 =[collDate1 substringFromIndex:8];
        NSString * day=[day1 substringToIndex:2];
        NSString * month1=[collDate1 substringFromIndex:5];
        NSString* month=[month1 substringToIndex:2];
        NSString * time1=[collDate1 substringFromIndex:11];
        NSString * hour=[time1 substringToIndex:2];
        NSString *minutes=[time1 substringFromIndex:3];
        NSString * collDateFirstRow=[NSString stringWithFormat:@"%@.%@.%@",day,month,year];
        NSString * collDateSecondRow=[NSString stringWithFormat:@"%@.%@",hour,minutes];
        NSString * stringForDate = [NSString stringWithFormat:@" %@\n %@",collDateFirstRow,collDateSecondRow];
       cell.labelDate.text = stringForDate;
    }
    else
    {
        cell.labelDate.text= @"";
    }
    cell.labelShortName.font = [UIFont fontWithName:@"Roboto-Regular" size:30];
    cell.labelShortName.textColor  = [UIColor whiteColor];
    if ([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]shortname])
    {
        cell.labelShortName.text =[[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]shortname];
    }
    else
    {
        cell.labelShortName.text =@"";
    }
    if ([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]price])
    {
        cell.labelPrice.text =[NSString stringWithFormat:@"%@ b",[[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]price]];
        
    }
    else
    {
        cell.labelPrice.text =@"0b";
    }
   


    if ([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row] CollAddrTypeMenu])
    {
        switch ([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row] CollAddrTypeMenu]) {
            case 1:
                cell.imgViewCall.image = [UIImage imageNamed:@"metro.png"];
                break;
            case 2:
                cell.imgViewCall.image = [UIImage imageNamed:@"train.png"];
                break;
            case 3:
                cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_airport.png"];
                break;
            case 4:
                cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_outdoors.png"];
                break;
            case 10:
                cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_hospital.png"];
                break;
            case 11:
                cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_school.png"];
                break;
            case 12:
                cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_cinema.png"];
                break;
            case 13:
                cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_mall.png"];
                break;
            default:
                break;
        }
    }
    if ([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]DeliveryAddrTypeMenu])
    {
        switch ([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row] DeliveryAddrTypeMenu]) {
            case 1:
                cell.imgViewDel.image = [UIImage imageNamed:@"metro.png"];
                break;
            case 2:
                cell.imgViewDel.image = [UIImage imageNamed:@"train.png"];
                break;
            case 3:
                cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_airport.png"];
                break;
            case 4:
                cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_outdoors.png"];
                break;
            case 10:
                cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_hospital.png"];
                break;
            case 11:
                cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_school.png"];
                break;
            case 12:
                cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_cinema.png"];
                break;
            case 13:
                cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_mall.png"];
                break;
            default:
                break;
        }
    }

    if (height ==40)
    {
        cell.labelYandexReview.text = @"";
        cell.rateImgView1.hidden =YES;
        cell.rateImgView2.hidden = YES;
        cell.rateImgView3.hidden = YES;
        cell.rateImgView4.hidden =YES;
        cell.rateImgView5.hidden = YES;
    }
    [self addYandexRate:3];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return  cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView ==tableViewInterval)
    {
         return 44;
    }
    else
    { height =38;
      NSString * myString;
        if([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]yandex_rating] && [[[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]yandex_rating]integerValue] != -1)
        {
            if([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]yandex_review] && [[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]yandex_review].length !=0)
            {
                UILabel * labelDefiningSize;
                CGSize  expectSize;
                myString =[[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]yandex_review];
                if (!labelDefiningSize)
                {
                 labelDefiningSize  = [[UILabel alloc] init];
                }
                labelDefiningSize.text =myString;
                labelDefiningSize.numberOfLines = 0;
                labelDefiningSize.lineBreakMode = NSLineBreakByWordWrapping;
                CGSize maximumLabelSize = CGSizeMake(252,100);
                expectSize = [labelDefiningSize sizeThatFits:maximumLabelSize];
                if (expectSize.height<=20)
                {
                    height =height+20;
                }
                else
                {
                    height =height+expectSize.height;
                }
            }
            else
            {
                height =height +20;
            }
        }
        else
        {
            height = height +2;
        }

     return height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
if (tableView == tableViewInterval)
{
    [transparentView removeFromSuperview];
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
    transparentView = [[UIView alloc]initWithFrame:self.view.frame];
    transparentView.backgroundColor = [UIColor blackColor];
    transparentView.alpha =0.7;
    [self.view addSubview:transparentView];
    [self.view  addSubview:datePicker];
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDatePicker)];
    letterTapRecognizer.numberOfTapsRequired = 1;
    [transparentView addGestureRecognizer:letterTapRecognizer];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = NO;
    [datePicker addTarget:self action:@selector(changeDateInLabel:)forControlEvents:UIControlEventValueChanged];
    datePicker.backgroundColor = [UIColor whiteColor];
    if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait ||
       [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortraitUpsideDown)
    {
        datePicker.frame =CGRectMake(self.tableViewOrdersHistory.frame.origin.x ,self.GreyView.frame.origin.y+50,self.tableViewOrdersHistory.frame.size.width,0);
    }
    else
    {
    datePicker.frame =CGRectMake(self.tableViewOrdersHistory.frame.origin.x+self.tableViewOrdersHistory.frame.size.width/4 ,self.GreyView.frame.origin.y+20,self.tableViewOrdersHistory.frame.size.width/2,0);
    }
    if (!labelSettingTheDate)
    {
     labelSettingTheDate = [[UILabel alloc]init];
    }
    if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait ||
       [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortraitUpsideDown)
    {
        labelSettingTheDate.frame  = CGRectMake(datePicker.frame.origin.x ,datePicker.frame.origin.y-50,datePicker.frame.size.width,50);
    }
    else
    {
        labelSettingTheDate.frame  = CGRectMake(datePicker.frame.origin.x ,datePicker.frame.origin.y-25,datePicker.frame.size.width,25);
    }
    labelSettingTheDate.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    labelSettingTheDate.textColor=[UIColor colorWithRed:44/255.0 green:203/255.0 blue:251/255.0 alpha:1];
    labelSettingTheDate.backgroundColor=[UIColor whiteColor];
    labelSettingTheDate.text=@"Настройка даты";
    labelSettingTheDate.textAlignment=NSTextAlignmentCenter;
    if (! designLabel1)
    {
     designLabel1=[[UILabel alloc]init];
    }
    designLabel1.frame=CGRectMake(datePicker.frame.origin.x, labelSettingTheDate.frame.origin.y + labelSettingTheDate.frame.size.height, datePicker.frame.size.width,1);
    designLabel1.backgroundColor=[UIColor colorWithRed:44/255.0 green:203/255.0 blue:251/255.0 alpha:1];
    [self.view  addSubview:labelSettingTheDate];
    [self.view  addSubview:designLabel1];
    if (!buttonCancell)
    {
     buttonCancell = [[UIButton alloc]init];
    }
    if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait ||
                        [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortraitUpsideDown)
    {
        buttonCancell.frame =CGRectMake(datePicker.frame.origin.x,datePicker.frame.origin.y+datePicker.frame.size.height, datePicker.frame.size.width/2,50);
    }
    else
    {
       buttonCancell.frame =CGRectMake(datePicker.frame.origin.x,datePicker.frame.origin.y+datePicker.frame.size.height, datePicker.frame.size.width/2,25);
    }
    [[buttonCancell layer] setBorderWidth:1.0f];
    buttonCancell.layer.borderColor =[UIColor colorWithRed:44/255.0 green:203/255.0 blue:251/255.0 alpha:1].CGColor;
    buttonCancell.backgroundColor = [UIColor whiteColor];
    buttonCancell.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
    [buttonCancell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonCancell  addTarget:self action:@selector(Cancell) forControlEvents:UIControlEventTouchUpInside];
    [buttonCancell setTitle:@"Отмена" forState:UIControlStateNormal];
    [self.view  addSubview:buttonCancell];
    if (!buttonSetStartDate)
    {
     buttonSetStartDate = [[UIButton alloc]init];
    }
   if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait ||
                         [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortraitUpsideDown)
    {
      buttonSetStartDate.frame =CGRectMake(datePicker.frame.origin.x+buttonCancell.frame.size.width,datePicker.frame.origin.y+datePicker.frame.size.height, datePicker.frame.size.width/2,50);
    }
    else
    {
      buttonSetStartDate.frame =CGRectMake(datePicker.frame.origin.x+buttonCancell.frame.size.width,datePicker.frame.origin.y+datePicker.frame.size.height, datePicker.frame.size.width/2,25);
    }
    [[buttonSetStartDate layer] setBorderWidth:1.0f];
    buttonSetStartDate.layer.borderColor =[UIColor colorWithRed:44/255.0 green:203/255.0 blue:251/255.0 alpha:1].CGColor;
    buttonSetStartDate.backgroundColor = [UIColor whiteColor];
    buttonSetStartDate.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
    [buttonSetStartDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonSetStartDate addTarget:self action:@selector(setTime) forControlEvents:UIControlEventTouchUpInside];
    [buttonSetStartDate setTitle:@"Установить" forState:UIControlStateNormal];
    [self.view  addSubview:buttonSetStartDate];

}

-(void)Cancell
{
    self.buttonDatePicker.userInteractionEnabled = YES;
    [transparentView removeFromSuperview];
    [datePicker removeFromSuperview];
    [buttonCancell removeFromSuperview];
    [buttonSetStartDate removeFromSuperview];
    [labelSettingTheDate removeFromSuperview];
    [designLabel1 removeFromSuperview];
    self.tableViewOrdersHistory.userInteractionEnabled = YES;
}

-(void)setTime
{
    self.buttonDatePicker.userInteractionEnabled = YES;
    [datePicker removeFromSuperview];
    [transparentView removeFromSuperview];
    [buttonSetStartDate removeFromSuperview];
    [buttonCancell removeFromSuperview];
    [labelSettingTheDate removeFromSuperview];
    [designLabel1 removeFromSuperview];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    self.labelSelectedDate.attributedText =[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]]attributes:underlineAttribute];
    self.tableViewOrdersHistory.userInteractionEnabled = YES;
}


-(void)removeDatePicker
{
    [transparentView removeFromSuperview];
    [datePicker removeFromSuperview];
    [labelSettingTheDate removeFromSuperview];
    [buttonCancell removeFromSuperview];
    [buttonSetStartDate removeFromSuperview];
    [tableViewInterval removeFromSuperview];
    [designLabel1 removeFromSuperview];
    self.buttonDatePicker.userInteractionEnabled = YES;
    self.buttonIntervalTableView.userInteractionEnabled = YES;
    
}

- (void)changeDateInLabel:(id)sender{
    //Use NSDateFormatter to write out the date in a friendly format
  
    
    
}

- (IBAction)pickToDate:(id)sender
{
    transparentView = [[UIView alloc]initWithFrame:self.view.frame];
    transparentView.backgroundColor = [UIColor blackColor];
    transparentView.alpha =0.7;
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDatePicker)];
    letterTapRecognizer.numberOfTapsRequired = 1;
    [transparentView addGestureRecognizer:letterTapRecognizer];
    [self.view addSubview:transparentView];
    if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait ||
    [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortraitUpsideDown)
    {
        tableViewInterval = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViewOrdersHistory.frame.origin.x ,self.GreyView.frame.origin.y,self.tableViewOrdersHistory.frame.size.width,5*44)];
        self.buttonIntervalTableView.userInteractionEnabled = NO;
    }else
    {
     tableViewInterval = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViewOrdersHistory.frame.origin.x +self.GreyView.frame.size.width/4,self.GreyView.frame.origin.y-10,self.tableViewOrdersHistory.frame.size.width/2,5*44)];
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
- (IBAction)findOrdersFromInterval:(id)sender
{
    if (!ordersHistoryJsonObject)
    {
      ordersHistoryJsonObject = [[OrdersHistoryJson alloc]init];
    }
    ordersHistoryJsonObject.start=self.labelSelectedDate.text;
    ordersHistoryJsonObject.end=stringEndDate;
    [self requestOrdersHistory];
}

-(void)requestOrdersHistory
{
    if (!indicator)
    {
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    NSDictionary*jsonDictionary=[ordersHistoryJsonObject  toDictionary];
    NSString*jsons=[ordersHistoryJsonObject  toJSONString];
    NSLog(@"%@",jsons);
    NSURL* url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"api_url"]];
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
            UIAlertController *alertNoCon = [UIAlertController alertControllerWithTitle:@ "Нет соединения с интернетом!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [alertNoCon dismissViewControllerAnimated:YES completion:nil];
                                                          }];
            [alertNoCon addAction:cancel];
            [self presentViewController:alertNoCon animated:YES completion:nil];
        }
        NSString* jsonString1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"selectedOrdersDetails =%@",jsonString1);
        NSError*err;
        ordersHistoryResponseObject  = [[OrdersHistoryResponse alloc] initWithString:jsonString1 error:&err];
        if(ordersHistoryResponseObject.code!=nil)
        {
            
            UIAlertController *alertServerErr = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:ordersHistoryResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          [alertServerErr dismissViewControllerAnimated:YES completion:nil];
                                                          }];
            [alertServerErr addAction:cancel];
            [self presentViewController:alertServerErr animated:YES completion:nil];
        }
        [indicator stopAnimating];
        [self.tableViewOrdersHistory reloadData];
        
    }];
}

- (IBAction)openAndCloseLeftMenu:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.2
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
             self.tableViewOrdersHistory.userInteractionEnabled=NO;
             
             self.tableViewOrdersHistory.tag=1;
             
             
             [leftMenu.disabledViewsArray removeAllObjects];
   
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.tableViewOrdersHistory.tag]];
             
         }
         else
         {
             leftMenu.flag=0;
             self.tableViewOrdersHistory.userInteractionEnabled=YES;
             
         }
         
     }
     
     
     ];
    
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
             self.tableViewOrdersHistory.userInteractionEnabled=YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             self.tableViewOrdersHistory.userInteractionEnabled=NO;
             
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
    self.tableViewOrdersHistory.userInteractionEnabled=NO;
    leftMenu.flag=1;
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        

        UIDeviceOrientation deviceOrientation   = [[UIDevice currentDevice] orientation];
        
        if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
            NSLog(@"Will change to Landscape");
            self.buttonDatePicker.userInteractionEnabled = YES;
            self.buttonIntervalTableView.userInteractionEnabled = YES;
            [transparentView removeFromSuperview];
            [datePicker removeFromSuperview];
            [labelSettingTheDate removeFromSuperview];
            [buttonSetStartDate removeFromSuperview];
            [buttonCancell removeFromSuperview];
            [tableViewInterval removeFromSuperview];
            [designLabel1 removeFromSuperview];
            indicator.center = self.view.center;
            gradLayer.frame =CGRectMake(0, 0, self.GreyView.frame.size.width,self.GreyView.frame.size.height);
            gradLayerForSelfView.frame =CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);

}

        else {
            NSLog(@"Will change to Portrait");
            self.buttonDatePicker.userInteractionEnabled = YES;
            self.buttonIntervalTableView.userInteractionEnabled = YES;
            [transparentView removeFromSuperview];
            [datePicker removeFromSuperview];
            [labelSettingTheDate removeFromSuperview];
            [buttonCancell removeFromSuperview];
            [buttonSetStartDate removeFromSuperview];
            [tableViewInterval removeFromSuperview];
            [designLabel1 removeFromSuperview];
            gradLayer.frame = CGRectMake(0, 0, self.GreyView.frame.size.width,self.GreyView.frame.size.height);
            gradLayerForSelfView.frame =CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
            indicator.center = self.view.center;
        }
     
        
    }
     

     
    completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         CGFloat xx;
         if(leftMenu.flag==0)
         {
             xx=320*(CGFloat)5/6*(-1);
         }
         else
         {
             xx=0;
         }
         leftMenu.frame =CGRectMake(xx, leftMenu.frame.origin.y, leftMenu.frame.size.width, self.view.frame.size.height-64);
         
     }];
    
    
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
    
    
   
}



-(void)addYandexRate:(NSInteger)k
{
 
    for (int i=0; i<k; i++)
    {
        ratingArray[i]=1;
    }

    for (int i =0; i<5; i++)
    {
        UIImageView * imgView = [arrayRateImageViews objectAtIndex:i];
       if (ratingArray[i]==1)
        {
            
            imgView.image =[UIImage imageNamed:@"star.png"];
        }
        else
        {
            imgView.image = [UIImage imageNamed:@"star_none.png"];
        }
        
        
    }

}

- (IBAction)actionGPS:(id)sender {
}


- (IBAction)openMap:(UIButton*)sender
{
    openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
}

@end
