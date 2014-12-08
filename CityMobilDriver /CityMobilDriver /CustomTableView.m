//
//  CustomTableView.m
//  CityMobilDriver
//
//  Created by Intern on 11/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "CustomTableView.h"

@implementation CustomTableView


{
    NSDictionary*xmlDictionary;
        NSRange range;
}
-(void)setXmlDictionary:(NSDictionary*)dictionary
{
    xmlDictionary=dictionary;
    range=NSMakeRange(0,1);
}
- (NSInteger)tableView:(CustomTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger i=tableView.i;
    NSInteger j=tableView.j;
    if ([[[[[[[[[[[xmlDictionary objectForKey:@"Tariffs"] objectForKey:@"Tariff"]objectAtIndex:i] objectForKey:@"Description"]objectForKey:@"Interval"]objectAtIndex:0] objectForKey:@"Transfer"] objectForKey:@"Destination"]objectAtIndex:j] objectForKey:@"Source"] isKindOfClass:[NSArray class]])
    {
        return  [[[[[[[[[[[xmlDictionary objectForKey:@"Tariffs"] objectForKey:@"Tariff"]objectAtIndex:i] objectForKey:@"Description"]objectForKey:@"Interval"]objectAtIndex:0] objectForKey:@"Transfer"] objectForKey:@"Destination"]objectAtIndex:j] objectForKey:@"Source"] count];
    }
    else return 1;
    
    
}

- (UITableViewCell*)tableView:(CustomTableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger i=tableView.i;
    NSInteger j=tableView.j;
    
    NSString* simpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableViewCell_%ld" , (long)indexPath.row];
    TariffCustomCell *cell = (TariffCustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if( cell == nil )
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TariffCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if ([[[[[[[[[[[xmlDictionary objectForKey:@"Tariffs"] objectForKey:@"Tariff"]objectAtIndex:i] objectForKey:@"Description"]objectForKey:@"Interval"]objectAtIndex:0] objectForKey:@"Transfer"] objectForKey:@"Destination"]objectAtIndex:j] objectForKey:@"Source"] isKindOfClass:[NSArray class]])
    {
        cell.txtLabel.text=[[[[[[[[[[[[xmlDictionary objectForKey:@"Tariffs"] objectForKey:@"Tariff"]objectAtIndex:i] objectForKey:@"Description"]objectForKey:@"Interval"]objectAtIndex:0] objectForKey:@"Transfer"] objectForKey:@"Destination"]objectAtIndex:j] objectForKey:@"Source"]objectAtIndex:indexPath.row]objectForKey:@"name"];
        

        
        cell.priceLabel.text=[NSString stringWithFormat:@"%@%@",[[[[[[[[[[[[xmlDictionary objectForKey:@"Tariffs"] objectForKey:@"Tariff"]objectAtIndex:i] objectForKey:@"Description"]objectForKey:@"Interval"]objectAtIndex:0] objectForKey:@"Transfer"] objectForKey:@"Destination"]objectAtIndex:j] objectForKey:@"Source"]objectAtIndex:indexPath.row]objectForKey:@"text"],
                              [[[[[[[[[[xmlDictionary objectForKey:@"Tariffs"] objectForKey:@"Tariff"]objectAtIndex:i] objectForKey:@"Description"]objectForKey:@"Interval"]objectAtIndex:0] objectForKey:@"City"] objectForKey:@"Currency"] objectForKey:@"text"] substringWithRange:range]];
    }
    else
    {
        cell.txtLabel.text=[[[[[[[[[[[xmlDictionary objectForKey:@"Tariffs"] objectForKey:@"Tariff"]objectAtIndex:i] objectForKey:@"Description"]objectForKey:@"Interval"]objectAtIndex:0] objectForKey:@"Transfer"] objectForKey:@"Destination"]objectAtIndex:j] objectForKey:@"Source"] objectForKey:@"name"];
        
        
        
        cell.priceLabel.text=[NSString stringWithFormat:@"%@%@",[[[[[[[[[[[xmlDictionary objectForKey:@"Tariffs"] objectForKey:@"Tariff"]objectAtIndex:i] objectForKey:@"Description"]objectForKey:@"Interval"]objectAtIndex:0] objectForKey:@"Transfer"] objectForKey:@"Destination"]objectAtIndex:j] objectForKey:@"Source"] objectForKey:@"text"],
                              [[[[[[[[[[xmlDictionary objectForKey:@"Tariffs"] objectForKey:@"Tariff"]objectAtIndex:i] objectForKey:@"Description"]objectForKey:@"Interval"]objectAtIndex:0] objectForKey:@"City"] objectForKey:@"Currency"] objectForKey:@"text"] substringWithRange:range]];

       
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  15;
}

@end
