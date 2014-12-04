#import "RootViewController.h"
#import "CustomCell.h"
#import "OrdersJson.h"
#import "OrdersResponse.h"
#import "SelectedOrdersViewController.h"
#import "SingleDataProviderForFilter.h"
#import "RecallJson.h"
#import "RecallResponse.h"
#import "LeftMenu.h"


@interface RootViewController ()
{
    //ARUS
    NSInteger flag;
    NSInteger flag1;
    BOOL  timerCreated;
    BOOL alertNoConIsCreated;
    BOOL  cancelOfAlertNoConIsClicked;
    BOOL alertServErrIsCreated;
    BOOL cancelOfAlertServErrIsClicked;
    OrdersResponse*ordersResponseObject;
    LoginViewController*log;
    CAGradientLayer * gradLayerLabel1;
    CAGradientLayer * gradLayerLabel2;
    NSTimer * requestTimer;
    UILabel * label1;
    UILabel * label2;
    NSInteger selectedRow;
    //NAREK
    LeftMenu*leftMenu;
    UISwipeGestureRecognizer*recognizerRight;
    RecallResponse*recallResponseObject;
    UIAlertView *callDispetcherAlert;
   
    
}
@end
@implementation RootViewController
-(void)viewDidAppear:(BOOL)animated
{
    [self.cityButtonIpad setNeedsDisplay];
    [self.cityButtonLand setNeedsDisplay];
    [self.cityButtonPort setNeedsDisplay];
    [self.yandexButtonIpad setNeedsDisplay];
    [self.yandexButtonLand setNeedsDisplay];
    [self.yandexButtonPort setNeedsDisplay];
    [super viewDidAppear:animated];
    timerCreated =NO;
    flag=0;
    self.tableViewOrdersPort.userInteractionEnabled=YES;
    self.tableViewOrdersLand.userInteractionEnabled=YES;
    self.tableViewIpad.userInteractionEnabled=YES;
    leftMenu=[LeftMenu getLeftMenu:self];
    if (cancelOfAlertNoConIsClicked ==YES)
    {
        alertNoConIsCreated=NO;
    }
    else
    {
       alertNoConIsCreated=YES;
    }
    if (cancelOfAlertServErrIsClicked ==YES)
    {
        alertServErrIsCreated =NO;
    }
    else
    {
        alertServErrIsCreated =YES;
    }
    [self requestGetOrders];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    selectedRow = -1;
    log=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:log animated:NO];
    //RootViewController Interface
    self.labelMessages.font =[UIFont fontWithName:@"Roboto-Regular" size:16];
    self.labelCallToDispetcher.font =[UIFont fontWithName:@"Roboto-Regular" size:15];
    self.titleLabelPort.font =[UIFont fontWithName:@"Roboto-Regular" size:19];
    self.labelMessagesLand.font =[UIFont fontWithName:@"Roboto-Regular" size:20];
    self.labelCallToDispetcherLand.font =[UIFont fontWithName:@"Roboto-Regular" size:18];
    self.titleLabelLand.font =[UIFont fontWithName:@"Roboto-Regular" size:20];
    self.labelMessagesIpad.font =[UIFont fontWithName:@"Roboto-Regular" size:20];
    self.labelCallToDispethcerIpad.font =[UIFont fontWithName:@"Roboto-Regular" size:18];
    self.titleLabelIpad.font =[UIFont fontWithName:@"Roboto-Regular" size:20];
    //Controlling AlertVCS
    cancelOfAlertNoConIsClicked =YES;
    cancelOfAlertServErrIsClicked=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSelectedRow
{
    selectedRow=-1;
}


- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return ordersResponseObject.categories.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CustomCell * cell = [[CustomCell alloc]init];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    NSString * count = [[ordersResponseObject.categories objectAtIndex:indexPath.row] getCount];
    if (count && [count isEqualToString:@"0"])
    {
        cell.hidden =YES;
    }
    if (flag1 ==-1)
    {
    cell.contentView.backgroundColor =[UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
    }
    else
    {
    cell.contentView.backgroundColor=[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
    
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(CustomCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedRow ==indexPath.row)
    {
        cell.View1.backgroundColor =[UIColor  colorWithRed:255/255.0f green:139/255.0f blue:0/255.0f alpha:1.0f];
    }
    else
    {
    gradLayerLabel1 =[CAGradientLayer layer];
    UIColor * gradColStart =[UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1.0f];
    UIColor * gradColFin =[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1.0f];
    gradLayerLabel1.frame =CGRectMake(0, 0, cell.bounds.size.width*0.859, self.view.frame.size.height/12-3);
    [gradLayerLabel1 setColors:[NSArray arrayWithObjects:(id)(gradColStart.CGColor), (id)(gradColFin.CGColor),nil]];
    [cell.View1.layer insertSublayer:gradLayerLabel1 atIndex:0];
    }
    label1 =[[UILabel alloc]init];
    label1.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.View1 addSubview:label1];
    NSLayoutConstraint * label1Tral = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0];
    NSLayoutConstraint * label1Top = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeTop multiplier:1.f constant:0];
    NSLayoutConstraint * label1Lead = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
    NSLayoutConstraint * label1Butom = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.View1 attribute:NSLayoutAttributeBottom multiplier:1.f constant:0];
    [cell.View1 addConstraint:label1Tral];
    [cell.View1 addConstraint:label1Top];
    [cell.View1 addConstraint:label1Lead];
    [cell.View1 addConstraint:label1Butom];
    label1.font =[UIFont fontWithName:@"Roboto-Regular" size:16];
    label1.textColor = [UIColor blackColor];
    if ([[ordersResponseObject.categories objectAtIndex:indexPath.row] name])
    {
      label1.text =[NSString stringWithFormat:@"      %@",[[ordersResponseObject.categories objectAtIndex:indexPath.row] name]];
    }
    else
    {
    label1.text=@"";
    }
    gradLayerLabel2 =[CAGradientLayer layer];
    UIColor * gradColStartLab2 =[UIColor colorWithRed:130/255.0f green:130/255.0f blue:130/255.0f alpha:1.0f];
    UIColor * gradColFinLab2 =[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0f];
    gradLayerLabel2.frame =CGRectMake(0, 0, cell.bounds.size.width*0.141, self.view.frame.size.height/12-3);
    [gradLayerLabel2 setColors:[NSArray arrayWithObjects:(id)(gradColStartLab2.CGColor), (id)(gradColFinLab2.CGColor),nil]];
    [cell.View2.layer insertSublayer:gradLayerLabel2 atIndex:0];
    label2 =[[UILabel alloc]init];
    label2.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.View2 addSubview:label2];
    NSLayoutConstraint * label2Tral = [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.View2 attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0];
    NSLayoutConstraint * label2Top = [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.View2 attribute:NSLayoutAttributeTop multiplier:1.f constant:0];
    NSLayoutConstraint * label2Lead = [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.View2 attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
    NSLayoutConstraint * label2Butom = [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.View2 attribute:NSLayoutAttributeBottom multiplier:1.f constant:0];
    [cell.View2 addConstraint:label2Tral];
    [cell.View2 addConstraint:label2Top];
    [cell.View2 addConstraint:label2Lead];
    [cell.View2 addConstraint:label2Butom];
    label2.font =[UIFont fontWithName:@"Roboto-Regular" size:23];
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment =NSTextAlignmentCenter;
    NSString * currentCount =[[ordersResponseObject.categories objectAtIndex:indexPath.row] getCount];
    if (currentCount)
    {
    label2.text=[NSString stringWithFormat:@"%@",currentCount];
    }
    else
    {
    label2.text=@"";
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (tableView==leftMenu)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
        {
        selectedRow =indexPath.row;
        [self.tableViewOrdersPort reloadData];
        [self.tableViewOrdersLand reloadData];
        [self.tableViewIpad reloadData];
        SelectedOrdersViewController *selectedOrdersCont = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectedOrders"];
        if ([[ordersResponseObject.categories objectAtIndex:indexPath.row] getFilter])
        {
            [selectedOrdersCont setFilter:[[ordersResponseObject.categories objectAtIndex:indexPath.row] getFilter]];
        }
        else
        {
            NSLog(@"There is no filter");
        }
        [self.navigationController pushViewController:selectedOrdersCont animated:YES];
        selectedOrdersCont.titleString =[[ordersResponseObject.categories objectAtIndex:indexPath.row]name];
            
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == leftMenu)
    {
                return  44;
    }
    else
    {
     NSString * count = [[ordersResponseObject.categories objectAtIndex:indexPath.row] getCount];
     if (count && [count isEqualToString:@"0"])
     {
            return 0;
     }
     return  self.view.frame.size.height/12;
    }
    
}

- (IBAction)actionGPS:(id)sender
{
}

- (IBAction)refreshPage:(id)sender
{
    if (cancelOfAlertNoConIsClicked ==YES)
    {
        alertNoConIsCreated=NO;
    }
    else
    {
        alertNoConIsCreated=YES;
    }
    
    if (cancelOfAlertServErrIsClicked ==YES)
    {
        alertServErrIsCreated =NO;
    }
    else
    {
        alertServErrIsCreated =YES;
    }
    
    [self requestGetOrders];
}

- (IBAction)back:(id)sender

{UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Подтвердите выход из приложения" message:nil preferredStyle:UIAlertControllerStyleAlert];
UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"ОК" style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                    [[self navigationController] pushViewController:log animated:NO];
                                                              }];
