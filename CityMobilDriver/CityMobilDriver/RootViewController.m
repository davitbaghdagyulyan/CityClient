

#import "RootViewController.h"
#import "CustomCell.h"
#import "OrdersJson.h"
#import "OrdersResponse.h"
#import "SelectedOrdersViewController.h"
#import "SingleDataProviderForFilter.h"
#import "RecallJson.h"
#import "RecallResponse.h"
#import "LeftMenu.h"
#import "CustomAlertView.h"

@interface RootViewController ()
{
    NSInteger flag;
    LeftMenu*leftMenu;
    UISwipeGestureRecognizer*recognizerRight;
    OrdersResponse*ordersResponseObject;
    RecallResponse*recallResponseObject;
    UIAlertView *alertBack;
    UIAlertView *alert;
    UIAlertView *callDispetcherAlert;
    LoginViewController*log;
}
@end
@implementation RootViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    flag=0;
    self.tableViewOrdersPort.userInteractionEnabled=YES;
    self.tableViewOrdersLand.userInteractionEnabled=YES;
    self.tableViewIpad.userInteractionEnabled=YES;
    leftMenu=[LeftMenu getLeftMenu:self];
    [self requestGetOrders];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    LoginViewController*log=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:log animated:NO];
    //RootViewController Interface
    self.labelMessages.font =[UIFont fontWithName:@"MyriadPro-Regular" size:16];
    self.labelCallToDispetcher.font =[UIFont fontWithName:@"Roboto-Regular" size:15];
    self.titleLabelPort.font =[UIFont fontWithName:@"Roboto-Regular" size:19];
    self.labelMessagesLand.font =[UIFont fontWithName:@"MyriadPro-Regular" size:20];
    self.labelCallToDispetcherLand.font =[UIFont fontWithName:@"Roboto-Regular" size:18];
    self.titleLabelLand.font =[UIFont fontWithName:@"Roboto-Regular" size:20];
    self.labelMessagesIpad.font =[UIFont fontWithName:@"MyriadPro-Regular" size:20];
    self.labelCallToDispethcerIpad.font =[UIFont fontWithName:@"Roboto-Regular" size:18];
    self.titleLabelIpad.font =[UIFont fontWithName:@"Roboto-Regular" size:20];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return  ordersResponseObject.categories.count;
 
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *simpleTableIdentifierIphone = @"SimpleTableCellIphone";
    CustomCell * cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierIphone];
    if (cell == nil)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.label1.font =[UIFont fontWithName:@"Roboto-Regular" size:15];
    cell.label2.font =[UIFont fontWithName:@"RobotoCondensed-Regular" size:23];
    cell.label1.text=[NSString stringWithFormat:@"      %@",[[ordersResponseObject.categories objectAtIndex:indexPath.row] name]];
    NSString * currentCount =[[ordersResponseObject.categories objectAtIndex:indexPath.row] getCount];
    cell.label2.text=[NSString stringWithFormat:@"%@",currentCount];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (tableView==leftMenu)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
        {
        [SingleDataProviderForFilter sharedFilter].filter =[[ordersResponseObject.categories objectAtIndex:indexPath.row] getFilter];
        SelectedOrdersViewController *selectedOrdersCont = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectedOrders"];
        
        [self.navigationController pushViewController:selectedOrdersCont animated:YES];
        selectedOrdersCont.titleString =[[ordersResponseObject.categories objectAtIndex:indexPath.row]name];
        if (indexPath.row==0)
        {
            selectedOrdersCont.stringForSrochno =@"СРОЧНО";
        }
    else
        {
         selectedOrdersCont.stringForSrochno =@"";
         }

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
        if ([count isEqualToString:@"0"])
        {
            return 0;
        }

     return  self.view.frame.size.height/12;
    }
    
}


- (IBAction)actionYandex:(id)sender {
}

- (IBAction)actionUnknown1:(id)sender {
}

- (IBAction)actionGPS:(id)sender {
}

- (IBAction)actionUnkown2:(id)sender {
}

- (IBAction)back:(id)sender

{
   alertBack = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Подтвердите выход из приложения"
                                                   delegate:self
                                          cancelButtonTitle:@"Отмена"
                                          otherButtonTitles:@"ОК"];
    [alertBack show];
    return ;
  
    
}

- (IBAction)actionUnkown3:(id)sender {
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


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGFloat x;
    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        
        
        if(flag==0)
        {
            x=self.view.frame.size.width*(CGFloat)5/6*(-1);
        }
        else
        {
            x=0;
        }
      
        leftMenu.frame =CGRectMake(x, leftMenu.frame.origin.y, self.view.frame.size.width*(CGFloat)5/6, self.view.frame.size.height-self.navigationView.frame.size.height);

        
       
        
    }
    else if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        
        
        CGAffineTransform transformFlip = CGAffineTransformMakeRotation( 1.571 );
        callDispetcherAlert.transform = transformFlip;
        
        if(flag==0)
        {
            x=self.view.frame.size.width*(CGFloat)5/6*(-1);
        }
        else
        {
            x=0;
        }
        
        leftMenu.frame =CGRectMake(x, leftMenu.frame.origin.y, self.view.frame.size.width*(CGFloat)5/6, self.view.frame.size.height-self.navigationView.frame.size.height);
        
    }
    
    
}

- (IBAction)actionGetMessages:(UIButton *)sender

{
    MessagesViewController*mvc=[self.storyboard instantiateViewControllerWithIdentifier:@"MessagesViewController"];
    [self.navigationController pushViewController:mvc  animated:NO];
}

- (IBAction)actionCallDispetcher:(id)sender
{
   callDispetcherAlert = [[UIAlertView alloc] initWithTitle:@"Выберите действие"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Просьба перезвонить",@"Позвонить",nil];
  
  
    [callDispetcherAlert show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView ==callDispetcherAlert)
    {
        
  
    if (buttonIndex==0)
    {
        [self reCallRequest];
    }
    else
    {
        UIDevice *device = [UIDevice currentDevice];
        if ([[device model] isEqualToString:@"iPhone"] )
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:007-495-5005-050"]]];
        }
        
        
        else
        {
            UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [notPermitted show];
         
        }
    }
 }
    
else if(alertView ==  alertBack)
{
    if (buttonIndex==0)
    {
        [self requestGetOrders];
    }
   else
   {
    [[self navigationController] pushViewController:log animated:NO];
   }

}
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
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"NO INTERNET CONECTION"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            
            [alert1 show];
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        NSError*err;
        recallResponseObject = [[RecallResponse alloc] initWithString:jsonString error:&err];
        
        
       if((![recallResponseObject.code isEqualToString:@"750"])&&(recallResponseObject.code!=nil))
        {
            
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Ошибка запроса"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert1 show];
            return;
            
        }
        
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:nil
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        if([recallResponseObject.result isEqual:@1])
        {
            alert1.message=@"Запрос успешно отправлен!";
        }
        else if(recallResponseObject.text !=nil)
        {
            alert1.message=recallResponseObject.text;
        }
        [alert1 show];
    }];

}


-(void)requestGetOrders
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
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
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"First Json String %@",jsonString);
        NSError*err;
        ordersResponseObject = [[OrdersResponse alloc] initWithString:jsonString error:&err];
        
        
        if(ordersResponseObject.code!=nil)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                            message:nil
                                                        delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
            
        }
        [indicator stopAnimating];
        [self.tableViewOrdersPort reloadData];
        [self.tableViewOrdersLand reloadData];
        [self.tableViewIpad reloadData];
        //[self.tableViewOrdersIpad reloadData];
    }];
    
}



@end
