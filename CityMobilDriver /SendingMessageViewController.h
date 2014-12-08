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
@property (strong, nonatomic)  UIScrollView *scrollView;

@property (nonatomic, assign) BOOL isPushWidthInfoController;
@property (nonatomic, strong) NSString* titleText;
@property (nonatomic, strong) NSString* id_mail;
@property(nonatomic,strong)UIButton*sendButton;
@property (strong, nonatomic) UITextView *messageTextView;
@property (strong, nonatomic) UITextView *titleTextView;
@property (strong,nonatomic)UIView*underView;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
@property (strong, nonatomic) UILabel *writeLetterLabel;
- (IBAction)back:(id)sender;
@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;
- (IBAction)openMap:(UIButton*)sender;
@end
