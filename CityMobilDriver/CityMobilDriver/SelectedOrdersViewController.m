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
#import "LeftMenu.h"
#import "CustomCellSelectORDER.h"
#import "CustomViewForMaps.h"


@interface SelectedOrdersViewController ()
{
    NSInteger flag;
    LeftMenu*leftMenu;
    NSUInteger index;
    CustomViewForMaps*viewMap;
    CGRect rect;
    NSUInteger number;
     CLLocationManager *locationManager;
    CLLocation* currentLocation;
}

@end

@implementation SelectedOrdersViewController
{
    SelectedOrdersDetailsResponse * selectedOrdersDetailsResponseObject;
    NSString * idhash;
    NSString * result;
    UIAlertView * alertConfirmPurchase;
    NSString *  deliveryAddrTypeMenu;
    NSString * deviceType;
    NSString * callDateFormat;
    NSString * shortName;
    NSString * percent;
    NSString * NoSmoking;
    NSString * G_Width;
    NSString * payment_method;
    NSString * conditioner;
    NSString * animal;
    NSString * stringForLabelShortName;
    NSString * stringForLabelPercent;
    NSInteger selectedRow;
    float height;
    UILabel * labelCallMetroName;
    UILabel *labelCollAddressText;
    UILabel *labelCallComment;
    UILabel * labelDeliveryMetroName;
    UILabel * labelDeliveryAddressText;
    UILabel *labelDeliveryComment;
    UILabel *labelOurComment;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:20];
    self.titleLabel.text = self.titleString;
    flag=0;
    self.tableViewOrdersDetails.userInteractionEnabled = YES;
    leftMenu=[LeftMenu getLeftMenu:self];
    [self requestOrder];
    selectedRow = -1;
    viewMap=[[CustomViewForMaps alloc] init];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomViewForMaps" owner:self options:nil];
    viewMap = [nib objectAtIndex:0];
    
    
    viewMap.frame=self.view.frame;
    viewMap.center=self.view.center;
    [viewMap.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *singleTapYandex =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openYandexMap)];
    [singleTapYandex setNumberOfTapsRequired:1];
    
    UITapGestureRecognizer *singleTapGoogle =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openGoogleMap)];
    [singleTapYandex setNumberOfTapsRequired:1];

    viewMap.yandexImageView.userInteractionEnabled=YES;
    viewMap.googleImageView.userInteractionEnabled=YES;
    [viewMap.yandexImageView addGestureRecognizer:singleTapYandex];
    [viewMap.googleImageView addGestureRecognizer:singleTapGoogle];
    
 
   
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    deviceType= [UIDevice currentDevice].model;
    
    // Do any additional setup after loading the view.
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
    float height1 =35;
    //SELECTED
    if(selectedRow==indexPath.row)
    {
        //CALLADDRESS
        CGSize expectSizeForCollAddress;
        NSString * collAddress =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollAddressText];
        NSLog(@"CollAddress is %@",collAddress);
        if (collAddress && collAddress.length !=0)
        {
            labelCollAddressText  = [[UILabel alloc] init];
            labelCollAddressText.font = [UIFont fontWithName:@"RobotoCondensed-Regular" size:14];
            labelCollAddressText.text = collAddress;
            labelCollAddressText.numberOfLines = 0;
            labelCollAddressText.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize maximumLabelSize = CGSizeMake(220,100);
            expectSizeForCollAddress = [labelCollAddressText sizeThatFits:maximumLabelSize];
        }
        
        else
        {
            expectSizeForCollAddress = CGSizeMake(0, 0);
        }
        
        if (expectSizeForCollAddress.height !=0)
        {
            height1 += expectSizeForCollAddress.height+4+5;
        }
        else
        {
            height1 += 15;
        }
        //CALLCOMMENT
        NSString * callComment =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollComment];
        NSLog(@"CallComment is %@",callComment);
        CGSize expectSizeForCallComment;
        if(callComment && callComment.length !=0)
        {
            labelCallComment  = [[UILabel alloc] init];
            labelCallComment.font = [UIFont fontWithName:@"RobotoCondensed-Regular" size:14];
            labelCallComment.text =callComment;
            labelCallComment.numberOfLines = 0;
            labelCallComment.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize maximumLabelSize = CGSizeMake(300,100);
            expectSizeForCallComment = [labelCallComment sizeThatFits:maximumLabelSize];
        }
        else
        {
            expectSizeForCallComment = CGSizeMake(0, 0);
        }
        if (expectSizeForCallComment.height !=0)
        {
            height1 +=expectSizeForCallComment.height+4+5;
        }
        else
        {
            height1 +=5;
        }
        //DELIVERYADDRESS
        float height2 =35;
        NSString * deliveryAddress =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] DeliveryAddressText];
        CGSize  expectSizeForDeliveryAddress;
        if(deliveryAddress && deliveryAddress.length !=0)
        {
            labelDeliveryAddressText  = [[UILabel alloc] init];
            labelDeliveryAddressText.font = [UIFont fontWithName:@"RobotoCondensed-Regular" size:14];
            labelDeliveryAddressText.text =deliveryAddress;
            labelDeliveryAddressText.numberOfLines = 0;
            labelDeliveryAddressText.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize maximumLabelSize = CGSizeMake(220,100);
            expectSizeForDeliveryAddress = [labelCollAddressText sizeThatFits:maximumLabelSize];
        }
        else
        {
            expectSizeForDeliveryAddress = CGSizeMake(0, 0);
        }
        if (expectSizeForDeliveryAddress.height !=0)
        {
            height2 += expectSizeForDeliveryAddress.height+4+5;
        }
        else
        {
            height2 += 15;
        }
        
        //DELIVERYCOMMENT
        NSString * deliveryComment =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row]DeliveryComment];
        CGSize expectSizeDeliveryComment;
        if(deliveryComment && deliveryComment.length !=0)
        {
            labelDeliveryComment  = [[UILabel alloc] init];
            labelDeliveryComment.font = [UIFont fontWithName:@"RobotoCondensed-Regular" size:14];
            labelDeliveryComment.text =deliveryComment;
            labelDeliveryComment.numberOfLines = 0;
            labelDeliveryComment.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize maximumLabelSize = CGSizeMake(300,100);
            expectSizeDeliveryComment = [labelCallComment sizeThatFits:maximumLabelSize];
        }
        else
        {
            expectSizeDeliveryComment = CGSizeMake(0, 0);
        }
        if (expectSizeDeliveryComment.height != 0)
        {
            height2 +=expectSizeDeliveryComment.height+4+5;
        }
        
        //OURCOMMENT
        NSString * ourComment =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] OurComment];
        CGSize expectSizeForOurComment;
        if(ourComment && ourComment.length !=0)
        {
            labelOurComment  = [[UILabel alloc] init];
            labelOurComment.font = [UIFont fontWithName:@"RobotoCondensed-Regular" size:14];
            labelOurComment.text = ourComment;
            labelOurComment.numberOfLines = 0;
            labelOurComment.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize maximumLabelSize = CGSizeMake(300,100);
            expectSizeForOurComment = [labelOurComment sizeThatFits:maximumLabelSize];
        }
        else
        {
            expectSizeForOurComment = CGSizeMake(0, 0);
        }
        if (expectSizeForOurComment.height != 0)
        {
            height2 +=expectSizeForOurComment.height +4+5;
        }
        else
        {
            height2 +=5;
        }
        
        //DEFINING HEGHT FOR VIEW3
        if ([[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] DeliveryAddrTypeMenu]integerValue]==0)
        {
            height2 = 0;
        }

        
        //DEFINING HEIGHT FOR CELL
        height = 2+1+22+height1+height2+1+4+45+4;
       //CustomCellSelectedORDER2
        //xxxx[[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CanBuyDeliveryAddress]integerValue]==1
        if ([[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CanBuyDeliveryAddress]integerValue]==1)
        {
            height = 2+1+22+height1+4+80;
            NSString *simpleTableIdentifierIphone = [NSString stringWithFormat: @"SimpleTableORDER2Selected%d",indexPath.row];
            CustomCellSelectORDER * cell = (CustomCellSelectORDER *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierIphone];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellSelectORDER2" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
           //******************************************Nareks Change*******************************************
            
            [cell.buttonMap1 addTarget:self action:@selector(collMap) forControlEvents:UIControlEventTouchUpInside];
            [cell.buttonMap2  addTarget:self action:@selector(deliveryMapp) forControlEvents:UIControlEventTouchUpInside];
            index=indexPath.row;
            cell.whiteView.translatesAutoresizingMaskIntoConstraints = NO;
            cell.View1.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.whiteView removeConstraint:[cell.whiteView.constraints objectAtIndex:3]];
            NSLayoutConstraint * view11Height =[NSLayoutConstraint constraintWithItem:cell.View1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.whiteView attribute:NSLayoutAttributeHeight multiplier:0.f constant:22];
            [cell.whiteView addConstraint:view11Height];
        //VIEW2
        cell.View2.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.View2 removeConstraint:[cell.View2.constraints objectAtIndex:0]];
        NSLayoutConstraint * view22Height =[NSLayoutConstraint constraintWithItem:cell.View2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.whiteView attribute:NSLayoutAttributeHeight multiplier:0.f constant:height1];
            [cell.whiteView addConstraint:view22Height];
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollMetroName])
            {
                cell.labelCallMetroName.text =[NSString stringWithFormat:@"  %@",[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollMetroName]];
            }
       else
            {
                cell.labelCallMetroName.text = @"";
            }
       if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] shortname])
            {
                shortName =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] shortname];
            }
       else
            {
                shortName = @"";
            }
      if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollDate])
            {
            callDateFormat = [self TimeFormat:[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollDate]];
            }
            else
            {
                callDateFormat = @"";
            }
      stringForLabelShortName = [NSString stringWithFormat:@"  %@ %@ %@",self.stringForSrochno,callDateFormat,shortName];
      cell.labelShortName.text = stringForLabelShortName;
      if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row]percent])
            {
                percent =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] percent];
            }
      else
            {
                percent = @"";
            }
      if([percent length]>3)
            {
                stringForLabelPercent= [percent substringToIndex:2];
            }
      else
            {
                stringForLabelPercent = percent;
            }
     stringForLabelPercent = [stringForLabelPercent stringByAppendingString:@"%"];
     cell.labelPercent.font = [UIFont fontWithName:@"RobotoCondensed-Regular" size:19];
     cell.labelPercent.text = stringForLabelPercent;
     if (expectSizeForCollAddress.height !=0)
     {
      labelCollAddressText.backgroundColor=[UIColor whiteColor];
      if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
                   [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
                {
                    labelCollAddressText.frame = CGRectMake(10, 30+5, expectSizeForCollAddress.width, expectSizeForCollAddress.height+4);
                }
      else
                {
                    labelCollAddressText.frame = CGRectMake(10, 30+5, 400, expectSizeForCollAddress.height+4);
                }
                
        [cell.View2 addSubview:labelCollAddressText];
     }
    if(expectSizeForCallComment.height !=0)
    {
      labelCallComment.backgroundColor =  [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f];
      if (expectSizeForCollAddress.height ==0)
        {
          if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
                       [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
                    {
                        labelCallComment.frame =CGRectMake(10,30+20,290,  expectSizeForCallComment.height+4);
                    }
          else
                    {
                        labelCallComment.frame =CGRectMake(10,30+20,550,  expectSizeForCallComment.height+4);
                    }
                    
                    
         }
     else
          {
            if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
                       [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
                    {
                        labelCallComment.frame =CGRectMake(10,30+5+expectSizeForCollAddress.height+4+5,290,  expectSizeForCallComment.height+4);
                    }
                    else
                    {
                        labelCallComment.frame =CGRectMake(10,30+5+expectSizeForCollAddress.height+4+5,450,  expectSizeForCallComment.height+4);
                    }
                    
            }
             [cell.View2 addSubview:labelCallComment];
            }
    idhash =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] idhash];
    [cell.showAddress  addTarget:self action:@selector(showAddress) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    }
    NSString *simpleTableIdentifierIphone = [NSString stringWithFormat: @"SimpleTableORDERSelected%ld",(long)indexPath.row];
    CustomCellSelectORDER * cell = (CustomCellSelectORDER *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierIphone];
    if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellSelectORDER" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    
        
        [cell.buttonMap1 addTarget:self action:@selector(collMap) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonMap2  addTarget:self action:@selector(deliveryMapp) forControlEvents:UIControlEventTouchUpInside];
        index=indexPath.row;
        // VIEW1
    cell.whiteView.translatesAutoresizingMaskIntoConstraints = NO;
    cell.View1.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.whiteView removeConstraint:[cell.whiteView.constraints objectAtIndex:3]];
    NSLayoutConstraint * view11Height =[NSLayoutConstraint constraintWithItem:cell.View1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.whiteView attribute:NSLayoutAttributeHeight multiplier:0.f constant:22];
    [cell.whiteView addConstraint:view11Height];
    //VIEW2
    cell.View2.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.View2 removeConstraint:[cell.View2.constraints objectAtIndex:0]];
    NSLayoutConstraint * view22Height =[NSLayoutConstraint constraintWithItem:cell.View2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.whiteView attribute:NSLayoutAttributeHeight multiplier:0.f constant:height1];
    [cell.whiteView addConstraint:view22Height];
    //VIEW3
    cell.View3.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.View3 removeConstraint:[cell.View3.constraints objectAtIndex:0]];
    NSLayoutConstraint * view33Height =[NSLayoutConstraint constraintWithItem:cell.View3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.whiteView attribute:NSLayoutAttributeHeight multiplier:0.f constant:height2];
    [cell.whiteView addConstraint:view33Height];
    if (![[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] DeliveryMetroName]|| [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] DeliveryMetroName]length]==0)
        {
            cell.buttonMap2.hidden = YES;
        }
    /* Will add after I will have images
         NSString * collAddressType =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollAddrTypeMenu];
         switch ([collAddressType integerValue]) {
         case 1:
         cell.imgViewCall.image = [UIImage imageNamed:@"Metro"];
         break;
         case 2:
         cell.imgViewCall.image = [UIImage imageNamed:@"Gnacq"];
         case 3:
         cell.imgViewCall.image = [UIImage imageNamed:@"Odanav"];
         case 4:
         cell.imgViewCall.image = [UIImage imageNamed:@"Shoce"];
         case 10:
         cell.imgViewCall.image = [UIImage imageNamed:@"Hospital"];
         case 11:
         cell.imgViewCall.image = [UIImage imageNamed:@"School"];
         case 12:
         cell.imgViewCall.image = [UIImage imageNamed:@"Cinema"];
         case 13:
         cell.imgViewCall.image = [UIImage imageNamed:@"MOL"];
         default:
         break;
         }
         
         */
    if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollMetroName])
        {
            cell.labelCallMetroName.text = [[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollMetroName];
        }
    else
        {
            cell.labelCallMetroName.text = @"";
        }
        
   if (expectSizeForCollAddress.height !=0)
        {
            labelCollAddressText.backgroundColor=[UIColor whiteColor];
            if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
               [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown
               )
            {
            labelCollAddressText.frame = CGRectMake(10, 30+5, expectSizeForCollAddress.width, expectSizeForCollAddress.height+4);
            }
            else
            {
            labelCollAddressText.frame = CGRectMake(10, 30+5, 400, expectSizeForCollAddress.height+4);
            }
            [cell.View2 addSubview:labelCollAddressText];
        }
        if(expectSizeForCallComment.height !=0)
        {
            labelCallComment.backgroundColor =  [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f];
            if (expectSizeForCollAddress.height ==0)
            {
                if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
                   [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
                {
                    labelCallComment.frame =CGRectMake(10,30+20,290,  expectSizeForCallComment.height+4);
                }
                else
                {
                    labelCallComment.frame =CGRectMake(10,30+20,550,  expectSizeForCallComment.height+4);
                }
                
          }
        else
            {
                if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
                   [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
                {
                    labelCallComment.frame =CGRectMake(10,30+5+expectSizeForCollAddress.height+4+5,290,  expectSizeForCallComment.height+4);
                }
                else
                {
                    labelCallComment.frame =CGRectMake(10,30+5+expectSizeForCollAddress.height+4+5,450,  expectSizeForCallComment.height+4);
                }
                
            }
        [cell.View2 addSubview:labelCallComment];
        }
        if (height2 !=0) {
        NSString *deliveryAddressType =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row]DeliveryAddrTypeMenu];
            /* Will add after I will have images
             switch ([deliveryAddressType integerValue]) {
             case 1:
             cell.imgViewCall.image = [UIImage imageNamed:@"Metro"];
             break;
             case 2:
             cell.imgViewCall.image = [UIImage imageNamed:@"Gnacq"];
             case 3:
             cell.imgViewCall.image = [UIImage imageNamed:@"Odanav"];
             case 4:
             cell.imgViewCall.image = [UIImage imageNamed:@"Shoce"];
             case 10:
             cell.imgViewCall.image = [UIImage imageNamed:@"Hospital"];
             case 11:
             cell.imgViewCall.image = [UIImage imageNamed:@"School"];
             case 12:
             cell.imgViewCall.image = [UIImage imageNamed:@"Cinema"];
             case 13:
             cell.imgViewCall.image = [UIImage imageNamed:@"MOL"];
             default:
             break;
             }
             
             */
        if(deliveryAddressType && [deliveryAddressType integerValue]==50)
            {
                cell.labelDeliveryMetroName.text = @"По указанию";
            }else
            {
                cell.labelDeliveryMetroName.backgroundColor =[UIColor whiteColor];
                if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] DeliveryMetroName])
                {
                    cell.labelDeliveryMetroName.text =[NSString stringWithFormat:@"%@",[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] DeliveryMetroName]];
                }else
                {
                    cell.labelDeliveryMetroName.text =@"";
                }
            }
            if(expectSizeForDeliveryAddress.height !=0)
            {
              labelDeliveryAddressText.backgroundColor= [UIColor whiteColor];
                if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
                   [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
                {
                 labelDeliveryAddressText.frame = CGRectMake(10, 30+5, expectSizeForDeliveryAddress.width, expectSizeForDeliveryAddress.height+4);
                }else
                    {
                    labelDeliveryAddressText.frame = CGRectMake(10, 30+5, 400, expectSizeForDeliveryAddress.height+4);
                    }
              [cell.View3 addSubview:labelDeliveryAddressText];
            }
            if(expectSizeDeliveryComment.height !=0)
            {
                labelDeliveryComment.backgroundColor =  [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f];
                if (expectSizeForDeliveryAddress.height ==0)
                {
                if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
                       [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
                    {
                        labelDeliveryComment.frame = CGRectMake(10, 35+15, 290,  expectSizeDeliveryComment.height+4);
                    }else
                        {
                        labelDeliveryComment.frame = CGRectMake(10, 35+15, 450,  expectSizeDeliveryComment.height+4);
                        }
                }
            else
                {
                    if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
                       [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
                    {
                        labelDeliveryComment.frame = CGRectMake(10, 30+5+expectSizeForDeliveryAddress.height+4+5, 290,  expectSizeDeliveryComment.height+4);
                    }else
                      {
                        labelDeliveryComment.frame = CGRectMake(10, 30+5+expectSizeForDeliveryAddress.height+4+5, 450,  expectSizeDeliveryComment.height+4);
                      }
                    
                }
                [cell.View3 addSubview:labelDeliveryComment];
               }
            if (expectSizeForOurComment.height !=0)
            {
                labelOurComment.backgroundColor =  [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f];
                if(expectSizeForDeliveryAddress.height ==0 && expectSizeDeliveryComment.height !=0)
                {
                    if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
                       [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
                    {
                        labelOurComment.frame = CGRectMake(10, 35+15+expectSizeDeliveryComment.height +4+5, 290, expectSizeForOurComment.height);
                    }
                    else
                    {
                        labelOurComment.frame = CGRectMake(10, 35+15+expectSizeDeliveryComment.height +4+5, 450, expectSizeForOurComment.height);
                    }
            }
                else if(expectSizeForDeliveryAddress.height ==0 && expectSizeDeliveryComment.height ==0)
                {
                    if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
                       [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
                    {
                        labelOurComment.frame =CGRectMake(10,35+15,290,expectSizeForOurComment.height);
                    }
                    else
                    {
                        labelOurComment.frame =CGRectMake(10,35+15,450,expectSizeForOurComment.height);
                    }
                }
                else if(expectSizeForDeliveryAddress.height !=0 && expectSizeDeliveryComment.height ==0)
                {
                    if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
                       [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
                    {
                        labelOurComment.frame = CGRectMake(10, 30+5+expectSizeForDeliveryAddress.height+4+5, 290, expectSizeForOurComment.height);
                    }
                    else
                    {
                        labelOurComment.frame = CGRectMake(10, 30+5+expectSizeForDeliveryAddress.height+4+5,450, expectSizeForOurComment.height);
                    }
                }
                else
                {
                    
                    if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
                       [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
                    {
                        labelOurComment.frame = CGRectMake(10, 30+5+expectSizeForDeliveryAddress.height+4+5+expectSizeDeliveryComment.height+4+5, 290, expectSizeForOurComment.height);
                    }
                    else
                    {
                        labelOurComment.frame = CGRectMake(10, 30+5+expectSizeForDeliveryAddress.height+4+5+expectSizeDeliveryComment.height+4+5, 450, expectSizeForOurComment.height);
                    }
                }
                [cell.View3 addSubview:labelOurComment];
            }
        }
        [self addImages:cell.View1 atIndexPath:indexPath.row withLabel:cell.labelPercent];
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row]percent])
        {
            percent =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] percent];
        }
        else
        {
            percent = @"";
        }
        if([percent length]>3)
        {
            stringForLabelPercent= [percent substringToIndex:2];
        }
        else
        {
            stringForLabelPercent = percent;
        }
        stringForLabelPercent = [stringForLabelPercent stringByAppendingString:@"%"];
        cell.labelPercent.font = [UIFont fontWithName:@"RobotoCondensed-Regular" size:19];
        cell.labelPercent.textColor = [UIColor whiteColor];
        cell.labelPercent.text = stringForLabelPercent;
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] shortname])
        {
            shortName =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] shortname];
        }
        else
        {
            shortName = @"";
        }
        if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollDate])
        {
            
            callDateFormat = [self TimeFormat:[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollDate]];
        }
        else
        {
            callDateFormat = @"";
        }
        stringForLabelShortName = [NSString stringWithFormat:@"  %@ %@ %@",self.stringForSrochno,callDateFormat,shortName];
        cell.labelShortName.text=[NSString stringWithFormat:@"  %@", stringForLabelShortName];
        return  cell;
        
    }
   
    
    else
    {
       if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] shortname])
        {
            shortName =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] shortname];
        }
        else
        {
            shortName = @"";
        }
      if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollDate])
        {
           callDateFormat = [self TimeFormat:[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollDate]];
        }
        else
        {
            callDateFormat = @"";
        }
    stringForLabelShortName = [NSString stringWithFormat:@"  %@ %@ %@",self.stringForSrochno,callDateFormat,shortName];
    if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row]percent])
        {
            percent =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] percent];
        }
        else
        {
            percent = @"";
        }
    if([percent length]>3)
        {
            stringForLabelPercent= [percent substringToIndex:2];
        }
        else
        {
            stringForLabelPercent = percent;
        }
        stringForLabelPercent = [stringForLabelPercent stringByAppendingString:@"%"];
        // cell.labelPercent.font = [UIFont fontWithName:@"RobotoCondensed-Regular" size:19];
        //cell.labelPercent.textColor = [UIColor whiteColor];
        //cell.labelPercent.text = stringForLabelPercent;
        NSString * collAddressType =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollAddrTypeMenu];
        /*  Will add after I will have images
         switch ([collAddressType integerValue]) {
         case 1:
         cell.imgViewCall.image = [UIImage imageNamed:@"Metro"];
         break;
         case 2:
         cell.imgViewCall.image = [UIImage imageNamed:@"Gnacq"];
         case 3:
         cell.imgViewCall.image = [UIImage imageNamed:@"Odanav"];
         case 4:
         cell.imgViewCall.image = [UIImage imageNamed:@"Shoce"];
         case 10:
         cell.imgViewCall.image = [UIImage imageNamed:@"Hospital"];
         case 11:
         cell.imgViewCall.image = [UIImage imageNamed:@"School"];
         case 12:
         cell.imgViewCall.image = [UIImage imageNamed:@"Cinema"];
         case 13:
         cell.imgViewCall.image = [UIImage imageNamed:@"MOL"];
         default:
         break;
         }
         
         */
        deliveryAddrTypeMenu =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] DeliveryAddrTypeMenu];
        if(deliveryAddrTypeMenu && [deliveryAddrTypeMenu integerValue] ==0)
        {
          NSString *simpleTableIdentifierIphone = [NSString stringWithFormat: @"SimpleTableOrders%ld",(long)indexPath.row];
            CustomCellSelectedOrders * cell = (CustomCellSelectedOrders *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierIphone];
            if (cell == nil)
            {
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellSelectedOrders2" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.labelPercent0.font = [UIFont fontWithName:@"RobotoCondensed-Regular" size:19];
            cell.labelPercent0.textColor = [UIColor whiteColor];
            cell.labelPercent0.text =  stringForLabelPercent;
            cell.labelShortName0.text =  stringForLabelShortName;
            if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollMetroName])
            {
                cell.labelCallMetroName0.text = [NSString stringWithFormat:@"  %@",[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollMetroName]];
            }
            else
            {
             cell.labelCallMetroName0.text =@"";
            }
            
            [self addImages:cell.View1 atIndexPath:indexPath.row withLabel:cell.labelPercent];
            return cell;
            
        }
        else
        {
            NSString *simpleTableIdentifierIphone = [NSString stringWithFormat: @"SimpleTableOrders2%ld",(long)indexPath.row];
            CustomCellSelectedOrders * cell = (CustomCellSelectedOrders *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierIphone];
            if (cell == nil)
            {
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellSelectedOrders" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.labelPercent.font = [UIFont fontWithName:@"RobotoCondensed-Regular" size:19];
            cell.labelPercent.textColor = [UIColor whiteColor];
            cell.labelPercent.text = stringForLabelPercent;
            cell.labelShortName.text = stringForLabelShortName;
            if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollMetroName])
            {
                cell.labelCollMetroName.text = [NSString stringWithFormat:@"  %@",[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] CollMetroName]];
            }
            else
            {
                cell.labelCollMetroName.text =@"";
            }
            if ( deliveryAddrTypeMenu && [deliveryAddrTypeMenu integerValue] ==50)
            {
                cell.labelDeliveryMetroName.text = @"  По указанию";
            }
            else if([[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] DeliveryMetroName])
            {
                cell.labelDeliveryMetroName.text = [NSString stringWithFormat:@"  %@",[[selectedOrdersDetailsResponseObject.orders objectAtIndex:indexPath.row] DeliveryMetroName]];
            }
            else
            {
                cell.labelDeliveryMetroName.text = @"";
            }
            /*  Will add after I will have images
             switch (deliveryAddrTypeMenu && [deliveryAddrTypeMenu integerValue]) {
             case 1:
             cell.imgViewCall.image = [UIImage imageNamed:@"Metro"];
             break;
             case 2:
             cell.imgViewCall.image = [UIImage imageNamed:@"Gnacq"];
             case 3:
             cell.imgViewCall.image = [UIImage imageNamed:@"Odanav"];
             case 4:
             cell.imgViewCall.image = [UIImage imageNamed:@"Shoce"];
             case 10:
             cell.imgViewCall.image = [UIImage imageNamed:@"Hospital"];
             case 11:
             cell.imgViewCall.image = [UIImage imageNamed:@"School"];
             case 12:
             cell.imgViewCall.image = [UIImage imageNamed:@"Cinema"];
             case 13:
             cell.imgViewCall.image = [UIImage imageNamed:@"MOL"];
             default:
             break;
             }
             
             */
            [self addImages:cell.View1 atIndexPath:indexPath.row withLabel:cell.labelPercent];
            return  cell;
        }
        
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(selectedRow==indexPath.row)
    {
        selectedRow =-1;
    }else{
        selectedRow =indexPath.row;
    }
    [self.tableViewOrdersDetails reloadData];
    [self.tableViewOrdersDetails scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deviceType = [UIDevice currentDevice].model;
    if(selectedRow==indexPath.row)
    {
        return height;
    }
    
    else
    {
        if([deliveryAddrTypeMenu integerValue] ==0)
        {
            if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
               [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
            {
                return 51;
            }
            
            else
            {
                return self.view.frame.size.height/6;
            }
            
        }
        else
        {
            if ([deviceType isEqualToString:@"iPhone Simulator"])
            {
                if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
                   [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
                {
                 return  self.view.frame.size.height*146/1136;
                }
                else
                {
                return   self.view.frame.size.height/4;
                }
            }
            else
                {
                  if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
                   [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
                  {
                  return  self.view.frame.size.height*146/1136;
                  }
                  else
                  {
                  return self.view.frame.size.height/6;
                  }
                }
    }
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
             self.tableViewOrdersDetails.userInteractionEnabled=NO;
             
         }
         else
         {
             flag=0;
             self.tableViewOrdersDetails.userInteractionEnabled=YES;
             
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
             self.tableViewOrdersDetails.userInteractionEnabled=YES;
             
             
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             self.tableViewOrdersDetails.userInteractionEnabled=NO;
             
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
    
    
    
    
    
    
    
    
    self.tableViewOrdersDetails.userInteractionEnabled=NO;
    
    
    flag=1;
    
    
    
    
    
    
}


-(NSString*)TimeFormat:(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:string];
    /////////convert nsdata To NSString////////////////////////////////////
    [dateFormatter setDateFormat:@"HH:mm"];
    if(date==nil) return @"00:00";
    return [dateFormatter stringFromDate:date];
    
}


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
        selectedRow = -1;
        [self requestOrder];
        [self.tableViewOrdersDetails reloadData];
    }
    else if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft
             || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        selectedRow = -1;
        [self requestOrder];
        [self.tableViewOrdersDetails reloadData];
    }

}


