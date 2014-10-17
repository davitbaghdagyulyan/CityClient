//
//  SelectedOrdersDetailsResponse.h
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/13/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "SelectedOrdersDetailsElements.h"

@interface SelectedOrdersDetailsResponse : JSONModel

@property (nonatomic,strong)NSMutableArray<SelectedOrdersDetailsElements>*orders;
@property(nonatomic,strong)NSString*code;


@end