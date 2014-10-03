

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "LeftViewCellObject.h"

@interface RootViewController : UIViewController <UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *navigationView;


- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;




@end

