//
//  RobotSettingsViewController.m
//  CityMobilDriver
//
//  Created by Intern on 11/17/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "RobotSettingsViewController.h"
#import "RequestStandart.h"
#import "ResponseGetAutoSettings.h"
#import "RequestUpdateAutoSettings.h"
#import "LeftMenu.h"
#import "StandartResponse.h"
#import "OpenMapButtonHandler.h"
#import "LoginViewController.h"


@interface RobotSettingsViewController ()
{
    LeftMenu*leftMenu;
    
    
    UIScrollView *scrollView;
    UILabel* descriptionLabel;
    UITableView* robotTable;
    UIButton* saveButton;
    
    
    BOOL isDefaultTable;
    ResponseGetAutoSettings* responseObject;
    UIView* backgroundView;
    UIActivityIndicatorView* indicator;
    
    UITableView* radiusSettingsTable;
    UITableView* timeSettingsTable;
    
    
    NSMutableArray* controllViewsArray;
    
    UIView* childYearView;
    
    
    NSMutableArray* carCheckBoxArray;
    
    UILabel* childSeatLabel;
    
    OpenMapButtonHandler*openMapButtonHandlerObject;
    
    
    UITableViewCell* childSeatCell;
    UIButton* cancelButton;
    
}
@end

@implementation RobotSettingsViewController
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(8, 64, self.view.frame.size.width - 16, self.view.frame.size.height - 64)];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 551);
    [self.view addSubview:scrollView];
    
    descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, 50)];
    descriptionLabel.text = @"НАСТРОЙКА РОБОТА";
    descriptionLabel.textColor = [UIColor orangeColor];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:descriptionLabel];
    
    

    
    
    saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 508, scrollView.frame.size.width, 35)];
    saveButton.backgroundColor = [UIColor orangeColor];
    [saveButton setTitle:@"Сохранить" forState:UIControlStateNormal];
    saveButton.titleLabel.textColor = [UIColor whiteColor];
    [saveButton addTarget:self action:@selector(saveInformation:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:saveButton];
    
    
    backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.alpha = 0.6;
    [self.view addSubview:backgroundView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    tag = 102;
    [self.gpsButton setNeedsDisplay];
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    isDefaultTable = YES;
    controllViewsArray = [[NSMutableArray alloc]init];
    carCheckBoxArray = [[NSMutableArray alloc]init];
    scrollView.userInteractionEnabled=YES;
    leftMenu=[LeftMenu getLeftMenu:self];
    
    
    robotTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, scrollView.frame.size.width, 450)];
    robotTable.scrollEnabled = NO;
    robotTable.delegate = self;
    robotTable.dataSource = self;
    [scrollView addSubview:robotTable];
    
    [self RequestGetAutoSettings];
    
    
    [GPSConection showGPSConection:self];
    
    [self.yandexButton setNeedsDisplay];
    [self.cityButton setNeedsDisplay];
}


-(void)viewWillDisappear:(BOOL)animated{
    robotTable = nil;
    controllViewsArray = nil;
    carCheckBoxArray = nil;
}


