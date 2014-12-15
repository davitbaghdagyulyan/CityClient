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
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    
//    if (!selected) {
//        [self.checkbox setImage:[UIImage imageNamed:@"box2.png"] forState:UIControlStateSelected];
//        [super setSelected:YES animated:NO];
//    }
//    else{
//        [super setSelected:NO animated:NO];
//        [self.checkbox setImage:[UIImage imageNamed:@"box.png"] forState:UIControlStateNormal];
//    }
//}

- (IBAction)checkboxAction:(UIButton *)sender {
    if (!sender.isSelected) {
        [sender setSelected:YES];
    }
    else{
        [sender setSelected:NO];
    }
}
@end
