//
//  EditCarInfoViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "EditCarInfoViewController.h"
#import "OpenMapButtonHandler.h"
#import "CardsViewController.h"

@interface EditCarInfoViewController ()
{
    UIView* backgroundView1;
    UITableView* markTableView;
    UITableView* modelTableView;
    UITableView* colorTableView;
    ResponseGetModelList* modelResponseObject;
    ResponseGetMarkList* getMarkResponseObject;
    ResponseGetColorList* getColorListObject;
    
    UIImagePickerController* imagePicker;
    
    UITextField* activeTextFeild;
    
    UIAlertView* sucsedAlert;
    
    
    LeftMenu*leftMenu;
    
    CAGradientLayer* gradientLayer1;
    CAGradientLayer* gradientLayer2;
    OpenMapButtonHandler*openMapButtonHandlerObject;

}
@end


@implementation EditCarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.segmentControll.selectedSegmentIndex = 1;
    
    self.year.returnKeyType = UIReturnKeyNext;
    self.gosNumber.returnKeyType = UIReturnKeyNext;
    self.vinCode.returnKeyType = UIReturnKeyNext;
    self.firstLicense.returnKeyType = UIReturnKeyNext;
    self.lastLicense.returnKeyType = UIReturnKeyDone;

    
    self.year.delegate = self;
    self.gosNumber.delegate = self;
    self.vinCode.delegate = self;
    self.firstLicense.delegate = self;
    self.lastLicense.delegate = self;
    
    
    
    UITapGestureRecognizer* tapBegan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchRecognizer)];
    [self.backgroundView addGestureRecognizer:tapBegan];
    
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(actionHandleTapOnCreateImageView)];
    [singleTap setNumberOfTapsRequired:1];
    self.carImageView.userInteractionEnabled = YES;
    [self.carImageView addGestureRecognizer:singleTap];
    
    [self registerForKeyboardNotifications];
    
    

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   [self.gpsButton setNeedsDisplay];
    [self requestGetMarkInfo];
    [self requestGetColorList];
    
     [GPSConection showGPSConection:self];
    leftMenu=[LeftMenu getLeftMenu:self];
    self.scrollView.userInteractionEnabled=YES;
    self.segmentControll.userInteractionEnabled=YES;
    self.scrollView.userInteractionEnabled=YES;
    
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];
    
    
    gradientLayer1 = [self greyGradient:self.backgroundView widthFrame:CGRectMake(0, 0, CGRectGetWidth(self.backgroundView.frame), CGRectGetHeight(self.backgroundView.frame)*45.f/310)];
    [self.backgroundView.layer insertSublayer:gradientLayer1 atIndex:0];
    
    
    
//    NSRange range;
//    range.location = 0;
//    range.length = 2;
//   
//    NSMutableString* str = [[NSMutableString alloc]initWithString:self.modelString];
//    if (str.length > 0) {
//        [str deleteCharactersInRange:range];
//    }
    [self.model setTitle:self.modelString forState:UIControlStateNormal];

    [self.color setTitle:self.colorString forState:UIControlStateNormal];

    [self.mark setTitle:self.markString forState:UIControlStateNormal];
    
    
    
    
    self.year.text = self.yearString;
    self.gosNumber.text = self.gosNumberString;
    self.vinCode.text = self.vinCodeString;
    self.firstLicense.text = self.firstLicenseString;
    self.lastLicense.text = self.lastLicenseString;
    
    
    [self.model setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.color setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.mark setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    
    
    self.year.textColor = [UIColor lightGrayColor];
    self.gosNumber.textColor = [UIColor lightGrayColor];
    self.vinCode.textColor = [UIColor lightGrayColor];
    self.firstLicense.textColor = [UIColor lightGrayColor];
    self.lastLicense.textColor = [UIColor lightGrayColor];
    
}

-(void)requestGetColorList
{
    
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    RequestGetColorList* jsonObject=[[RequestGetColorList alloc]init];
    jsonObject.key = [SingleDataProvider sharedKey].key;
    
    NSDictionary* jsonDictionary=[jsonObject toDictionary];
    NSString*jsons=[jsonObject toJSONString];
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
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
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
        NSLog(@"%@",jsonString);
        NSError* err;
        
        getColorListObject = [[ResponseGetColorList alloc] initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:getColorListObject.text code:getColorListObject.code];
        
        if (self.color.titleLabel.text.length == 0) {
            [self.color setTitle:[getColorListObject.colors[0] getColor] forState:UIControlStateNormal];
        }
        
        [indicator stopAnimating];

    }];
    
}


