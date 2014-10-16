//
//  SettingsViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/10/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property(nonatomic,strong) UIColor* viewsColor;
@property(nonatomic,strong) UIColor* buttonTextColor;
@end

@implementation SettingsViewController
static bool isWhit;
+(BOOL) getScrinColor
{
    return isWhit;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.balance.text =[self.balance.text stringByAppendingString:[UserInformationProvider sharedInformation].balance];
    self.limit.text =[self.limit.text stringByAppendingString:[UserInformationProvider sharedInformation].credit_limit];
    self.callsign.text =[self.callsign.text stringByAppendingString:[UserInformationProvider sharedInformation].bankid];
    self.buttonTextColor = self.required.titleLabel.textColor;
    //NSLog(@"%@",self.buttonTextColor);//????
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait && self.view.frame.size.height == 480)
    {
        self.scrolView.contentSize = self.view.frame.size;
    }
    
    if (([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) && self.view.frame.size.height != 768)
    {
        CGSize scrolViewSize = self.view.frame.size;
        scrolViewSize.height = self.view.frame.size.width;
        self.scrolView.contentSize = scrolViewSize;
    }
}








- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    }
     
    completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    if (([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) && self.view.frame.size.height != 768)
    {
        //NSLog(@"%@",NSStringFromCGSize(size));
        CGSize scrollSize = size;
        scrollSize.height = size.width;
        self.scrolView.contentSize = scrollSize;
    }
        
    if (([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait || [UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown) && self.view.frame.size.height == 480)
        {
            self.scrolView.contentSize = size;
        }
        
    }];
    
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
}
- (IBAction)nightModeAction:(id)sender
{
    if (self.nightMode.on)
    {
        self.backgroundImage.image = [UIImage imageNamed:@"XXX.png"];
        self.settings.textColor = [UIColor blackColor];
        self.yandexSettings.textColor = [UIColor blackColor];

    }
    else
    {
        self.backgroundImage.image = [UIImage imageNamed:@"pages_background.png"];
        self.settings.textColor = [UIColor orangeColor];
        self.yandexSettings.textColor = [UIColor orangeColor];
    }
}


- (IBAction)requiredAction:(id)sender
{
    [self.required setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.notRequired setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
    [self.off setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
}


- (IBAction)notRequiredAction:(id)sender
{
    [self.notRequired setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.required setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
    [self.off setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
}


- (IBAction)offAction:(id)sender
{
    [self.off setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.required setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
    [self.notRequired setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
}

- (IBAction)onAction:(id)sender
{
    [self.on setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.yandexOff setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
}
- (IBAction)yandexOffAction:(id)sender
{
    [self.yandexOff setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.on setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
}






- (IBAction)fontSize:(id)sender
{
    FontSizeViewController* s = [[FontSizeViewController alloc]initWithNibName:@"FontSizeViewController" bundle:nil];
    
    [self.view addSubview:s.view];
}








@end