UIAlertAction* cancellation = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                            [self requestGetOrders];
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                            }];
[alert addAction:cancel];
[alert addAction:cancellation];
[self presentViewController:alert animated:YES completion:nil];
}

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
             self.tableViewOrdersPort.userInteractionEnabled=NO;
             self.tableViewOrdersLand.userInteractionEnabled=NO;
             self.tableViewIpad.userInteractionEnabled=NO;
         }
         else
         {
           flag=0;
             self.tableViewOrdersPort.userInteractionEnabled=YES;
             self.tableViewOrdersLand.userInteractionEnabled=YES;
             self.tableViewIpad.userInteractionEnabled=YES;
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
                          self.tableViewOrdersPort.userInteractionEnabled=YES;
                          self.tableViewOrdersLand.userInteractionEnabled=YES;
                          self.tableViewIpad.userInteractionEnabled=YES;
                          point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
                      }
                 else if (touchLocation.x>leftMenu.frame.size.width/2)
                     {
                         point.x=(CGFloat)leftMenu.frame.size.width/2;
                        
                         self.tableViewOrdersPort.userInteractionEnabled=NO;
                         self.tableViewOrdersLand.userInteractionEnabled=NO;
                         self.tableViewIpad.userInteractionEnabled=NO;
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
    self.tableViewOrdersPort.userInteractionEnabled=NO;
    self.tableViewOrdersLand.userInteractionEnabled=NO;
    self.tableViewIpad.userInteractionEnabled=NO;
    flag=1;
    
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{

    [coordinator animateAlongsideTransition:nil
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
         
       
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
  [super viewWillTransitionToSize: size withTransitionCoordinator:coordinator];
}

- (IBAction)actionGetMessages:(UIButton *)sender

{
    MessagesViewController*mvc=[self.storyboard instantiateViewControllerWithIdentifier:@"MessagesViewController"];
    [self.navigationController pushViewController:mvc  animated:NO];
}

- (IBAction)actionCallDispetcher:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Выберите действие" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction*pleaseCallBack = [UIAlertAction actionWithTitle:@"Просьба перезвонить" style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action)
                            {
                                
                                [alert dismissViewControllerAnimated:YES completion:nil];
                                [self reCallRequest];
                                
                            }];
    [alert addAction:pleaseCallBack];
    
    
    UIAlertAction*call = [UIAlertAction actionWithTitle:@"Позвонить" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                        UIDevice *device = [UIDevice currentDevice];
                                        if ([[device model] isEqualToString:@"iPhone"] )
                                        {
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:007-495-5005-050"]]];
                                        }
                                        else
                                        {
                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Your device doesn't support this feature." preferredStyle:UIAlertControllerStyleAlert];
                                            
                                            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                          handler:^(UIAlertAction * action)
                                                                    {
                                                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                                                        
                                                                    }];
                                            [alert addAction:cancel];
                                            [self presentViewController:alert animated:YES completion:nil];
                                        }
                                        
                                    }];
    [alert addAction:call];
    
    UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action)
                            {
                                [alert dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];


}

    


