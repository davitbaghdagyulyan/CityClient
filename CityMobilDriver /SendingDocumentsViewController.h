//
//  SendingDocumentsViewController.h
//  CityMobilDriver
//
//  Created by Intern on 11/14/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendingDocumentsViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet GPSIcon *gpsButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSString* urlString;


//// left Menu /////

- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;

- (IBAction)back:(UIButton *)sender;
- (IBAction)openMap:(UIButton*)sender;


@property (nonatomic,weak) IBOutlet UIButton* yandexButton;
@property (nonatomic,weak) IBOutlet UIButton* cityButton;
@end
