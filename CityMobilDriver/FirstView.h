///Users/intern/Documents/Projects/CityMobilDriver/secondView.h
//  FirstView.h
//  CityMobilDriver
//
//  Created by Intern on 10/20/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestDocScansUrl.h"
#import "SingleDataProvider.h"
#import "DriverAllInfoResponse.h"

@protocol segmentControlDelegate <NSObject>

@required
- (IBAction)segmentControlAction:(UISegmentedControl *)sender;
- (IBAction)edit:(UIButton *)sender;
- (IBAction)sendDocumentsAction:(UIButton *)sender;
@end

@interface FirstView : UIView <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *FirstScrollView;
- (IBAction)edit:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlView;

- (IBAction)segmentControlAction:(UISegmentedControl *)sender;


@property(nonatomic,weak) id<segmentControlDelegate> delegate;


- (IBAction)sendDocumentsAction:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIImageView *profilPhoto;





@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *middleName;


@property (weak, nonatomic) IBOutlet UILabel *percentToCharge;
@property (weak, nonatomic) IBOutlet UILabel *passportSer;
@property (weak, nonatomic) IBOutlet UILabel *passportNum;
@property (weak, nonatomic) IBOutlet UILabel *dateRegister;
@property (weak, nonatomic) IBOutlet UILabel *passportWho;
@property (weak, nonatomic) IBOutlet UILabel *passportAddress;


@property (weak, nonatomic) IBOutlet UILabel *driverLicenseSerial;
@property (weak, nonatomic) IBOutlet UILabel *driverLicenseNumber;
@property (weak, nonatomic) IBOutlet UILabel *driverLicenseClass;






@end