#pragma mark - separators

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == robotTable) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 5, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 5, 0, 0)];
        }
    }
    else{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([robotTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [robotTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([robotTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [robotTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([radiusSettingsTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [radiusSettingsTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([radiusSettingsTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [radiusSettingsTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([timeSettingsTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [timeSettingsTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([timeSettingsTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [timeSettingsTable setLayoutMargins:UIEdgeInsetsZero];
    }
}



#pragma mark - scrollView horizontal scroll

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    if (sender.contentOffset.x != 0)
    {
        CGPoint offset = sender.contentOffset;
        offset.x = 0;
        sender.contentOffset = offset;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == robotTable) {
        return 10;
    }
    if (tableView == radiusSettingsTable) {
        return 6;
    }
    if (tableView == timeSettingsTable) {
        return 12;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (tableView == robotTable) {
    cell.backgroundColor = [UIColor colorWithRed:236/255 green:236/255 blue:236/255 alpha:0.1];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UILabel* textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width - 60, 45)];
    textLabel.numberOfLines = 2;
    [cell.contentView addSubview:textLabel];
    
    cell.textLabel.numberOfLines = 2;
    
    if (isDefaultTable) {
    switch (indexPath.row) {
        case 0:
        {
            textLabel.text = @" Радиус поиска показа, км";
            [self setButton:cell isDefaultTable:YES isRadius:YES];
        }
            case 1:
            textLabel.text = @" До сдачи авто по заказу, мин";
            [self setButton:cell isDefaultTable:YES isRadius:NO];
            break;
        case 2:
            textLabel.text = @" Некурящий салон";
            [self setSwitch:cell isSelected:NO switchTag:2];
            break;
        case 3:
            textLabel.text = @" В машине есть кондиционер";
            [self setSwitch:cell isSelected:NO switchTag:3];
            break;
        case 4:
            textLabel.text = @" Перевожу животных";
            [self setSwitch:cell isSelected:NO switchTag:4];
            break;
        case 5:
            textLabel.text = @" Есть квитанция";
            [self setSwitch:cell isSelected:NO switchTag:5];
            break;
        case 6:
            textLabel.text = @" В машине есть Wi-Fi";
            [self setSwitch:cell isSelected:NO switchTag:6];
            break;
        case 7:
            textLabel.text = @" Оплата пластиковыми картами";
            [self setSwitch:cell isSelected:NO switchTag:7];
            break;
        case 8:
            textLabel.text = @" Класс машины";
            break;
        case 9:
            textLabel.text = @" Детские кресла";
            [self setSwitch:cell isSelected:NO switchTag:8];
            break;
  default:

    break;
}
    }
    else{
        switch (indexPath.row) {
            case 0:
            {
                textLabel.text = @" Радиус поиска показа, км";
                [self setButton:cell isDefaultTable:NO isRadius:YES];
            }
                break;
            case 1:
                textLabel.text = @" До сдачи авто по заказу, мин";
                [self setButton:cell isDefaultTable:NO isRadius:NO];
                break;
            case 2:
                textLabel.text = @" Некурящий салон";
                [self setSwitch:cell isSelected:!responseObject.smoking switchTag:2];
                break;
            case 3:
                textLabel.text = @" В машине есть кондиционер";
                [self setSwitch:cell isSelected:responseObject.conditioner switchTag:3];
                break;
            case 4:
                textLabel.text = @" Перевезу животных";
                [self setSwitch:cell isSelected:responseObject.animal switchTag:4];
                break;
            case 5:
                textLabel.text = @" Есть квитанция";
                [self setSwitch:cell isSelected:responseObject.has_check switchTag:5];
                break;
            case 6:
                textLabel.text = @" В машине есть Wi-Fi";
                [self setSwitch:cell isSelected:responseObject.has_wifi switchTag:6];
                break;
            case 7:
                textLabel.text = @" Оплата пластиковыми картами";
                [self setSwitch:cell isSelected:responseObject.has_card switchTag:7];
                break;
            case 8:
            {
                textLabel.text = @" Класс машины";
                
                for (int i = 0; i < [responseObject.possible_tariffs count]; ++i) {
                    UIButton* checkBox = [[UIButton alloc]initWithFrame:CGRectMake(8, 45 + i*(8+15), 16, 15)];
                    
                    [checkBox setBackgroundImage:[UIImage imageNamed:@"box2.png"] forState:UIControlStateSelected];
                    [checkBox setBackgroundImage:[UIImage imageNamed:@"box.png"] forState:UIControlStateNormal];
                    
                    
                    [checkBox addTarget:self action:@selector(checkBoxAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if ([responseObject.tariffs containsObject:[responseObject.possible_tariffs[i] getId]]) {
                        [checkBox setSelected:YES];
                    }
                    
                    else{
                        [checkBox setSelected:NO];
                    }
                    [cell.contentView addSubview:checkBox];
                    
                    
                    UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(8 + 16 + 10, 45 + i*(8+15) - 4, 200, 15 + 8)];
                    button.tag = i;
                    [button setTitle:[responseObject.possible_tariffs[i] name] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(setCheckBox:) forControlEvents:UIControlEventTouchUpInside];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    [cell addSubview:button];
                    
                    [carCheckBoxArray addObject:checkBox];
                }
            }
                break;
            case 9:{
                
                textLabel.text = @" Детские кресла";
                childSeatLabel = textLabel;
                if ([responseObject.child_seat count] > 0) {
                    [self setSwitch:cell isSelected:YES switchTag:8];
                    
                    textLabel.text = [textLabel.text stringByAppendingString:@" ["];
                    for (int i = 0; i < [responseObject.child_seat count]; ++i) {
                        NSNumber* number = responseObject.child_seat[i];
                        textLabel.text = [textLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@",number]];
                        if (i < [responseObject.child_seat count] - 1) {
                            textLabel.text = [textLabel.text stringByAppendingString:@","];
                        }
                        
                    }
                    textLabel.text = [textLabel.text stringByAppendingString:@"]"];
                }
                else{
                    [self setSwitch:cell isSelected:NO switchTag:8];
                }
                childSeatCell = cell;
            }
                break;
            default:
                
                break;
        }
    }
    }
    
    if (tableView == radiusSettingsTable) {
        if (indexPath.row == 5) {
            cell.backgroundColor = [UIColor orangeColor];
            cell.textLabel.text = @"Отмена";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        else{
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];//???
            cell.textLabel.text = [NSString stringWithFormat:@"%i",indexPath.row + 1];
        }
    }
    
    if (tableView == timeSettingsTable) {
        if (indexPath.row == 12) {
            cell.backgroundColor = [UIColor orangeColor];
            cell.textLabel.text = @"Отмена";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        else{
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];//???
            cell.textLabel.text = [NSString stringWithFormat:@"%i",(indexPath.row + 1) * 5];
        }
    }
    
    
    return cell;
}



-(void)cancelButton:(UIButton*)sender{
    [cancelButton removeFromSuperview];
    [timeSettingsTable removeFromSuperview];
    [backgroundView removeFromSuperview];
}

-(void)setCheckBox:(UIButton*)sender{
    UIButton* checkBox = (UIButton*)carCheckBoxArray[sender.tag];

    if (checkBox.isSelected) {
            [checkBox setSelected:NO];
    }
    else{
        [checkBox setSelected:YES];
    }
}

-(void)setSwitch: (UITableViewCell*)cell isSelected:(BOOL)isSelected switchTag:(NSInteger)tag{
    NSLog(@"%li",(long)tag);
    UISwitch* Switch = [[UISwitch alloc]init];
    Switch.onTintColor = [UIColor orangeColor];
    Switch.tag = tag + 100;
    Switch.on = isSelected;

    Switch.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:Switch];
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:Switch attribute:NSLayoutAttributeTrailingMargin
                                 relatedBy:NSLayoutRelationEqual toItem:cell.contentView
                                 attribute:NSLayoutAttributeTrailingMargin multiplier:1.0 constant:-10]];
    
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:Switch attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual toItem:cell.contentView
                                                     attribute:NSLayoutAttributeTop multiplier:1.0 constant:8]];
    
    
    if (!isDefaultTable) {
        [controllViewsArray addObject:Switch];
        [Switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)setButton: (UITableViewCell*)cell isDefaultTable:(BOOL)defaultTable isRadius:(BOOL)isRadius{
    
    UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(cell.frame.size.width - 20, 7, 48, 25)];
    
    button.backgroundColor = [UIColor whiteColor];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(button.frame.size.width - 10, 10, 8, 4)];
    [imageView setImage:[UIImage imageNamed:@"arrow.png"]];
    [button addSubview:imageView];
    [cell.contentView addSubview:button];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (!defaultTable) {
        [button addTarget:self action:@selector(radiusTimeSettings:) forControlEvents:UIControlEventTouchUpInside];
        if (isRadius) {
            [button setTitle: [NSString stringWithFormat:@"%ld",(long)responseObject.radius] forState:UIControlStateNormal];
            button.tag = 100;
        }
        else{
            [button setTitle: [NSString stringWithFormat:@"%ld",(long)responseObject.collminute] forState:UIControlStateNormal];
            button.tag = 101;
        }
        [controllViewsArray addObject:button];
    }
    
    
    
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailingMargin
                                                                 relatedBy:NSLayoutRelationEqual toItem:cell.contentView
                                                                 attribute:NSLayoutAttributeTrailingMargin multiplier:1.0 constant:-10]];
    
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual toItem:cell.contentView
                                                                 attribute:NSLayoutAttributeTop multiplier:1.0 constant:8]];
    
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual toItem:cell.contentView
                                                                 attribute:NSLayoutAttributeWidth multiplier:0 constant:48]];
    
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual toItem:cell.contentView
                                                                 attribute:NSLayoutAttributeWidth multiplier:0 constant:25]];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == robotTable) {
        if (isDefaultTable) {
            return 45;
        }
        else {
            if (indexPath.row == 8) {
                robotTable.frame = CGRectMake(0, 50, scrollView.frame.size.width, 450 + (15 + 8)* [responseObject.possible_tariffs count]);
                saveButton.frame = CGRectMake(0, 508 + (15 + 8)*[responseObject.possible_tariffs count], scrollView.frame.size.width, 35);
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 551 + (15 + 8)*[responseObject.possible_tariffs count]);
                return 45 + (15 + 8)*[responseObject.possible_tariffs count];
            }
            else{
                return 45;
            }
        }
    }
    if (tableView == timeSettingsTable || tableView == radiusSettingsTable) {
        return 40;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == timeSettingsTable) {
            UIButton* button = controllViewsArray[1];
            [button setTitle:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forState:UIControlStateNormal];
        [cancelButton removeFromSuperview];
        [timeSettingsTable removeFromSuperview];
        [backgroundView removeFromSuperview];
    }
    if (tableView == radiusSettingsTable) {
        
        if (indexPath.row != 5) {
            UIButton* button = controllViewsArray[0];
            [button setTitle:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forState:UIControlStateNormal];
        }
        [radiusSettingsTable removeFromSuperview];
        [backgroundView removeFromSuperview];
    }
}

#pragma mark radius and time settings actions
-(void)radiusTimeSettings:(UIButton*)sender{
    [self.view addSubview:backgroundView];
    if (sender.tag == 100) {
        if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeLeft ||
           [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeRight)
        {
            radiusSettingsTable = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*7/64, (self.view.frame.size.height - 240)/2, self.view.frame.size.width*25/32, 240)];
            radiusSettingsTable.scrollEnabled = NO;

        }
        else{
            radiusSettingsTable = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*7/64,  (self.view.frame.size.height - 240)/2, self.view.frame.size.width*25/32, 240)];
            radiusSettingsTable.scrollEnabled = NO;
        }
        
        radiusSettingsTable.delegate = self;
        radiusSettingsTable.dataSource = self;
        [self.view addSubview:radiusSettingsTable];

    }
    else if(sender.tag == 101){
    timeSettingsTable = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*7/64, (self.view.frame.size.height - 240)/2 - 20, self.view.frame.size.width*25/32, 240)];
        cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(timeSettingsTable.frame), CGRectGetMaxY(timeSettingsTable.frame), CGRectGetWidth(timeSettingsTable.frame), 40)];
        [cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.backgroundColor = [UIColor orangeColor];
        [cancelButton setTitle:@"Отмена" forState:UIControlStateNormal];
        [self.view addSubview:cancelButton];
        
        
        timeSettingsTable.delegate = self;
        timeSettingsTable.dataSource = self;
        [self.view addSubview:timeSettingsTable];
    }
}


