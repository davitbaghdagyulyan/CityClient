//
//  RequestSetBill.m
//  CityMobilDriver
//
//  Created by Intern on 12/9/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "RequestSetBill.h"
#import "SingleDataProvider.h"

@implementation RequestSetBill
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.ipass=@"o3XOFR7xpv";
        self.ilog=@"cm-api";
        self.locale=@"ru";
        self.method=@"SetBill";
        self.version=@"1.0.2";
        self.key = [SingleDataProvider sharedKey].key;
    }
    return self;
}
@end
