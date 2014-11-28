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
- (IBAction)showSettingViewController:(UIButton *)sender;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
@end

@interface FirstView : UIView <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *FirstScrollView;
- (IBAction)edit:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlView;

- (IBAction)segmentControlAction:(UISegmentedControl *)sender;


@property(nonatomic,weak) id<segmentControlDelegate> delegate;


- (IBAction)sendDocumentsAction:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIImageView *profilPhoto;








- (IBAction)showSettingViewController:(UIButton *)sender;

- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;


@end
