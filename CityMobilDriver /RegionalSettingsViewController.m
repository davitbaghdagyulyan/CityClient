//
//  RegionalSettingsViewController.m
//  CityMobilDriver
//
//  Created by Intern on 11/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "RegionalSettingsViewController.h"
#import "RequestStandart.h"
#import "SingleDataProvider.h"
#import "GetZonesResponse.h"
#import "CustomTableViewCell.h"
#import "RequestGetApiAbilities.h"
#import "ResponseGetApiAbilities.h"

#import "LeftMenu.h"



@interface RegionalSettingsViewController ()
{
    CLLocationManager *locationManager;
    CLLocation* currentLocation;
    GetZonesResponse* responseObject;
    NSString* sity;
    
    CLLocationDistance currentDistance;
    
    UIView* backgroundView;
    UIView* buttomView;
    UITableView* sityTable;
    
    NSInteger selectedIndexOfCell;
    BOOL isRegionFound;
    BOOL isbuttomViewInNotFound;
    LeftMenu*leftMenu;
}
@end

@implementation RegionalSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [locationManager requestAlwaysAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getzones];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //NSLog(@" class = %@",[[locations lastObject] class]);
    
    currentLocation = [locations lastObject];
    NSLog(@"%f--- %f", currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
}

#pragma mark Requests
-(void)getzones
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    RequestStandart* requestObject=[[RequestStandart alloc]init];
    requestObject.method = @"getzones";
    requestObject.key = [SingleDataProvider sharedKey].key;
    NSDictionary* jsonDictionary = [requestObject toDictionary];
    
    NSURL* url = [NSURL URLWithString:@"https://driver-api.city-mobil.ru/"];
    
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
            [indicator stopAnimating];
            [self presentViewController:alert animated:YES completion:nil];
            return ;
        }
        
        NSError* err;
        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        
        responseObject = [[GetZonesResponse alloc]initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:responseObject.text code:responseObject.code];
        
        //NSLog(@"%@",[responseObject description]);
        isRegionFound = [self isCircleContainsPoint];
        if (isRegionFound)
        {
            [self regionFound:sity];
        }
        else{
            [self regionNotFound:NO];
        }
        
        [indicator stopAnimating];
        
    }];
}

-(BOOL)isCircleContainsPoint
{
    if (currentLocation)
    {
    for (int i = 0; i < [responseObject.zones count]; ++i)
      {
        CLLocation* sityLocation = [[CLLocation alloc]initWithLatitude:[responseObject.zones[i] latitude]
                                                             longitude:[responseObject.zones[i] longitude]];

        
        NSLog(@"%@",currentLocation);
            currentDistance = [sityLocation distanceFromLocation:currentLocation];
            if (currentDistance < [responseObject.zones[i] getRadius])
            {
                sity = [responseObject.zones[i] name];
                selectedIndexOfCell=i;
                return YES;
            
            }
      }
    }
    return NO;
}


-(void)regionFound:(NSString*)descriptionText{
    backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.alpha = 0.3;
    [self.view addSubview:backgroundView];
    
    
    buttomView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, (self.view.frame.size.height - 120) / 2, 300, 120)];
    
    buttomView.backgroundColor = [UIColor grayColor];
    isbuttomViewInNotFound = NO;
    [self.view addSubview:buttomView];
    
    UILabel* descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, buttomView.frame.size.width, buttomView.frame.size.height/2)];
    descriptionLabel.text = @" Ваш регион: ";
    descriptionLabel.text = [descriptionLabel.text stringByAppendingString:descriptionText];
    descriptionLabel.backgroundColor = [UIColor whiteColor];
    [buttomView addSubview:descriptionLabel];

    
    UIButton* changeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, buttomView.frame.size.height/2 + 1, buttomView.frame.size.width/2, buttomView.frame.size.height/2)];
    changeButton.backgroundColor = [UIColor whiteColor];
    [changeButton setTitle:@"Сменить" forState:UIControlStateNormal];
    [changeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(changeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:changeButton];
    
    
    UIButton* okButton = [[UIButton alloc]initWithFrame:CGRectMake(buttomView.frame.size.width/2 + 1, buttomView.frame.size.height/2 + 1, buttomView.frame.size.width/2 - 1, buttomView.frame.size.height/2)];
    okButton.backgroundColor = [UIColor whiteColor];
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttomView addSubview:okButton];
}

-(void)okButtonAction
{
    [backgroundView removeFromSuperview];
    [buttomView removeFromSuperview];
   
    leftMenu=[LeftMenu getLeftMenu:self];

    
    leftMenu.isChangedRegion=YES;
    
    [self requestGetApiAbilities];
    
    
}

-(void)changeButtonAction{
    isRegionFound = NO;
    [backgroundView removeFromSuperview];
    [buttomView removeFromSuperview];
    [self regionNotFound:YES];
}


-(void)tryAgainButtonAction{
    [backgroundView removeFromSuperview];
    [buttomView removeFromSuperview];
    [self getzones];
}