-(void)reCallRequest
{
    RecallJson* recallJsonObject=[[RecallJson alloc]init];
    NSDictionary*jsonDictionary=[recallJsonObject toDictionary];
    NSString*jsons=[recallJsonObject toJSONString];
    NSLog(@"%@",jsons);
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
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:@"Нет соединения с интернетом!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
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
        NSError*err;
        recallResponseObject = [[RecallResponse alloc] initWithString:jsonString error:&err];
        if((![recallResponseObject.code isEqualToString:@"750"])&&(recallResponseObject.code!=nil))
        {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:recallResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
       
        
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    [alert1 dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
        [alert1 addAction:cancel];
        
        
        
        if([recallResponseObject.result isEqual:@1])
        {
            alert1.message=@"Запрос успешно отправлен!";
        }
        else if(recallResponseObject.text !=nil)
        {
            alert1.message=recallResponseObject.text;
        }
       [self presentViewController:alert1 animated:YES completion:nil];
    }];

}
-(void)requestGetOrders
{
    flag1=-1;
    self.view.backgroundColor = [UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
    self.tableViewIpad.backgroundColor =[UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
    self.tableViewOrdersLand.backgroundColor =[UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
    self.tableViewOrdersPort.backgroundColor =[UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
    self.titleLabelPort.backgroundColor =[UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
    self.titleLabelIpad.backgroundColor =[UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
    self.titleLabelLand.backgroundColor =[UIColor colorWithRed:93/255.0f green:93/255.0f blue:93/255.0f alpha:1.0f];
    [self.tableViewOrdersPort reloadData];
    [self.tableViewOrdersLand reloadData];
    [self.tableViewIpad reloadData];
    
    OrdersJson* ordersJsonObject=[[OrdersJson alloc]init];
    NSDictionary*jsonDictionary=[ordersJsonObject toDictionary];
    NSString*jsons=[ordersJsonObject toJSONString];
    NSLog(@"%@",jsons);
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
        if (!data && alertNoConIsCreated ==NO)
        {
           
            UIAlertController *alertNoCon = [UIAlertController alertControllerWithTitle:@ "Нет соединения с интернетом!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            alertNoConIsCreated =YES;
            cancelOfAlertNoConIsClicked =NO;
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              cancelOfAlertNoConIsClicked=YES;
                                                              [alertNoCon dismissViewControllerAnimated:YES completion:nil];
                                                          }];
            [alertNoCon addAction:cancel];
            [self presentViewController:alertNoCon animated:YES completion:nil];
        }
        else if(data)
        {
            alertNoConIsCreated =NO;
        }
        
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"First Json String %@",jsonString);
        NSError*err;
        ordersResponseObject = [[OrdersResponse alloc] initWithString:jsonString error:&err];
        if(ordersResponseObject.code!=nil && alertServErrIsCreated==NO)
        {
            UIAlertController *alertServerErr = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:ordersResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
            alertServErrIsCreated =YES;
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              cancelOfAlertServErrIsClicked = YES;
                                                              [alertServerErr dismissViewControllerAnimated:YES completion:nil];
                                                          }];
            [alertServerErr addAction:cancel];
            [self presentViewController:alertServerErr animated:YES completion:nil];
            
        }
        else if(ordersResponseObject.code==nil)
        {
            alertServErrIsCreated=NO;
        }
        flag1=1;
        if (ordersResponseObject.code==nil && data)
        {   self.view.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
            self.tableViewOrdersPort.backgroundColor=[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
            self.tableViewOrdersLand.backgroundColor=[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
            self.tableViewIpad.backgroundColor=[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
            self.titleLabelPort.backgroundColor =[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
            self.titleLabelLand.backgroundColor =[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
            self.titleLabelIpad.backgroundColor =[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
            [self.tableViewOrdersPort reloadData];
            [self.tableViewOrdersLand reloadData];
            [self.tableViewIpad reloadData];
        }
       if (timerCreated ==NO) {
            requestTimer= [NSTimer scheduledTimerWithTimeInterval:10
                                                       target:self
                                                     selector:@selector(requestGetOrders)
                                                     userInfo:nil
                                                      repeats:YES];
            timerCreated =YES;
        }
    
     
           }];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [requestTimer invalidate];
}


@end