-(void)showAddress
{
    alertConfirmPurchase = [[UIAlertView alloc] initWithTitle:@""
                                           message:@"Подтвердите покупку"
                                          delegate:self
                                 cancelButtonTitle:@"Отмена"
                                 otherButtonTitles:@"ОК"];
    [alertConfirmPurchase show];
    return ;

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex==0)
    {
        [self requestOrder];
        
    }
    else
    {
        [self requestBuyDeliveryAddress];
        if ([result integerValue]==1)
        {
            [self requestOrder];
        }
    }
}

-(void)requestBuyDeliveryAddress
{
    NSURL* url = [NSURL URLWithString:@"https://driver-msk.city-mobil.ru/taxiserv/api/driver/"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@"o3XOFR7xpv" forKey:@"ipass"];
    [dictionary setObject:@"cm-api"forKey:@"ilog"];
    [dictionary setObject:[[SingleDataProvider sharedKey]key] forKey:@"key"];
    [dictionary setObject:@"BuyDeliveryAddress" forKey:@"method"];
    [dictionary setObject:@"1.0.2" forKey:@"version"];
    [dictionary setObject:@"17" forKey:@"versionCode"];
    [dictionary setObject:idhash forKey:@"idhash"];
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
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
        //[activityIndicator stopAnimating];
        if (!data) {
            
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"NetworkError" message:@"No iNet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            return ;
        }
        NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",newStr);
        id detailData;
        detailData  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSLog(@"json2=%@",detailData);
        NSLog(@"result is %@",[detailData objectForKey:@"result"]);
        result = [detailData objectForKey:@"result"];
    }];
    
}


