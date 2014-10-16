//
//  SelectedOrdersDetailsJson.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/13/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SelectedOrdersDetailsJson.h"
#import "SingleDataProviderForFilter.h"
#import "SingleDataProvider.h"
@implementation SelectedOrdersDetailsJson
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.ipass=@"o3XOFR7xpv";
        self.key=[[SingleDataProvider sharedKey]key];
        self.ilog=@"cm-api";
        self.method=@"GetOrders";
        self.version=@"1.0.2";
        self.versionCode=@"17";
        self.filter =
        [[SingleDataProviderForFilter sharedFilter]filter];
    }
    return self;
}

@end
