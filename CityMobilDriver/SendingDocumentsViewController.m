//
//  SendingDocumentsViewController.m
//  CityMobilDriver
//
//  Created by Intern on 11/14/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SendingDocumentsViewController.h"

@interface SendingDocumentsViewController ()
{
    UIActivityIndicatorView* indicator;
}
@end

@implementation SendingDocumentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [indicator stopAnimating];
}


@end