-(void)addImages:(UIView *)view
     atIndexPath:(NSInteger)index
      withLabel :(UILabel *)label
{
    
    UIImageView * imgView1;
    imgView1 = [[UIImageView alloc]initWithImage:nil];
    imgView1.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:imgView1];
    NSLayoutConstraint * imgView1ConstraintWidth;
    NSLayoutConstraint * imgView1ConstraintHeight;
    NSLayoutConstraint *imgView1X;
    NSLayoutConstraint *imgView1Y;
    if ([deviceType isEqualToString:@"iPhone Simulator"])
    {
        imgView1X = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -50];
        imgView1Y = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
    else
    {
        imgView1X = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -100];
        imgView1Y = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:6];
    }
    [view addConstraint:imgView1X];
    [view addConstraint:imgView1Y];
    
if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getNoSmoking])
    {
      NoSmoking =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getNoSmoking];
      if ([NoSmoking isEqualToString:@"Y"])
        {
          imgView1.image = [UIImage imageNamed: @"ic_no_smoking_lounge_small.png"];
          imgView1ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
          imgView1ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
        [view   addConstraint:imgView1ConstraintWidth];
        [view addConstraint:imgView1ConstraintHeight];
        }
        else if([[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getG_width])
        {
            G_Width =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getG_width];
            if ([G_Width integerValue] ==1)
            {
                imgView1ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                imgView1ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
                imgView1.image = [UIImage imageNamed: @"ic_smoking_lounge_small.png"];
                [view addConstraint:imgView1ConstraintHeight];
                [view addConstraint:imgView1ConstraintWidth];
            }
            else if([G_Width integerValue] ==0)
            {
                imgView1.image = nil;
            }
            else
            {
                imgView1.image = nil;
            }
        }
}
//Image2 construction and initialization
UIImageView * imgView2;
imgView2 = [[UIImageView alloc]initWithImage:nil];
imgView2.translatesAutoresizingMaskIntoConstraints = NO;
[view addSubview:imgView2];
NSLayoutConstraint * imgView2ConstraintWidth;
NSLayoutConstraint * imgView2ConstraintHeight;
NSLayoutConstraint *imgView2X;
NSLayoutConstraint *imgView2Y;
if ([deviceType isEqualToString:@"iPhone Simulator"])
    {
        imgView2X = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView1 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -30];
        imgView2Y = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
