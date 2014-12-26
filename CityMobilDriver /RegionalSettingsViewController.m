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
    
    
    BOOL isRegionFound;
    BOOL isbuttomViewInNotFound;
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
        if (isRegionFound) {
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
    if (currentLocation) {
    for (int i = 0; i < [responseObject.zones count]; ++i) {
        CLLocation* sityLocation = [[CLLocation alloc]initWithLatitude:[responseObject.zones[i] latitude]
                                                             longitude:[responseObject.zones[i] longitude]];

        
        NSLog(@"%@",currentLocation);
            currentDistance = [sityLocation distanceFromLocation:currentLocation];
            if (currentDistance < [responseObject.zones[i] getRadius]) {
                sity = [responseObject.zones[i] name];
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

-(void)okButtonAction{
    [backgroundView removeFromSuperview];
    [buttomView removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:NO];
    
    
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
    
    buttomView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, (self.view.frame.size.height - 250) / 2, 300, 250)];
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
    
    sityTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 51, buttomView.frame.size.width, 160)];
    sityTable.delegate = self;
    sityTable.dataSource = self;
    sityTable.scrollEnabled = NO;
    [buttomView addSubview:sityTable];
    
    UIButton* tryAgainButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 211, 2*buttomView.frame.size.width/3, 40)];
    tryAgainButton.backgroundColor = [UIColor whiteColor];
    [tryAgainButton setTitle:@"повторить попытку" forState:UIControlStateNormal];
    [tryAgainButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tryAgainButton addTarget:self action:@selector(tryAgainButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:tryAgainButton];
    
    UIButton* okButton = [[UIButton alloc]initWithFrame:CGRectMake(2*buttomView.frame.size.width/3 + 1, 211, buttomView.frame.size.width/3 - 1, 40)];
    okButton.backgroundColor = [UIColor whiteColor];
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:okButton];
}






#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isRegionFound) {
        return 1;
    }
    return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomTableViewCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil] objectAtIndex:0];
    if (isRegionFound) {
        cell.cellText.text = sity;
    }
    else{
        if (indexPath.row == 0) {
            cell.cellText.text = @"   Москва";
        }
        if (indexPath.row == 1) {
            cell.cellText.text = @"   Краснодар";
        }
        if (indexPath.row == 2) {
            cell.cellText.text = @"   Ростов-на-Дон";
        }
        if (indexPath.row == 3) {
            cell.cellText.text = @"   Казань";
        }
    }
    

    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell* selectedCell = (CustomTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    selectedCell.selectedCell.image = [UIImage imageNamed:@"rb_2.png"];
    
    for (UIView *view in tableView.subviews) {
        for (CustomTableViewCell* cell in view.subviews) {
            if (cell != selectedCell) {
                cell.selectedCell.image = [UIImage imageNamed:@"rb.png"];
            }
        }
    }
    
}



#pragma mark - rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        backgroundView.frame = self.view.frame;
        if (isbuttomViewInNotFound) {
            buttomView.frame = CGRectMake((self.view.frame.size.width - 300)/2, (self.view.frame.size.height - 250) / 2, 300, 250);
        }
        else{
            buttomView.frame = CGRectMake((self.view.frame.size.width - 300)/2, (self.view.frame.size.height - 120) / 2, 300, 120);
        }
    }
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {

    }];
    
}


@end
