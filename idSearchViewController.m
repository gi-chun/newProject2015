//
//  idSearchViewController.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 21..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import "idSearchViewController.h"

#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"
#import "NavigationBarView.h"
#import "datePickerViewController.h"
#import "idResultViewController.h"

@interface idSearchViewController () <NavigationBarViewDelegate>
{
    
    
    NavigationBarView *navigationBarView;
    NSString *strYYYY;
    NSString *strInitYYY;
   
    UITextField* currentEditingTextField;
     __weak IBOutlet UITextField *idTxt;
    __weak IBOutlet UILabel *yyyyLabel;
    __weak IBOutlet UILabel *label_name;
    __weak IBOutlet UILabel *label_yyyy;
    __weak IBOutlet UIButton *btnSearh;
}
@end

@implementation idSearchViewController

- (void)didTouchPicker{
    
//    [[NSUserDefaults standardUserDefaults] setObject:dicItems[@"email"] forKey:kYYYYMMDD];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    UITextField* currentEditingTextField;
   
    strYYYY = [[NSUserDefaults standardUserDefaults] stringForKey:kYYYYMMDD];
    [yyyyLabel setText:[self returnYYYYValuePerLan:strYYYY]];

}

- (NSString*)returnYYYYValuePerLan:(NSString*)pParam{
    
    NSString *result = nil;
    NSString* yyyy;
    NSString* mm;
    NSString* dd;
    
    NSRange range = {0,4};
    yyyy = [pParam substringWithRange:range];
    NSRange range_ = {4,2};
    mm = [pParam substringWithRange:range_];
    NSRange range__ = {6,2};
    dd = [pParam substringWithRange:range__];
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    
    if([temp isEqualToString:@"ko"]){
        result = [NSString stringWithFormat:@"%@년 %@월 %@일", yyyy, mm, dd];
    }else{
        result = [NSString stringWithFormat:@"%@day %@month %@year", dd, mm, yyyy];
    }
    
    return result;
}

- (IBAction)dayButtonClick:(id)sender {
    
    datePickerViewController *myPickerController = [[datePickerViewController alloc] init];
    [myPickerController setDelegate:self];
    
    //[myPickerController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:myPickerController animated:YES completion:nil];
}