else
    {
        imgView2X = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView1 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -100];
        imgView2Y = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
        
    }
[view addConstraint:imgView2X];
[view addConstraint:imgView2Y];
if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getPayment_method])
{
  payment_method =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getPayment_method];
  if ([payment_method isEqualToString:@"cash"])
    {
     imgView2.image = [UIImage imageNamed:@"ic_cash_payment_small.png"];
     imgView2ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:24];
     imgView2ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
     [view addConstraint:imgView2ConstraintHeight];
     [view addConstraint:imgView2ConstraintWidth];
    }
  else if  ([payment_method isEqualToString:@"card"])
    {
     imgView2.image = [UIImage imageNamed:@"ic_credit_card_payment_small.png"];
    imgView2ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:19];
    imgView2ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
     [view addConstraint:imgView2ConstraintHeight];
     [view addConstraint:imgView2ConstraintWidth];
     }
 else if([payment_method isEqualToString:@"corporate"]   )
     {
       imgView2.image = [UIImage imageNamed:@"ic_non_cash_payment_small.png"];
       imgView2ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:21];
       imgView2ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
       [view addConstraint:imgView2ConstraintHeight];
       [view addConstraint:imgView2ConstraintWidth];
     }
 else
    {
     imgView2.image = nil;
    }
        
}
    
    
//********Image3 construction and initialization
UIImageView * imgView3;
imgView3 = [[UIImageView alloc]initWithImage:nil];
    imgView3.translatesAutoresizingMaskIntoConstraints = NO;
    [view  addSubview:imgView3];
    NSLayoutConstraint * imgView3ConstraintWidth;
    NSLayoutConstraint * imgView3ConstraintHeight;
    NSLayoutConstraint *imgView3X;
    NSLayoutConstraint *imgView3Y;
