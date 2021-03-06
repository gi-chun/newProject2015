//
//  personModifyViewController.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 21..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import "personModifyViewController.h"
#import "pwdChangeViewController.h"
#import "memberOutViewController.h"

#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"
#import "NavigationBarView.h"

@interface personModifyViewController () <NavigationBarViewDelegate>
{
    NavigationBarView *navigationBarView;
    UITextField* currentEditingTextField;
    
    __weak IBOutlet UILabel *label_id;
    __weak IBOutlet UILabel *idLabel;
    __weak IBOutlet UILabel *label_mail;
    __weak IBOutlet UITextField *emailTxt;
    __weak IBOutlet UILabel *label_pwd;
    __weak IBOutlet UILabel *label_member;
    __weak IBOutlet UILabel *label_membership;
    __weak IBOutlet UILabel *label_nomal;
    __weak IBOutlet UILabel *cardNmLabel;
    __weak IBOutlet UIButton *btn_change;
    __weak IBOutlet UILabel *labelPoint;
    __weak IBOutlet UIImageView *imgCard;
    
}
@end

@implementation personModifyViewController

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

    [emailTxt setKeyboardType: UIKeyboardTypeEmailAddress ];
    
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

    
    [self resetNavigationBarView:1];
    [self setDelegateText];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:kId]){
        [idLabel setText:[[NSUserDefaults standardUserDefaults] stringForKey:kId]];
    }
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:kEmail]){
        [emailTxt setText:[[NSUserDefaults standardUserDefaults] stringForKey:kEmail]];
        
    }
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:kCardCode]){
        [cardNmLabel setText:[[NSUserDefaults standardUserDefaults] stringForKey:kCardCode]];
        
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
    
    NSString* grade;
    NSString* cardImageName;
    if([[NSUserDefaults standardUserDefaults] stringForKey:kMb_grade]){
        grade = [[NSUserDefaults standardUserDefaults] stringForKey:kMb_grade];
    }
    
    if([grade isEqualToString:@"0"]){
        cardImageName =  @"setting_card_b.png";
    }else if([grade isEqualToString:@"1"]){
        cardImageName =  @"setting_card_s.png";
    }else if([grade isEqualToString:@"2"]){
        cardImageName =  @"setting_card_g.png";
    }else if([grade isEqualToString:@"3"]){
        cardImageName =  @"setting_card_v.png";
    }
    [imgCard setImage:[UIImage imageNamed:cardImageName]];
    
    NSString* strPoint;
    if([[NSUserDefaults standardUserDefaults] stringForKey:kMb_point]){
        strPoint = [[NSUserDefaults standardUserDefaults] stringForKey:kMb_point];
    }
    
    //strPoint = @"9999999";
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setDecimalSeparator:@"."];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    
    NSNumber *nPoint = [NSNumber numberWithInt:[strPoint intValue]];
    strPoint = [NSString stringWithFormat:@"%@ P", [numberFormatter stringFromNumber:nPoint]];
    [labelPoint setText:strPoint];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:kMb_grade_nm]){
        [label_nomal setText:[[NSUserDefaults standardUserDefaults] stringForKey:kMb_grade_nm]];
    }
    
    //[emailTxt becomeFirstResponder];
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
        //[backgroundImageView setImage:[UIImage imageNamed:strImage]];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill; //UIViewContentModeScaleAspectFit
        [self.view addSubview:backgroundImageView];
        
        NSURL *imageURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kMainBannerImgUrl]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                backgroundImageView.image = [UIImage imageWithData:imageData];
                if([imageData length] < 1){
                    [backgroundImageView setImage:[UIImage imageNamed:strImage]];
                }
            });
        });
        
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
        //[backgroundImageView setImage:[UIImage imageNamed:strImage]];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill; //UIViewContentModeScaleAspectFit
        [self.view addSubview:backgroundImageView];
        
        NSURL *imageURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kMainBannerImgUrl]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                backgroundImageView.image = [UIImage imageWithData:imageData];
                if([imageData length] < 1){
                    [backgroundImageView setImage:[UIImage imageNamed:strImage]];
                }
            });
        });
        
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

