//
//  TariffsCityMobilViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/31/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "TariffsCityMobilViewController.h"
#import "GetTariffsUrlResponseXML.h"
#import "TariffsCustomView.h"
#import "TariffCustomCell.h"
#import "CustomTableView.h"
#import "CustomLabel.h"
#import "OpenMapButtonHandler.h"

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@interface TariffsCityMobilViewController ()
{
    UIScrollView*smallScrollView;
    LeftMenu*leftMenu;
    NSUInteger position;
    GetTariffsUrlResponse*getTariffsUrlResponseObject;
    GetTariffsUrlResponseXML*getTariffsUrlResponseXMLObject;
    CGFloat contentWidth;
    NSMutableArray*scrollViewArray;
    NSRange range;
    NSMutableArray*daytimeLabelArray;
    NSMutableArray*nightTimeLabelArray;
    NSMutableArray*CustomViewArray;
    NSMutableArray*shortLabelArray;
      NSDictionary *xmlDictionary;
    TariffsCustomView*customView;
    CustomTableView*ctvObject;
    CAGradientLayer *gradient;
    OpenMapButtonHandler*openMapButtonHandlerObject;
}
@end

@implementation TariffsCityMobilViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.gpsButton setNeedsDisplay];
     [GPSConection showGPSConection:self];
    position=0;
    self.tariffsSacrollView.delegate=self;
    for (UIScrollView* scroll in self.tariffsSacrollView.subviews)
    {
        [scroll removeFromSuperview];
    }
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];
//
    [self requestGetTariffsUrl];
   
    leftMenu=[LeftMenu getLeftMenu:self];
    contentWidth=0;