if ([deviceType isEqualToString:@"iPhone Simulator"])
    {
        imgView3X = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView2 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -30];
        imgView3Y = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
else
    {
        imgView3X = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView2 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -100];
        imgView3Y = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
    }
    
[view addConstraint:imgView3X];
[view addConstraint:imgView3Y];
    
if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getConditioner])
        
{
  conditioner =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getConditioner];
  if ([conditioner integerValue]==1)
        {
            imgView3.image = [UIImage imageNamed:@"ic_air_conditioning_small.png"];
            imgView3ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:15];
            imgView3ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
            [view addConstraint:imgView3ConstraintHeight];
            [view addConstraint:imgView3ConstraintWidth];
            
        }
 else
        {
            imgView3.image = nil;
        }
}
//********Image4 construction and initialization
UIImageView * imgView4;
imgView4 = [[UIImageView alloc]initWithImage:nil];
imgView4.translatesAutoresizingMaskIntoConstraints = NO;
[view addSubview:imgView4];
NSLayoutConstraint * imgView4ConstraintWidth;
NSLayoutConstraint * imgView4ConstraintHeight;
NSLayoutConstraint *imgView4X;
NSLayoutConstraint *imgView4Y;
if ([deviceType isEqualToString:@"iPhone Simulator"])
    {
        imgView4X = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView3 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -30];
        imgView4Y = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
    
    else
    {
        imgView4X = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView3 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -100];
        imgView4Y = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
    }
