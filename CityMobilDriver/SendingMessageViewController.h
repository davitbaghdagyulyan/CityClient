//
//  SendingMessageViewController.h
//  CityMobilDriver
//
//  Created by Intern on 10/16/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenu.h"
@interface SendingMessageViewController : UIViewController<UITextViewDelegate>

- (IBAction)sendAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UITextView *titleTextView;

- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *writeLetterLabel;

@end