-(void)switchAction:(UISwitch*)sender{
    switch (sender.tag) {
        case 102:
            
            break;
        case 103:
            
            break;
        case 104:
            
            break;
        case 105:
            
            break;
        case 106:
            
            break;
        case 107:
            
            break;
        case 108:
        {
            if (sender.isOn) {
                [self.view addSubview:backgroundView];
                childYearView = [[NSBundle mainBundle] loadNibNamed:@"childYear" owner:self options:nil][0];
                childYearView.frame = CGRectMake((self.view.frame.size.width - 262)/2, (self.view.frame.size.height - 240)/2, 262, 240);
                [self.view addSubview:childYearView];
            }
            else{
                childSeatLabel.text = @" Детские кресла";
            }
            

        }
            break;
            
        default:
            break;
    }
}

- (IBAction)checkBoxAction:(UIButton *)sender {
    if (!sender.isSelected) {
        [sender setSelected:YES];
    }
    else{
        [sender setSelected:NO];
    }
}


- (IBAction)okChildYear:(UIButton *)sender {
    [backgroundView removeFromSuperview];
    [childYearView removeFromSuperview];


    NSInteger count = 0;
    for (int i = 0; i < [self.checkBoxes count]; ++i) {
        if ([self.checkBoxes[i] isSelected]) {
            ++count;
        }
    }
    if (count == 0) {
        UISwitch* swith = (UISwitch*)[childSeatCell viewWithTag:108];
        swith.on = NO;
        return;
    }
    if (count) {
        childSeatLabel.text = [childSeatLabel.text stringByAppendingString:@" ["];
    }
    NSInteger newCount = count;
    for (int i = 0; i < [self.checkBoxes count]; ++i) {
        if ([self.checkBoxes[i] isSelected]) {
            -- count;
            childSeatLabel.text = [childSeatLabel.text stringByAppendingString:[NSString stringWithFormat:@"%i",i + 1]];
            if (count > 0) {
                childSeatLabel.text = [childSeatLabel.text stringByAppendingString:@","];
            }
        }
    }
    if (newCount) {
        childSeatLabel.text = [childSeatLabel.text stringByAppendingString:@"]"];
    }
}


