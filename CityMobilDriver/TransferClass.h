//
//  TransferClass.h
//  CityMobilDriver
//
//  Created by Intern on 11/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "JSONModel.h"
#import "DestinationElements.h"
#import "OtherClass.h"

@interface TransferClass : JSONModel

@property(nonatomic,strong)NSString<Optional>*text;
@property(nonatomic,strong)NSArray<DestinationElements,Optional>*Destination;
@property(nonatomic,strong)OtherClass<Optional>*Other;


@end
