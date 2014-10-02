

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "LeftViewCellObject.h"
#import "CustomCellIphone.h"

@interface RootViewController : UIViewController <UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *navigationView;







- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;



@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableViewOrdersPort;
@property (strong, nonatomic) IBOutlet UIView *helpViewPort;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;


@property (strong, nonatomic) IBOutlet UILabel *titleLabelLand;
@property (strong, nonatomic) IBOutlet UITableView *tableViewOrdersLand;
@property (strong, nonatomic) IBOutlet UIView *helpViewLand;
@property (strong, nonatomic) IBOutlet UIButton *button1Land;
@property (strong, nonatomic) IBOutlet UIButton *button2Land;



@property (strong, nonatomic) IBOutlet UILabel *titleLabelIpad;
@property (strong, nonatomic) IBOutlet UITableView *tableViewOrdersIpad;
@property (strong, nonatomic) IBOutlet UIView *helpViewIpad;
@property (strong, nonatomic) IBOutlet UIButton *button1Ipad;
@property (strong, nonatomic) IBOutlet UIButton *button2Ipad;

@end

