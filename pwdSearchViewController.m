//
//  pwdSearchViewController.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 22..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import "pwdSearchViewController.h"

#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"
#import "NavigationBarView.h"
#import "datePickerViewController.h"

@interface pwdSearchViewController () <NavigationBarViewDelegate>
{
    NavigationBarView *navigationBarView;
    UITextField* currentEditingTextField;
    __weak IBOutlet UITextField *mailTxt;
    __weak IBOutlet UITextField *nameTxt;
    __weak IBOutlet UIButton *yearBtn;
    __weak IBOutlet UIButton *searchBtnClick;
    __weak IBOutlet UILabel *yyyymmddLabel;
    __weak IBOutlet UILabel *label_id;
    __weak IBOutlet UILabel *label_name;
    __weak IBOutlet UILabel *labelView_yyyymmdd;
}

@end

@implementation pwdSearchViewController

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)SearchClick:(id)sender {
    
    [searchBtnClick setEnabled:false ];
    
    /////////
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        if([mailTxt.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:EMAIL_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [mailTxt becomeFirstResponder];
            [searchBtnClick setEnabled:true ];
            return;
        }
        if([self NSStringIsValidEmail:mailTxt.text] == false){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:EMAIL_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [mailTxt becomeFirstResponder];
            [searchBtnClick setEnabled:true ];
            return;
        }
        
        if([nameTxt.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:ID_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [nameTxt becomeFirstResponder];
            [searchBtnClick setEnabled:true ];
            return;
        }
        
        if([yyyymmddLabel.text isEqualToString:@"yyyymmdd"]){
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:BIRTH_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [yyyymmddLabel becomeFirstResponder];
            [searchBtnClick setEnabled:true ];
            return;
        }
        
    }else if([temp isEqualToString:@"vi"]){
        if([mailTxt.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:EMAIL_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [mailTxt becomeFirstResponder];
            [searchBtnClick setEnabled:true ];
            return;
        }
        if([self NSStringIsValidEmail:mailTxt.text] == false){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:EMAIL_CHECK_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [mailTxt becomeFirstResponder];
            [searchBtnClick setEnabled:true ];
            return;
        }
        
        if([nameTxt.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:ID_CHECK_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [nameTxt becomeFirstResponder];
            [searchBtnClick setEnabled:true ];
            return;
        }
        
        if([yyyymmddLabel.text isEqualToString:@"yyyymmdd"]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:BIRTH_CHECK_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [yyyymmddLabel becomeFirstResponder];
            [searchBtnClick setEnabled:true ];
            return;
        }
        
    }else{
        
        temp = @"EN";
    }
    /////////
    
    UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
    [likeImageView setCenter:CGPointMake(kScreenBoundsWidth/2, kScreenBoundsHeight/2)];
    [likeImageView setImage:[UIImage imageNamed:@"loding.png"]];
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
    
    [rootDic setObject:@"" forKey:@"task"];
    [rootDic setObject:@"" forKey:@"action"];
    [rootDic setObject:@"M2030N" forKey:@"serviceCode"];
    [rootDic setObject:@"S_SNYM2030" forKey:@"requestMessage"];
    [rootDic setObject:@"R_SNYM2030" forKey:@"responseMessage"];
    
    [indiv_infoDic setObject:yyyymmddLabel.text forKey:@"birth"];
    [indiv_infoDic setObject:nameTxt.text forKey:@"user_nm"];
    [indiv_infoDic setObject:mailTxt.text forKey:@"email_id"];
    
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
            
            NSString * stSearch = nil;
            NSString* temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
            if([temp isEqualToString:@"ko"]){
                stSearch = [NSString stringWithFormat:SEND_PWD_MAIL_KO];
            }else{
                stSearch = [NSString stringWithFormat:SEND_PWD_MAIL_VI];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:stSearch delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }
        
        [searchBtnClick setEnabled:true ];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Fail %@", error] delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
        [alert show];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [searchBtnClick setEnabled:true ];
    }];

    
}

- (void)didTouchPicker{
    
    //    [[NSUserDefaults standardUserDefaults] setObject:dicItems[@"email"] forKey:kYYYYMMDD];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    UITextField* currentEditingTextField;
    
    [yyyymmddLabel setText:[[NSUserDefaults standardUserDefaults] stringForKey:kYYYYMMDD]];
    
}

- (IBAction)dayButtonClick:(id)sender {
    
    datePickerViewController *myPickerController = [[datePickerViewController alloc] init];
    [myPickerController setDelegate:self];
    
    //[myPickerController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:myPickerController animated:YES completion:nil];
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

    [mailTxt setKeyboardType: UIKeyboardTypeEmailAddress ];
    
    [self resetNavigationBarView:1];
    [self setDelegateText];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:kEmail]){
        mailTxt.text = [[NSUserDefaults standardUserDefaults] stringForKey:kEmail];
        
    }
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        [self initScreenView_ko];
    }else if([temp isEqualToString:@"vi"]){
        [self initScreenView_vi];
    }else{
        temp = @"EN";
    }
    
    [mailTxt becomeFirstResponder];
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - text delegate
// Automatically register fields
-(void)setDelegateText
{
    [mailTxt setDelegate:self];
    [nameTxt setDelegate:self];
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
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:PW_SEARCH_TITLE_KO];
        [navigationBarView setDelegate:self];
    }else if([temp isEqualToString:@"vi"]){
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:PW_SEARCH_TITLE_VI];
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
    
    [self resetNavigationBarView:1];
    
    [label_id setText:PW_SEARCH_ID_KO];
    [label_name setText:PW_SEARCH_NAME_KO];
    [labelView_yyyymmdd setText:PW_SEARCH_YYYY_KO];
    [searchBtnClick setTitle:PW_SEARCH_KO forState:UIControlStateNormal];
    
}

-(void)initScreenView_vi{
    
    [self resetNavigationBarView:1];
    
    [label_id setText:PW_SEARCH_ID_VI];
    [label_name setText:PW_SEARCH_NAME_VI];
    [labelView_yyyymmdd setText:PW_SEARCH_YYYY_VI];
    [searchBtnClick setTitle:PW_SEARCH_VI forState:UIControlStateNormal];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