// 
    scrollViewArray=[[NSMutableArray alloc]init];
    daytimeLabelArray=[[NSMutableArray alloc]init];
    nightTimeLabelArray=[[NSMutableArray alloc]init];
    CustomViewArray=[[NSMutableArray alloc]init];
    shortLabelArray=[[NSMutableArray alloc]init];
    ctvObject=[[CustomTableView alloc] init];
     range=NSMakeRange(0,1);
    
    self.tariffsSacrollView.userInteractionEnabled=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");

}
-(void)requestGetTariffsUrl
{
    UIActivityIndicatorView*indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    GetTariffsUrlJson* getTariffsUrlJsonObject=[[GetTariffsUrlJson alloc]init];
    
    NSDictionary*jsonDictionary=[getTariffsUrlJsonObject toDictionary];
    NSString*jsons=[getTariffsUrlJsonObject toJSONString];
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
    request.timeoutInterval = 30;
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

            [indicator stopAnimating];
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JsonString:%@",jsonString);
        NSError*err;
        getTariffsUrlResponseObject = [[GetTariffsUrlResponse alloc] initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:getTariffsUrlResponseObject.text code:getTariffsUrlResponseObject.code];
        
        
//        if(getTariffsUrlResponseObject.code!=nil)
//        {
//           
//            
//            
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:getTariffsUrlResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action)
//                                    {
//                                        [alert dismissViewControllerAnimated:YES completion:nil];
//                                        
//                                    }];
//            [alert addAction:cancel];
//            [self presentViewController:alert animated:YES completion:nil];
//           
//            [indicator stopAnimating];
//            
//        }
        
        [indicator stopAnimating];
        
        NSError *error;

        NSLog(@"%@",getTariffsUrlResponseObject.yandex_tariffs_url);
        NSString* contentsString = [NSString stringWithContentsOfURL:[NSURL URLWithString:getTariffsUrlResponseObject.tariffs_url]
                                                      encoding:NSUTF8StringEncoding
                                                         error:&error];
        NSLog(@"%@",contentsString);
        NSError*parseError=nil;
       // NSData* xmlData = [contentsString dataUsingEncoding:NSUTF8StringEncoding];
        xmlDictionary =[[NSDictionary alloc]initWithDictionary:[XMLReader dictionaryForXMLString:contentsString error:&parseError]];
        [ctvObject setXmlDictionary:xmlDictionary];
        NSLog(@"%@",xmlDictionary);
        NSString* jsonStringFromXML = [[NSString alloc] initWithString:[xmlDictionary bv_jsonStringWithPrettyPrint:YES]];
        NSLog(@"%@",jsonStringFromXML);
        NSError*errorXML;
        getTariffsUrlResponseXMLObject=[[GetTariffsUrlResponseXML alloc] initWithString:jsonStringFromXML usingEncoding:NSUTF8StringEncoding error:&errorXML];
        NSLog(@"%@",errorXML);
        [self actionTariffsPageMake];
    }];
}
-(void)actionTariffsPageMake
{
    gradient = [CAGradientLayer layer];
    
    //    CGColorRef darkColor = [[self.scrollView.backgroundColor colorWithAlphaComponent:0.5] CGColor];
    //    CGColorRef lightColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.6] CGColor];
    
    gradient.frame = CGRectMake(0, 0, self.tariffsSacrollView.frame.size.width*getTariffsUrlResponseXMLObject.Tariffs.Tariff.count, self.tariffsSacrollView.frame.size.height);
    
    
    [gradient setColors:[NSArray arrayWithObjects:(id)([UIColor lightGrayColor].CGColor), (id)([UIColor whiteColor].CGColor),nil]];
    [self.tariffsSacrollView.layer addSublayer:gradient];

    
    for (int i=0; i<getTariffsUrlResponseXMLObject.Tariffs.Tariff.count; i++)
    {
      
        smallScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(5+i*self.tariffsSacrollView.frame.size.width, 60, self.tariffsSacrollView.frame.size.width-10, self.tariffsSacrollView.frame.size.height-60)];
        smallScrollView.backgroundColor=[UIColor clearColor];
        [self.tariffsSacrollView addSubview:smallScrollView];
        CGFloat contentHeight=0;
        contentWidth=contentWidth+self.tariffsSacrollView.frame.size.width;
        UILabel*shortLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        shortLabel.font=[UIFont systemFontOfSize:40];
        CGPoint point=CGPointMake(i*self.tariffsSacrollView.frame.size.width+self.tariffsSacrollView.frame.size.width/2, 30);
        shortLabel.center=point;
        shortLabel.text=[[[[getTariffsUrlResponseXMLObject.Tariffs.Tariff objectAtIndex:i]Name]text] substringWithRange:range];
        shortLabel.textAlignment=NSTextAlignmentCenter;
        [self.tariffsSacrollView addSubview:shortLabel];
        [shortLabelArray addObject:shortLabel];
        
        CustomLabel* daytimeLabel=[[CustomLabel alloc] init];
        daytimeLabel.backgroundColor=[UIColor whiteColor];
        daytimeLabel.font=[UIFont systemFontOfSize:14];
        daytimeLabel.numberOfLines = 0;
        daytimeLabel.lineBreakMode = NSLineBreakByWordWrapping;
       daytimeLabel.text=[NSString stringWithFormat:@"%@  %@ %@ %@ %@\n%@",
        [[[[[[getTariffsUrlResponseXMLObject.Tariffs.Tariff objectAtIndex:i]Description] Interval] objectAtIndex:0]name] uppercaseString],
    [[[[[[[getTariffsUrlResponseXMLObject.Tariffs.Tariff objectAtIndex:i]Description] Interval]objectAtIndex:0]City]Included]text],[[[[[[[getTariffsUrlResponseXMLObject.Tariffs.Tariff objectAtIndex:i]Description] Interval]objectAtIndex:0]City]MinPrice]text],
        [[[[[[[getTariffsUrlResponseXMLObject.Tariffs.Tariff objectAtIndex:i]Description] Interval]objectAtIndex:0]City]Currency]text],
        [[[[[[[getTariffsUrlResponseXMLObject.Tariffs.Tariff objectAtIndex:i]Description] Interval]objectAtIndex:0]City]Other]text],
        [[[[[[getTariffsUrlResponseXMLObject.Tariffs.Tariff objectAtIndex:i]Description] Interval]objectAtIndex:0]Special]text]];
       
        CGSize maximumLabelSize = CGSizeMake(smallScrollView.frame.size.width,600);
        CGSize expectSizeForLabel = [daytimeLabel sizeThatFits:maximumLabelSize];
        daytimeLabel.frame=CGRectMake(0,contentHeight,smallScrollView.frame.size.width,expectSizeForLabel.height+10);
        contentHeight=contentHeight+daytimeLabel.frame.size.height;
        [smallScrollView addSubview:daytimeLabel];
        
        [daytimeLabelArray addObject:daytimeLabel];
        
        
        CustomLabel* nightTimeLabel=[[CustomLabel alloc]init];
        nightTimeLabel.backgroundColor=[UIColor grayColor];
        nightTimeLabel.textColor=[UIColor whiteColor];
        nightTimeLabel.font=[UIFont systemFontOfSize:14];
        nightTimeLabel.numberOfLines = 0;
        nightTimeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        nightTimeLabel.text=[NSString stringWithFormat:@"%@  %@ %@ %@ %@\n%@",
                           [[[[[[getTariffsUrlResponseXMLObject.Tariffs.Tariff objectAtIndex:i]Description] Interval] objectAtIndex:1]name] uppercaseString],
                           [[[[[[[getTariffsUrlResponseXMLObject.Tariffs.Tariff objectAtIndex:i]Description] Interval]objectAtIndex:1]City]Included]text],
                             [[[[[[[getTariffsUrlResponseXMLObject.Tariffs.Tariff objectAtIndex:i]Description] Interval]objectAtIndex:1]City]MinPrice]text],
                           [[[[[[[getTariffsUrlResponseXMLObject.Tariffs.Tariff objectAtIndex:i]Description] Interval]objectAtIndex:1]City]Currency]text],
                           [[[[[[[getTariffsUrlResponseXMLObject.Tariffs.Tariff objectAtIndex:i]Description] Interval]objectAtIndex:1]City]Other]text],
                           [[[[[[getTariffsUrlResponseXMLObject.Tariffs.Tariff objectAtIndex:i]Description] Interval]objectAtIndex:1]Special]text]];

        maximumLabelSize = CGSizeMake(smallScrollView.frame.size.width,600);
        expectSizeForLabel = [nightTimeLabel sizeThatFits:maximumLabelSize];
        nightTimeLabel.frame=CGRectMake(0,contentHeight,smallScrollView.frame.size.width,expectSizeForLabel.height+10);
        contentHeight=contentHeight+nightTimeLabel.frame.size.height;
        [smallScrollView addSubview:nightTimeLabel];
        
        [nightTimeLabelArray addObject:nightTimeLabel];
       
        contentHeight=contentHeight+10;
        for (int j=0; j<[[[[[[[getTariffsUrlResponseXMLObject.Tariffs.Tariff objectAtIndex:i]Description] Interval]objectAtIndex:0]Transfer] Destination]count]; j++)
        {
           //customView=[[TariffsCustomView alloc] init];
            //if(customView==nil)
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TariffCustomView" owner:self options:nil];
            //customView = [[TariffsCustomView alloc] init];
            customView=[nib objectAtIndex:0] ;
            
    
            if ([[[[[[[[[[[xmlDictionary objectForKey:@"Tariffs"] objectForKey:@"Tariff"]objectAtIndex:i] objectForKey:@"Description"]objectForKey:@"Interval"]objectAtIndex:0] objectForKey:@"Transfer"] objectForKey:@"Destination"]objectAtIndex:j] objectForKey:@"Source"] isKindOfClass:[NSArray class]])
            {

            customView.frame = CGRectMake(0,contentHeight, smallScrollView.frame.size.width, 40+15*[[[[[[[[[[[xmlDictionary objectForKey:@"Tariffs"] objectForKey:@"Tariff"]objectAtIndex:i] objectForKey:@"Description"]objectForKey:@"Interval"]objectAtIndex:0] objectForKey:@"Transfer"] objectForKey:@"Destination"]objectAtIndex:j] objectForKey:@"Source"] count]);
            }
            else
            {
                customView.frame = CGRectMake(0,contentHeight, smallScrollView.frame.size.width, 40+15);

            }
                
            [customView updateConstraints];
            [customView.customTableView updateConstraints];
        
            customView.customLabel.text=[[[[[[[[getTariffsUrlResponseXMLObject.Tariffs.Tariff objectAtIndex:i]Description] Interval]objectAtIndex:0]Transfer] Destination]objectAtIndex:j] name];
            customView.customTableView.userInteractionEnabled=NO;
            [smallScrollView addSubview:customView];
            [CustomViewArray addObject:customView];
            //replace with tags
            customView.customTableView.delegate=(id)ctvObject;
            customView.customTableView.dataSource=(id)ctvObject;
            customView.customTableView.j=j;
            customView.customTableView.i=i;
            if (j==[[[[[[[getTariffsUrlResponseXMLObject.Tariffs.Tariff objectAtIndex:i]Description] Interval]objectAtIndex:0]Transfer] Destination]count]-1)
            {
                contentHeight=contentHeight+customView.frame.size.height;
            }
            else
            {
            contentHeight=contentHeight+customView.frame.size.height+10;
            }
        }
        smallScrollView.contentSize=CGSizeMake(smallScrollView.frame.size.width,contentHeight);
        [scrollViewArray addObject:smallScrollView];
    }
    self.tariffsSacrollView.contentSize=CGSizeMake(contentWidth, self.tariffsSacrollView.frame.size.height);

}
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    ;
    
    [coordinator animateAlongsideTransition:nil
     
                             completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
        
         
         
         [self.tariffsSacrollView setContentOffset:CGPointMake(self.tariffsSacrollView.bounds.size.width*position, 0)];
         self.lastContentOffset = self.tariffsSacrollView.contentOffset.x;
         
         gradient.frame = CGRectMake(0, 0, self.tariffsSacrollView.frame.size.width*getTariffsUrlResponseXMLObject.Tariffs.Tariff.count, self.tariffsSacrollView.frame.size.height);
         
         for (int i=0;i<scrollViewArray.count;i++)
         {
             [[scrollViewArray objectAtIndex:i]setFrame:CGRectMake(5+i*self.tariffsSacrollView.frame.size.width, 60, self.tariffsSacrollView.frame.size.width-10, self.tariffsSacrollView.frame.size.height-60)];
         }
         
         for (int i=0;i<daytimeLabelArray.count;i++)
         {
            
             UILabel*daytimeLabel=[daytimeLabelArray objectAtIndex:i];
              UIScrollView*superView=(UIScrollView*)[daytimeLabel superview];
             
             daytimeLabel.frame=CGRectMake(0,daytimeLabel.frame.origin.y,superView.frame.size.width,daytimeLabel.frame.size.height);
         }
         
         for (int i=0;i<nightTimeLabelArray.count;i++)
         {
             
             UILabel*nightTimeLabel=[nightTimeLabelArray objectAtIndex:i];
             UIScrollView*superView=(UIScrollView*)[nightTimeLabel superview];
             
             nightTimeLabel.frame=CGRectMake(0,nightTimeLabel.frame.origin.y,superView.frame.size.width,nightTimeLabel.frame.size.height);
         }
         
         for (int i=0;i<CustomViewArray.count;i++)
         {
             
             
             TariffsCustomView*cstomView=[CustomViewArray objectAtIndex:i];
             UIScrollView*superView=(UIScrollView*)[customView superview];
             
             cstomView.frame=CGRectMake(0,cstomView.frame.origin.y,superView.frame.size.width,cstomView.frame.size.height);
             [cstomView updateConstraints];
         }
         
       
         
         for (int i=0;i<shortLabelArray.count;i++)
         {
             UILabel*shortLabel=[shortLabelArray objectAtIndex:i];
             CGPoint point=CGPointMake(i*self.tariffsSacrollView.frame.size.width+self.tariffsSacrollView.frame.size.width/2, 30);
             shortLabel.center=point;
            
         }
             self.tariffsSacrollView.contentSize=CGSizeMake(self.tariffsSacrollView.frame.size.width*getTariffsUrlResponseXMLObject.Tariffs.Tariff.count, self.tariffsSacrollView.frame.size.height);
                  CGFloat xx;
         
         if(leftMenu.flag==0)
         {
             xx=self.view.frame.size.width*(CGFloat)5/6*(-1);
         }
         else
         {
             xx=0;
         }
         
         leftMenu.frame =CGRectMake(xx, leftMenu.frame.origin.y, leftMenu.frame.size.width, self.view.frame.size.height-64);
         
     }];
    
    [super viewWillTransitionToSize: size withTransitionCoordinator:coordinator];
}
- (IBAction)back:(id)sender
{
    if (leftMenu.flag)
    {
        CGPoint point;
        point.x=leftMenu.center.x-leftMenu.frame.size.width;
        point.y=leftMenu.center.y;
        leftMenu.center=point;
          leftMenu.flag=0;
    }
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}