[view addConstraint:imgView4X];
[view addConstraint:imgView4Y];
if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getAnimal])
{
 animal =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getAnimal];
 if ([animal integerValue]==1)
    {
     imgView4.image = [UIImage imageNamed:@"ic_transportation_of_animals_small.png"];
     imgView4ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
      imgView4ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
    [view addConstraint:imgView4ConstraintHeight];
    [view addConstraint:imgView4ConstraintWidth];
    }
 else
     {
            imgView4.image = nil;
     }
        
    
}
//********Image5 construction and initialization
UIImageView * imgView5;
imgView5 = [[UIImageView alloc]initWithImage:nil];
imgView5.translatesAutoresizingMaskIntoConstraints = NO;
[view addSubview:imgView5];
NSLayoutConstraint * imgView5ConstraintWidth;
NSLayoutConstraint * imgView5ConstraintHeight;
NSLayoutConstraint *imgView5X;
NSLayoutConstraint *imgView5Y;
if ([deviceType isEqualToString:@"iPhone Simulator"])
    {
        imgView5X = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView4 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -30];
        imgView5Y = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
    
else
    {
        imgView5X = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView4 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -100];
        imgView5Y = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
    }
    [view addConstraint:imgView5X];
    [view addConstraint:imgView5Y];
if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getBaby_seat])
    {
        NSString * babySeat;
        babySeat =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getBaby_seat];
        if ([babySeat integerValue]>0)
        {
            imgView5.image = [UIImage imageNamed:@"ic_child_seat_small.png"];
            
            imgView5ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:15];
            imgView5ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView5 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
            [view addConstraint:imgView5ConstraintHeight];
            [view addConstraint:imgView5ConstraintWidth];
            
            
        }
        else
        {
            imgView5.image = nil;
            
        }
        
    }
