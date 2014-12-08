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
        NSString * collDate2 =[collDate1 substringFromIndex:2];
        NSString * collDateFirstRow=[collDate2 substringToIndex:8];
        NSString * collDateSecondRow=[collDate2 substringFromIndex:9];
        NSString * stringForDate = [NSString stringWithFormat:@" %@\n %@",collDateFirstRow,collDateSecondRow];
        self.labelOppDate.text = stringForDate;
    }
    else
    {
        self.labelOppDate.text= @"";
    }
    if (self.sum)
    {
        self.labelSum.text=[NSString stringWithFormat:@"%@ b",self.sum];
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