- (void)didTouchMainAD{
    if ([self.delegate respondsToSelector:@selector(didTouchMainAD)]) {
        [self.delegate didTouchMainAD];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Navigation : viewDidLoad에서 한번, viewDidAppear에서 한번 더 한다.
    [self.navigationItem setHidesBackButton:YES];
    [self resetNavigationBarView:1];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)emailSummit:(id)sender {
    
    [btn_change setEnabled:false];
     
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    
    if([temp isEqualToString:@"ko"]){
    
        if([emailTxt.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:EMAIL_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [emailTxt becomeFirstResponder];
             [btn_change setEnabled:true];
            return;
        }
        
        if([self NSStringIsValidEmail:emailTxt.text] == false){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:EMAIL_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            
            [alert show];
            
            [emailTxt becomeFirstResponder];
            [btn_change setEnabled:true];
            return;
        }
        
    }else{
        
    }
    
    CGFloat marginX = 0;
    if(kScreenBoundsWidth > 320){
        if(kScreenBoundsWidth > 400){
            marginX = -36;
        }else{
            marginX = -16;
        }
    }else{
        marginX = 8;
    }
    
    UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
    [likeImageView setCenter:CGPointMake(kScreenBoundsWidth/2+marginX, kScreenBoundsHeight/2)];
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
    
    [rootDic setObject:TASK_USR forKey:@"task"];
    [rootDic setObject:@"setUserEmail" forKey:@"action"];
    [rootDic setObject:@"" forKey:@"serviceCode"];
    [rootDic setObject:@"" forKey:@"requestMessage"];
    [rootDic setObject:@"" forKey:@"responseMessage"];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:kCardCode]){
        [indiv_infoDic setObject:[[NSUserDefaults standardUserDefaults] stringForKey:kCardCode] forKey:@"user_seq"];
    }
    NSString* strEmail = [[NSUserDefaults standardUserDefaults] stringForKey:kEmail];
    if([[NSUserDefaults standardUserDefaults] stringForKey:kEmail]){
        [indiv_infoDic setObject:strEmail forKey:@"email"];
    }
    
//    NSString* strEmail = [[NSUserDefaults standardUserDefaults] stringForKey:kEmail];
//    if([[NSUserDefaults standardUserDefaults] stringForKey:kEmail]){
//        [indiv_infoDic setObject:strEmail forKey:@"email"];
//    }
    
    [indiv_infoDic setObject:emailTxt.text forKey:@"email"];
    
    //[indiv_infoDic setObject:emailTxt.text forKey:@"email"];
    //emailTxt
    
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
            
            //to json
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *jsonString = [jsonWriter stringWithObject:jsonArray];
            NSLog(@"jsonString ==> %@", jsonString);
            
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            NSHTTPCookie *cookie;
            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
            [cookieProperties setObject:@"locale_" forKey:NSHTTPCookieName];
            [cookieProperties setObject:@"KO" forKey:NSHTTPCookieValue];
            [cookieProperties setObject:COOKIE_SAVE_DOMAIN forKey:NSHTTPCookieDomain];
            [cookieProperties setObject:COOKIE_SAVE_DOMAIN forKey:NSHTTPCookieOriginURL];
            [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
            [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
            // set expiration to one month from now
            [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
            cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            
            for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
                NSLog(@"%@=%@", cookie.name, cookie.value);
            }
            
            NSString* temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
            
            if([temp isEqualToString:@"ko"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:CHANGE_MAIL_KO delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:CHANGE_MAIL_VI delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            //set kCardCode
            [[NSUserDefaults standardUserDefaults] setObject:emailTxt.text forKey:kEmail];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //emailTxt.text = strEmail;
            [btn_change setEnabled:true];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         NSLog(@"Error: %@", error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Fail %@", error] delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
        [alert show];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [btn_change setEnabled:true];
        
    }];

    
}

- (IBAction)pwdChange:(id)sender {

    float meHeight = kScreenBoundsHeight;
    if(meHeight <= 480){
        [self.view setBounds:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }

    pwdChangeViewController *pwdChangeController = [[pwdChangeViewController alloc] init];
    [pwdChangeController setDelegate:self];
    [self.navigationController pushViewController:pwdChangeController animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    
//    [pwdChangeController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//    [self presentViewController:pwdChangeController animated:YES completion:nil];

    
    //////
    /*
    MYDetailViewController *dvc = [[MYDetailViewController alloc] initWithNibName:@"MYDetailViewController" bundle:[NSBundle mainBundle]];
    [dvc setDelegate:self];
    [dvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:dvc animated:YES completion:nil];
    
    
    -(void)dismiss
    {
        [self.presentingViewController dissmissViewControllerAnimated:YES completion:nil];
    }
     */
    
}

- (IBAction)memberOutClick:(id)sender {
    
    float meHeight = kScreenBoundsHeight;
    if(meHeight <= 480){
        [self.view setBounds:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }

    memberOutViewController *pwdChangeController = [[memberOutViewController alloc] init];
    [pwdChangeController setDelegate:self];
    [self.navigationController pushViewController:pwdChangeController animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
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
    [emailTxt setDelegate:self];
    
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

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
//{
//    [self endEdit];
//
//}

// xcode 7.1
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self endEdit];
//}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:PERSON_TITLE_KO];
        [navigationBarView setDelegate:self];
    }else if([temp isEqualToString:@"vi"]){
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:PERSON_TITLE_VI];
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -initScreenView
-(void)initScreenView_ko{
    
        [self resetNavigationBarView:1];
        [label_id setText:PERSON_ID_KO];
        [label_mail setText:PERSON_MAIL_KO];
        [btn_change setTitle:PERSON_CHANGE_KO forState:UIControlStateNormal];
        [label_pwd setText:PERSON_PWD_CHANGE_KO];
        [label_member setText:PERSON_MEMBER_OUT_KO];
        [label_membership setText:PERSON_MEMBER_LEVEL_KO];
        [label_nomal setText:PERSON_NOMAL_KO];
    
}

-(void)initScreenView_vi{
    
    [self resetNavigationBarView:1];
    [label_id setText:PERSON_ID_VI];
    [label_mail setText:PERSON_MAIL_VI];
    [btn_change setTitle:PERSON_CHANGE_VI forState:UIControlStateNormal];
    [label_pwd setText:PERSON_PWD_CHANGE_VI];
    [label_member setText:PERSON_MEMBER_OUT_VI];
    [label_membership setText:PERSON_MEMBER_LEVEL_VI];
    [label_nomal setText:PERSON_NOMAL_VI];
}




@end
