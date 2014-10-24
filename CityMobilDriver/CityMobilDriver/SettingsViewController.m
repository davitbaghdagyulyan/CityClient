//
//  SettingsViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/10/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
{
    NSInteger flag;
    LeftMenu*leftMenu;
    
    UITableView* fontSizeTableView;
    UIView* backgroundView;
    UIView* fontSizeView;
    
    UIView* fontStileView;
    UITableView* StileIconTableView;
    
    UITableView* selectLanguageTableView;
}
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
    
    
    NSString* a = [UserInformationProvider sharedInformation].balance;
    
    
    self.balance.text =[self.balance.text stringByAppendingString:[UserInformationProvider sharedInformation].balance];
    self.limit.text =[self.limit.text stringByAppendingString:[UserInformationProvider sharedInformation].credit_limit];
    self.callsign.text =[self.callsign.text stringByAppendingString:[UserInformationProvider sharedInformation].bankid];
    self.buttonTextColor = self.required.titleLabel.textColor;
    //NSLog(@"%@",self.buttonTextColor);//????
}



-(void)viewDidAppear:(BOOL)animated
{
    
    self.scrolView.userInteractionEnabled=YES;
    leftMenu=[LeftMenu getLeftMenu:self];
    
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
        
        fontSizeView.center = self.view.center;
        fontStileView.center = self.view.center;
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










- (IBAction)fontSize:(id)sender/////////
{
    backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundView.alpha = 0.5;
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:backgroundView];
    
    
    fontSizeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 250)];
    fontSizeView.center = self.view.center;
    [self.view addSubview:fontSizeView];
    
    UILabel* descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, fontSizeView.frame.size.width, 50)];
    descriptionLabel.text = @"Размер шрифта";
    descriptionLabel.backgroundColor = [UIColor whiteColor];
    [fontSizeView addSubview:descriptionLabel];

    
    fontSizeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, fontSizeView.frame.size.width, 150)];
    fontSizeTableView.scrollEnabled = NO;
    fontSizeTableView.delegate = self;
    fontSizeTableView.dataSource = self;
    [fontSizeView addSubview:fontSizeTableView];
    
    
    UIButton* okSizeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, fontSizeView.frame.size.width, 50)];
    okSizeButton.backgroundColor = [UIColor whiteColor];
    [okSizeButton addTarget:self action:@selector(okButton) forControlEvents:UIControlEventTouchUpInside];
    [okSizeButton setTitle:@"OK" forState:UIControlStateNormal];
    [okSizeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [fontSizeView addSubview:okSizeButton];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == fontSizeTableView)
    {
        return 3;
    }
    if (tableView == StileIconTableView || tableView == selectLanguageTableView)
    {
        return 2;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == fontSizeTableView)
    {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        CustomTableViewCell* cell = [nibArray objectAtIndex:0];
        
        switch (indexPath.row)
        {
            case 0:
                cell.cellText.text = @"Мелкий";
                break;
            case 1:
                cell.cellText.text = @"Обычный";
                break;
            case 2:
                cell.cellText.text = @"Крупный";
                break;
            default:
                break;
        }
        return cell;
    }
    
    if (tableView == StileIconTableView)
    {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        CustomTableViewCell* cell = [nibArray objectAtIndex:0];
        
        switch (indexPath.row)
        {
            case 0:
                cell.cellText.text = @"Радужный";
                break;
            case 1:
                cell.cellText.text = @"Черный";
                break;
            default:
                break;
        }
        return cell;
    }
    
    if (tableView == selectLanguageTableView)
    {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        CustomTableViewCell* cell = [nibArray objectAtIndex:0];
        
        switch (indexPath.row)
        {
            case 0:
                cell.cellText.text = @"Русский";
                break;
            case 1:
                cell.cellText.text = @"English";
                break;
            default:
                break;
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == fontSizeTableView)
    {
        CustomTableViewCell* cell = (CustomTableViewCell*)[fontSizeTableView cellForRowAtIndexPath:indexPath];
        cell.selectedCell.backgroundColor = [UIColor blueColor];
    }
    if (tableView == StileIconTableView)
    {
        CustomTableViewCell* cell = (CustomTableViewCell*)[StileIconTableView cellForRowAtIndexPath:indexPath];
        cell.selectedCell.backgroundColor = [UIColor blueColor];
    }
}


-(void)okButton
{
    [fontSizeView removeFromSuperview];
    [backgroundView removeFromSuperview];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if (backgroundView == touch.view)
    {
        [fontStileView removeFromSuperview];
        [fontSizeView removeFromSuperview];
        [backgroundView removeFromSuperview];
    }
}





