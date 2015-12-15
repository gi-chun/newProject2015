//
//  pwdChangeViewController.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 21..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import "pwdChangeViewController.h"

#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"
#import "NavigationBarView.h"

@interface pwdChangeViewController ()
{
    NavigationBarView *navigationBarView;
    UITextField* currentEditingTextField;
    
    __weak IBOutlet UITextField *oldPwdTxt;
    __weak IBOutlet UITextField *newPwdTxt;
    __weak IBOutlet UITextField *confirmTxt;
    
    __weak IBOutlet UILabel *label_oldPwd;
    __weak IBOutlet UILabel *label_newPwd;
    __weak IBOutlet UILabel *label_confirmPwd;
    
    __weak IBOutlet UIButton *btn_save;
    
}
@end

@implementation pwdChangeViewController

- (IBAction)saveClick:(id)sender {
    
    [btn_save setEnabled:false ];
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        
        if([oldPwdTxt.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:PWD_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [oldPwdTxt becomeFirstResponder];
            [btn_save setEnabled:true ];
            return;
        }
        if([newPwdTxt.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NEW_PWD_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [newPwdTxt becomeFirstResponder];
            [btn_save setEnabled:true ];
            return;
        }
        if([confirmTxt.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:PWD_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [confirmTxt becomeFirstResponder];
            [btn_save setEnabled:true ];
            return;
        }
        if( ![newPwdTxt.text isEqualToString:confirmTxt.text] ){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:PW_NO_EQUAL_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [newPwdTxt becomeFirstResponder];
            [btn_save setEnabled:true ];
            return;
        }

    }else{
        if([oldPwdTxt.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:PWD_CHECK_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [oldPwdTxt becomeFirstResponder];
            [btn_save setEnabled:true ];
            return;
        }
        if([newPwdTxt.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NEW_PWD_CHECK_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [newPwdTxt becomeFirstResponder];
            [btn_save setEnabled:true ];
            return;
        }
        if([confirmTxt.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:PWD_CHECK_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [confirmTxt becomeFirstResponder];
            [btn_save setEnabled:true ];
            return;
        }
        if( ![newPwdTxt.text isEqualToString:confirmTxt.text] ){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:PW_NO_EQUAL_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [newPwdTxt becomeFirstResponder];
            [btn_save setEnabled:true ];
            return;
        }

        
    }
    
    
    
    UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
    [likeImageView setCenter:CGPointMake(kScreenBoundsWidth/2, kScreenBoundsHeight/2)];
    [likeImageView setImage:[UIImage imageNamed:@"loding_cha_01@3x.png"]];
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
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *rootDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *indiv_infoDic = [NSMutableDictionary dictionary];
    
    [rootDic setObject:@"" forKey:@"task"];
    [rootDic setObject:@"" forKey:@"action"];
    [rootDic setObject:@"M2020N" forKey:@"serviceCode"];
    [rootDic setObject:@"S_SNYM2020" forKey:@"requestMessage"];
    [rootDic setObject:@"S_SNYM2020" forKey:@"responseMessage"];
    
    //회원번호
    //아이디
    //단말기고유번고
    //변경전 PIN
    //변경후 PIN
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:kCardCode]){
        [indiv_infoDic setObject:[[NSUserDefaults standardUserDefaults] stringForKey:kCardCode] forKey:@"user_seq"];
    }
    if([[NSUserDefaults standardUserDefaults] stringForKey:kId]){
        [indiv_infoDic setObject:[[NSUserDefaults standardUserDefaults] stringForKey:kEmail_id] forKey:@"email_id"];
    }
    if([[NSUserDefaults standardUserDefaults] stringForKey:kUUID]){
        [indiv_infoDic setObject:[[NSUserDefaults standardUserDefaults] stringForKey:kUUID] forKey:@"tmn_unq_no"];
    }
    [indiv_infoDic setObject:oldPwdTxt.text forKey:@"bf_pinno"];
    [indiv_infoDic setObject:newPwdTxt.text forKey:@"af_pinno"];
    
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
            
             [btn_save setEnabled:true ];
            return ;
            
            //[self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            
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
            
            NSString* temp;
            temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
            if([temp isEqualToString:@"ko"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:PWD_CHANGE_COMPLEATE_KO delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:PWD_CHANGE_COMPLEATE_VI delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            //set kCardCode
            [[NSUserDefaults standardUserDefaults] setObject:newPwdTxt.text forKey:kPwd];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [btn_save setEnabled:true ];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            //emailTxt.text = strEmail;
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Fail %@", error] delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
        [alert show];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [btn_save setEnabled:true ];
        
    }];

    
     //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    float meHeight = kScreenBoundsHeight;
    if(meHeight <= 480){
        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(handlePanGesture:)];
        [self.view addGestureRecognizer:gestureRecognizer];
        self.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+kToolBarHeight+10+10);
    }

    CGFloat marginX = 0;
    
    if(kScreenBoundsWidth > 320){
        if(kScreenBoundsWidth > 400){
            [self.view setBounds:CGRectMake(-kPopWindowMarginW*2, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            marginX = kPopWindowMarginW*2;
        }else{
            [self.view setBounds:CGRectMake(-kPopWindowMarginW, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            marginX = kPopWindowMarginW;
        }
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
    
    //[oldPwdTxt becomeFirstResponder];
    
    [self resetNavigationBarView:1];
    [self setDelegateText];
    
    [confirmTxt setKeyboardType:UIKeyboardTypeNumberPad ];
    [newPwdTxt setKeyboardType:UIKeyboardTypeNumberPad ];
    [oldPwdTxt setKeyboardType:UIKeyboardTypeNumberPad ];
    
    //[oldPwdTxt setText:[[NSUserDefaults standardUserDefaults] stringForKey:kPwd]];
    
    //
    meHeight = kScreenBoundsHeight;
    if(meHeight > 480){
        NSString* strImage;
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
            strImage = BOTTOM_BANNER_KO;
        }else{
            strImage = BOTTOM_BANNER_VI;
        }
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-marginX, kScreenBoundsHeight-(kToolBarHeight+15), kScreenBoundsWidth, kToolBarHeight)];
        [backgroundImageView setImage:[UIImage imageNamed:strImage]];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill; //UIViewContentModeScaleAspectFit
        [self.view addSubview:backgroundImageView];
        
        UIButton *adButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [adButton setFrame:CGRectMake(-marginX, kScreenBoundsHeight-(kToolBarHeight+15), kScreenBoundsWidth, kToolBarHeight)];
        [adButton setBackgroundColor:[UIColor clearColor]];
        [adButton addTarget:self action:@selector(touchToolbar:) forControlEvents:UIControlEventTouchUpInside];
        //[adButton setTag:2];
        [self.view addSubview:adButton];
    }else{
        NSString* strImage;
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
            strImage = BOTTOM_BANNER_KO;
        }else{
            strImage = BOTTOM_BANNER_VI;
        }
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-marginX, self.view.bounds.size.height+10, kScreenBoundsWidth, kToolBarHeight)];
        [backgroundImageView setImage:[UIImage imageNamed:strImage]];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill; //UIViewContentModeScaleAspectFit
        [self.view addSubview:backgroundImageView];
        
        UIButton *adButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [adButton setFrame:CGRectMake(-marginX, self.view.bounds.size.height+10, kScreenBoundsWidth, kToolBarHeight)];
        [adButton setBackgroundColor:[UIColor clearColor]];
        [adButton addTarget:self action:@selector(touchToolbar:) forControlEvents:UIControlEventTouchUpInside];
        //[adButton setTag:2];
        [self.view addSubview:adButton];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    CGRect bounds = self.view.bounds;
    
    // Translate the view's bounds, but do not permit values that would violate contentSize
    CGFloat newBoundsOriginX = bounds.origin.x - translation.x;
    CGFloat minBoundsOriginX = 0.0;
    CGFloat maxBoundsOriginX = self.contentSize.width - bounds.size.width;
    bounds.origin.x = fmax(minBoundsOriginX, fmin(newBoundsOriginX, maxBoundsOriginX));
    
    CGFloat newBoundsOriginY = bounds.origin.y - translation.y;
    CGFloat minBoundsOriginY = 0.0;
    CGFloat maxBoundsOriginY = self.contentSize.height - bounds.size.height;
    bounds.origin.y = fmax(minBoundsOriginY, fmin(newBoundsOriginY, maxBoundsOriginY));
    
    self.view.bounds = bounds;
    [gestureRecognizer setTranslation:CGPointZero inView:self.view];
}


- (void)touchToolbar:(id)sender
{
    //UIButton *button = (UIButton *)sender;
    [self.navigationController popToRootViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(didTouchMainAD)]) {
        [self.delegate didTouchMainAD];
    }
}