#pragma mark - Requests
-(void)RequestGetAutoSettings
{
    RequestStandart* RequestObject=[[RequestStandart alloc]init];
    RequestObject.method = @"GetAutoSettings";
    NSDictionary* jsonDictionary = [RequestObject toDictionary];
    
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
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            return ;
        }
        
        NSError* err;
        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        responseObject = [[ResponseGetAutoSettings alloc]initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:responseObject.text code:responseObject.code];
                
        NSLog(@"%@",[responseObject description]);
        
        isDefaultTable = NO;
        [robotTable reloadData];
        [backgroundView removeFromSuperview];
        [indicator removeFromSuperview];
    }];
    
}





-(void)saveInformation:(UIButton*)sender{
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    RequestUpdateAutoSettings* requestObject=[[RequestUpdateAutoSettings alloc]init];
    
    requestObject.settings.radius =  [[controllViewsArray[0] titleLabel].text integerValue];
    requestObject.settings.collminute = [[controllViewsArray[1] titleLabel].text integerValue];
    
    requestObject.settings.smoking = ![controllViewsArray[2] isOn];
    requestObject.settings.conditioner = [controllViewsArray[3] isOn];
    requestObject.settings.animal = [controllViewsArray[4] isOn];
    requestObject.settings.has_check = [controllViewsArray[5] isOn];
    requestObject.settings.has_wifi = [controllViewsArray[6] isOn];
    requestObject.settings.has_card = [controllViewsArray[7] isOn];
    
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for (int i = 0; i < [carCheckBoxArray count]; ++i) {
        [array addObject:[NSNumber numberWithInt:-1]];
    }
    
    for (int i = 0; i < [carCheckBoxArray count]; ++i) {
        if ([carCheckBoxArray[i] isSelected]) {
            [array addObject:[responseObject.possible_tariffs[i] getId]];
        }
    }
    requestObject.settings.tariffs = array;
    
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    if ([controllViewsArray[8] isOn]) {
        for (int i = 0; i < [self.checkBoxes count]; ++i) {
            if ([self.checkBoxes[i] isSelected]) {
                [arr addObject:[NSNumber numberWithInt:i+1]];
            }
        }
    }
    requestObject.settings.child_seat = arr;
    
    
    
    requestObject.settings.possible_tariffs = nil;
    requestObject.settings.max_collminute = 0;
    requestObject.settings.max_radius = 0;
    
    
    NSDictionary* jsonDictionary = [requestObject toDictionary];
    NSLog(@"%@",jsonDictionary);
    
    
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
        
        NSError* err;
        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"---------->>>>>> %@",jsonString);
        StandartResponse* obj = [[StandartResponse alloc]initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:obj.text code:obj.code];
        
        if (obj.code == nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Настройки успешно сохранены" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            [indicator stopAnimating];
        }
    }];
}