-(void)requestGetMarkInfo
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    RequestGetMarkList* jsonObject=[[RequestGetMarkList alloc]init];
    jsonObject.key = [SingleDataProvider sharedKey].key;
    
    NSDictionary* jsonDictionary=[jsonObject toDictionary];
    NSString*jsons=[jsonObject toJSONString];
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
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
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
        NSLog(@"%@",jsonString);
        NSError* err;
        
        getMarkResponseObject = [[ResponseGetMarkList alloc] initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:getMarkResponseObject.text code:getMarkResponseObject.code];
        
        if (self.mark.titleLabel.text.length == 0) {
            [self.mark setTitle:[getMarkResponseObject.marks[0] mark] forState:UIControlStateNormal];
        }
        
        
        [indicator stopAnimating];
        [self requestGetModelInfo:[getMarkResponseObject.marks[0] getId]];
    }];
    
}


-(void)requestGetModelInfo:(NSInteger)idMarkNumber
{
    RequestGetModelList* jsonObject=[[RequestGetModelList alloc]init];
    jsonObject.key = [SingleDataProvider sharedKey].key;
    jsonObject.id_mark = idMarkNumber;
    
    NSDictionary* jsonDictionary=[jsonObject toDictionary];
    NSString*jsons=[jsonObject toJSONString];
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
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            return ;
        }
        
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        NSError*err;
        
        modelResponseObject = [[ResponseGetModelList alloc] initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:modelResponseObject.text code:modelResponseObject.code];
        
        if ([modelResponseObject.models count] && self.model.titleLabel.text.length == 0) {
            [self.model setTitle:[modelResponseObject.models[0] model] forState:UIControlStateNormal];
        }
    }];
    
}

-(void)pushOrPopViewController:(UIViewController*)controller
{
    NSArray *viewControlles = self.navigationController.viewControllers;
    
    for (UIViewController* currentController in viewControlles) {
        if ([controller isKindOfClass:currentController.class]) {
            [self.navigationController popToViewController:currentController animated:NO];
            return;
        }
    }
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)segmentControllAction:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        ProfilViewController* profilViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfilViewController"];
        [self pushOrPopViewController:profilViewController];
    }
    if (sender.selectedSegmentIndex == 1)
    {
    }
    if (sender.selectedSegmentIndex == 2) {
        CardsViewController* carInfoController=[self.storyboard instantiateViewControllerWithIdentifier:@"CardsViewController"];
        [self pushOrPopViewController:carInfoController];
    }
}


- (IBAction)markAction:(id)sender
{
    backgroundView1 = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundView1.alpha = 0.5;
    backgroundView1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:backgroundView1];

    
    markTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.height - 40)];
    markTableView.delegate = self;
    markTableView.dataSource = self;
    [self.view addSubview:markTableView];
}


- (IBAction)modelAction:(id)sender
{
    if ([modelResponseObject.models count]) {
        backgroundView1 = [[UIView alloc]initWithFrame:self.view.frame];
        backgroundView1.alpha = 0.5;
        backgroundView1.backgroundColor = [UIColor grayColor];
        [self.view addSubview:backgroundView1];
        
        
        if ([modelResponseObject.models count] * 40 >= self.view.frame.size.height - 40) {
            modelTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.height - 40)];
        }
        else{
            CGRect tableRect;
            tableRect.origin = self.view.center;
            modelTableView = [[UITableView alloc]init];
            
            modelTableView.frame = CGRectMake(20, (self.view.frame.size.height - 40 * [modelResponseObject.models count])/2, self.view.frame.size.width - 40, 40 * [modelResponseObject.models count]);
            modelTableView.scrollEnabled = NO;
        }
        
        
        modelTableView.delegate = self;
        modelTableView.dataSource = self;
        [self.view addSubview:modelTableView];
    }
}