- (IBAction)openAndCloseLeftMenu:(UIButton *)sender
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void)
     {
         CGPoint point;
         if (leftMenu.flag==0)
             point.x=(CGFloat)leftMenu.frame.size.width/2;
         else
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         point.y=leftMenu.center.y;
         leftMenu.center=point;
         
     }
                     completion:^(BOOL finished)
     {
         
         if (leftMenu.flag==0)
         {
             leftMenu.flag=1;
             self.tariffsSacrollView.userInteractionEnabled=NO;
             
             self.tariffsSacrollView.tag=1;
        
             [leftMenu.disabledViewsArray removeAllObjects];
             
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.tariffsSacrollView.tag]];
          
         }
         else
         {
             self.tariffsSacrollView.userInteractionEnabled=YES;
             leftMenu.flag=0;
         }
         
     }
     ];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if (leftMenu.flag==0 && touchLocation.x>((float)1/16 *self.view.frame.size.width))
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
             leftMenu.flag=0;
             self.tariffsSacrollView.userInteractionEnabled=YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             leftMenu.flag=1;
             self.tariffsSacrollView.userInteractionEnabled=NO;
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
    if (leftMenu.flag==0 && touchLocation.x>((float)1/16 *self.view.frame.size.width))
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
    leftMenu.flag=1;
    self.tariffsSacrollView.userInteractionEnabled=NO;
}

- (IBAction)openMap:(UIButton*)sender
{
   openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    ScrollDirection scrollDirection;
    if (self.lastContentOffset > scrollView.contentOffset.x)
    {
        scrollDirection = ScrollDirectionRight;
    
             position-=1;
 
       
       
    }
    else if (self.lastContentOffset < scrollView.contentOffset.x)
    {
        scrollDirection = ScrollDirectionLeft;
        position+=1;
    }
  
    self.lastContentOffset = scrollView.contentOffset.x;
    
    // do whatever you need to with scrollDirection here.
}


@end
