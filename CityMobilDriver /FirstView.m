//
//  FirstView.m
//  CityMobilDriver
//
//  Created by Intern on 10/20/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "FirstView.h"
#import "LeftMenu.h"
@interface FirstView()
{
    DriverAllInfoResponse* jsonResponseObject;
    
    NSInteger flag;
    LeftMenu*leftMenu;
}
@end



@implementation FirstView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation
*/
- (void)drawRect:(CGRect)rect
{
    self.FirstScrollView.showsHorizontalScrollIndicator = NO;
    self.FirstScrollView.delegate = self;
    

 
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    if (sender.contentOffset.x != 0)
    {
        CGPoint offset = sender.contentOffset;
        offset.x = 0;
        sender.contentOffset = offset;
    }
}

- (IBAction)edit:(UIButton *)sender
{
    [self.delegate edit:sender];
}
- (IBAction)segmentControlAction:(UISegmentedControl *)sender
{
        [self.delegate segmentControlAction:sender];
}


- (IBAction)sendDocumentsAction:(UIButton *)sender
{
    [self.delegate sendDocumentsAction:sender];
}









- (IBAction)showSettingViewController:(UIButton *)sender
{
    [self.delegate showSettingViewController:sender];
}

- (IBAction)openAndCloseLeftMenu:(UIButton *)sender
{
    [self.delegate openAndCloseLeftMenu:sender];
}






@end
