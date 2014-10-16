//
//  MessagesViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "MessagesViewController.h"
#import "MailJson.h"
#import "MailResponse.h"
@interface MessagesViewController ()
{

    UITableView*leftMenu;
    NSInteger flag;
    NSMutableArray*nameArray;

    MailResponse*mailResponseObject;
}
@end

@implementation MessagesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self RequestGetMail];
    
    leftMenu=[[UITableView alloc]initWithFrame:CGRectMake(-1*self.view.frame.size.width*(CGFloat)5/6, self.navigationView.frame.origin.y+self.navigationView.frame.size.height, self.view.frame.size.width*(CGFloat)5/6, self.view.frame.size.height-self.navigationView.frame.size.height) ];
    [self.view addSubview:leftMenu];
    self.messagesTableView.delegate = self;
    self.messagesTableView.dataSource = self;
  
 

    
    flag=0;
    
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

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView==leftMenu)
    {
        return nameArray.count;
    }
    else
    {
        return mailResponseObject.mail.count;
    }
   
   
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    if (tableView==leftMenu)
    {
       
    
    NSString* simpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableViewCell_%ld" , indexPath.row];
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
       
        
            cell.textLabel.text = [[nameArray objectAtIndex:indexPath.row]name];
            
            
            cell.backgroundColor=[UIColor blueColor];
            cell.textLabel.textColor=[UIColor whiteColor];
            tableView.backgroundColor=[UIColor blueColor];
        
        return cell;
    }
    else
    {
        NSString* simpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableViewCell_%ld" , (long)indexPath.row];
       
        MessagesCell *cell = (MessagesCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if( cell == nil )
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessagesCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        cell.titLabel.text=[[mailResponseObject.mail objectAtIndex:indexPath.row] getTitle];
        cell.dateLabel.text=[self TimeFormat:[[mailResponseObject.mail objectAtIndex:indexPath.row] getDate]];
        
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==leftMenu)
    {
    
    }
    else
    {
      
        infoViewController* infoContorller = [self.storyboard instantiateViewControllerWithIdentifier:@"info"];
        [self.navigationController pushViewController:infoContorller animated:NO];
        infoContorller.id_mail = [[mailResponseObject.mail objectAtIndex:indexPath.row] id];
        infoContorller.titleText = [[mailResponseObject.mail objectAtIndex:indexPath.row] getTitle];
        
        
        
        
    }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44;
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
             self.messagesTableView.userInteractionEnabled=NO;
         }
         else
         {
            self.messagesTableView.userInteractionEnabled=YES;
             flag=0;
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
              self.messagesTableView.userInteractionEnabled=YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             flag=1;
              self.messagesTableView.userInteractionEnabled=NO;
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
    {
        return;
    }
    CGPoint point;
    
    
    
    point.x= touchLocation.x- (CGFloat)leftMenu.frame.size.width/2;
    point.y=leftMenu.center.y;
    if (point.x>leftMenu.frame.size.width/2)
    {
        return;
    }
    leftMenu.center=point;
    
    
    
    
    
    
    
    
    
    
    flag=1;
    self.messagesTableView.userInteractionEnabled=NO;
    
    
    
    
    
    
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
-(void)RequestGetMail
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];

    
    MailJson* mailJsonObject=[[MailJson alloc]init];
   
    
    
    NSDictionary*jsonDictionary=[mailJsonObject toDictionary];
    NSString*jsons=[mailJsonObject toJSONString];
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
        NSLog(@"MessagesString%@",jsonString);
        NSError*err;
       mailResponseObject = [[MailResponse alloc] initWithString:jsonString error:&err];
       
        
        if(mailResponseObject.code!=nil)
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
        [self.messagesTableView reloadData];
    }];

}
-(NSString*)TimeFormat:(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    
    
    
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:string];
    
    /////////convert nsdata To NSString////////////////////////////////////
    [dateFormatter setDateFormat:@"dd-MM-yyy"];
    if(date==nil) return @"";
    return [dateFormatter stringFromDate:date];
    
}
@end
