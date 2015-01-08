//
//  PaymentHistoryCustomCell.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 12/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "PaymentHistoryCustomCell.h"

@implementation PaymentHistoryCustomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateLabels
{
    if (self.oppDate)
    {
        NSString *collDate1 =[self.oppDate substringToIndex:16];
        NSString * year1 =[collDate1 substringToIndex:4];
        NSString * year =[year1 substringFromIndex:2];
        NSString * day1 =[collDate1 substringFromIndex:8];
        NSString * day=[day1 substringToIndex:2];
        NSString * month1=[collDate1 substringFromIndex:5];
        NSString* month=[month1 substringToIndex:2];
        NSString * time1=[collDate1 substringFromIndex:11];
        NSString * hour=[time1 substringToIndex:2];
        NSString *minutes=[time1 substringFromIndex:3];
        NSString * collDateFirstRow=[NSString stringWithFormat:@"%@.%@.%@",day,month,year];
        NSString * collDateSecondRow=[NSString stringWithFormat:@"%@.%@",hour,minutes];
        NSString * stringForDate = [NSString stringWithFormat:@" %@\n %@",collDateFirstRow,collDateSecondRow];
        self.labelOppDate.text = stringForDate;
    }
    else
    {
        self.labelOppDate.text= @"";
    }
    if (self.sum)
    {
        NSMutableAttributedString *sum = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ b",self.sum]];
//        UIFont *myFont = [UIFont fontWithName:@"Roboto-Regular" size:17];
//        [sum addAttribute:NSFontAttributeName
//                       value:myFont
//                       range:NSMakeRange(0,sum.length-1)];
        self.labelSum.attributedText=sum;
    }
    else
    {
       self.labelSum.text=@"";
    }
    if (self.comment)
    {
       self.labelComment.text=self.comment;
    }
    else
    {
        self.labelComment.text=@"";
    }
    
    }

@end
