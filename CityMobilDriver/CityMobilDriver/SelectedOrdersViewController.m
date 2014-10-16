//
//  SelectedOrdersViewController.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/9/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SelectedOrdersViewController.h"
#import "CustomCellSelectedOrders.h"
#import "SingleDataProvider.h"
#import "SingleDataProviderForFilter.h"
#import "SelectedOrdersDetailsResponse.h"
#import "SelectedOrdersDetailsJson.h"
#import "JSONModel.h"

@interface SelectedOrdersViewController ()

@end

@implementation SelectedOrdersViewController
{

    SelectedOrdersDetailsResponse * selectedOrdersDetailsResponseObject;
    NSString * percent;
    NSString * callDateText;
    NSString * deliveryMetroName;
    NSString * callMetroName;
    NSString * shortName;
    NSString * NoSmoking;
    NSString * G_Width;

}

- (void)viewDidLoad {
    [super viewDidLoad];
       // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self requestOrder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return  selectedOrdersDetailsResponseObject.orders.count;
    

}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
   
    
    NSString *simpleTableIdentifierIphone = @"SimpleTableOrdersSelected";
    
    CustomCellSelectedOrders * cell = (CustomCellSelectedOrders *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierIphone];
    if (cell == nil)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellSelectedOrders" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    
    if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getShortname])
    {
        shortName =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getShortname];
    }
    else
    {
       shortName = @"";
    
    }
    
    if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getCollDateText])
    {
        callDateText =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getCollDateText];
    }
    else
    {
        callDateText = @"";
        
    }

    NSString * stringForLabelShortName = [NSString stringWithFormat:@"%@ %@",shortName,callDateText];
    
    cell.labelShortName.text = stringForLabelShortName;
    
    if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getPercent])
    {
        percent =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getPercent];
    }
    else
    {
      percent = @"";
        
    }
   
    NSString * stringForLabelPercent;
    if([percent length]>3)
    {
    stringForLabelPercent= [percent substringToIndex:2];
    }
    else
        
        
        
    {
        stringForLabelPercent = percent;
    }
    stringForLabelPercent = [stringForLabelPercent stringByAppendingString:@"%"];
    cell.labelPercent.text = stringForLabelPercent;
    
    if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getCollMetroName])
    {
       callMetroName =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getCollMetroName];
    }
    else
    {
        callMetroName = @"";
        
    }

    NSString * stringForLabelCallMetroName = callMetroName;
    cell.labelCollMetroName.text = stringForLabelCallMetroName;
    
    if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getDeliveryMetroName])
    {
        deliveryMetroName =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getDeliveryMetroName];
    }
    else
    {
        deliveryMetroName = @"";
        
    }
    
    NSString * stringForLabelDeliveryMetroName = deliveryMetroName;
    cell.labelDeliveryMetroName.text = stringForLabelDeliveryMetroName;
    
    if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getNoSmoking])
    {
        
        NoSmoking =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getNoSmoking];
        UIImageView * imgView1;
        NSLayoutConstraint * imgView1ConstraintWidth;
        NSLayoutConstraint * imgView1ConstraintHeight;
        NSLayoutConstraint *imgView1X;
        NSLayoutConstraint *imgView1Y;
        
        if ([NoSmoking isEqualToString:@"Y"])
        {
            UIImage *image1 = [UIImage imageNamed: @"ic_no_smoking_lounge_small.png"];
           imgView1=[[UIImageView alloc]initWithImage:image1];
            imgView1.backgroundColor= [UIColor yellowColor];
            imgView1.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.View1 addSubview:imgView1];
            imgView1.hidden = NO;
            
          imgView1ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:20];
           imgView1ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:20];
            
            [cell.View1   addConstraint:imgView1ConstraintWidth];
            [cell.View1 addConstraint:imgView1ConstraintHeight];
           imgView1X = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                                             -10];
           imgView1Y = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:10];
            
            [cell.View1 addConstraint:imgView1X];
            [cell.View1 addConstraint:imgView1Y];
            

        }
        
    else if([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getG_width])
    {
        G_Width =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] getG_width];
        if ([G_Width integerValue] ==1)
        {
            UIImage * image2 = [UIImage imageNamed: @"ic_smoking_lounge_small.png"];
             NSLayoutConstraint * imgView1ConstraintWidth11 = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.f constant:20];
            imgView1ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeWidth multiplier:0.f constant:20];
            [cell.View1 addConstraint:imgView1ConstraintWidth11];
           
        }
        else if([G_Width integerValue] ==0)
        {
            imgView1.image = nil;
        
        }
    
    }
       
    }
    
    
    
    return  cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
[tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPhone Simulator"])
    {
        if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
           
           [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown
           
           )
        {return  self.view.frame.size.height*146/1136;
        }
        else
        {

            return self.view.frame.size.height/4;
        }

    }
    else
    {
    return self.view.frame.size.height*146/1136;
    
    }
    

}


-(void)requestOrder
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    SelectedOrdersDetailsJson* detailsJsonObject=[[SelectedOrdersDetailsJson alloc]init];
    
    
    
    NSDictionary*jsonDictionary=[detailsJsonObject toDictionary];
    NSString*jsons=[detailsJsonObject toJSONString];
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
            return ;
        }
        NSString* jsonString1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"selectedOrdersDetails =%@",jsonString1);
        NSError*err;
      
        selectedOrdersDetailsResponseObject = [[SelectedOrdersDetailsResponse alloc] initWithString:jsonString1 error:&err];
        
        
        if(selectedOrdersDetailsResponseObject.code!=nil)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
            
        }
        [indicator stopAnimating];
       
        [self.tableViewOrdersDetails reloadData];
    }];
    
    
}


-(void)addingImages
{
    NSMutableArray * arrayOfImageViews;
    UIImageView * imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 17,18)];
    [arrayOfImageViews addObject:imgView1];
    UIImageView * imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 17,18)];
    [arrayOfImageViews addObject:imgView2];
    UIImageView * imgView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 17,18)];
    [arrayOfImageViews addObject:imgView3];
    
                              

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
