//
//  LeftMenu.m
//  CityMobilDriver
//
//  Created by Intern on 10/10/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "LeftMenu.h"
#import "RootViewController.h"
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
    cell.textLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
    
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
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
        case 1:
            myClass = NSClassFromString(@"MyOrdersViewController");
            identity =@"MyOrdersViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
        case 2:
            myClass = NSClassFromString(@"ReplenishmentViewController");
            identity =@"ReplenishmentViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
            
            
        case 4:
            myClass = NSClassFromString(@"RobotSettingsViewController");
            identity =@"RobotSettingsViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;


        case 5:
            myClass =NSClassFromString(@"OrdersHistoryViewController");
            identity =@"OrdersHistoryViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
            
            
            

        case 3:
        
            myClass = NSClassFromString(@"MessagesViewController");
            identity =@"MessagesViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
        case 12:
            
            myClass = NSClassFromString(@"SettingsViewController");
            identity =@"SettingsViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
            
        case 10:
            myClass = NSClassFromString(@"ProfilViewController");
            identity =@"ProfilViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
            
        case 11:
        
            myClass = NSClassFromString(@"StatisticsViewController");
            identity =@"StatisticsViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
        case 7:
            myClass = NSClassFromString(@"TariffsCityMobilViewController");
            identity =@"TariffsCityMobilViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
        case 9:
            myClass = NSClassFromString(@"DesignationIconsViewController");
            identity =@"DesignationIconsViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;

        case 13:
            exit(0); //not recommended apple
            break;
                    default:
            break;
            
            
    }
    
    
   
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
         //[(RootViewController*)self.curentViewController setSelectedRow];
        [self.curentViewController viewDidAppear:NO];
        return;
    }

    BOOL isFirstloadViewController=YES;
   
    for (id controller in self.curentViewController.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[aClass class]])
        {
            
           
            [self.curentViewController.navigationController popToViewController:controller animated:NO];
//            if ([controller isKindOfClass:[RootViewController class]])
//            {
//                [(RootViewController*)controller setSelectedRow];
//            }
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
