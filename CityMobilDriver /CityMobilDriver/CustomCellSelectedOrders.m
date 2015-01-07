//
//  CustomCellSelectedOrders.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/9/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "CustomCellSelectedOrders.h"

@implementation CustomCellSelectedOrders
{
    NSTimer * updateLabelTimer;
}
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
    NSMutableString * stringForUrgent;
    if ([self.stringForSrochno isEqualToString:@"СРОЧНО"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
        NSDate *callDate = [[NSDate alloc] init];
        callDate=[dateFormatter dateFromString:self.callDate];
        NSTimeInterval diff = [callDate timeIntervalSinceDate:[NSDate date]];
        NSInteger minutes=(int)((diff+3600)/60);
        NSInteger seconds = (int)(diff+3600)%60;
        NSString * minutesString;
        NSString * secondsString;
        if(minutes<10)
        {
            minutesString=[NSString stringWithFormat:@"0%ld",minutes];
        }
        else
        {
            minutesString=[NSString stringWithFormat:@"%ld",minutes];
        }
        if (seconds<10)
        {
            secondsString =[NSString stringWithFormat:@"0%ld",seconds];
        }
        else
        {
            secondsString =[NSString stringWithFormat:@"%ld",seconds];
        }
        stringForUrgent=[NSMutableString stringWithFormat:@"%@:%@",minutesString,secondsString];
        self.labelShortName.text=[NSString stringWithFormat:@"%@ %@ %@",self.stringForSrochno,stringForUrgent,self.shortName];
        self.labelShortName0.text =[NSString stringWithFormat:@"%@ %@ %@",self.stringForSrochno,stringForUrgent,self.shortName];
        if (self.timerForUpdatingLabelShortNameIsCreated==NO)
        {
            updateLabelTimer= [NSTimer scheduledTimerWithTimeInterval:1
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
        self.labelShortName.text=[NSString stringWithFormat:@"%@ %@ %@",self.stringForSrochno,[self TimeFormat: self.callDate],self.shortName];
        self.labelShortName0.text =[NSString stringWithFormat:@"%@ %@ %@",self.stringForSrochno,[self TimeFormat: self.callDate],self.shortName];
    }
    if ([stringForUrgent isEqualToString:@"00:00"])
    {
        [updateLabelTimer invalidate];
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
