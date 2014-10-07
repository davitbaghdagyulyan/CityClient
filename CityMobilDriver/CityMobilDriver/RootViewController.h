

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "LeftViewCellObject.h"
#import "MessagesViewController.h"
@interface RootViewController : UIViewController <UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *navigationView;


- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UILabel *titleLabelPort;

@property (weak, nonatomic) IBOutlet UITableView *tableViewOrdersPort;


@property (weak, nonatomic) IBOutlet UIView *helpViewPort;


@property (weak, nonatomic) IBOutlet UIButton *button1Port;


@property (weak, nonatomic) IBOutlet UIButton *button2Port;


- (IBAction)actionGetMessages:(UIButton *)sender;



@end