-(void)regionNotFound:(BOOL)isChange{
    
    backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.alpha = 0.3;
    [self.view addSubview:backgroundView];
    
    buttomView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, (self.view.frame.size.height - 250) / 2, 300, responseObject.zones.count*40+91)];
    buttomView.backgroundColor = [UIColor blueColor];
    isbuttomViewInNotFound = YES;
    [self.view addSubview:buttomView];
    
    UILabel* descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, buttomView.frame.size.width, 50)];
    if (isChange) {
        descriptionLabel.text = @" выберите из списка";
    }
    else{
        descriptionLabel.text = @" Ваш регион не найден \r\n выберите из списка";
    }
    descriptionLabel.numberOfLines = 2;
    descriptionLabel.backgroundColor = [UIColor whiteColor];
    [buttomView addSubview:descriptionLabel];
    
    sityTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 51, buttomView.frame.size.width, responseObject.zones.count*40)];
    sityTable.delegate = self;
    sityTable.dataSource = self;
    sityTable.scrollEnabled = NO;
    [buttomView addSubview:sityTable];
    
    UIButton* tryAgainButton = [[UIButton alloc]initWithFrame:CGRectMake(0, responseObject.zones.count*40+51, 2*buttomView.frame.size.width/3, 40)];
    tryAgainButton.backgroundColor = [UIColor whiteColor];
    [tryAgainButton setTitle:@"повторить попытку" forState:UIControlStateNormal];
    [tryAgainButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tryAgainButton addTarget:self action:@selector(tryAgainButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:tryAgainButton];
    
    UIButton* okButton = [[UIButton alloc]initWithFrame:CGRectMake(2*buttomView.frame.size.width/3 + 1, responseObject.zones.count*40+51, buttomView.frame.size.width/3 - 1, 40)];
    okButton.backgroundColor = [UIColor whiteColor];
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:okButton];
}






#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)secKtion{
    if (isRegionFound)
    {
        return 1;
    }
    
    return responseObject.zones.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomTableViewCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil] objectAtIndex:0];
    if (isRegionFound)
    {
        cell.cellText.text = sity;
    }
    else
    {
        if (!indexPath.row)
        {
            cell.selectedCell.image = [UIImage imageNamed:@"rb_2.png"];
            selectedIndexOfCell=0;
        }
        NSString*city=[[responseObject.zones objectAtIndex:indexPath.row] name];
        cell.cellText.text =[@"   " stringByAppendingString:city];
    }
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell* selectedCell = (CustomTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    selectedCell.selectedCell.image = [UIImage imageNamed:@"rb_2.png"];
    selectedIndexOfCell=indexPath.row;
    for (UIView *view in tableView.subviews) {
        for (CustomTableViewCell* cell in view.subviews) {
        if (cell != selectedCell)
            {
               cell.selectedCell.image = [UIImage imageNamed:@"rb.png"];
            }
        }
    }
    
}


#pragma mark - Separators

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == sityTable) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
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
    
    if ([sityTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [sityTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([sityTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [sityTable setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)requestGetApiAbilities
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    RequestGetApiAbilities* requestGetApiAbilitiesObject=[[RequestGetApiAbilities alloc]init];

   
    NSDictionary* jsonDictionary = [requestGetApiAbilitiesObject toDictionary];
    
    NSURL* url = [NSURL URLWithString:[responseObject.zones[selectedIndexOfCell]api_url]];
    
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
            [indicator stopAnimating];
            [self presentViewController:alert animated:YES completion:nil];
            return ;
        }
        
        NSError* err;
        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        
        ResponseGetApiAbilities*responseGetApiAbilitiesObject = [[ResponseGetApiAbilities alloc]initWithString:jsonString error:&err];
        if (responseGetApiAbilitiesObject.code ==nil)
        {
            NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
            
            [defaults setObject:responseGetApiAbilitiesObject.api_registration_enabled forKey:@"api_registration_enabled"];
            
            [defaults setObject:responseGetApiAbilitiesObject.messages_enabled
                         forKey:@"messages_enabled"];
            
            [defaults setObject:responseGetApiAbilitiesObject.managers_calling_enabled forKey:@"managers_calling_enabled"];
            
            [defaults setObject:responseGetApiAbilitiesObject.autoassignment_enabled
                         forKey:@"autoassignment_enabled"];
            
            [defaults setObject:responseGetApiAbilitiesObject.yandex_enabled
                         forKey:@"yandex_enabled"];
            
            [defaults setObject:responseGetApiAbilitiesObject.new_order_notification_enabled forKey:@"new_order_notification_enabled"];
            
            [defaults setObject:responseGetApiAbilitiesObject.statistics_enabled
                         forKey:@"statistics_enabled"];
            
            [defaults setObject:responseGetApiAbilitiesObject.calculate_wait_time_enabled
                         forKey:@"calculate_wait_time_enabled"];
            
            [defaults setObject:[responseObject.zones[selectedIndexOfCell]country]
                         forKey:@"country"];
            
            [defaults setObject:[responseObject.zones[selectedIndexOfCell]phone]
                         forKey:@"phone"];
            
            [defaults setObject:[responseObject.zones[selectedIndexOfCell]gmt]
                         forKey:@"gmt"];
            
            [defaults setObject:[responseObject.zones[selectedIndexOfCell]api_url]
                         forKey:@"api_url"];
            
            
            [defaults setObject:[[responseObject.zones[selectedIndexOfCell]application_behavior]sound_notification_on_new_order]
                         forKey:@"sound_notification_on_new_order"];
            NSObject*object=[ApiAbilitiesSingleTon sharedApiAbilities];
            object=nil;
            [ApiAbilitiesSingleTon sharedApiAbilities];

        }
        [indicator stopAnimating];
        
        [self.navigationController popViewControllerAnimated:NO];
    }];

}

#pragma mark - rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
        backgroundView.frame = self.view.frame;
        if (isbuttomViewInNotFound)
        {
            buttomView.frame = CGRectMake((self.view.frame.size.width - 300)/2, (self.view.frame.size.height - 250) / 2, 300, responseObject.zones.count*40+91);
        }
        else
        {
            buttomView.frame = CGRectMake((self.view.frame.size.width - 300)/2, (self.view.frame.size.height - 120) / 2, 300, 120);
        }
    }
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {

    }];
    
}


@end
