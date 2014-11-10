//
//  CarInfoViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "CarInfoViewController.h"

@interface CarInfoViewController ()
{
    RequestGetCarInfo* getCarInfoObject;
    ResponseGetCarInfo* getCarInfoResponse;
}
@end

@implementation CarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCarInfo];
    getCarInfoResponse = [[ResponseGetCarInfo alloc]init];
    self.carInfoTable.delegate = self;
    self.carInfoTable.dataSource = self;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.segmentControll.selectedSegmentIndex = 1;
}


-(void)getCarInfo
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    getCarInfoObject = [[RequestGetCarInfo alloc]init];
    getCarInfoObject.key = [SingleDataProvider sharedKey].key;
    NSLog(@"%@",getCarInfoObject.key);
    NSDictionary* jsonDictionary=[getCarInfoObject toDictionary];
    NSString* jsons=[getCarInfoObject toJSONString];
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
        NSError*err;
        
        if (jsonString.length > 5) {
            getCarInfoResponse = [[ResponseGetCarInfo alloc] initWithString:jsonString error:&err];
        }
        [self.carInfoTable reloadData];
        [indicator stopAnimating];
    }];
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc]init];
    cell.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"марка ";
            [self setAtributedString:cell.textLabel :getCarInfoResponse.mark];
            break;
        case 1:
            cell.textLabel.text = @"модель ";
            [self setAtributedString:cell.textLabel :getCarInfoResponse.model];
            break;
        case 2:
            cell.textLabel.text = @"год производства ";
            [self setAtributedString:cell.textLabel :getCarInfoResponse.year];
            break;
        case 3:
            cell.textLabel.text = @"цвет ";
            [self setAtributedString:cell.textLabel :getCarInfoResponse.color];
            break;
        case 4:
            cell.textLabel.text = @"гос.номер ";
            [self setAtributedString:cell.textLabel :getCarInfoResponse.car_license_pref];
            break;
        case 5:
            cell.textLabel.text = @"vin-код ";
            [self setAtributedString:cell.textLabel :getCarInfoResponse.VIN];
            break;
        case 6:
            cell.textLabel.text = @"лицензия - ";
            [self setAtributedString:cell.textLabel :getCarInfoResponse.car_license_number];
            break;
            
        default:
            break;
    }
    
    
    return cell;
}


-(void)setAtributedString:(UILabel*)label  :(NSString*)appendingString
{
    label.text = [label.text stringByAppendingString:appendingString];//
    NSRange range1 = [label.text rangeOfString:appendingString];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:label.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0f]} range:range1];
    label.attributedText=attributedText;
}


-(void)pushOrPopViewController:(UIViewController*)controller
{
    NSArray *viewControlles = self.navigationController.viewControllers;
    
    for (UIViewController* currentController in viewControlles) {
        if ([controller isKindOfClass:currentController.class]) {
            [self.navigationController popToViewController:currentController animated:NO];
            return;
        }
    }
    [self.navigationController pushViewController:controller animated:NO];
}


- (IBAction)segmentControllAction:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        ProfilViewController* profilViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfilViewController"];
        [self pushOrPopViewController:profilViewController];
    }
    if (sender.selectedSegmentIndex == 1)
    {
    }
}

- (IBAction)edit:(UIButton *)sender {
    EditCarInfoViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EditCarInfoViewController"];
    controller.carImage = self.carImage.image;
    [self pushOrPopViewController:controller];
}










@end
