//
//  LeftMenu.m
//  CityMobilDriver
//
//  Created by Intern on 10/10/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "LeftMenu.h"
#import "MessagesViewController.h"
@implementation LeftMenu

{
    Class myClass;
    NSString*identity;
}

+(LeftMenu*)getLeftMenu:(id)curentSelf
{
    static LeftMenu* leftMenu = nil;
    
    if (leftMenu == nil)
    {
        leftMenu = [LeftMenu alloc];
        leftMenu.curentViewController=curentSelf;
        leftMenu = [leftMenu init];
    }
    leftMenu.curentViewController=curentSelf;

    [leftMenu.curentViewController.view addSubview:leftMenu];
    return leftMenu;
}

-(instancetype)init
{
    self=[super init];
          if(self)
          {
              self.frame=CGRectMake(-1*self.curentViewController.view.frame.size.width*(CGFloat)5/6, 64, self.curentViewController.view.frame.size.width*(CGFloat)5/6, self.curentViewController.view.frame.size.height-64);
            
              self.delegate=self;
              self.dataSource=self;
              self.nameArray=[[NSMutableArray alloc]initWithObjects:@"Свабодные заказы",@"Мои заказы",@"Пополнение баланса",@"Сообщение",@"Настройка робота",@"Архив заказов",@"Архив платежей",@"Тарифы СитиМобил",@"Тарифы Яндекс",@"Обозначение иконок",@"Профиль",@"Статистика",@"Настройки",@"Выход", nil];

          }
          return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

   
        return self.nameArray.count;
   
    
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
   
        
        
        NSString* simpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableViewCell_%ld" , (long)indexPath.row];
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        
        cell.textLabel.text = [self.nameArray objectAtIndex:indexPath.row];
        
    
        cell.backgroundColor=[UIColor colorWithRed:(CGFloat)111/255 green:(CGFloat)111/255 blue:(CGFloat)111/255 alpha:1];
        cell.textLabel.textColor=[UIColor blackColor];
        tableView.backgroundColor=[UIColor colorWithRed:(CGFloat)111/255 green:(CGFloat)111/255 blue:(CGFloat)111/255 alpha:1];
        
        return cell;
    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSLog(@"viewControllers:%@",self.curentViewController.navigationController.viewControllers) ;
    switch (indexPath.row) {
        case 0:
            myClass = NSClassFromString(@"RootViewController");
            identity =@"RootViewController";
            break;
        case 3:
        
            myClass = NSClassFromString(@"MessagesViewController");
            identity =@"MessagesViewController";
            break;
                    default:
            break;
    }
    [self pushOrPoptoViewContrller:myClass andIdentity:identity];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44;
}

-(void)pushOrPoptoViewContrller:(Class)aClass andIdentity:(NSString*)identityString
{
    CGPoint point;
    point.x=self.center.x-self.frame.size.width;
    point.y=self.center.y;
    self.center=point;
    if ([self.curentViewController isKindOfClass:[aClass class]])
    {
        
        [self.curentViewController viewDidAppear:NO];
        return;
    }

    BOOL isFirstloadViewController=YES;
   
    for (id controller in self.curentViewController.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[aClass class]])
        {
            
           
            [self.curentViewController.navigationController popToViewController:controller animated:NO];
            isFirstloadViewController=NO;
            break;
            
        }
    }
    if (isFirstloadViewController)
    {
         id vc=[self.curentViewController.storyboard instantiateViewControllerWithIdentifier:identityString];
        [self.curentViewController.navigationController pushViewController:vc  animated:NO];
        
    }
 
}
@end
