//
//  SelectedOrdersTableViewHandler.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/25/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SelectedOrdersTableViewHandler.h"
#import "CustomCellSelectedOrders.h"
#import "CustomCellSelectORDER.h"
#import "SelectedOrdersDetailsResponse.h"
#import "SelectedOrdersViewController.h"
#import "SingleDataProvider.h"
@implementation SelectedOrdersTableViewHandler
-(instancetype)init
{
    self=[super init];
    if (self)
    {

    count=1;
    }
    return self;
}


-(void)setSelectedRow:(NSInteger)selectedRo
{
    selectedRow=selectedRo;
}
-(void)setResponseObject:(SelectedOrdersDetailsResponse*)object andStringforSroch:(NSString*)string andFlag1:(NSInteger)flag andCurentSelf:(UIViewController*)vc andNumberOfClass:(NSUInteger)number;
{
    responseObject=object;
    stringforSrochno=string;
    flag1=flag;
    curentSelf=vc;
    numberOfClass=number;
    
    if (count)
    {
        selectedRow=-1;
        deviceType= [UIDevice currentDevice].model;
        if (numberOfClass==0)
        {
            if ([SingleDataProvider sharedKey].arrayOfIndexes1.count==0) {
                NSMutableArray * arrayOfIndexes1 =[[NSMutableArray alloc]init];
                [SingleDataProvider sharedKey].arrayOfIndexes1=arrayOfIndexes1;
            }
        }
        if (numberOfClass==1)
        {
            if ([SingleDataProvider sharedKey].arrayOfIndexes2.count==0)
            {
                NSMutableArray * arrayOfIndexes2 =[[NSMutableArray alloc]init];
                [SingleDataProvider sharedKey].arrayOfIndexes2=arrayOfIndexes2;
            }
        }
    }
    count=0;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return responseObject.orders.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger k=0;
    if([[UIApplication sharedApplication]statusBarOrientation]==UIDeviceOrientationPortrait || [[UIApplication sharedApplication]statusBarOrientation]==UIDeviceOrientationPortraitUpsideDown)
    {
        k=36;
    }
    else
    {
        k=64;
    }
    if ([[responseObject.orders objectAtIndex:indexPath.row] shortname])
    {
        shortName =[[responseObject.orders objectAtIndex:indexPath.row] shortname];
    }
    else
    {
        shortName = @"";
    }
    if ([[responseObject.orders objectAtIndex:indexPath.row] CollDate])
    {
        callDateFormat = [self TimeFormat:[[responseObject.orders objectAtIndex:indexPath.row] CollDate]];
    }
    else
    {
        callDateFormat = @"";
    }
////    if (numberOfClass==1 && [stringforSrochno isEqualToString:@"СРОЧНО"])
////    {
//        [self TimeForUrgentOrders:[[responseObject.orders objectAtIndex:indexPath.row] CollDate]];
//    
//  //  }
    
    stringForLabelShortName = [NSString stringWithFormat:@"  %@ %@ %@",stringforSrochno,callDateFormat,shortName];
    if ([[responseObject.orders objectAtIndex:indexPath.row]percent])
    {
        percent =[[responseObject.orders objectAtIndex:indexPath.row] percent];
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
    if(selectedRow==indexPath.row)
    {
        //CustomCellSelectedORDER2
        if ([[[responseObject.orders objectAtIndex:indexPath.row] CanBuyDeliveryAddress]integerValue]==1)
        {
            
            NSString *simpleTableIdentifierIphone = [NSString stringWithFormat: @"SimpleTableORDER2Selected%ld",(long)indexPath.row];
            CustomCellSelectORDER * cell = (CustomCellSelectORDER *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierIphone];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellSelectORDER2" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                
            }
            //******************************************Nareks Change*******************************************
            
            indexOfCell=indexPath.row;
            if (numberOfClass==0)
            {
                [cell.Button addTarget:(SelectedOrdersViewController*)curentSelf action:@selector(toTakeAction) forControlEvents:UIControlEventTouchUpInside];
                [cell.buttonMap1 addTarget:(SelectedOrdersViewController*)curentSelf action:@selector(collMap) forControlEvents:UIControlEventTouchUpInside];
                [cell.buttonMap2  addTarget:(SelectedOrdersViewController*)curentSelf action:@selector(deliveryMapp) forControlEvents:UIControlEventTouchUpInside];
                [(SelectedOrdersViewController*)curentSelf setIndexOfCell:indexOfCell];
            }
            else
            {
                
                [cell.Button addTarget:(MyOrdersViewController*)curentSelf action:@selector(toTakeAction) forControlEvents:UIControlEventTouchUpInside];
                [cell.buttonMap1 addTarget:(MyOrdersViewController*)curentSelf action:@selector(collMap) forControlEvents:UIControlEventTouchUpInside];
                [cell.buttonMap2  addTarget:(MyOrdersViewController*)curentSelf action:@selector(deliveryMapp) forControlEvents:UIControlEventTouchUpInside];
                [(MyOrdersViewController*)curentSelf setIndexOfCell:indexOfCell];
                
                
            }
            //VIEW1
            cell.whiteView.translatesAutoresizingMaskIntoConstraints = NO;
            cell.View1.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.whiteView removeConstraint:[cell.whiteView.constraints objectAtIndex:3]];
            NSLayoutConstraint * view11Height =[NSLayoutConstraint constraintWithItem:cell.View1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.whiteView attribute:NSLayoutAttributeHeight multiplier:0.f constant:22];
            [cell.whiteView addConstraint:view11Height];
            cell.labelPercent.text = stringForLabelPercent;
            cell.labelShortName.text=stringForLabelShortName;
            [self addImages:cell.View1 atIndexPath:indexPath.row withLabel:cell.labelPercent];
            //VIEW2
            cell.View2.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.View2 removeConstraint:[cell.View2.constraints objectAtIndex:0]];
            NSLayoutConstraint * view22Height =[NSLayoutConstraint constraintWithItem:cell.View2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.whiteView attribute:NSLayoutAttributeHeight multiplier:0.f constant:height1];
            [cell.whiteView addConstraint:view22Height];
            if ([[responseObject.orders objectAtIndex:indexPath.row] CollMetroName])
            {
                cell.labelCallMetroName.text =[NSString stringWithFormat:@"  %@",[[responseObject.orders objectAtIndex:indexPath.row] CollMetroName]];
            }
            else
            {
                cell.labelCallMetroName.text = @"";
            }
            if (expectSizeForCollAddress.height !=0)
            {
                labelCollAddressText.backgroundColor=[UIColor whiteColor];
                labelCollAddressText.frame = CGRectMake(10, 30+5, curentSelf.view.frame.size.width-k-43-25, expectSizeForCollAddress.height+4);
                [cell.View2 addSubview:labelCollAddressText];
            }
            
            if(expectSizeForCallComment.height !=0)
            {
                labelCallComment.backgroundColor =  [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f];
                if (expectSizeForCollAddress.height ==0)
                {
                    labelCallComment.frame =CGRectMake(10,30+20,curentSelf.view.frame.size.width-k-15,  expectSizeForCallComment.height+4);
                }
                else
                {
                    labelCallComment.frame =CGRectMake(10,30+5+expectSizeForCollAddress.height+4+5,curentSelf.view.frame.size.width-k-15,expectSizeForCallComment.height+4);
                    
                    
                }
                [cell.View2 addSubview:labelCallComment];
            }
            idhash =[[responseObject.orders objectAtIndex:indexPath.row] idhash];
            [cell.showAddress  addTarget:curentSelf action:@selector(showAddress) forControlEvents:UIControlEventTouchUpInside];
            if (numberOfClass==0)
            {
                underView=cell.underView;
                [(SelectedOrdersViewController*)curentSelf setUnderView:underView];
            }
            
            
            
            if (flag1 ==-1)
            {
                cell.whiteLabel.backgroundColor =[UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
            }
            else
            {
                cell.whiteLabel.backgroundColor=[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
            }
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            return cell;
        }
        NSString *simpleTableIdentifierIphone = [NSString stringWithFormat: @"SimpleTableORDERSelected%ld",(long)indexPath.row];
        CustomCellSelectORDER * cell = (CustomCellSelectORDER *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierIphone];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellSelectORDER" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            if (numberOfClass==1 && height!=0)
            {
                
//                id copyOfView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:cell.underView]];
//                
//                self.under = (UIView*)copyOfView;
               
                
                [cell.Button removeFromSuperview];
                
                UIView*buttonView=[[UIView alloc]init];
                buttonView.backgroundColor=[UIColor whiteColor];
                buttonView.tag=111;
                [cell.orangeView addSubview:buttonView];
                buttonView.translatesAutoresizingMaskIntoConstraints=NO;
                
                UIButton*closeButton=[[UIButton alloc]init];
                closeButton.backgroundColor=[UIColor grayColor];
                [buttonView addSubview:closeButton];
                closeButton.translatesAutoresizingMaskIntoConstraints=NO;
                [closeButton setTitle:@"Закрыть" forState:UIControlStateNormal];
                [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                closeButton.tag=61;
                
                UIButton*toOrderButton=[[UIButton alloc]init];
                toOrderButton.backgroundColor=[UIColor orangeColor];
                [buttonView addSubview:toOrderButton];
                toOrderButton.translatesAutoresizingMaskIntoConstraints=NO;
                [toOrderButton setTitle:@"К заказу" forState:UIControlStateNormal];
                [toOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                toOrderButton.tag=62;
                [closeButton addTarget:(MyOrdersViewController*)curentSelf action:@selector(closeOrderAction) forControlEvents:UIControlEventTouchUpInside];
                
                [toOrderButton addTarget:(MyOrdersViewController*)curentSelf action:@selector(toOrderAction) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                
                [cell.orangeView addConstraint:[NSLayoutConstraint constraintWithItem:buttonView
                                                                            attribute:NSLayoutAttributeLeading
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:cell.orangeView
                                                                            attribute:NSLayoutAttributeLeading
                                                                           multiplier:1.0
                                                                             constant:0]];
                
                
                [cell.orangeView addConstraint:[NSLayoutConstraint constraintWithItem:buttonView
                                                                            attribute:NSLayoutAttributeTop
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:cell.DL5Label
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0
                                                                             constant:0]];
                
                [cell.orangeView addConstraint:[NSLayoutConstraint constraintWithItem:cell.orangeView
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:buttonView
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0
                                                                             constant:4]];
                
                [cell.orangeView addConstraint:[NSLayoutConstraint constraintWithItem:buttonView
                                                                            attribute:NSLayoutAttributeTrailing
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:cell.orangeView
                                                                            attribute:NSLayoutAttributeTrailing
                                                                           multiplier:1.0
                                                                             constant:0]];
                
                
                
                [buttonView addConstraint:[NSLayoutConstraint constraintWithItem:buttonView
                                                                       attribute: NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute: NSLayoutAttributeHeight
                                                                      multiplier:1.0
                                                                        constant:cell.Button.frame.size.height]];
                
                ///closebutton constraits*************
                
                [buttonView addConstraint:[NSLayoutConstraint constraintWithItem:closeButton
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:buttonView
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1.0
                                                                        constant:0]];
                
                
                [buttonView addConstraint:[NSLayoutConstraint constraintWithItem:closeButton
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:buttonView
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0
                                                                        constant:0]];
                
                [buttonView addConstraint:[NSLayoutConstraint constraintWithItem:buttonView
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:closeButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:0]];
                
                [closeButton addConstraint:[NSLayoutConstraint constraintWithItem:closeButton
                                                                        attribute: NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute: NSLayoutAttributeWidth
                                                                       multiplier:1.0
                                                                         constant:(curentSelf.view.frame.size.width-20)/2-2]];
                
                [closeButton addConstraint:[NSLayoutConstraint constraintWithItem:closeButton
                                                                        attribute: NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute: NSLayoutAttributeHeight
                                                                       multiplier:1.0
                                                                         constant:cell.Button.frame.size.height]];
                
                //********************toOrderButton
                
                [buttonView addConstraint:[NSLayoutConstraint constraintWithItem:toOrderButton
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:closeButton
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:4]];
                
                
                [buttonView addConstraint:[NSLayoutConstraint constraintWithItem:toOrderButton
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:buttonView
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0
                                                                        constant:0]];
                
                [buttonView addConstraint:[NSLayoutConstraint constraintWithItem:buttonView
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:toOrderButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:0]];
                
                [toOrderButton addConstraint:[NSLayoutConstraint constraintWithItem:toOrderButton
                                                                          attribute: NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute: NSLayoutAttributeWidth
                                                                         multiplier:1.0
                                                                           constant:(curentSelf.view.frame.size.width-20)/2-2]];
                
                [toOrderButton addConstraint:[NSLayoutConstraint constraintWithItem:toOrderButton
                                                                          attribute: NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute: NSLayoutAttributeHeight
                                                                         multiplier:1.0
                                                                           constant:cell.Button.frame.size.height]];
                
            }
    

        }
    
        indexOfCell=indexPath.row;
        if (numberOfClass==0)
        {
            [cell.Button addTarget:(SelectedOrdersViewController*)curentSelf action:@selector(toTakeAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.buttonMap1 addTarget:(SelectedOrdersViewController*)curentSelf action:@selector(collMap) forControlEvents:UIControlEventTouchUpInside];
            [cell.buttonMap2  addTarget:(SelectedOrdersViewController*)curentSelf action:@selector(deliveryMapp) forControlEvents:UIControlEventTouchUpInside];
            [(SelectedOrdersViewController*)curentSelf setIndexOfCell:indexOfCell];
        }
        else
        {
            
            [cell.Button addTarget:(MyOrdersViewController*)curentSelf action:@selector(toTakeAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.buttonMap1 addTarget:(MyOrdersViewController*)curentSelf action:@selector(collMap) forControlEvents:UIControlEventTouchUpInside];
            [cell.buttonMap2  addTarget:(MyOrdersViewController*)curentSelf action:@selector(deliveryMapp) forControlEvents:UIControlEventTouchUpInside];
            
            [(MyOrdersViewController*)curentSelf setIndexOfCell:indexOfCell];
        }
        
        
        // VIEW1
        cell.whiteView.translatesAutoresizingMaskIntoConstraints = NO;
        cell.View1.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.whiteView removeConstraint:[cell.whiteView.constraints objectAtIndex:3]];
        NSLayoutConstraint * view11Height =[NSLayoutConstraint constraintWithItem:cell.View1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.whiteView attribute:NSLayoutAttributeHeight multiplier:0.f constant:22];
        [cell.whiteView addConstraint:view11Height];
        cell.labelShortName.text=[NSString stringWithFormat:@"%@", stringForLabelShortName];
        cell.labelPercent.text = stringForLabelPercent;
        [self addImages:cell.View1 atIndexPath:indexPath.row withLabel:cell.labelPercent];
        
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
        //When we don't have deliveryMetroName we don't show map button
         if ([[[responseObject.orders objectAtIndex:indexPath.row] DeliveryAddrTypeMenu]integerValue]==0)
         {
             [cell.labelDeliveryMetroName removeFromSuperview];
             cell.buttonMap2.hidden = YES;
             labelOurComment.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f];
             labelDeliveryComment.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f];
             labelDeliveryComment.frame = CGRectMake(10, 5, curentSelf.view.frame.size.width-k-15,  expectSizeDeliveryComment.height+4);
             if (expectSizeDeliveryComment.height==0)
             {
              labelOurComment.frame = CGRectMake(10, 5, curentSelf.view.frame.size.width-k-15, expectSizeForOurComment.height);
             }
             labelOurComment.frame = CGRectMake(10, 5+expectSizeDeliveryComment.height +4+5, curentSelf.view.frame.size.width-k-15, expectSizeForOurComment.height);
             [cell.View3 addSubview:labelDeliveryComment];
             [cell.View3 addSubview:labelOurComment];
         }
        
        
        if (![[responseObject.orders objectAtIndex:indexPath.row] DeliveryMetroName]|| [[[responseObject.orders objectAtIndex:indexPath.row] DeliveryMetroName]length]==0)
        {
            cell.buttonMap2.hidden = YES;
        }
        
        if ([[responseObject.orders objectAtIndex:indexPath.row] CollMetroName])
        {
            cell.labelCallMetroName.text = [[responseObject.orders objectAtIndex:indexPath.row] CollMetroName];
        }
        else
        {
            cell.labelCallMetroName.text = @"";
        }
        
        if (expectSizeForCollAddress.height !=0)
        {
            labelCollAddressText.backgroundColor=[UIColor whiteColor];
            labelCollAddressText.frame = CGRectMake(10, 30+5,curentSelf.view.frame.size.width-k-43-25,expectSizeForCollAddress.height+4);
            [cell.View2 addSubview:labelCollAddressText];
        }
        if(expectSizeForCallComment.height !=0)
        {
            labelCallComment.backgroundColor =  [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f];
            if (expectSizeForCollAddress.height ==0)
            {
                labelCallComment.frame =CGRectMake(10,30+20,curentSelf.view.frame.size.width-k-15,expectSizeForCallComment.height+4);
            }
            else
            {
                labelCallComment.frame =CGRectMake(10,30+5+expectSizeForCollAddress.height+4+5,curentSelf.view.frame.size.width-k-15,  expectSizeForCallComment.height+4);
                
            }
            [cell.View2 addSubview:labelCallComment];
        }
        if (height2 !=0 &&  [[[responseObject.orders objectAtIndex:indexPath.row] DeliveryAddrTypeMenu]integerValue]!=0)
 {
            NSString *deliveryAddressType =[[responseObject.orders objectAtIndex:indexPath.row]DeliveryAddrTypeMenu];
            if(deliveryAddressType && [deliveryAddressType integerValue]==50)
            {
                cell.labelDeliveryMetroName.text = @"По указанию";
            }else
            {
               if ([[responseObject.orders objectAtIndex:indexPath.row] DeliveryMetroName])
                {
                    cell.labelDeliveryMetroName.text =[NSString stringWithFormat:@"%@",[[responseObject.orders objectAtIndex:indexPath.row] DeliveryMetroName]];
                }else
                {
                    cell.labelDeliveryMetroName.text =@"";
                }
            }
            
            if(expectSizeForDeliveryAddress.height !=0)
            {
                labelDeliveryAddressText.backgroundColor= [UIColor whiteColor];
                labelDeliveryAddressText.frame = CGRectMake(10, 30+5, curentSelf.view.frame.size.width-k-43-25,
                                                            expectSizeForDeliveryAddress.height+4);
                
                [cell.View3 addSubview:labelDeliveryAddressText];
            }
            if(expectSizeDeliveryComment.height !=0)
            {
                labelDeliveryComment.backgroundColor =  [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f];
                if (expectSizeForDeliveryAddress.height ==0)
                {
                    labelDeliveryComment.frame = CGRectMake(10, 35+15, curentSelf.view.frame.size.width-k-15,  expectSizeDeliveryComment.height+4);
                }
                else
                {
                    labelDeliveryComment.frame = CGRectMake(10, 30+5+expectSizeForDeliveryAddress.height+4+5, curentSelf.view.frame.size.width-k-15,  expectSizeDeliveryComment.height+4);
                }
                [cell.View3 addSubview:labelDeliveryComment];
            }
            if (expectSizeForOurComment.height !=0)
            {
                labelOurComment.backgroundColor =  [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f];
                if(expectSizeForDeliveryAddress.height ==0 && expectSizeDeliveryComment.height !=0)
                {
                    labelOurComment.frame = CGRectMake(10, 35+15+expectSizeDeliveryComment.height +4+5, curentSelf.view.frame.size.width-k-15, expectSizeForOurComment.height);
                }
                else if(expectSizeForDeliveryAddress.height ==0 && expectSizeDeliveryComment.height ==0)
                {
                    labelOurComment.frame =CGRectMake(10,35+15,curentSelf.view.frame.size.width-k-15,expectSizeForOurComment.height);
                    
                }
                else if(expectSizeForDeliveryAddress.height !=0 && expectSizeDeliveryComment.height ==0)
                {
                    labelOurComment.frame = CGRectMake(10, 30+5+expectSizeForDeliveryAddress.height+4+5,curentSelf.view.frame.size.width-k-15, expectSizeForOurComment.height);
                    
                }
                else
                {
                    labelOurComment.frame = CGRectMake(10, 30+5+expectSizeForDeliveryAddress.height+4+5+expectSizeDeliveryComment.height+4+5, curentSelf.view.frame.size.width-k-15, expectSizeForOurComment.height);
                    
                }
                [cell.View3 addSubview:labelOurComment];
            }
        }
        
        
        
        if (numberOfClass==0)
        {
            underView=cell.underView;
            [(SelectedOrdersViewController*)curentSelf setUnderView:underView];
        }
        else
        {
             underView=cell.underView;
             [(MyOrdersViewController*)curentSelf setUnderView:underView];
        }
        
        
        if (flag1 ==-1)
        {
            cell.whiteLabel.backgroundColor =[UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
        }
        else
        {
            cell.whiteLabel.backgroundColor=[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
        }
        
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return  cell;
        
    }
    
    
    else
    {
        deliveryAddrTypeMenu =[[responseObject.orders objectAtIndex:indexPath.row] DeliveryAddrTypeMenu];
        if(deliveryAddrTypeMenu && [deliveryAddrTypeMenu integerValue] ==0)
        {
            NSString *simpleTableIdentifierIphone = [NSString stringWithFormat: @"SimpleTableOrdersSecond%ld",(long)indexPath.row];
            CustomCellSelectedOrders * cell = (CustomCellSelectedOrders *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierIphone];
            if (cell == nil)
            {
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellSelectedOrders2" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.labelPercent0.textColor = [UIColor whiteColor];
            cell.labelPercent0.text =  stringForLabelPercent;
            cell.labelShortName0.text =  stringForLabelShortName;
            [self addImages:cell.View1 atIndexPath:indexPath.row withLabel:cell.labelPercent];
            if ([[responseObject.orders objectAtIndex:indexPath.row] CollMetroName])
            {
                cell.labelCallMetroName0.text = [NSString stringWithFormat:@"  %@",[[responseObject.orders objectAtIndex:indexPath.row] CollMetroName]];
            }
            else
            {
                cell.labelCallMetroName0.text =@"";
            }
            if (flag1 ==-1)
            {
                cell.backgroundColor =[UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
                
                cell.contentView.backgroundColor =[UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
            }
            else
            {
                cell.backgroundColor =[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
                
                cell.contentView.backgroundColor=[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
            }
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        else
        {
            NSString *simpleTableIdentifierIphone = [NSString stringWithFormat: @"SimpleTableOrdersFirst%ld",(long)indexPath.row];
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
            [self addImages:cell.View1 atIndexPath:indexPath.row withLabel:cell.labelPercent];
            if ([[responseObject.orders objectAtIndex:indexPath.row] CollMetroName])
            {
                cell.labelCollMetroName.text = [NSString stringWithFormat:@"  %@",[[responseObject.orders objectAtIndex:indexPath.row] CollMetroName]];
            }
            else
            {
                cell.labelCollMetroName.text =@"";
            }
            
            if ( deliveryAddrTypeMenu && [deliveryAddrTypeMenu integerValue] ==50)
            {
                cell.labelDeliveryMetroName.text = @"  По указанию";
            }
            else if([[responseObject.orders objectAtIndex:indexPath.row] DeliveryMetroName])
            {
                cell.labelDeliveryMetroName.text = [NSString stringWithFormat:@"  %@",[[responseObject.orders objectAtIndex:indexPath.row] DeliveryMetroName]];
            }
            else
            {
                cell.labelDeliveryMetroName.text = @"";
            }
            if (flag1 ==-1)
            {
                cell.backgroundColor =[UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
                
                cell.contentView.backgroundColor =[UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
            }
            else
            {
                cell.backgroundColor = [UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
                
                cell.contentView.backgroundColor=[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
            }
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            return  cell;
        }
        
        
    }
    
}



- (void)tableView:(UITableView *)tableView
  willDisplayCell:(CustomCellSelectedOrders *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    idhash =[[responseObject.orders objectAtIndex:indexPath.row] idhash];
    NSString * CollAddrTypeMenu =[[responseObject.orders objectAtIndex:indexPath.row]CollAddrTypeMenu];
    if (CollAddrTypeMenu)
    {
      switch ([CollAddrTypeMenu integerValue]) {
        case 1:
            cell.imgViewCall.image = [UIImage imageNamed:@"metro"];
            break;
        case 2:
            cell.imgViewCall.image = [UIImage imageNamed:@"train"];
        case 3:
            cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_airport"];
        case 4:
            cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_outdoors"];
        case 10:
            cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_hospital"];
        case 11:
            cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_school"];
        case 12:
            cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_cinema copy"];
        case 13:
            cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_mall"];
        default:
            break;
    }
    }
    NSString * DeliveryAddrTypeMenu =[[responseObject.orders objectAtIndex:indexPath.row]DeliveryAddrTypeMenu];
    if (DeliveryAddrTypeMenu)
    {
    switch ([DeliveryAddrTypeMenu integerValue]) {
        case 1:
            cell.imgViewDel.image = [UIImage imageNamed:@"metro"];
            break;
        case 2:
            cell.imgViewDel.image = [UIImage imageNamed:@"train"];
        case 3:
            cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_airport"];
        case 4:
            cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_outdoors"];
        case 10:
            cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_hospital"];
        case 11:
            cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_school"];
        case 12:
            cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_cinema copy"];
        case 13:
            cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_mall"];
        default:
            break;
    }
    }
    
    if (indexPath.row!=selectedRow ) {
        if ([[SingleDataProvider sharedKey].arrayOfIndexes containsObject:idhash])
        {
        if (CollAddrTypeMenu)
        {
            switch ([CollAddrTypeMenu integerValue]) {
                case 1:
                    cell.imgViewCall.image = [UIImage imageNamed:@"metro_d"];
                    break;
                case 2:
                    cell.imgViewCall.image = [UIImage imageNamed:@"train_d"];
                case 3:
                    cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_airport_viewed"];
                case 4:
                    cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_outdoors_viewed"];
                case 10:
                    cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_hospital_viewed"];
                case 11:
                    cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_school_viewed"];
                case 12:
                    cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_cinema_viewed"];
                case 13:
                    cell.imgViewCall.image = [UIImage imageNamed:@"ic_landmark_mall_viewed"];
                default:
                    break;
            }
        }
         if (DeliveryAddrTypeMenu)
            {
               switch ([DeliveryAddrTypeMenu integerValue]) {
                case 1:
                    cell.imgViewDel.image = [UIImage imageNamed:@"metro_d"];
                    break;
                case 2:
                    cell.imgViewDel.image = [UIImage imageNamed:@"train_d"];
                case 3:
                    cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_airport_viewed"];
                case 4:
                    cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_outdoors_viewed"];
                case 10:
                    cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_hospital_viewed"];
                case 11:
                    cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_school_viewed"];
                case 12:
                    cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_cinema_viewed"];
                case 13:
                    cell.imgViewDel.image = [UIImage imageNamed:@"ic_landmark_mall_viewed"];
                default:
                    break;
            }
            }
            cell.labelCallMetroName0.font =[UIFont fontWithName:@"RobotoCondensed-Light" size:14];
            cell.labelCollMetroName.font=[UIFont fontWithName:@"RobotoCondensed-Light" size:14];
            cell.labelDeliveryMetroName.font=[UIFont fontWithName:@"RobotoCondensed-Light" size:14];
            
            
        }
        if(deliveryAddrTypeMenu && [deliveryAddrTypeMenu integerValue] ==0)
        {
            CAGradientLayer* gradLayerForCell =[CAGradientLayer layer];
            UIColor * gradColStart =[UIColor colorWithRed:223/255.0f green:223/255.0f blue:223/255.0f alpha:1.f];
            UIColor * gradColFin =[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1.f];
            if ([deviceType isEqualToString:@"iPhone Simulator"])
            {
                if([[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortrait ||
                   [[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortraitUpsideDown)
                {
                    gradLayerForCell.frame =CGRectMake(0,0,cell.bounds.size.width,48);
                }
                else
                {
                    gradLayerForCell.frame =CGRectMake(0,0,cell.bounds.size.width,(curentSelf.view.frame.size.height/6)-3);
                }
                
            }
            [gradLayerForCell setColors:[NSArray arrayWithObjects:(id)(gradColStart.CGColor), (id)(gradColFin.CGColor),nil]];
            [cell.additionalViewXib2.layer insertSublayer:gradLayerForCell atIndex:0];
         }
        else
        {
            CAGradientLayer* gradLayerForCell =[CAGradientLayer layer];
            UIColor * gradColStart =[UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1.f];
            UIColor * gradColFin =[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1.f];
            if ([deviceType isEqualToString:@"iPhone Simulator"])
            {
                if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait ||
                   [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortraitUpsideDown)
                {
                    gradLayerForCell.frame =CGRectMake(0,0,cell.bounds.size.width,(curentSelf.view.frame.size.height*146/1136)-3);
                }
                else
                {
                    gradLayerForCell.frame =CGRectMake(0,0,cell.bounds.size.width,(curentSelf.view.frame.size.height/4)-3);
                }
                
            }
            [gradLayerForCell setColors:[NSArray arrayWithObjects:(id)(gradColStart.CGColor), (id)(gradColFin.CGColor),nil]];
            [cell.additionalView.layer insertSublayer:gradLayerForCell atIndex:0];
            
            
            
        }
        
    }
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   //((SelectedOrdersViewController*)curentSelf).idhash=[[responseObject.orders objectAtIndex:indexPath.row] idhash];
    idhash=[[responseObject.orders objectAtIndex:indexPath.row] idhash];
    if(selectedRow==indexPath.row)
    {
        selectedRow =-1;
    }else{
        selectedRow =indexPath.row;
    }
    if (!([[SingleDataProvider sharedKey].arrayOfIndexes containsObject:idhash]))
    {
        [[SingleDataProvider sharedKey].arrayOfIndexes addObject:idhash];
    }
    [tableView reloadData];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    
    deliveryAddrTypeMenu =[[responseObject.orders objectAtIndex:indexPath.row] DeliveryAddrTypeMenu];
    
    if(selectedRow==indexPath.row)
    {
        height1 =35;
       //CALLADDRESS
        NSString * collAddress =[[responseObject.orders objectAtIndex:indexPath.row] CollAddressText];
        NSLog(@"CollAddress is %@",collAddress);
        if (collAddress && collAddress.length !=0)
        {
            if (!labelCollAddressText)
            {
                labelCollAddressText  = [[UILabel alloc] init];
            }
            labelCollAddressText.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
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
        NSString * callComment =[[responseObject.orders objectAtIndex:indexPath.row] CollComment];
        NSLog(@"CallComment is %@",callComment);
        
        if(callComment && callComment.length !=0)       {
            if (!labelCallComment)
            {
            labelCallComment  = [[UILabel alloc] init];
            }
            labelCallComment.font = [UIFont fontWithName:@"Roboto-LightItalic" size:15];
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
        height2 =35;
        NSString * deliveryAddress =[[responseObject.orders objectAtIndex:indexPath.row] DeliveryAddressText];
        
        if(deliveryAddress && deliveryAddress.length !=0)
        {
            if (!labelDeliveryAddressText)
            {
            labelDeliveryAddressText  = [[UILabel alloc] init];
            }
            labelDeliveryAddressText.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
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
        NSString * deliveryComment =[[responseObject.orders objectAtIndex:indexPath.row]DeliveryComment];
        
        if(deliveryComment && deliveryComment.length !=0)
        {
            if (!labelDeliveryComment)
            {
                labelDeliveryComment  = [[UILabel alloc] init];
            }
            labelDeliveryComment.font = [UIFont fontWithName:@"Roboto-LightItalic" size:15];
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
        NSString * ourComment =[[responseObject.orders objectAtIndex:indexPath.row] OurComment];
        
        if(ourComment && ourComment.length !=0)
        {
            if (!labelOurComment)
            {
             labelOurComment  = [[UILabel alloc] init];
            }
            labelOurComment.font =  [UIFont fontWithName:@"Roboto-LightItalic" size:15];
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
        if ([[[responseObject.orders objectAtIndex:indexPath.row] DeliveryAddrTypeMenu]integerValue]==0 && expectSizeDeliveryComment.height==0
            && expectSizeForOurComment.height==0 )
        {
            height2=0;
        }
        if ([[[responseObject.orders objectAtIndex:indexPath.row] DeliveryAddrTypeMenu]integerValue]==0 &&(expectSizeDeliveryComment.height!=0 ||expectSizeForOurComment.height!=0 ))
        {
            height2=5+expectSizeDeliveryComment.height+4+5+expectSizeForOurComment.height+4+5;
        }
        
        //DEFINING HEIGHT FOR CELL
        height = 2+1+22+height1+height2+1+4+45+4;
        //CustomCellSelectedORDER2
        if ([[[responseObject.orders objectAtIndex:indexPath.row] CanBuyDeliveryAddress]integerValue]==1)
        {
            height = 2+1+22+height1+4+80;
        }
        
        return height;
        
        
    }
//    else if (selectedRow==indexPath.row && numberOfClass==1)
//    {
//        heightOfMyOrderCell=height+45;
//       
//        return height+45;
//       
//    }
    
    else
    {
    
        if([deliveryAddrTypeMenu integerValue] ==0)
        {
            if([[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortrait ||
               [[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortraitUpsideDown)
            {
                return 51;
            }
            
            else
            {
               
                return curentSelf.view.frame.size.height/6;
            }
            
        }
        else
        {
            if ([deviceType isEqualToString:@"iPhone Simulator"])
            {
                if([[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortrait ||
                   [[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortraitUpsideDown)
                {
                    return  curentSelf.view.frame.size.height*146/1136;
                }
                else
                {
                    return   curentSelf.view.frame.size.height/4;
                }
            }
            else
            {
                if([[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortrait ||
                   [[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortraitUpsideDown)
                {
                    return  curentSelf.view.frame.size.height*146/1136;
                }
                else
                {
                    return curentSelf.view.frame.size.height/6;
                }
            }
        }
    }
}

-(void)addImages:(UIView *)view
     atIndexPath:(NSInteger)index
      withLabel :(UILabel *)label
{
    
    UIImageView * imgView1;
    if (!imgView1)
    {
     imgView1 = [[UIImageView alloc]initWithImage:nil];
    }
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
    
    if ([[responseObject.orders objectAtIndex:index] getNoSmoking])
    {
        NoSmoking =[[responseObject.orders objectAtIndex:index] getNoSmoking];
        if ([NoSmoking isEqualToString:@"Y"])
        {
            imgView1.image = [UIImage imageNamed: @"ic_no_smoking_lounge_small.png"];
            imgView1ConstraintWidth = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:17];
            imgView1ConstraintHeight = [NSLayoutConstraint constraintWithItem:imgView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.f constant:18];
            [view   addConstraint:imgView1ConstraintWidth];
            [view addConstraint:imgView1ConstraintHeight];
        }
        else if([[responseObject.orders objectAtIndex:index] getG_width])
        {
            G_Width =[[responseObject.orders objectAtIndex:index] getG_width];
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
    //Image2 construction and initializatio
    UIImageView * imgView2;
    if (!imgView2)
    {
        imgView2 = [[UIImageView alloc]initWithImage:nil];
    }
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
    if ([[responseObject.orders objectAtIndex:index] getPayment_method])
    {
        payment_method =[[responseObject.orders objectAtIndex:index] getPayment_method];
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
    if (!imgView3)
    {
      imgView3 = [[UIImageView alloc]initWithImage:nil];
    }
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
    
    if ([[responseObject.orders objectAtIndex:index] getConditioner])
        
    {
        conditioner =[[responseObject.orders objectAtIndex:index] getConditioner];
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
    if (!imgView4)
    {
     imgView4 = [[UIImageView alloc]initWithImage:nil];
    }
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
    if ([[responseObject.orders objectAtIndex:index] getAnimal])
    {
        animal =[[responseObject.orders objectAtIndex:index] getAnimal];
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
    if (!imgView5)
    {
     imgView5 = [[UIImageView alloc]initWithImage:nil];
    }
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
    if ([[responseObject.orders objectAtIndex:index] getBaby_seat])
    {
        NSString * babySeat;
        babySeat =[[responseObject.orders objectAtIndex:index] getBaby_seat];
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
    if (!imgView6)
    {
     imgView6 = [[UIImageView alloc]initWithImage:nil];
    }
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
    if ([[responseObject.orders objectAtIndex:index] getLuggage])
    {
        NSString * luggage;
        luggage =[[responseObject.orders objectAtIndex:index] getLuggage];
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
    if (!imgView7)
    {
        imgView7 = [[UIImageView alloc]initWithImage:nil];
    }
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
    if ([[responseObject.orders objectAtIndex:index] getUseBonus])
    {
        NSString * useBonus;
        useBonus =[[responseObject.orders objectAtIndex:index] getUseBonus];
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
    if (!imgView8)
    {
        imgView8 = [[UIImageView alloc]initWithImage:nil];
    }
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
    if ([[responseObject.orders objectAtIndex:index] getNeed_wifi])
    {
        NSString * need_WiFi;
        need_WiFi =[[responseObject.orders objectAtIndex:index] getNeed_wifi];
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
    if (!imgView9)
    {
        imgView9 = [[UIImageView alloc]initWithImage:nil];
    }
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
    if ([[responseObject.orders objectAtIndex:index] getYellow_reg_num])
    {
        NSString * yellowNumber;
        yellowNumber =[[responseObject.orders objectAtIndex:index] getYellow_reg_num];
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

//-(void)TimeForUrgentOrders:(NSString *)string
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
//    NSDate *date1 = [[NSDate alloc] init];
//    date1 = [dateFormatter dateFromString:string];
//    NSTimeInterval diff = [date1 timeIntervalSinceNow];
//    div_t h = div(diff, 3600);
//    int hours = h.quot;
//    // Divide the remainder by 60; the quotient is minutes, the remainder
//    // is seconds.
//    div_t m = div(h.rem, 60);
//    int minutes = m.quot;
//    int seconds = m.rem;
//    
//    // If you want to get the individual digits of the units, use div again
//    // with a divisor of 10.
//    
//    NSLog(@"%d:%d:%d", hours, minutes, seconds);
//   
//}
@end