- (IBAction)saveBtnClick:(id)sender {
    
    [btnSearh setEnabled:false];
    
    if([idTxt.text length] == 0){
        
        NSString* temp;
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NAME_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NAME_CHECK_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
        }
        [idTxt becomeFirstResponder];
        
        [btnSearh setEnabled:true];
        return;
    }
    
    if([yyyyLabel.text isEqualToString:strInitYYY]){
        
        NSString* temp;
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:BIRTH_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:BIRTH_CHECK_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
        }
        [idTxt becomeFirstResponder];
        [btnSearh setEnabled:true];
        return;
    }
    
    if([yyyyLabel.text length] == 0){
        
        NSString* temp;
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:BIRTH_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:BIRTH_CHECK_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
        }
        [idTxt becomeFirstResponder];
        [btnSearh setEnabled:true];
        return;
    }

    
    UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
    [likeImageView setCenter:CGPointMake(kScreenBoundsWidth/2, kScreenBoundsHeight/2)];
    [likeImageView setImage:[UIImage imageNamed:@"loading.png"]];
    [self.view addSubview:likeImageView];
    [self.view bringSubviewToFront:likeImageView];
    
    if ([SYSTEM_VERSION intValue] > 7) {
        likeImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:3.0f
                              delay:0
             usingSpringWithDamping:0.2f
              initialSpringVelocity:6.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             likeImageView.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             [likeImageView removeFromSuperview];
                         }];
    }
    else {
        [UIView animateWithDuration:1.0f animations:^{
            [likeImageView removeFromSuperview];
        }];
    }

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *rootDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *indiv_infoDic = [NSMutableDictionary dictionary];
    
    [rootDic setObject:TASK_USR forKey:@"task"];
    [rootDic setObject:@"searchEmail" forKey:@"action"];
    [rootDic setObject:@"" forKey:@"serviceCode"];
    [rootDic setObject:@"" forKey:@"requestMessage"];
    [rootDic setObject:@"" forKey:@"responseMessage"];
    
    [indiv_infoDic setObject:strYYYY forKey:@"birth"];
    [indiv_infoDic setObject:idTxt.text forKey:@"user_nm"];
    
    [sendDic setObject:rootDic forKey:@"root_info"];
    [sendDic setObject:indiv_infoDic forKey:@"indiv_info"];//////
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:sendDic];
    NSLog(@"request json: %@", jsonString);
    
    NSDictionary *parameters = @{@"plainJSON": jsonString};
    
    [manager POST:API_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSString *responseData = (NSString*) responseObject;
        NSArray *jsonArray = (NSArray *)responseData;
        NSDictionary * dicResponse = (NSDictionary *)responseData;
        
        //warning
        NSDictionary *dicItems = [dicResponse objectForKey:@"WARNING"];
        
        if(dicItems){
            NSString* sError = dicItems[@"msg"];
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:sError delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            
            //[self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            
            dicItems = [dicResponse objectForKey:@"root_info"];
            NSString* sCount = dicItems[@"result"];
            
            if([sCount isEqualToString:@"0"]){
                [btnSearh setEnabled:true];
                
                NSString* temp;
                temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
                if([temp isEqualToString:@"ko"]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NOT_EXIT_ID_KO delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
                    [alert show];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NOT_EXIT_ID_VI delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
                [idTxt becomeFirstResponder];
                
                return;
            }
            
            dicItems = [dicResponse objectForKey:@"indiv_info"];
            NSString* sEmail = dicItems[@"email_id"];
            
            
            //to json
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *jsonString = [jsonWriter stringWithObject:jsonArray];
            NSLog(@"jsonString ==> %@", jsonString);
            
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            NSHTTPCookie *cookie;
            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
            [cookieProperties setObject:@"locale_" forKey:NSHTTPCookieName];
            [cookieProperties setObject:@"KO" forKey:NSHTTPCookieValue];
            [cookieProperties setObject:@"vntst.shinhanglobal.com" forKey:NSHTTPCookieDomain];
            [cookieProperties setObject:@"vntst.shinhanglobal.com" forKey:NSHTTPCookieOriginURL];
            [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
            [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
            // set expiration to one month from now
            [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
            cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            
            for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
                NSLog(@"%@=%@", cookie.name, cookie.value);
            }
            
//            NSString * stSearch = [NSString stringWithFormat:@"조회된 아이디는 [%@] 입니다. ", sEmail];
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:stSearch delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//            [alert show];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            idResultViewController *idResultController = [[idResultViewController alloc] init];
            [idResultController setDelegate:self];
            [idResultController setId:sEmail];
            [self.navigationController pushViewController:idResultController animated:YES];
            
            //[self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        
        [btnSearh setEnabled:true];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
//        NSString* temp;
//        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
//        if([temp isEqualToString:@"ko"]){
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Fail %@", error] delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//            [alert show];
//            
//        }else{
//            
//        }
        
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [btnSearh setEnabled:true];
        
    }];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(kScreenBoundsWidth > 320){
        if(kScreenBoundsWidth > 400){
            [self.view setBounds:CGRectMake(-kPopWindowMarginW*2, -30, self.view.bounds.size.width, self.view.bounds.size.height)];
        }else{
            [self.view setBounds:CGRectMake(-kPopWindowMarginW, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        }
        
    }
    
    [self resetNavigationBarView:1];
    [self setDelegateText];
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        [self initScreenView_ko];
    }else if([temp isEqualToString:@"vi"]){
        [self initScreenView_vi];
    }else{
        temp = @"EN";
    }
    
    idTxt.text = [[NSUserDefaults standardUserDefaults] stringForKey:kUserNm] ;
    [idTxt becomeFirstResponder];
    
}
/////
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Navigation : viewDidLoad에서 한번, viewDidAppear에서 한번 더 한다.
    //[self.navigationItem setHidesBackButton:YES];
    [self resetNavigationBarView:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - text delegate
// Automatically register fields
-(void)setDelegateText
{
    [idTxt setDelegate:self];
}
// UITextField Protocol
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentEditingTextField = textField;
}
-(void)dateSave:(id)sender
{
    self.navigationItem.rightBarButtonItem=nil;

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    currentEditingTextField = NULL;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEdit];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self textFieldValueIsValid:textField]) {
        [self endEdit];
        return YES;
    } else {
        return NO;
    }
}
// Own functions
-(void)endEdit
{
    if (currentEditingTextField) {
        [currentEditingTextField endEditing:YES];
        currentEditingTextField = NULL;
    }
}
// Override this in your subclass to handle eventual values that may prevent validation.
-(BOOL)textFieldValueIsValid:(UITextField*)textField
{
    return YES;
}

/////////////////////////////////////////////////////////////////////
//navigation
#pragma mark - CPNavigationBarView
- (void)resetNavigationBarView:(NSInteger) type
{
    [self.navigationItem setHidesBackButton:YES];
    
    for (UIView *subView in self.navigationController.navigationBar.subviews) {
        if ([subView isKindOfClass:[NavigationBarView class]]) {
            [subView removeFromSuperview];
        }
    }
    [self.navigationController.navigationBar addSubview:[self navigationBarView:1]];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}

- (NavigationBarView *)navigationBarView:(NSInteger)navigationType
{
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:IDSEARCH_TITLE_KO];
        [navigationBarView setDelegate:self];
    }else if([temp isEqualToString:@"vi"]){
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:IDSEARCH_TITLE_VI];
        [navigationBarView setDelegate:self];
    }else{
        temp = @"EN";
    }
    return navigationBarView;
}

- (void)didTouchBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
    //    if ([self.delegate respondsToSelector:@selector(didTouchBackButton)]) {
    //        [self.delegate didTouchBackButton];
    //    }
}

#pragma mark -initScreenView
-(void)initScreenView_ko{
    
    strInitYYY = @" 년 월 일";
    [yyyyLabel setText:strInitYYY];
    [self resetNavigationBarView:1];
    [label_name setText:IDSEARCH_NAME_KO];
    [label_yyyy setText:IDSEARCH_YYYY_KO];
    [btnSearh setTitle:IDSEARCH_SEARCH_KO forState:UIControlStateNormal];
    
}

-(void)initScreenView_vi{
    
    strInitYYY = @" day monty year";
    [yyyyLabel setText:strInitYYY];
    [self resetNavigationBarView:1];
    [label_name setText:IDSEARCH_NAME_VI];
    [label_yyyy setText:IDSEARCH_YYYY_VI];
    [btnSearh setTitle:IDSEARCH_SEARCH_VI forState:UIControlStateNormal];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
