//
//  ServicesTableCell.m
//  CityMobilDriver
//
//  Created by Intern on 12/5/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "ServicesTableCell.h"

@implementation ServicesTableCell

- (void)awakeFromNib {
    // Initialization code
}


- (IBAction)checkboxAction:(UIButton *)sender {
    if (!sender.isSelected) {
        [sender setSelected:YES];
    }
    else{
        [sender setSelected:NO];
    }
}
@end
