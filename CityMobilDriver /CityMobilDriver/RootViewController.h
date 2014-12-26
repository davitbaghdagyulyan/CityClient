

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "UIAlertView+Orientation.h"
#import "MessagesViewController.h"
@interface RootViewController : UIViewController <UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>



@property (weak, nonatomic) IBOutlet UIButton *gpsButtonPort;


@property (weak, nonatomic) IBOutlet UIButton *gpsButtonLand;

@property (weak, nonatomic) IBOutlet GPSIcon *gpsButtonIpad;


@property (strong, nonatomic) IBOutlet UIButton *yandexButtonIpad;
@property (strong, nonatomic) IBOutlet UIButton *yandexButtonLand;
@property (strong, nonatomic) IBOutlet UIButton *yandexButtonPort;


@property (nonatomic,weak) IBOutlet UIButton* cityButtonPort;
@property (strong, nonatomic) IBOutlet UIButton *cityButtonLand;
@property (strong, nonatomic) IBOutlet UIButton *cityButtonIpad;


//UI for Iphones in Portrait
@property (strong, nonatomic) IBOutlet UIView *navigationView;

- (IBAction)refreshPage:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)openAndCloseLeftMenu:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelForDesign;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelPort;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOrdersPort;
@property (weak, nonatomic) IBOutlet UIView *helpViewPort;
@property (weak, nonatomic) IBOutlet UIButton *button1Port;
- (IBAction)actionGetMessages:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelMessages;
@property (weak, nonatomic) IBOutlet UIButton *button2Port;
- (IBAction)actionCallDispetcher:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelCallToDispetcher;
//UI for Iphones in Land
@property (weak, nonatomic) IBOutlet UILabel *labelForDesignLand;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOrdersLand;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelLand;
@property (weak, nonatomic) IBOutlet UILabel *labelMessagesLand;
@property (weak, nonatomic) IBOutlet UILabel *labelCallToDispetcherLand;
//UI for Ipads
@property (weak, nonatomic) IBOutlet UITableView *tableViewIpad;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelIpad;
@property (weak, nonatomic) IBOutlet UILabel *labelMessagesIpad;
@property (weak, nonatomic) IBOutlet UILabel *labelCallToDispethcerIpad;
-(void)setSelectedRow;
- (IBAction)openMap:(UIButton*)sender;

@end