/////
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Navigation : viewDidLoad에서 한번, viewDidAppear에서 한번 더 한다.
    //[self.navigationItem setHidesBackButton:YES];
    [self resetNavigationBarView:1];
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - text delegate
// Automatically register fields
-(void)setDelegateText
{
    [confirmTxt setDelegate:self];
    [newPwdTxt setDelegate:self];
    [oldPwdTxt setDelegate:self];
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


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self endEdit];
//}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endEdit];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(textField.tag == 1 || textField.tag == 2 || textField.tag == 3){
        if (textField.text.length >= PWD_MAX_LENGTH && range.length == 0)
        {
            [self endEdit];
            return NO; // return NO to not change text
        }
        else if(textField.text.length >= PWD_MAX_LENGTH && range.length == 0){
            [self endEdit];
            return NO; // return NO to not change text
        }
    }
    
    return YES;
    
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
    NSString* sTitle;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        sTitle = PERSON_PWD_CHANGE_KO;
        
    }else{
        sTitle = PERSON_PWD_CHANGE_VI;
    }
    navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:sTitle];
    [navigationBarView setDelegate:self];
    
    return navigationBarView;
}

- (void)didTouchBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
    //    if ([self.delegate respondsToSelector:@selector(didTouchBackButton)]) {
    //        [self.delegate didTouchBackButton];
    //    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -initScreenView
-(void)initScreenView_ko{
    
    [self resetNavigationBarView:1];
    [label_oldPwd setText:PW_CURRENT_KO];
    [label_newPwd setText:PW_NEW_KO];
    [label_confirmPwd setText:PW_CONFIRM_KO];
    [btn_save setTitle:SAVE_KO forState:UIControlStateNormal];
}

-(void)initScreenView_vi{
    
    [self resetNavigationBarView:1];
    [label_oldPwd setText:PW_CURRENT_VI];
    [label_newPwd setText:PW_NEW_VI];
    [label_confirmPwd setText:PW_CONFIRM_VI];
    [btn_save setTitle:SAVE_VI forState:UIControlStateNormal];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
