//
//  SelectedOrdersTableViewHandler.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/25/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedOrdersDetailsResponse.h"
#import "MyOrdersViewController.h"

//@protocol FooDelegate <NSObject>
//@optional
//-(void)toTakeAction;
//-(void)collMap;
//-(void)deliveryMapp;
//@end

@interface SelectedOrdersTableViewHandler : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat heightOfMyOrderCell;
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
    SelectedOrdersDetailsResponse*responseObject;
    NSUInteger indexOfCell;
    NSString*stringforSrochno;
    NSInteger flag1;
    UIView*underView;
    UIViewController*curentSelf;
    NSUInteger numberOfClass;
    CGSize expectSizeForCollAddress;
    CGSize expectSizeForCallComment;
     CGSize  expectSizeForDeliveryAddress;
        CGSize expectSizeDeliveryComment;
       CGSize expectSizeForOurComment;
    CGFloat height2;
    CGFloat height1;
    
}
@property(nonatomic,strong)UIView*under;
-(void)setResponseObject:(SelectedOrdersDetailsResponse*)object andStringforSroch:(NSString*)string andFlag1:(NSInteger)flag andCurentSelf:(UIViewController*)vc andNumberOfClass:(NSUInteger)number;

-(void)setSelectedRow:(NSInteger)selectedRo;

@end
