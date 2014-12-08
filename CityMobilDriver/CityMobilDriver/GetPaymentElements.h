//
//  GetPaymentElements.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 12/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//


@protocol GetPaymentElements @end
#import "JSONModel.h"


@interface GetPaymentElements : JSONModel
@property(nonatomic,copy)NSString*comment;
@property(nonatomic,copy)NSString*oppdate;
@property(nonatomic,copy)NSString*sum;
@end
