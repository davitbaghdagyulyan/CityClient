//
//  SendingDocumentsViewController.h
//  CityMobilDriver
//
//  Created by Intern on 11/14/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendingDocumentsViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)back:(UIButton *)sender;

@property (nonatomic, strong) NSString* urlString;
@end