- (IBAction)colorAction:(id)sender {
    backgroundView1 = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundView1.alpha = 0.5;
    backgroundView1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:backgroundView1];
    
    colorTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.height - 40)];
    
    colorTableView.delegate = self;
    colorTableView.dataSource = self;
    [self.view addSubview:colorTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == markTableView)
    {
        return [getMarkResponseObject.marks count];
    }
    
    if (tableView == modelTableView) {
        return [modelResponseObject.models count];
    }
    if (tableView == colorTableView) {
        return [getColorListObject.colors count];
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == markTableView)
    {
        UITableViewCell* cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = [getMarkResponseObject.marks[indexPath.row] mark];
        return cell;
    }
    
    if (tableView == modelTableView) {
        UITableViewCell* cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = [modelResponseObject.models[indexPath.row] model];
        return cell;
    }
    if (tableView == colorTableView) {
        UITableViewCell* cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = [getColorListObject.colors[indexPath.row] getColor];
        return cell;
    }
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == markTableView) {
        [markTableView removeFromSuperview];
        [backgroundView1 removeFromSuperview];
        [self.mark setTitle:[getMarkResponseObject.marks[indexPath.row] mark] forState:UIControlStateNormal];
        [self requestGetModelInfo:[getMarkResponseObject.marks[indexPath.row] getId]];
        //[modelTableView reloadData];
    }
    
    if (tableView == modelTableView) {
        [modelTableView removeFromSuperview];
        [backgroundView1 removeFromSuperview];
        [self.model setTitle:[modelResponseObject.models[indexPath.row] model] forState:UIControlStateNormal];
    }
    
    if (tableView == colorTableView) {
        [colorTableView removeFromSuperview];
        [backgroundView1 removeFromSuperview];
        [self.color setTitle:[getColorListObject.colors[indexPath.row] getColor] forState:UIControlStateNormal];
    }
}



-(void)touchRecognizer{
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    
    [activeTextFeild resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == self.year) {
        [self.gosNumber becomeFirstResponder];
//        activeTextFeild = self.gosNumber;
    }
    if (textField == self.gosNumber) {
        [self.vinCode becomeFirstResponder];
//        [self.scrollView scrollRectToVisible:self.vinCode.frame animated:NO];
//        activeTextFeild = self.vinCode;
    }
    if (textField == self.vinCode) {
        [self.firstLicense becomeFirstResponder];
//        [self.scrollView scrollRectToVisible:self.firstLicense.frame animated:NO];
//        activeTextFeild = self.firstLicense;
    }
    if (textField == self.firstLicense) {
        [self.lastLicense becomeFirstResponder];
//        [self.scrollView scrollRectToVisible:self.lastLicense.frame animated:NO];
//        activeTextFeild = self.lastLicense;
    }
    if (textField == self.lastLicense) {
        [self.lastLicense resignFirstResponder];
//        [self.scrollView scrollRectToVisible:self.lastLicense.frame animated:NO];
//        activeTextFeild = self.lastLicense;
    }
    
    return YES;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + 20, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    NSLog(@"%@",NSStringFromCGRect(activeTextFeild.frame));
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}



- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    activeTextFeild = textField;
}




-(void)actionHandleTapOnCreateImageView
{
    imagePicker = [[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* img = info[UIImagePickerControllerOriginalImage];
    
    int min = MIN(img.size.height, img.size.width);
    int max = MAX(img.size.height, img.size.width);
    
    int y = (max - min) / 2;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.carImageView setImage:[self imageWithImage:info[UIImagePickerControllerOriginalImage] scaledToSize:CGRectMake(0, y, min, min)]];
    NSString *model = [[UIDevice currentDevice] model];
    if (![model isEqualToString:@"iPhone Simulator"]) {
        self.carImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    self.carImageView.layer.cornerRadius = self.carImageView.frame.size.height /2;
    self.carImageView.layer.masksToBounds = YES;
    self.carImageView.layer.borderWidth = 0;
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGRect)newRect;
{
    CGImageRef tempImage = CGImageCreateWithImageInRect([image CGImage], newRect);
    UIImage *newImage = [UIImage imageWithCGImage:tempImage];
    CGImageRelease(tempImage);
    
    return newImage;
}






- (IBAction)saveAction:(id)sender
{
    if (![self image:self.carImageView.image isEqualTo:self.carImage])
    {
        [self RequestSetCarInfoWidthPhoto];
    }
    else
    {
        [self RequestSetCarInfo];
    }
}

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

-(void)RequestSetCarInfo
{
    
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    RequestSetCarInfo* jsonObject=[[RequestSetCarInfo alloc]init];
    jsonObject.key = [SingleDataProvider sharedKey].key;
    jsonObject.VIN = self.vinCode.text;
    jsonObject.car_license_pref = self.firstLicense.text;
    jsonObject.car_license_number = self.lastLicense.text;
    jsonObject.id_mark = self.mark.currentTitle;
    jsonObject.id_model = self.model.currentTitle;
    jsonObject.reg_num = self.gosNumber.text;
    jsonObject.year = self.year.text;
    jsonObject.id_color = self.color.currentTitle;
    jsonObject.id_car = @"";
    
    NSDictionary* jsonDictionary=[jsonObject toDictionary];
    NSString*jsons=[jsonObject toJSONString];
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
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        if (data)
        {
            NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSError* err;
            ResponseSetCarInfo* jsonResponseObject = [[ResponseSetCarInfo alloc]initWithString:jsonString error:&err];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:jsonResponseObject.msg preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         CarInfoViewController* carInfoController=[self.storyboard instantiateViewControllerWithIdentifier:@"CarInfoViewController"];
                                         [self pushOrPopViewController:carInfoController];
                                     }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            [indicator stopAnimating];

        }
        
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:@"Нет соединения с интернетом!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            return ;
        }
        
    }];
}