- (IBAction)stileIcon:(id)sender
{
    backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundView.alpha = 0.5;
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:backgroundView];
    
    
    fontStileView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 200)];
    fontStileView.center = self.view.center;
    [self.view addSubview:fontStileView];
    
    UILabel* descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, fontStileView.frame.size.width, 50)];
    if ([sender tag] == 100)
    {
        descriptionLabel.text = @"Размер шрифта";
    }
    if ([sender tag] == 101)
    {
        descriptionLabel.text = @"Выберите язык";
    }
    descriptionLabel.backgroundColor = [UIColor whiteColor];
    [fontStileView addSubview:descriptionLabel];
    
    
    
    if ([sender tag] == 100)
    {
        StileIconTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, fontStileView.frame.size.width, 100)];
        StileIconTableView.scrollEnabled = NO;
        StileIconTableView.delegate = self;
        StileIconTableView.dataSource = self;
        [fontStileView addSubview:StileIconTableView];
    }
    if ([sender tag] == 101)
    {
        selectLanguageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, fontStileView.frame.size.width, 100)];
        selectLanguageTableView.scrollEnabled = NO;
        selectLanguageTableView.delegate = self;
        selectLanguageTableView.dataSource = self;
        [fontStileView addSubview:selectLanguageTableView];
    }

    
    UIButton* okStileButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 150, fontStileView.frame.size.width, 50)];
    okStileButton.backgroundColor = [UIColor whiteColor];
    [okStileButton addTarget:self action:@selector(okStileButton) forControlEvents:UIControlEventTouchUpInside];
    [okStileButton setTitle:@"OK" forState:UIControlStateNormal];
    [okStileButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [fontStileView addSubview:okStileButton];
}

//- (IBAction)selectLanguage:(id)sender
//{
//    backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
//    backgroundView.alpha = 0.5;
//    backgroundView.backgroundColor = [UIColor grayColor];
//    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:backgroundView];
//    
//    
//    fontStileView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 200)];
//    fontStileView.center = self.view.center;
//    [self.view addSubview:fontStileView];
//    
//    UILabel* descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, fontStileView.frame.size.width, 50)];
//    descriptionLabel.text = @"Выберите язык";
//    descriptionLabel.backgroundColor = [UIColor whiteColor];
//    [fontStileView addSubview:descriptionLabel];
//    
//    
//    StileIconTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, fontStileView.frame.size.width, 100)];
//    StileIconTableView.scrollEnabled = NO;
//    StileIconTableView.delegate = self;
//    StileIconTableView.dataSource = self;
//    [fontStileView addSubview:StileIconTableView];
//    
//    
//    UIButton* okStileButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 150, fontStileView.frame.size.width, 50)];
//    okStileButton.backgroundColor = [UIColor whiteColor];
//    [okStileButton addTarget:self action:@selector(okStileButton) forControlEvents:UIControlEventTouchUpInside];
//    [okStileButton setTitle:@"OK" forState:UIControlStateNormal];
//    [okStileButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [fontStileView addSubview:okStileButton];
//}


-(void)okStileButton
{
    [fontStileView removeFromSuperview];
    [backgroundView removeFromSuperview];
}






/////////////////////////


- (IBAction)openAndCloseLeftMenu:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void)
     {
         CGPoint point;
         if (flag==0)
             point.x=(CGFloat)leftMenu.frame.size.width/2;
         else
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         point.y=leftMenu.center.y;
         leftMenu.center=point;
         
     }
                     completion:^(BOOL finished)
     {
         
         if (flag==0)
         {
             flag=1;
             self.scrolView.userInteractionEnabled=NO;
          
         }
         else
         {
             flag=0;
             self.scrolView.userInteractionEnabled=YES;
         }
     }
     ];
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if (flag==0 && touchLocation.x>((float)1/16 *self.view.frame.size.width))
        return;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void)
     {
         CGPoint point;
         NSLog(@"\n%f", 2*leftMenu.center.x);
         NSLog(@"\n%f",leftMenu.frame.size.width/2);
         if (touchLocation.x<=leftMenu.frame.size.width/2)
         {
             flag=0;
             self.scrolView.userInteractionEnabled=YES;
           
             
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             self.scrolView.userInteractionEnabled=NO;
            
             flag=1;
         }
         point.y=leftMenu.center.y;
         leftMenu.center=point;
         NSLog(@"\n%f",leftMenu.frame.size.width);
         
     }
                     completion:nil
     ];

}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if (flag==0 && touchLocation.x>((float)1/16 *self.view.frame.size.width))
        return;
    CGPoint point;
    point.x= touchLocation.x- (CGFloat)leftMenu.frame.size.width/2;
    point.y=leftMenu.center.y;
    if (point.x>leftMenu.frame.size.width/2)
    {
        return;
    }
    leftMenu.center=point;
    self.scrolView.userInteractionEnabled=NO;
    flag=1;
}











@end
