//
//  SettingsViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/10/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SettingsViewController.h"
#import "SucceedResponse.h"
#import "yandexIcon.h"
#import "IconsColorSingltone.h"

//static UIColor* buttonTextColor = nil;

static int yandexColor;
static int cityColor = -1;

@interface SettingsViewController ()
{
    NSInteger flag;
    LeftMenu*leftMenu;
    
    
    UIView* backgroundView;
    UIView* fontSizeView;
    UIView* fontStileView;
    
    UITableView* fontSizeTableView;
    UITableView* StileIconTableView;
    UITableView* selectLanguageTableView;
    
    
    NSString* fontSizeText;
    NSString* fontStileText;
    NSString* languageText;
}
@property(nonatomic,strong) UIColor* buttonTextColor;


@end

@implementation SettingsViewController




#pragma mark - lifecicle Object
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.balance.text =[self.balance.text stringByAppendingString:[UserInformationProvider sharedInformation].balance];
    self.limit.text =[self.limit.text stringByAppendingString:[UserInformationProvider sharedInformation].credit_limit];
    self.callsign.text =[self.callsign.text stringByAppendingString:[UserInformationProvider sharedInformation].bankid];
    self.buttonTextColor = self.required.titleLabel.textColor;
    
    //self.nightMode.on = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isNightMode"] boolValue];
    //NSLog(@"%i",self.nightMode.on);

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
    
    NSInteger fontNubmer = [[NSUserDefaults standardUserDefaults] integerForKey:@"fontSize"];
    
    if (fontNubmer == 0) {
        [self replaceString:self.fontSize.titleLabel widthString:@"  Мелкий"];
    }
    if (fontNubmer == 1) {
        [self replaceString:self.fontSize.titleLabel widthString:@"  Обычный"];
    }
    if (fontNubmer == 2) {
        [self replaceString:self.fontSize.titleLabel widthString:@"  Крупный"];
    }
    
    
    NSInteger styleNubmer = [[NSUserDefaults standardUserDefaults] integerForKey:@"stileIcon"];
    
    if (styleNubmer == 0) {
        [self replaceString:self.stileIcon.titleLabel widthString:@"  Радужный"];
    }
    if (styleNubmer == 1) {
        [self replaceString:self.stileIcon.titleLabel widthString:@"  Черный"];
    }
    
    
    NSInteger languageNubmer = [[NSUserDefaults standardUserDefaults] integerForKey:@"language"];
    
    if (languageNubmer == 0) {
        [self replaceString:self.selectLanguage.titleLabel widthString:@"  Русский"];
    }
    if (languageNubmer == 1) {
        [self replaceString:self.selectLanguage.titleLabel widthString:@"  English"];
    }
    
    fontSizeText = [self replaceString:self.fontSize.titleLabel.text];
    fontStileText = [self replaceString:self.stileIcon.titleLabel.text];
    languageText = [self replaceString:self.selectLanguage.titleLabel.text];
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isNightMode"] boolValue]) {
        [self.checkBox.imageView setImage:[UIImage imageNamed:@"box2.png"]];
        [self setAppMode];
    }
    
    
    
    NSLog(@"cityColor = %i",cityColor);
    if ([IconsColorSingltone sharedColor].cityMobilColor == 0) {
        [self.off setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.notRequired setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.required setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    if ([IconsColorSingltone sharedColor].cityMobilColor == 1) {
        [self.required setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.notRequired setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.off setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    if ([IconsColorSingltone sharedColor].cityMobilColor == 2) {
        [self.off setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.notRequired setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.required setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }
    
    
    if ([IconsColorSingltone sharedColor].yandexColor == 0) {
        [self.on setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.yandexOff setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    
    if ([IconsColorSingltone sharedColor].yandexColor == 1) {
        [self.on setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.yandexOff setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    
}


-(void) replaceString:(UILabel*)label widthString:(NSString*) newString{
    NSRange range = [label.text rangeOfString:@":"];
    NSString* subString = [label.text substringFromIndex:range.location + 1];
    label.text = [label.text stringByReplacingOccurrencesOfString:subString withString:newString];
}

-(NSString*) replaceString:(NSString*)string{
    NSRange range = [string rangeOfString:@":"];
    return [string substringFromIndex:range.location + 1];
}

#pragma mark - rotation Method

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
        if (([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) && self.view.frame.size.height != 768)
        {
            //NSLog(@"%@",NSStringFromCGSize(size));
            //        CGSize scrollSize = size;
            //        scrollSize.height = size.width;
            //        self.scrolView.contentSize = scrollSize;
        }
        
        if (([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait || [UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown) && self.view.frame.size.height == 480)
        {
            //            self.scrolView.contentSize = size;
        }
        
        fontSizeView.center = self.view.center;
        fontStileView.center = self.view.center;
    }
     
    completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {

    }];
    
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
}

- (IBAction)offAction:(id)sender
{
//    cityColor = 0;
    [self setAutoAssign:0];
}

- (IBAction)notRequiredAction:(id)sender
{
//    cityColor = 1;
    [self setAutoAssign:1];
}

- (IBAction)requiredAction:(id)sender
{
//    cityColor = 2;
    [self setAutoAssign:2];////???? 3
}


#pragma mark - yandex Settings
- (IBAction)onAction:(id)sender
{
    //[self.on setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    //[self.yandexOff setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
    
    
    yandexColor = 1;
    [self setYandexAutoAssign:1];
}
- (IBAction)yandexOffAction:(id)sender
{
    //[self.yandexOff setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //[self.on setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
    
    yandexColor = 0;
    [self setYandexAutoAssign:0];
}

-(void)setAutoAssign:(NSInteger)state
{
    RequestSetAutoget* RequestObject=[[RequestSetAutoget alloc]init];
    RequestObject.state = state;
    NSDictionary* jsonDictionary = [RequestObject toDictionary];
    
    NSURL* url = [NSURL URLWithString:@"https://driver-msk.city-mobil.ru/taxiserv/api/driver/"];
    
    NSError* error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    request.timeoutInterval = 10;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"NO INTERNET CONECTION"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            
            [alert show];
            return ;
        }
        
        NSError* err;
        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        SucceedResponse* responseObject = [[SucceedResponse alloc]initWithString:jsonString error:&err];
        if (responseObject.result == 1) {
            switch (state) {
                case 0:
                    [self.notRequired setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [self.required setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [self.off setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    
                    [self.cityIcon setImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
                    [IconsColorSingltone sharedColor].cityMobilColor = 0;
                    
                    break;
                    
                case 1:
                    [self.off setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [self.required setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [self.notRequired setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                    
                    [self.cityIcon setImage:[UIImage imageNamed:@"set3_orange.png"] forState:UIControlStateNormal];
                    [IconsColorSingltone sharedColor].cityMobilColor = 1;
                    break;
                case 2:
                    [self.required setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                    [self.notRequired setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [self.off setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    
                    [self.cityIcon setImage:[UIImage imageNamed:@"icon_green.png"] forState:UIControlStateNormal];
                    [IconsColorSingltone sharedColor].cityMobilColor = 2;
                    break;
                default:
                    break;
            }
        }

        
    }];
}

-(void)setYandexAutoAssign:(NSInteger)y_state
{
    RequestSetYandexAutoget* RequestObject=[[RequestSetYandexAutoget alloc]init];
    RequestObject.y_state = y_state;
    NSDictionary* jsonDictionary = [RequestObject toDictionary];
    
    NSURL* url = [NSURL URLWithString:@"https://driver-msk.city-mobil.ru/taxiserv/api/driver/"];
    
    NSError* error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString*jsons=[RequestObject toJSONString];
    NSLog(@"%@",jsons);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    request.timeoutInterval = 10;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"NO INTERNET CONECTION"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            
            [alert show];
            return ;
        }
        
        NSError* err;
        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        SucceedResponse* responseObject = [[SucceedResponse alloc]initWithString:jsonString error:&err];
        if (responseObject.result == 1) {
        switch (y_state) {
            case 0:
            {
                [self.yandexOff setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [self.on setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
                [IconsColorSingltone sharedColor].yandexColor = 0;
                [self.yandexIcon setImage:[UIImage imageNamed:@"ya@2x"] forState:UIControlStateNormal];
                break;
            }
            case 1:
            {
                [self.on setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                [self.yandexOff setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
                [IconsColorSingltone sharedColor].yandexColor = 1;
                [self.yandexIcon setImage:[UIImage imageNamed:@"ya_green.png"] forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        }
    }];
}


#pragma mark - program settings

- (IBAction)fontSize:(id)sender{
    
    backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundView.alpha = 0.5;
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:backgroundView];
    
    
    fontSizeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 250)];
    fontSizeView.center = self.view.center;
    [self.view addSubview:fontSizeView];

    
    fontSizeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, fontSizeView.frame.size.width, 250)];
    fontSizeTableView.scrollEnabled = NO;
    fontSizeTableView.delegate = self;
    fontSizeTableView.dataSource = self;
//    [fontSizeTableView setSeparatorInset:UIEdgeInsetsZero];
    [fontSizeView addSubview:fontSizeTableView];
    
    
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
    

    StileIconTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, fontStileView.frame.size.width, 200)];
    StileIconTableView.scrollEnabled = NO;
    StileIconTableView.delegate = self;
    StileIconTableView.dataSource = self;
    [fontStileView addSubview:StileIconTableView];

}


- (IBAction)selectLanguage:(id)sender{
    
    backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundView.alpha = 0.5;
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:backgroundView];
    
    
    fontStileView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 200)];
    fontStileView.center = self.view.center;
    [self.view addSubview:fontStileView];

    selectLanguageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, fontStileView.frame.size.width, 200)];
    selectLanguageTableView.scrollEnabled = NO;
    selectLanguageTableView.delegate = self;
    selectLanguageTableView.dataSource = self;
    [fontStileView addSubview:selectLanguageTableView];
}



- (IBAction)nightModeAction:(id)sender
{
    
    NSNumber* isNightMode = nil;
    if (![self.checkBox isSelected]) {
        self.backgroundImage.image = [UIImage imageNamed:@"pages_background.png"];
        self.settings.textColor = [UIColor orangeColor];
        self.yandexSettings.textColor = [UIColor orangeColor];
        isNightMode = [NSNumber numberWithBool:YES];
        [self.checkBox setSelected:YES];
    }
    else{
        self.backgroundImage.image = [UIImage imageNamed:@"notFoundImage.png"];
        self.settings.textColor = [UIColor blackColor];
        self.yandexSettings.textColor = [UIColor blackColor];
        isNightMode = [NSNumber numberWithBool:NO];
        [self.checkBox setSelected:NO];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:isNightMode forKey:@"isNightMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setAppMode
{
    if ([self image:self.checkBox.imageView.image isEqualTo:[UIImage imageNamed:@"box2.png"]])
    {
        self.backgroundImage.image = [UIImage imageNamed:@"pages_background.png"];
        self.settings.textColor = [UIColor orangeColor];
        self.yandexSettings.textColor = [UIColor orangeColor];
    }
    else
    {
        self.backgroundImage.image = [UIImage imageNamed:@"notFoundImage.png"];
        self.settings.textColor = [UIColor blackColor];
        self.yandexSettings.textColor = [UIColor blackColor];
    }
}

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    return [data1 isEqual:data2];
}


#pragma mark Table View settings

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* titleView = [[UIView alloc]init];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 310, 48)];
    if (tableView == fontSizeTableView) {
        titleLabel.text = @"   Размер шрифта";
    }
    if (tableView == StileIconTableView) {
        titleLabel.text = @"   Стиль иконок";
    }
    if (tableView == selectLanguageTableView) {
        titleLabel.text = @"   Выберите язык";
    }
    
    [titleView addSubview:titleLabel];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 48, 310, 2)];
    lineView.backgroundColor = [UIColor colorWithRed:227/255 green:227/255 blue:229/255 alpha:0.1];
    [titleView addSubview:lineView];
    
    
    return titleView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == fontSizeTableView)
    {
        return 5;
    }
    if (tableView == StileIconTableView || tableView == selectLanguageTableView)
    {
        return 4;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* okCell = [[UITableViewCell alloc]init];
    if (tableView == fontSizeTableView)
    {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        CustomTableViewCell* cell = [nibArray objectAtIndex:0];

        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        switch (indexPath.row)
        {
            case 0:
                cell.cellText.text = @"   Мелкий";
                break;
            case 1:
                cell.cellText.text = @"   Обычный";
                break;
            case 2:
                cell.cellText.text = @"   Крупный";
                break;
            case 3:
                okCell.textLabel.text = @"ok";
                okCell.tag = 150;
                [okCell.textLabel setTextAlignment:NSTextAlignmentCenter];
                return okCell;
                break;
            default:
                break;
        }
        
        NSInteger fontNubmer = [[NSUserDefaults standardUserDefaults] integerForKey:@"fontSize"];
        
        if (fontNubmer == indexPath.row) {
            cell.selectedCell.image = [UIImage imageNamed:@"rb_2.png"];
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
                cell.cellText.text = @"   Радужный";
                break;
            case 1:
                cell.cellText.text = @"   Черный";
                break;
            case 2:
                okCell.textLabel.text = @"ok";
                okCell.tag = 151;
                [okCell.textLabel setTextAlignment:NSTextAlignmentCenter];
                return okCell;
            default:
                break;
        }
        NSInteger styleNubmer = [[NSUserDefaults standardUserDefaults] integerForKey:@"stileIcon"];
        
        if (styleNubmer == indexPath.row) {
            cell.selectedCell.image = [UIImage imageNamed:@"rb_2.png"];
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
                cell.cellText.text = @"   Русский";
                break;
            case 1:
                cell.cellText.text = @"   English";
                break;
            case 2:
                okCell.textLabel.text = @"ok";
                okCell.tag = 152;
                [okCell.textLabel setTextAlignment:NSTextAlignmentCenter];
                return okCell;
            default:
                break;
        }
        NSInteger languageNubmer = [[NSUserDefaults standardUserDefaults] integerForKey:@"language"];
        if (languageNubmer == indexPath.row) {
            cell.selectedCell.image = [UIImage imageNamed:@"rb_2.png"];
        }
        return cell;
    }
    
    
    return nil;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([fontSizeTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [fontSizeTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([fontSizeTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [fontSizeTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([StileIconTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [StileIconTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([StileIconTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [StileIconTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([fontSizeTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [fontSizeTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([selectLanguageTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [selectLanguageTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView cellForRowAtIndexPath:indexPath].tag == 150) {
        [fontSizeView removeFromSuperview];
        [backgroundView removeFromSuperview];
        
        NSString* fontText = self.fontSize.titleLabel.text;
        NSRange range = [fontText rangeOfString:@":"];
        NSString* subString = [fontText substringFromIndex:range.location + 1];
        
        fontText = [fontText stringByReplacingOccurrencesOfString:subString withString:fontSizeText];
        [self.fontSize setTitle:fontText forState:UIControlStateNormal];
        
        }
    else if ([tableView cellForRowAtIndexPath:indexPath].tag == 151) {
        [fontStileView removeFromSuperview];
        [backgroundView removeFromSuperview];
        
        
        NSString* fontText = self.stileIcon.titleLabel.text;
        NSRange range = [fontText rangeOfString:@":"];
        NSString* subString = [fontText substringFromIndex:range.location + 1];
        fontText = [fontText stringByReplacingOccurrencesOfString:subString withString:fontStileText];
        [self.stileIcon setTitle:fontText forState:UIControlStateNormal];
        
    }
    else if ([tableView cellForRowAtIndexPath:indexPath].tag == 152) {
        [fontStileView removeFromSuperview];
        [backgroundView removeFromSuperview];
        
        NSString* fontText = self.selectLanguage.titleLabel.text;
        NSRange range = [fontText rangeOfString:@":"];
        NSString* subString = [fontText substringFromIndex:range.location + 1];
        fontText = [fontText stringByReplacingOccurrencesOfString:subString withString:languageText];
        [self.selectLanguage setTitle:fontText forState:UIControlStateNormal];
    }
    
    else{
        if (tableView == fontSizeTableView)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:indexPath.row] forKey:@"fontSize"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            CustomTableViewCell* cell = (CustomTableViewCell*)[fontSizeTableView cellForRowAtIndexPath:indexPath];
            
            fontSizeText = [NSString stringWithString:cell.cellText.text];
        }
        if (tableView == StileIconTableView)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"stileIcon"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            CustomTableViewCell* cell = (CustomTableViewCell*)[StileIconTableView cellForRowAtIndexPath:indexPath];
            
            fontStileText = [NSString stringWithString:cell.cellText.text];
        }
        
        if (tableView == selectLanguageTableView)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"language"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            CustomTableViewCell* cell = (CustomTableViewCell*)[selectLanguageTableView cellForRowAtIndexPath:indexPath];
            languageText = [NSString stringWithString:cell.cellText.text];
        }
        
        
        
        CustomTableViewCell* selectedCell = (CustomTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        selectedCell.selectedCell.image = [UIImage imageNamed:@"rb_2.png"];
        for (UIView *view in tableView.subviews) {
            for (UITableViewCell* cell in view.subviews) {
                if ( [cell isKindOfClass:[CustomTableViewCell class]] && cell != selectedCell) {
                    CustomTableViewCell* celll = (CustomTableViewCell*)cell;
                    celll.selectedCell.image = [UIImage imageNamed:@"rb.png"];
                }
            }
        }
    }
    
}




/////////////////////////


#pragma mark - left Menu

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
