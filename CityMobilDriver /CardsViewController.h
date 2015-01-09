//
//  CardsViewController.h
//  CityMobilDriver
//
//  Created by Intern on 10/31/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardsViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet GPSIcon *gpsButton;
- (IBAction)openMap:(UIButton*)sender;
@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControll;
- (IBAction)segmentControllAction:(UISegmentedControl*)sender;

@property (weak, nonatomic) IBOutlet UILabel *hasCards;

- (IBAction)addCard:(UIButton *)sender;

- (IBAction)deleteCard:(UIButton *)sender;



- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;

- (IBAction)back:(UIButton *)sender;

@end
