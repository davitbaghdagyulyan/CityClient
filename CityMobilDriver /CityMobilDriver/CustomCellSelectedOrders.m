//
//  CustomCellSelectedOrders.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/9/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "CustomCellSelectedOrders.h"

@implementation CustomCellSelectedOrders

- (void)awakeFromNib
{
    self.timerForUpdatingLabelShortNameIsCreated=NO;
   // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
    // Configure the view for the selected state
}

-(void)updateLabelShortName
{
    if ([self.stringForSrochno isEqualToString:@"СРОЧНО"]) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSDate *callDate = [[NSDate alloc] init];
    callDate=[dateFormatter dateFromString:self.callDate];
    NSTimeInterval diff = [callDate timeIntervalSinceDate:[NSDate date]];
    NSInteger k=(int)((diff+3600)/60);
    NSInteger mnacord = (int)(diff+3600)%60;
    NSMutableString * stringForUrgent;
    if (k<10)
    {
        stringForUrgent=[NSMutableString stringWithFormat:@"0%ld:%ld",k,mnacord];
    }
    else
    {
        stringForUrgent=[NSMutableString stringWithFormat:@"%ld:%ld",k,mnacord];
    }
    self.labelShortName.text=[NSString stringWithFormat:@"  %@ %@ %@",self.stringForSrochno,stringForUrgent,self.shortName];
    self.labelShortName0.text =[NSString stringWithFormat:@"  %@ %@ %@",self.stringForSrochno,stringForUrgent,self.shortName];
    if (self.timerForUpdatingLabelShortNameIsCreated==NO)
    {
        NSTimer * updateLabelTimer= [NSTimer scheduledTimerWithTimeInterval:1
                                                                     target:self
                                                                   selector:@selector(updateLabelShortName)
                                                                   userInfo:nil
                                                                    repeats:YES];
        self.timerForUpdatingLabelShortNameIsCreated=YES;
    }
  }
 else
 {
     self.labelShortName.font=[UIFont fontWithName:@"Roboto-Bold" size:15];
     self.labelShortName0.font=[UIFont fontWithName:@"Roboto-Bold" size:15];
     self.labelShortName.text=[NSString stringWithFormat:@"  %@ %@ %@",self.stringForSrochno,[self TimeFormat: self.callDate],self.shortName];
     self.labelShortName0.text =[NSString stringWithFormat:@"  %@ %@ %@",self.stringForSrochno,[self TimeFormat: self.callDate],self.shortName];
 }

}


-(NSString*)TimeFormat:(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:string];
    /////////convert nsdata To NSString////////////////////////////////////
    [dateFormatter setDateFormat:@"HH:mm"];
    if(date==nil) return @"00:00";
    return [dateFormatter stringFromDate:date];
    
}
@end
