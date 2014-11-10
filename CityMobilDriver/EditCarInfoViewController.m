//
//  EditCarInfoViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "EditCarInfoViewController.h"

@interface EditCarInfoViewController ()
{
    UIView* backgroundView;
    UITableView* markTableView;
    UITableView* modelTableView;
    UITableView* colorTableView;
    ResponseGetModelList* modelResponseObject;
    ResponseGetMarkList* getMarkResponseObject;
    ResponseGetColorList* getColorListObject;
    
    UIImagePickerController* imagePicker;
    
    UITextField* activeTextFeild;
    
    UIAlertView* sucsedAlert;
    
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
    
    
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer* tapBegan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchRecognizer)];
    [self.backgroundView addGestureRecognizer:tapBegan];
    
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(actionHandleTapOnCreateImageView)];
    [singleTap setNumberOfTapsRequired:1];
    self.carImageView.userInteractionEnabled = YES;
    [self.carImageView addGestureRecognizer:singleTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requestGetMarkInfo];
    [self requestGetColorList];
    //NSLog(@"%@",NSStringFromCGRect(self.view.frame));
}

-(void)requestGetColorList
{
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
    request.timeoutInterval = 10;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"NO INTERNET CONECTION"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            
            [alert show];
            return ;
        }
        
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        NSError* err;
        
        getColorListObject = [[ResponseGetColorList alloc] initWithString:jsonString error:&err];
        [self.color setTitle:[getColorListObject.colors[0] getColor] forState:UIControlStateNormal];
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
    request.timeoutInterval = 10;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"NO INTERNET CONECTION"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            
            [alert show];
            [indicator stopAnimating];
            return ;
        }
        
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        NSError* err;
        
        getMarkResponseObject = [[ResponseGetMarkList alloc] initWithString:jsonString error:&err];
        [self.mark setTitle:[getMarkResponseObject.marks[0] mark] forState:UIControlStateNormal];
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
    request.timeoutInterval = 10;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"NO INTERNET CONECTION"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return ;
        }
        
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        NSError*err;
        
        modelResponseObject = [[ResponseGetModelList alloc] initWithString:jsonString error:&err];
        
        if ([modelResponseObject.models count]) {
            [self.model setTitle:[modelResponseObject.models[0] model] forState:UIControlStateNormal];
        }
        else{
            [self.model setTitle:@"" forState:UIControlStateNormal];
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
        //[self.navigationController pushViewController:profilViewController animated:NO];
        [self pushOrPopViewController:profilViewController];
    }
    if (sender.selectedSegmentIndex == 1)
    {
//        CarInfoViewController* createProfilController=[self.storyboard instantiateViewControllerWithIdentifier:@"CarInfoViewController"];
//        [self.navigationController pushViewController:createProfilController animated:NO];
    }
}




- (IBAction)markAction:(id)sender
{
    backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundView.alpha = 0.5;
    backgroundView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:backgroundView];

    
    markTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.height - 40)];
    markTableView.delegate = self;
    markTableView.dataSource = self;
    [self.view addSubview:markTableView];
}


- (IBAction)modelAction:(id)sender
{
    if ([modelResponseObject.models count]) {
        backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
        backgroundView.alpha = 0.5;
        backgroundView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:backgroundView];
        
        
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
    backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundView.alpha = 0.5;
    backgroundView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:backgroundView];
    
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
        [backgroundView removeFromSuperview];
        [self.mark setTitle:[getMarkResponseObject.marks[indexPath.row] mark] forState:UIControlStateNormal];
        [self requestGetModelInfo:[getMarkResponseObject.marks[indexPath.row] getId]];
        //[modelTableView reloadData];
    }
    
    if (tableView == modelTableView) {
        [modelTableView removeFromSuperview];
        [backgroundView removeFromSuperview];
        [self.model setTitle:[modelResponseObject.models[indexPath.row] model] forState:UIControlStateNormal];
    }
    
    if (tableView == colorTableView) {
        [colorTableView removeFromSuperview];
        [backgroundView removeFromSuperview];
        [self.color setTitle:[getColorListObject.colors[indexPath.row] getColor] forState:UIControlStateNormal];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.year) {
        [self.gosNumber becomeFirstResponder];
    }
    if (textField == self.gosNumber) {
        [self.vinCode becomeFirstResponder];
    }
    if (textField == self.vinCode) {
        [self.firstLicense becomeFirstResponder];
    }
    if (textField == self.firstLicense) {
        [self.lastLicense becomeFirstResponder];
    }
    if (textField == self.lastLicense) {
        [self.lastLicense resignFirstResponder];
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
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeTextFeild.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeTextFeild.frame animated:YES];
    }
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


-(void)touchRecognizer
{
    [activeTextFeild resignFirstResponder];
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
    request.timeoutInterval = 10;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        if (data)
        {
            NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSError* err;
            ResponseSetCarInfo* jsonResponseObject = [[ResponseSetCarInfo alloc]initWithString:jsonString error:&err];
            
            sucsedAlert = [[UIAlertView alloc]initWithTitle:nil message:jsonResponseObject.msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [sucsedAlert show];
        }
        
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"NO INTERNET CONECTION" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
        
    }];
}



-(void)RequestSetCarInfoWidthPhoto
{
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
    request.timeoutInterval = 10;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        if (data)
        {
            NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSError* err;
            ResponseSetCarInfo* jsonResponseObject = [[ResponseSetCarInfo alloc]initWithString:jsonString error:&err];
            
            sucsedAlert = [[UIAlertView alloc]initWithTitle:nil message:jsonResponseObject.msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [sucsedAlert show];
        }
        
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"NO INTERNET CONECTION" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
        
    }];
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == sucsedAlert) {
        CarInfoViewController* carInfoController=[self.storyboard instantiateViewControllerWithIdentifier:@"CarInfoViewController"];
        [self pushOrPopViewController:carInfoController];
    }
}




@end
