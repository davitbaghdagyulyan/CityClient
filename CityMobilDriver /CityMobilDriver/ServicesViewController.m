//
//  ServicesViewController.m
//  CityMobilDriver
//
//  Created by Intern on 12/4/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "ServicesViewController.h"
#import "LoginViewController.h"
#import "GetServicesResponse.h"
#import "ServicesTableCell.h"
#import "LeftMenu.h"
#import "StandartResponse.h"
#import "TachometerViewController.h"
#import "OpenMapButtonHandler.h"

@interface ServicesViewController ()
{
    GetServicesResponse* responseObject;
    
    NSMutableArray* titleArray;
    NSMutableArray* priceArray;
    NSMutableArray* idArray;
    
    NSInteger flag;
    LeftMenu*leftMenu;
    OpenMapButtonHandler*openMapButtonHandlerObject;
}
@end

@implementation ServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self request];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    flag=0;
    leftMenu=[LeftMenu getLeftMenu:self];
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];

    
}



#pragma mark - Requests
-(void)request{
    
    NSURL* url = [NSURL URLWithString:@"http://web-q.city-mobil.ru/taxiserv/yandex/tariffs_for_us2.json"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    

    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    request.timeoutInterval = 10;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:@"Нет соединения с интернетом!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        NSError* err;

        
        NSMutableString* str = [NSMutableString stringWithString:jsonString];
        
        str = [NSMutableString stringWithFormat:@"{\"responseArray\":%@}",jsonString];
        
        responseObject = [[GetServicesResponse alloc]initWithString:str error:&err];
        
        
        titleArray = [[NSMutableArray alloc]init];
        priceArray = [[NSMutableArray alloc]init];
        idArray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < responseObject.responseArray.count; ++i) {
            NSString* str = [[responseObject.responseArray[i] intervals][0] id_tariff];
            if ([str isEqualToString:self.tariff]) {
                for (int j = 0; j < [responseObject.responseArray[i] services].count; ++j) {
                    [titleArray addObject:[[responseObject.responseArray[i] services][j] title]];
                    [priceArray addObject:[[responseObject.responseArray[i] services][j] price]];
                    [idArray addObject:[[responseObject.responseArray[i] services][j] getID]];
                }
            }
        }
        [self cutStringsInArray:priceArray];
        
        self.servicesTable.delegate = self;
        self.servicesTable.dataSource = self;
        [self.servicesTable reloadData];
    }];
}


-(void) setElementsRequest{

    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    
    for (ServicesTableCell* cell in [self.servicesTable visibleCells]) {
        NSIndexPath* indexPath = [self.servicesTable indexPathForCell:cell];
        NSNumber* number = [NSNumber numberWithBool:cell.checkbox.isSelected];
        NSString* str = [number stringValue];
        [dict setObject:[NSString stringWithFormat:@"%@",str] forKey:idArray[indexPath.row]];
    }

    NSMutableDictionary* jsonDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"o3XOFR7xpv",@"ipass",
                                    @"cm-api",@"ilog",
                                    @"ru", @"locale",
                                    self.idHash,@"idhash",
                                    @"GetTaximeter",@"method",
                                    [SingleDataProvider sharedKey].key, @"key",
                                    @"1.0.2",@"version",
                                    dict,@"elements",
                                    nil];
    
    
    NSString* s = [NSString stringWithFormat:@"%@",jsonDictionary];
    NSLog(@"%@",s);
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
        NSError* err;
        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"------------======= = = == -%@",jsonString);
        StandartResponse* standatrRespons = [[StandartResponse alloc]initWithString:jsonString error:&err];

        if (!data)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:@"Нет соединения с интернетом!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                        
                                    }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    
    if (standatrRespons.code) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:standatrRespons.text
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertController dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:NO];
    }
    }];
}



#pragma mark - actions

- (IBAction)okAction:(UIButton *)sender {
    [self setElementsRequest];
    
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServicesTableCell* cell = [[NSBundle mainBundle] loadNibNamed:@"ServicesTableCell" owner:self options:nil][0];
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.priceLabel.text = priceArray[indexPath.row];
    
    cell.priceLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (int i = 0; i < self.selectedID.count; ++i) {
        if ([titleArray[indexPath.row] isEqualToString:self.selectedID[i]]) {
            [cell.checkbox setSelected:YES];
        }
    }
    

    
    
    CGRect cellRect = cell.bgView.frame;
    cellRect.size.width = CGRectGetWidth(self.view.frame)*452/547;
    CAGradientLayer* gradientLayer = [self greyGradient:cell.bgView widthFrame:cellRect];
    [cell.bgView.layer insertSublayer:gradientLayer atIndex:0];
    [cell bringSubviewToFront:cell.priceLabel];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


- (CAGradientLayer*) greyGradient:(UIView*)view widthFrame:(CGRect) rect{
    UIColor *colorOne = [UIColor colorWithRed:198.f/255 green:198.f/255 blue:198.f/255 alpha:1.f];
    UIColor *colorTwo = [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1.f];
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.frame = rect;
    
    return headerLayer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ServicesTableCell* cell = (ServicesTableCell*) [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.checkbox.isSelected) {
        [cell.checkbox setSelected:NO];
    }
    else{
        [cell.checkbox setSelected:YES];
    }
}


#pragma mark - help functions

-(void)cutStringsInArray:(NSMutableArray*)array{
    for (int i = 0; i < array.count; ++i) {
        NSString* str = array[i];
        NSRange range = [str rangeOfString:@"."];
        
        NSRange substringRange1 = range;
        substringRange1.location += 1;
        
        NSRange substringRange2 = range;
        substringRange2.location += 2;
        
        if ([[str substringWithRange:substringRange2] isEqualToString:@"0"]) {
            str = [str stringByReplacingCharactersInRange:substringRange2 withString:@""];
            [array replaceObjectAtIndex:i withObject:str];
        }
        
        if ([[str substringWithRange:substringRange1] isEqualToString:@"0"]) {
            str = [str stringByReplacingCharactersInRange:substringRange1 withString:@""];
            [array replaceObjectAtIndex:i withObject:str];
        }
        
        NSRange range1 = [str rangeOfString:@"."];
        str = [str stringByReplacingCharactersInRange:range1 withString:@""];
        [array replaceObjectAtIndex:i withObject:str];
    }
}




#pragma mark - rotation
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self.servicesTable reloadData];
         
         
         
     }
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                                     CGFloat xx;
                                     
                                     if(flag==0)
                                     {
                                         xx=self.view.frame.size.width*(CGFloat)5/6*(-1);
                                     }
                                     else
                                     {
                                         xx=0;
                                     }
                                     leftMenu.frame =CGRectMake(xx, leftMenu.frame.origin.y, self.view.frame.size.width*(CGFloat)5/6, self.view.frame.size.height-64);
                                 }];
    
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
}





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
             self.servicesTable.userInteractionEnabled = NO;
         }
         else
         {
             flag=0;
             self.servicesTable.userInteractionEnabled = YES;
         }
         
         
         [self.servicesTable reloadData];
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
             self.servicesTable.userInteractionEnabled = YES;
             
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             self.servicesTable.userInteractionEnabled = NO;
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
    
    self.servicesTable.userInteractionEnabled = NO;
    
    flag=1;
    
    
}

- (IBAction)back:(id)sender
{
    if (flag)
    {
        CGPoint point;
        point.x=leftMenu.center.x-leftMenu.frame.size.width;
        point.y=leftMenu.center.y;
        leftMenu.center=point;
    }
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (IBAction)openMap:(UIButton*)sender
{
    openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
}


@end