//********Image6 construction and initialization
UIImageView * imgView6;
imgView6 = [[UIImageView alloc]initWithImage:nil];
imgView6.translatesAutoresizingMaskIntoConstraints = NO;
[view addSubview:imgView6];
NSLayoutConstraint * imgView6ConstraintWidth;
NSLayoutConstraint * imgView6ConstraintHeight;
NSLayoutConstraint *imgView6X;
NSLayoutConstraint *imgView6Y;
if ([deviceType isEqualToString:@"iPhone Simulator"])
    {
        imgView6X = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView5 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:-30];
        imgView6Y = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
else
    {
        imgView6X = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView5 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:-100];
        imgView6Y = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
    }
[view addConstraint:imgView6X];
[view addConstraint:imgView6Y];
if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getLuggage])
{
 NSString * luggage;
 luggage =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getLuggage];
 if ([luggage integerValue]==1)
        {
            imgView6.image = [UIImage imageNamed:@"ic_baggage_small.png"];
            imgView6ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
            imgView6ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
            [view addConstraint:imgView6ConstraintHeight];
            [view addConstraint:imgView6ConstraintWidth];
        }
        else
        {
            imgView6.image = nil;
        }
}
//********Image7 construction and initialization
UIImageView * imgView7;
imgView7 = [[UIImageView alloc]initWithImage:nil];
imgView7.translatesAutoresizingMaskIntoConstraints = NO;
[view addSubview:imgView7];
NSLayoutConstraint * imgView7ConstraintWidth;
NSLayoutConstraint * imgView7ConstraintHeight;
NSLayoutConstraint *imgView7X;
NSLayoutConstraint *imgView7Y;
if ([deviceType isEqualToString:@"iPhone Simulator"])
    {
        imgView7X = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView6 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:-30];
        imgView7Y = [NSLayoutConstraint constraintWithItem:imgView6 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
    }
else
    {
        imgView7X = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView6 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:-100];
        imgView7Y = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
    }
    
[view addConstraint:imgView7X];
[view addConstraint:imgView7Y];
if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getUseBonus])
{
        NSString * useBonus;
        useBonus =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getUseBonus];
        if ([useBonus isEqualToString:@"Y"])
        {
            imgView7.image = [UIImage imageNamed:@"ic_on_bonuses_payment_small.png"];
            imgView7ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:15];
            imgView7ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView7 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
            [view addConstraint:imgView7ConstraintHeight];
            [view addConstraint:imgView7ConstraintWidth];
        }
        else
        {
            imgView7.image = nil;
        }
}
//********Image8 construction and initialization
UIImageView * imgView8;
imgView8 = [[UIImageView alloc]initWithImage:nil];
imgView8.translatesAutoresizingMaskIntoConstraints = NO;
[view addSubview:imgView8];
NSLayoutConstraint * imgView8ConstraintWidth;
NSLayoutConstraint * imgView8ConstraintHeight;
NSLayoutConstraint *imgView8X;
NSLayoutConstraint *imgView8Y;
if ([deviceType isEqualToString:@"iPhone Simulator"])
    {
        imgView8X = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView7 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -30];
        imgView8Y = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
else
    {
        imgView8X = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView7 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:-100];
        imgView8Y = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
    }
[view addConstraint:imgView8X];
[view addConstraint:imgView8Y];
if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getNeed_wifi])
{
        NSString * need_WiFi;
        need_WiFi =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getNeed_wifi];
        if ([need_WiFi integerValue]==1)
        {
            imgView8.image = [UIImage imageNamed:@"ic_wifi_small.png"];
            
            imgView8ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
            imgView8ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
            [view addConstraint:imgView8ConstraintHeight];
            [view addConstraint:imgView8ConstraintWidth];
            
        }
        else
        {
            imgView8.image = nil;
        }
}
//********Image9 construction and initialization
UIImageView * imgView9;
imgView9 = [[UIImageView alloc]initWithImage:nil];
imgView9.translatesAutoresizingMaskIntoConstraints = NO;
[view addSubview:imgView9];
NSLayoutConstraint * imgView9ConstraintWidth;
NSLayoutConstraint * imgView9ConstraintHeight;
NSLayoutConstraint *imgView9X;
NSLayoutConstraint *imgView9Y;
if ([deviceType isEqualToString:@"iPhone Simulator"])
    {
        imgView9X = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView8 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:
                     -30];
        imgView9Y = [NSLayoutConstraint constraintWithItem:imgView8 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:2];
    }
else
    {
        imgView9X = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:imgView8 attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:-100];
        imgView9Y = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:4];
    }
[view addConstraint:imgView9X];
[view addConstraint:imgView9Y];
if ([[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getYellow_reg_num])
{
    NSString * yellowNumber;
    yellowNumber =[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] getYellow_reg_num];
    if ([yellowNumber integerValue]==1)
        {
            imgView9.image = [UIImage imageNamed:@"ic_order_with_visiting_small.png"];
            imgView9ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
            imgView9ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView9 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
            [view addConstraint:imgView9ConstraintHeight];
            [view addConstraint:imgView9ConstraintWidth];
            
            
        }
    else
        {
            imgView9.image = nil;
        }
}
NSMutableArray * arrayOfImages =[[NSMutableArray alloc]initWithObjects:imgView1,imgView2,imgView3,imgView4,imgView5,imgView6,imgView7,imgView8,imgView9,nil];
NSMutableArray * arrayOfImages2 =[[NSMutableArray alloc]init];
for (int i =0; i<arrayOfImages.count; i++)
    {
        UIImageView * imgViewCurrent =[arrayOfImages objectAtIndex:i];
        if (imgViewCurrent.image!=nil)
        {
            [arrayOfImages2 addObject:[arrayOfImages objectAtIndex:i]];
        }
    }
