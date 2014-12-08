//
//  SuburbClass.h
//  CityMobilDriver
//
//  Created by Intern on 11/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "StartAfterMKADClass.h"
#import "DriveMKADClass.h"
#import "DriveAfterMKADClass.h"

@interface SuburbClass : JSONModel

@property(nonatomic,strong)NSString*text;
@property(nonatomic,strong)StartAfterMKADClass*StartAfterMKAD;
@property(nonatomic,strong)DriveMKADClass*DriveMKAD;
@property(nonatomic,strong)DriveAfterMKADClass*DriveAfterMKAD;

@end
