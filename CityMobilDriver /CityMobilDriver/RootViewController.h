

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "UIAlertView+Orientation.h"
#import "MessagesViewController.h"
@interface RootViewController : UIViewController <UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *callToDispetcher;
@property (weak, nonatomic) IBOutlet UIButton *messagesButton;
@property (weak, nonatomic) IBOutlet UIImageView *callToDispetcherImageView;
@property (weak, nonatomic) IBOutlet UIImageView *messagesImageView;
@property (weak, nonatomic) IBOutlet UILabel *callToDispetcherLabel;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *gpsButtonPort;
@property (strong, nonatomic) IBOutlet UIButton *yandexButtonPort;
@property (nonatomic,weak) IBOutlet UIButton* cityButtonPort;
- (IBAction)refreshPage:(id)sender;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UILabel *labelForDesign;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelPort;
- (IBAction)actionGetMessages:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelMessages;
- (IBAction)actionCallDispetcher:(id)sender;
-(void)setSelectedRow;
- (IBAction)openMap:(UIButton*)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableViewOrdersPort;
@property (strong, nonatomic) IBOutlet UILabel *labelEmptyArray;
-(void)refreshAction;
@end

