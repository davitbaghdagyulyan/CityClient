//
//  TachometerViewController.h
//  CityMobilDriver
//
//  Created by Intern on 11/19/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TachometerViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *tachoElements;

@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *distance;



@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *elements;

- (IBAction)elementAction:(id)sender;



//@property(nonatomic,strong)NSString * name;

@property(nonatomic,strong)NSString* collDate;
@property(nonatomic,strong)NSString* shortname;
@property(nonatomic,strong)NSString* collMetroName;
@property(nonatomic,strong)NSString* CollComment;
@property(nonatomic,strong)NSString* deliveryMetroName;
@property(nonatomic,strong)NSString* deliveryComment;
@property(nonatomic,strong)NSString* ourComment;


///name price from services
@end
