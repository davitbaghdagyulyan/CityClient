//
//  SelectedOrdersViewController.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 10/9/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SelectedOrdersViewController.h"
#import "CustomCellSelectedOrders.h"
#import "SingleDataProvider.h"

@interface SelectedOrdersViewController ()

@end

@implementation SelectedOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestOrder];
    // Do any additional setup after loading the view.
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

    return  10;
    

}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
   
    
    NSString *simpleTableIdentifierIphone = @"SimpleTableOrdersSelected";
    
    CustomCellSelectedOrders * cell = (CustomCellSelectedOrders *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierIphone];
    if (cell == nil)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellSelectedOrders" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    
    
       return  cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
[tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  self.view.frame.size.height*146/1136;
//
}


-(void)requestOrder
{
    NSURL* url = [NSURL URLWithString:@"https://driver-msk.city-mobil.ru/taxiserv/api/driver/"];
    //    NSMutableDictionary *filter = [[NSMutableDictionary alloc] init];
    //    [filter setObject:@"all" forKey:@"type"];
    //    [filter setObject:@"0" forKey:@"group"];
    //    [filter setObject:@"0" forKey:@"district"];
    //    [filter setObject:@"0"forKey:@"my_group"];
    
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@"o3XOFR7xpv" forKey:@"ipass"];
    [dictionary setObject:@"cm-api"forKey:@"ilog"];
    [dictionary setObject:[[SingleDataProvider sharedKey]key]forKey:@"key"];
    [dictionary setObject:@"GetOrders" forKey:@"method"];
    [dictionary setObject:@"1.0.2" forKey:@"version"];
    [dictionary setObject:self.selectedFilter forKey:@"filter"];
    // NSMutableDictionary * myFilter = selectedFilter;
    
    //[NSString stringWithFormat:@"%@" , selectedFilter]
    
    NSError* error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    request.timeoutInterval = 10;
    
    
    // NSURLResponse* response = nil;
    //	NSData* data = [NSURLConnection sendSynchronousRequest:request
    //                                         returningResponse:&response
    //                                                     error:&error];
    //json=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    
    // jsonData=[NSData dataWithContentsOfURL:url];
    
    //[activityIndicator startAnimating];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //[activityIndicator stopAnimating];
        if (!data) {
            
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"NetworkError" message:@"No iNet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            return ;
        }
        NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JOSONMMMM=%@",newStr);
        
        //        if ([dictionary valueForKey:@"code"]) {
        //            NSString* code  = [dictionary valueForKey:@"code"];
        //
        //            return;
        //        }else {
        //
        //        }
        //
        
      
        // NSLog(@"I am happy");
        //obj1 =[json2 objectAtIndex:0];
        //NSLog(@"obj1=%@",obj1);
       
        
        // NSLog(@"response=%@",response);
        
        //        NSMutableArray * markes;
        //        ides =[[NSMutableArray alloc]init];
        //        marks =[[NSMutableArray alloc]init];
        //        markes = [[NSMutableArray alloc] initWithArray:[json valueForKey:@"marks"]];
        //
        //
        //
        //        for (int i=0; i<markes.count; i++)
        //        {
        //            //markes =[[json valueForKey:@"marks"]objectForKey:@"mark"];
        //            ID =[[markes objectAtIndex:i]objectForKey:@"id"];
        //            mark =[[markes objectAtIndex:i]objectForKey:@"mark"];
        //
        //            [ides addObject:ID];
        //            [marks addObject:mark];
        //
        //        }
        //
        //        [self.tableView reloadData];
        //        NSLog(@"marks = %@",mark);
        //        NSLog(@"ids= %@",ides);
        //        NSLog(@"marks = %@",marks);
        // print json:
    }];
    
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
