

#import "RootViewController.h"
#import "CustomCell.h"
#import "CellObject.h"

#import "OrdersJson.h"
#import "OrdersResponse.h"

#import "SelectedOrdersViewController.h"

#import "RecallJson.h"
#import "RecallResponse.h"



@interface RootViewController ()
{
    NSInteger flag;
    UITableView*leftMenu;
    UISwipeGestureRecognizer*recognizerRight;
    bool dragging;
    CGFloat oldX;
    NSMutableArray*nameArray;

   
    OrdersResponse*ordersResponseObject;
    RecallResponse*recallResponseObject;
    

 


}
@end

@implementation RootViewController
-(void)viewDidAppear:(BOOL)animated
{
    [self requestGetOrders];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    leftMenu=[[UITableView alloc]initWithFrame:CGRectMake(-1*self.view.frame.size.width*(CGFloat)5/6, self.navigationView.frame.origin.y+self.navigationView.frame.size.height, self.view.frame.size.width*(CGFloat)5/6, self.view.frame.size.height-self.navigationView.frame.size.height) ];
    [self.view addSubview:leftMenu];
    
    flag=0;
    
    LoginViewController*log=[self.storyboard instantiateViewControllerWithIdentifier:@"View2"];
    [self.navigationController pushViewController:log animated:NO];
    
   
    LeftViewCellObject*obj1=[[LeftViewCellObject alloc]init];
    obj1.name=@"Harut";
    LeftViewCellObject*obj2=[[LeftViewCellObject alloc]init];
    obj2.name=@"Vazgen";
    LeftViewCellObject*obj3=[[LeftViewCellObject alloc]init];
    obj3.name=@"Karen";
    LeftViewCellObject*obj4=[[LeftViewCellObject alloc]init];
    obj4.name=@"Tarzan";
    LeftViewCellObject*obj5=[[LeftViewCellObject alloc]init];
    obj5.name=@"Armen";
    LeftViewCellObject*obj6=[[LeftViewCellObject alloc]init];
    obj6.name=@"Taron";
    LeftViewCellObject*obj7=[[LeftViewCellObject alloc]init];
    obj7.name=@"Miqael";
    LeftViewCellObject*obj8=[[LeftViewCellObject alloc]init];
    obj8.name=@"Manvel";
    
    nameArray=[[NSMutableArray alloc]initWithObjects:obj1,obj2,obj3,obj4,obj5,obj6,obj7,obj8, nil];
    
    leftMenu.delegate=self;
    leftMenu.dataSource=self;
    
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
    if(tableView ==leftMenu)
    {
        return nameArray.count;
    }
    else
    {
        return  ordersResponseObject.categories.count;
    }
   }

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
  if(tableView == leftMenu)
  {
    NSString* simpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableViewCell_%ld" , (long)indexPath.row];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (tableView == leftMenu)
    {
        cell.textLabel.text = [[nameArray objectAtIndex:indexPath.row]name];

    
    cell.backgroundColor=[UIColor blueColor];
    cell.textLabel.textColor=[UIColor whiteColor];
        tableView.backgroundColor=[UIColor blueColor];
    }
    return cell;
  }
   
  else
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
       
       NSString * currentName =[[ordersResponseObject.categories objectAtIndex:indexPath.row] getName];
       cell.label1.text=[NSString stringWithFormat:@"      %@",currentName];
       NSString * currentCount =[[ordersResponseObject.categories objectAtIndex:indexPath.row] getCount];
       cell.label2.text=[NSString stringWithFormat:@"%@",currentCount];
       return  cell;
       
    
    return  cell;
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
       SelectedOrdersViewController *selectedOrdersCont = [self.storyboard
                                             instantiateViewControllerWithIdentifier:@"SelectedOrders"];
        selectedOrdersCont.selectedFilter =[[ordersResponseObject.categories objectAtIndex:indexPath.row] getFilter];
        [self.navigationController pushViewController:selectedOrdersCont animated:YES];
        
    
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
         
         if (flag==0) flag=1;
         else flag=0;
         
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
                          point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
                      }
                     
                     else if (touchLocation.x>leftMenu.frame.size.width/2)
                     {
                         point.x=(CGFloat)leftMenu.frame.size.width/2;
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
                 
                 
           
                 
             
      
    
    
             
             
             flag=1;
             
    
    


    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Выберите действие"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Просьба перезвонить",@"Позвонить",nil];
  
    [alert show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"NO INTERNET CONECTION"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            
            [alert show];
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        NSError*err;
        recallResponseObject = [[RecallResponse alloc] initWithString:jsonString error:&err];
        
        
       if((![recallResponseObject.code isEqualToString:@"750"])&&(recallResponseObject.code!=nil))
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка запроса"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
            
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        if([recallResponseObject.result isEqual:@1])
        {
            alert.message=@"Запрос успешно отправлен!";
        }
        else if(recallResponseObject.text !=nil)
        {
            alert.message=recallResponseObject.text;
        }
        [alert show];
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
        NSLog(@"%@",jsonString);
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