if (arrayOfImages2.count != 0)
    {
        if ([deviceType isEqualToString:@"iPhone Simulator"])
          {
            NSLayoutConstraint *constForX0 = [NSLayoutConstraint constraintWithItem:[arrayOfImages2 objectAtIndex:0] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-25];
            [view addConstraint:constForX0];
            for (int i =0; i<arrayOfImages2.count; i++)
            {
                if (i!=0)
                {
                    NSLayoutConstraint *constForX = [NSLayoutConstraint constraintWithItem:[arrayOfImages2 objectAtIndex:i] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:[arrayOfImages2 objectAtIndex:i-1]attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-25];
                    [view addConstraint:constForX];
                }
            }
            
        }
else
    {
      NSLayoutConstraint *constForX0 = [NSLayoutConstraint constraintWithItem:[arrayOfImages2 objectAtIndex:0] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-50];
      [view addConstraint:constForX0];
      for (int i =0; i<arrayOfImages2.count; i++)
            {
                if (i!=0)
                {
                    NSLayoutConstraint *constForX = [NSLayoutConstraint constraintWithItem:[arrayOfImages2 objectAtIndex:i] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:[arrayOfImages2 objectAtIndex:i-1]attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-50];
                    [view addConstraint:constForX];
                }
            }
            }
        }
    
    else
        
    {
        for (int i =0; i<arrayOfImages.count; i++)
        {
            NSLayoutConstraint *constForXhide = [NSLayoutConstraint constraintWithItem:[arrayOfImages objectAtIndex:i] attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:20];
            [view addConstraint:constForXhide];
            
        }
        
    }
}
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:nil
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         viewMap.frame=self.view.frame;
         viewMap.center=self.view.center;
        
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
         
     }];
    
    [super viewWillTransitionToSize: size withTransitionCoordinator:coordinator];
}
-(void)collMap
{
    [self.view addSubview:viewMap];
    viewMap.smallMapView.transform = CGAffineTransformMakeScale(0,0);
    number=0;
    [self animation];
}

-(void)deliveryMapp
{
    [self.view addSubview:viewMap];
     viewMap.smallMapView.transform = CGAffineTransformMakeScale(0,0);
    number=1;
    [self animation];
}
-(void)close
{
    [viewMap removeFromSuperview];
}

-(void)openYandexMap
{
 
    if (number)
    {
        NSString* urlStr=  [NSString stringWithFormat:@"yandexnavi://build_route_on_map?lat_from=%f&lon_from=%f&lat_to=%f&lon_to=%f",[[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] latitude]doubleValue],
                          [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] longitude] doubleValue],
                          [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] del_latitude] doubleValue],
                          [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] del_longitude] doubleValue]];
        NSURL* naviURL = [NSURL URLWithString:urlStr];
        NSLog(@"urlStr=%@",urlStr);
        if ([[UIApplication sharedApplication] canOpenURL:naviURL]) {
            // Если Навигатор установлен - открываем его
            [[UIApplication sharedApplication] openURL:naviURL];
        } else {
            // Если не установлен - открываем страницу в App Store
            NSURL* appStoreURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/yandex.navigator/id474500851?mt=8"];
            [[UIApplication sharedApplication] openURL:appStoreURL];
        }

    }
    else
    {
        NSString* urlStr=  [NSString stringWithFormat:@"yandexnavi://build_route_on_map?lat_from=%f&lon_from=%f&lat_to=%f&lon_to=%f",currentLocation.coordinate.latitude,
                            currentLocation.coordinate.longitude,
                            [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] latitude] doubleValue],
                            [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] longitude] doubleValue]];
        NSURL* naviURL = [NSURL URLWithString:urlStr];
        NSLog(@"urlStr=%@",urlStr);
        if ([[UIApplication sharedApplication] canOpenURL:naviURL]) {
            // Если Навигатор установлен - открываем его
            [[UIApplication sharedApplication] openURL:naviURL];
        } else {
            // Если не установлен - открываем страницу в App Store
            NSURL* appStoreURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/yandex.navigator/id474500851?mt=8"];
            [[UIApplication sharedApplication] openURL:appStoreURL];
        }

    }
}
-(void)openGoogleMap
{
    if (number)
    {
        NSString* urlStr=  [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",[[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] latitude]doubleValue],
                            [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] longitude] doubleValue],
                            [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] del_latitude] doubleValue],
                            [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] del_longitude] doubleValue]];
        NSURL* naviURL = [NSURL URLWithString:urlStr];
        NSLog(@"urlStr=%@",urlStr);
        if ([[UIApplication sharedApplication] canOpenURL:naviURL]) {
            // Если Навигатор установлен - открываем его
            [[UIApplication sharedApplication] openURL:naviURL];
        } else {
            // Если не установлен - открываем страницу в App Store
            NSURL* appStoreURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/yandex.navigator/id474500851?mt=8"];
            [[UIApplication sharedApplication] openURL:appStoreURL];
        }

    }
    else
    {
        NSString* urlStr=  [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
                            currentLocation.coordinate.latitude,
                            currentLocation.coordinate.longitude,
                            [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] latitude] doubleValue],
                            [[[selectedOrdersDetailsResponseObject.orders objectAtIndex:index] longitude] doubleValue]];
        NSURL* naviURL = [NSURL URLWithString:urlStr];
        NSLog(@"urlStr=%@",urlStr);
        if ([[UIApplication sharedApplication] canOpenURL:naviURL]) {
            // Если Навигатор установлен - открываем его
            [[UIApplication sharedApplication] openURL:naviURL];
        } else {
            // Если не установлен - открываем страницу в App Store
            NSURL* appStoreURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/google-maps/id585027354?mt=8"];
            [[UIApplication sharedApplication] openURL:appStoreURL];
        }
        
     
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations lastObject];
    NSLog(@"%f--- %f", currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
}
-(void)animation
{
    [UIView animateWithDuration:1
                          delay:0.0
                        options: 0
                     animations:^(void)
     {
       viewMap.smallMapView.transform = CGAffineTransformIdentity;
     }
                             completion:nil];
}
@end