#pragma mark - rotation


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        scrollView.frame = CGRectMake(8, 64, self.view.frame.size.width - 16, self.view.frame.size.height - 64);
        descriptionLabel.frame = CGRectMake(0, 0, scrollView.frame.size.width, 50);
        robotTable.frame = CGRectMake(0, 50, scrollView.frame.size.width, 450);
        if (isDefaultTable) {
            saveButton.frame = CGRectMake(0, 508, scrollView.frame.size.width, 35);
        }
        else{
        saveButton.frame = CGRectMake(0, 508 + (15 + 8)*[responseObject.possible_tariffs count], scrollView.frame.size.width, 35);
        }
        
            radiusSettingsTable.frame = CGRectMake(self.view.frame.size.width*7/64, (self.view.frame.size.height - 240)/2, self.view.frame.size.width*25/32, 240);
        
        
        timeSettingsTable.frame = CGRectMake(self.view.frame.size.width*7/64, (self.view.frame.size.height - 240)/2 - 20, self.view.frame.size.width*25/32, 240);
        cancelButton.frame = CGRectMake(CGRectGetMinX(timeSettingsTable.frame), CGRectGetMaxY(timeSettingsTable.frame), CGRectGetWidth(timeSettingsTable.frame), 40);
        

        backgroundView.frame = self.view.frame;
        indicator.center = self.view.center;
        
        
        childYearView.frame = CGRectMake((self.view.frame.size.width - 262)/2, (self.view.frame.size.height - 240)/2, 262, 240);
   
        

    }
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {     CGFloat xx;
                                     
                                     if(leftMenu.flag==0)
                                     {
                                         xx=self.view.frame.size.width*(CGFloat)5/6*(-1);
                                     }
                                     else
                                     {
                                         xx=0;
                                     }
                                     
                                     leftMenu.frame =CGRectMake(xx, leftMenu.frame.origin.y, leftMenu.frame.size.width, self.view.frame.size.height-64);}];
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
             scrollView.tag=1;
             scrollView.userInteractionEnabled=NO;
             [leftMenu.disabledViewsArray removeAllObjects];
          
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:scrollView.tag]];
             
         }
         else
         {
             leftMenu.flag=0;
             scrollView.userInteractionEnabled=YES;
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
             scrollView.userInteractionEnabled=YES;
             
             
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             scrollView.userInteractionEnabled=NO;
             
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
    scrollView.userInteractionEnabled=NO;
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
    }
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (IBAction)openMap:(UIButton*)sender
{
    openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
}

@end