-(void)RequestSetCarInfoWidthPhoto
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    RequestSetCarInfoWidthPhoto* jsonObject=[[RequestSetCarInfoWidthPhoto alloc]init];
    jsonObject.key = [SingleDataProvider sharedKey].key;
    jsonObject.VIN = self.vinCode.text;
    jsonObject.car_license_pref = self.firstLicense.text;
    jsonObject.car_license_number = self.lastLicense.text;
    jsonObject.id_mark = self.mark.currentTitle;
    jsonObject.id_model = self.model.currentTitle;
    jsonObject.reg_num = self.gosNumber.text;
    jsonObject.year = self.year.text;
    jsonObject.id_color = self.color.currentTitle;
    jsonObject.id_car = @"";
    NSString* imageString = [UIImagePNGRepresentation(self.carImageView.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    jsonObject.photo = imageString;
    
    
    NSDictionary* jsonDictionary=[jsonObject toDictionary];
    NSString*jsons=[jsonObject toJSONString];
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
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        if (data)
        {
            NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSError* err;
            ResponseSetCarInfo* jsonResponseObject = [[ResponseSetCarInfo alloc]initWithString:jsonString error:&err];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:jsonResponseObject.msg preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         CarInfoViewController* carInfoController=[self.storyboard instantiateViewControllerWithIdentifier:@"CarInfoViewController"];
                                        [self pushOrPopViewController:carInfoController];
                                     }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            [indicator stopAnimating];

        }
        
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:@"Нет соединения с интернетом!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            [indicator stopAnimating];
            return ;
        }
        
    }];
    
}


#pragma mark - rotation
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
             gradientLayer1.frame = CGRectMake(0, 0, CGRectGetWidth(self.backgroundView.frame), CGRectGetHeight(self.backgroundView.frame)*45.f/310);
     }
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
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
    
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
}

#pragma mark - gradient
- (CAGradientLayer*) greyGradient:(UIView*)view widthFrame:(CGRect) rect{
    UIColor *colorOne = [UIColor colorWithRed:198.f/255 green:198.f/255 blue:198.f/255 alpha:1.f];
    UIColor *colorTwo = [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1.f];
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.frame = rect;
    
    return headerLayer;
}


#pragma mark - left Menu

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
             self.scrollView.userInteractionEnabled = NO;
             self.segmentControll.userInteractionEnabled = NO;
             
             self.scrollView.tag=1;
             self.segmentControll.tag=2;
             [leftMenu.disabledViewsArray removeAllObjects];
           
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.scrollView.tag]];
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.segmentControll.tag]];
         }
         else
         {
             leftMenu.flag=0;
             self.scrollView.userInteractionEnabled = YES;
             self.segmentControll.userInteractionEnabled = YES;
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
             self.scrollView.userInteractionEnabled = YES;
             self.segmentControll.userInteractionEnabled = YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             self.scrollView.userInteractionEnabled = NO;
             self.segmentControll.userInteractionEnabled = NO;
             leftMenu.flag=1;
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
        return;
    CGPoint point;
    point.x= touchLocation.x- (CGFloat)leftMenu.frame.size.width/2;
    point.y=leftMenu.center.y;
    if (point.x>leftMenu.frame.size.width/2)
    {
        return;
    }
    leftMenu.center=point;
    self.scrollView.userInteractionEnabled = NO;
    self.segmentControll.userInteractionEnabled = NO;
    leftMenu.flag=1;
}

- (IBAction)back:(UIButton *)sender {
    if (leftMenu.flag)
    {
        CGPoint point;
        point.x=leftMenu.center.x-leftMenu.frame.size.width;
        point.y=leftMenu.center.y;
        leftMenu.center=point;
        leftMenu.flag=0;
    }
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)openMap:(UIButton*)sender
{
    openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
}



@end
