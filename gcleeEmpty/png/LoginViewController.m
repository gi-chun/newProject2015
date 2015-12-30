//
//  LoginViewController.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 17..
//  Copyright © 2015년 gclee. All rights reserved.
//
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "NavigationBarView.h"
#import "setInforViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"
#import "leftViewController.h"
#import "idSearchViewController.h"
#import "pwdSearchViewController.h"
#import "sys/utsname.h"
#import "UIView+FormScroll.h"

@interface LoginViewController () <NavigationBarViewDelegate>
{
    NavigationBarView *navigationBarView;
    UITextField* currentEditingTextField;
    UIActivityIndicatorView* spinner;
    __weak IBOutlet UIButton *loginBtn;
    __weak IBOutlet UITextField *txtID;
    __weak IBOutlet UITextField *txtPwd;
    __weak IBOutlet UISwitch *switchAuto;
    __weak IBOutlet UILabel *labelAuto;
    __weak IBOutlet UIButton *btnIDSearch;
    __weak IBOutlet UIButton *btnPwdSearch;
    __weak IBOutlet UILabel *labelNoti;
    __weak IBOutlet UIButton *btnSummit;
    MYLoginType myLoginType;
    __weak IBOutlet UILabel *idLabel;
    __weak IBOutlet UILabel *pwdLabel;
    __weak IBOutlet UILabel *idSearchLabel;
    __weak IBOutlet UILabel *pwdSearchLabel;
    IBOutlet UIView *mainView;
    IBOutlet UIScrollView *mainScrollView;
    
}

@end

@implementation LoginViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Navigation : viewDidLoad에서 한번, viewDidAppear에서 한번 더 한다.
    //[self.navigationItem setHidesBackButton:YES];
    
//    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [spinner setCenter:CGPointMake(kScreenBoundsWidth/2.0, kScreenBoundsHeight/2.0)]; // I do this because I'm in landscape mode
//    [self.view addSubview:spinner]; // spinner is not visible until started
    
    //txtPwd set
    
//    if(kScreenBoundsHeight <= 480){
//        
//        NSString* strImage;
//        NSString* temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
//        if([temp isEqualToString:@"ko"]){
//            strImage = BOTTOM_BANNER_KO;
//        }else{
//            strImage = BOTTOM_BANNER_VI;
//        }
//        
//        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenBoundsHeight+10, kScreenBoundsWidth, kToolBarHeight)];
//        [backgroundImageView setImage:[UIImage imageNamed:strImage]];
//        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill; //UIViewContentModeScaleAspectFit
//        [self.view addSubview:backgroundImageView];
//        
//        UIButton *adButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [adButton setFrame:CGRectMake(0, kScreenBoundsHeight, kScreenBoundsWidth, kToolBarHeight)];
//        [adButton setBackgroundColor:[UIColor clearColor]];
//        [adButton addTarget:self action:@selector(touchToolbar:) forControlEvents:UIControlEventTouchUpInside];
//        //[adButton setTag:2];
//        [self.view addSubview:adButton];
//    }
    
    [self resetNavigationBarView:1];
    
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
    
    [btnSummit.titleLabel setNumberOfLines:0];
    
    [txtPwd setKeyboardType:UIKeyboardTypeNumberPad ];
    [txtID setKeyboardType:UIKeyboardTypeEmailAddress ];
    
    txtID.text = [[NSUserDefaults standardUserDefaults] stringForKey:kId] ;
    txtPwd.text = [[NSUserDefaults standardUserDefaults] stringForKey:kPwd] ;
    
    //set auto login
    if([[NSUserDefaults standardUserDefaults] boolForKey:kAutoLogin] == YES)
    {
        [switchAuto setOn:true];
    }else{
        [switchAuto setOn:false];
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

    //[txtID becomeFirstResponder];
    
    //
    if(meHeight > 480){
        NSString* strImage;
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
            strImage = BOTTOM_BANNER_KO;
        }else{
            strImage = BOTTOM_BANNER_VI;
        }
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-marginX, kScreenBoundsHeight-(kToolBarHeight+15), kScreenBoundsWidth, kToolBarHeight)];
       
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


- (void)setLoginType:(NSInteger) loginType{
    
    myLoginType = loginType;
    
}

- (IBAction)pwdSearchClick:(id)sender {
    
    float meHeight = kScreenBoundsHeight;
    if(meHeight <= 480){
        [self.view setBounds:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    
    pwdSearchViewController *pwdSearchCtl = [[pwdSearchViewController alloc] init];
    [pwdSearchCtl setDelegate:self];
    [self.navigationController pushViewController:pwdSearchCtl animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    
}
- (IBAction)setInforClick:(id)sender {
    
    float meHeight = kScreenBoundsHeight;
    if(meHeight <= 480){
        [self.view setBounds:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    
    setInforViewController *setInforCtl = [[setInforViewController alloc] init];
    [setInforCtl setDelegate:self];
    [self.navigationController pushViewController:setInforCtl animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}
- (IBAction)autoLoginClick:(id)sender {
    
    if ([switchAuto isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAutoLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kAutoLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)idSearchClick:(id)sender {
    
    float meHeight = kScreenBoundsHeight;
    if(meHeight <= 480){
        [self.view setBounds:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    
    idSearchViewController *idSearchController = [[idSearchViewController alloc] init];
    [idSearchController setDelegate:self];
    [self.navigationController pushViewController:idSearchController animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)autoLogin{
//    [spinner setHidden:false];
//    [spinner startAnimating];
    
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
    
    //회원가입
    [rootDic setObject:@"" forKey:@"task"];
    [rootDic setObject:@"" forKey:@"action"];
    [rootDic setObject:@"M2010N" forKey:@"serviceCode"];
    [rootDic setObject:@"S_SNYM2010" forKey:@"requestMessage"];
    [rootDic setObject:@"R_SNYM2010" forKey:@"responseMessage"];
    
    [indiv_infoDic setObject:txtID.text forKey:@"email_id"];
    [indiv_infoDic setObject:txtPwd.text forKey:@"pinno"];
    
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
            
//            [spinner setHidden:true];
//            [spinner stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:sError delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            leftViewController *leftViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).gLeftViewController;
            [leftViewController setViewLogin];
            //[self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            
            dicItems = nil;
            dicItems = [dicResponse objectForKey:@"indiv_info"];
            NSString* sCardNm = dicItems[@"user_seq"];
            
            //set kCardCode
            [[NSUserDefaults standardUserDefaults] setObject:sCardNm forKey:kCardCode];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //set id, pwd
            [[NSUserDefaults standardUserDefaults] setObject:txtID.text forKey:kId];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:txtPwd.text forKey:kPwd];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"Response ==> %@", responseData);
            
            //to json
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *jsonString = [jsonWriter stringWithObject:jsonArray];
            NSLog(@"jsonString ==> %@", jsonString);
            
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            NSHTTPCookie *cookie;
            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
            [cookieProperties setObject:@"locale_" forKey:NSHTTPCookieName];
            //        [cookieProperties setObject:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]] forKey:NSHTTPCookieValue];
            //////////////////////////////////////
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
            
            //        //json
            //        SBJsonParser *jsonParser = [SBJsonParser new];
            //        NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseObject error:nil];
            //        NSLog(@"%@",jsonData);
            //        NSInteger success = [(NSNumber *) [jsonData objectForKey:@"result"] integerValue];
            //        NSLog(@"%d",success);
            
//            [spinner setHidden:true];
//            [spinner stopAnimating];
            
//            NSString* temp;
//            temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
//            if([temp isEqualToString:@"ko"]){
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:LOGIN_SUCCESS_KO delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//                [alert show];
//            }else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:LOGIN_SUCCESS_VI delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//                [alert show];
//            }
            
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoginY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            leftViewController *leftViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).gLeftViewController;
            
            [leftViewController setViewLogin];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            //
            //        [cookie setValue:@"KO" forKey:@"locale_"];
            //
            //        //add cookie
            //        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            //
            //        //
            //        NSMutableArray* cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
            //        NSLog(@"cookie dictionary found is %@",cookieDictionary);
            //
            //        for (int i=0; i < cookieDictionary.count; i++)
            //        {
            //            NSLog(@"cookie found is %@",[cookieDictionary objectAtIndex:i]);
            //            NSMutableDictionary* cookieDictionary1 = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
            //            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDictionary1];
            //            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            //
            //        }
            //
            
            NSLog(@"getCookie end ==>" );
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [spinner setHidden:true];
        [spinner stopAnimating];
        
        NSLog(@"Error: %@", error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Login Fail %@", error] delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
        [alert show];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];

    
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

- (void) setPush{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *rootDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *indiv_infoDic = [NSMutableDictionary dictionary];
    
    //
    [rootDic setObject:TASK_USR forKey:@"task"];
    [rootDic setObject:@"setPush" forKey:@"action"];
    [rootDic setObject:@"" forKey:@"serviceCode"];
    [rootDic setObject:@"" forKey:@"requestMessage"];
    [rootDic setObject:@"" forKey:@"responseMessage"];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:kCardCode]){
        [indiv_infoDic setObject:[[NSUserDefaults standardUserDefaults] stringForKey:kCardCode] forKey:@"user_seq"];
    }
    [indiv_infoDic setObject:@"I" forKey:@"os_d"];
    if([[NSUserDefaults standardUserDefaults] stringForKey:kosVer]){
        [indiv_infoDic setObject:[[NSUserDefaults standardUserDefaults] stringForKey:kosVer] forKey:@"os_ver"];
    }
    if([[NSUserDefaults standardUserDefaults] stringForKey:kUUID]){
        [indiv_infoDic setObject:[[NSUserDefaults standardUserDefaults] stringForKey:kUUID] forKey:@"tmn_unq_no"];
    }
    if([[NSUserDefaults standardUserDefaults] stringForKey:kUserDeviceToken]){
        
        [indiv_infoDic setObject:[[NSUserDefaults standardUserDefaults] stringForKey: kUserDeviceToken] forKey:@"push_tmn_refno"];
    }else{
        [indiv_infoDic setObject:@"" forKey:@"push_tmn_refno"];
    }

    
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
            
        }else{
            
            dicItems = nil;
            dicItems = [dicResponse objectForKey:@"indiv_info"];
            NSString* sCardNm = dicItems[@"user_seq"];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
//        if([temp isEqualToString:@"ko"]){
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:LOGIN_FAIL_KO, error] delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//            [alert show];
//        }else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:LOGIN_FAIL_VI, error] delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//            [alert show];
//        }
        
    }];
 
}

- (IBAction)loginBtnClick:(id)sender {
    
//    [spinner setHidden:false];
//    [spinner startAnimating];
    [loginBtn setEnabled:false];
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        if([txtID.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:ID_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [txtID becomeFirstResponder];
            
            [loginBtn setEnabled:true];
            return;
        }
        if([txtPwd.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:PWD_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [txtPwd becomeFirstResponder];
            [loginBtn setEnabled:true];
            return;
        }
        
        if([self NSStringIsValidEmail:txtID.text] == false){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:EMAIL_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [txtID becomeFirstResponder];
            [loginBtn setEnabled:true];
            return;
        }
        
        if([txtPwd.text length] < 4){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:PWD_LENGTH_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [txtPwd becomeFirstResponder];
            [loginBtn setEnabled:true];
            return;
        }
        
    }else if([temp isEqualToString:@"vi"]){
        if([txtID.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:ID_CHECK_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [txtID becomeFirstResponder];
            [loginBtn setEnabled:true];
            return;
        }
        if([txtPwd.text length] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:PWD_CHECK_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [txtPwd becomeFirstResponder];
            [loginBtn setEnabled:true];
            return;
        }
        
        if([self NSStringIsValidEmail:txtID.text] == false){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:EMAIL_CHECK_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [txtID becomeFirstResponder];
            [loginBtn setEnabled:true];
            return;
        }
        
        if([txtPwd.text length] < 4){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:PWD_LENGTH_CHECK_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [txtPwd becomeFirstResponder];
            [loginBtn setEnabled:true];
            return;
        }
        
    }else{
        
        temp = @"EN";
    }
    
    //set auto login
    if ([switchAuto isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAutoLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kAutoLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
    
    //
    [rootDic setObject:@"" forKey:@"task"];
    [rootDic setObject:@"" forKey:@"action"];
    [rootDic setObject:@"M2010N" forKey:@"serviceCode"];
    [rootDic setObject:@"S_SNYM2010" forKey:@"requestMessage"];
    [rootDic setObject:@"R_SNYM2010" forKey:@"responseMessage"];
    
    [indiv_infoDic setObject:txtID.text forKey:@"email_id"];
    [indiv_infoDic setObject:txtPwd.text forKey:@"pinno"];
    
    [indiv_infoDic setObject:txtID.text forKey:@"email_id"];
    [indiv_infoDic setObject:txtPwd.text forKey:@"pinno"];
    
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
            
            [spinner setHidden:true];
            [spinner stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:sError delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            leftViewController *leftViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).gLeftViewController;
            [leftViewController setViewLogin];
            
            //[self.navigationController popToRootViewControllerAnimated:YES];
        }else{
        
            dicItems = nil;
            dicItems = [dicResponse objectForKey:@"indiv_info"];
            NSString* sCardNm = dicItems[@"user_seq"];
            
            //set kCardCode
            [[NSUserDefaults standardUserDefaults] setObject:sCardNm forKey:kCardCode];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //set id, pwd
            [[NSUserDefaults standardUserDefaults] setObject:txtID.text forKey:kId];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:txtPwd.text forKey:kPwd];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:dicItems[@"email"] forKey:kEmail];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:dicItems[@"email_id"] forKey:kEmail_id];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString* sUserNm = dicItems[@"user_nm"];
            [[NSUserDefaults standardUserDefaults] setObject:sUserNm forKey:kUserNm];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"Response ==> %@", responseData);
            
            //to json
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *jsonString = [jsonWriter stringWithObject:jsonArray];
            NSLog(@"jsonString ==> %@", jsonString);
            //save login info
            [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:kLoginData];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            NSHTTPCookie *cookie;
            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
            [cookieProperties setObject:@"locale_" forKey:NSHTTPCookieName];
            //        [cookieProperties setObject:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]] forKey:NSHTTPCookieValue];
            //////////////////////////////////////
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
            
            //        //json
            //        SBJsonParser *jsonParser = [SBJsonParser new];
            //        NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseObject error:nil];
            //        NSLog(@"%@",jsonData);
            //        NSInteger success = [(NSNumber *) [jsonData objectForKey:@"result"] integerValue];
            //        NSLog(@"%d",success);
            
//            [spinner setHidden:true];
//            [spinner stopAnimating];
            
            ////////////////////////////////////////////////////////////////////////////
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoginY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            leftViewController *leftViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).gLeftViewController;
            
            [leftViewController setViewLogin];
            
            if(myLoginType == LoginTypeConfig || myLoginType == LoginTypeAD){
                [self.navigationController popViewControllerAnimated:YES];
                if ([self.delegate respondsToSelector:@selector(didLoginAfter)]) {
                    [self.delegate didLoginAfter];
                }
                
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
                    CGSize result = [[UIScreen mainScreen] bounds].size;
                    CGFloat scale = [UIScreen mainScreen].scale;
                    result = CGSizeMake(result.width * scale, result.height * scale);
                    
//                    if(result.height== 960){
//                        
//                        [self performSelector:@selector(viewSuceeAlert) withObject:nil afterDelay:1];
//                        
//                        NSLog(@"iphone 4, 4s retina resolution");
//                    }else{
//                        [self performSelector:@selector(viewSuceeAlert) withObject:nil afterDelay:1];
//                    }
                    
                }else{
                    
                    NSLog(@"iphone standard resolution");
                }
            }
            
            ////////////////////////////////////////////////////////////////////////////
            
            //
            //        [cookie setValue:@"KO" forKey:@"locale_"];
            //
            //        //add cookie
            //        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            //
            //        //
            //        NSMutableArray* cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
            //        NSLog(@"cookie dictionary found is %@",cookieDictionary);
            //
            //        for (int i=0; i < cookieDictionary.count; i++)
            //        {
            //            NSLog(@"cookie found is %@",[cookieDictionary objectAtIndex:i]);
            //            NSMutableDictionary* cookieDictionary1 = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
            //            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDictionary1];
            //            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            //            
            //        }
            //        
            
            NSLog(@"getCookie end ==>" );
            
            [self setPush];
        }
        
        [loginBtn setEnabled:true];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [spinner setHidden:true];
        [spinner stopAnimating];
        
        NSLog(@"Error: %@", error);
        
        if([temp isEqualToString:@"ko"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:LOGIN_FAIL_KO, error] delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:LOGIN_FAIL_VI, error] delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [loginBtn setEnabled:true];
        
    }];
    
}


- (void)viewSuceeAlert{
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    
//    if([temp isEqualToString:@"ko"]){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:LOGIN_SUCCESS_KO delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//        [alert show];
//    }else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:LOGIN_SUCCESS_VI delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    
}

- (void)resetNavigationBarView:(NSInteger) type
{
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController setNavigationBarHidden:NO];
    
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
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:LOGIN_TITLE_KO];
        [navigationBarView setDelegate:self];
    }else if([temp isEqualToString:@"vi"]){
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:LOGIN_TITLE_VI];
        [navigationBarView setDelegate:self];
    }else{
        temp = @"EN";
    }
    return navigationBarView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CPNavigationBarViewDelegate

- (void)didTouchBackButton
{
    //[self resetNavigationBarView:0];

    if(myLoginType == LoginTypeConfig){
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if(myLoginType == LoginTypeAD){
        
        if ([self.delegate respondsToSelector:@selector(didTouchGoSunny)]) {
            [self.delegate didTouchGoSunny];
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        if ([self.delegate respondsToSelector:@selector(didTouchBackButton)]) {
            [self.delegate didTouchBackButton];
        }
    }
}

#pragma mark - text delegate
// Automatically register fields

-(void)setDelegateText
{
    [txtID setDelegate:self];
    [txtPwd setDelegate:self];
}

// UITextField Protocol

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentEditingTextField = textField;
    //[self.view scrollToView:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    currentEditingTextField = NULL;
    [self endEdit];
    [self.view endEditing:YES];
    //[self.view scrollToY:0];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self endEdit];
//}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endEdit];
    [self.view endEditing:YES];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(textField.tag == 1){
        
        if (textField.text.length >= PWD_MAX_LENGTH && range.length == 0)
        {
            [self endEdit];
            [self.view endEditing:YES];
            return NO; // return NO to not change text
        }
        
    }else if(textField.tag == 0){
        if (textField.text.length >= ID_MAX_LENGTH && range.length == 0)
        {
            return NO; // return NO to not change text
        }
    }
    return  YES;
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

#pragma mark -initScreenView
-(void)initScreenView_ko{
    
    [self resetNavigationBarView:1];
    [idLabel setText:LOGIN_ID_KO];
    [pwdLabel setText:LOGIN_PWD_KO];
    [labelAuto setText:LOGIN_AUTO_KO];
    [loginBtn setTitle:LOGIN_BTN_KO forState:UIControlStateNormal];
    [labelNoti setText:LOGIN_NOTI_KO];
    [btnSummit setTitle:LOGIN_SUMMIT_KO forState:UIControlStateNormal];
    [idSearchLabel setText:LOGIN_ID_FIND_KO];
    [pwdSearchLabel setText:LOGIN_PWD_FIND_KO];
    
}

-(void)initScreenView_vi{
    
    [self resetNavigationBarView:1];
    [idLabel setText:LOGIN_ID_VI];
    [pwdLabel setText:LOGIN_PWD_VI];
    [labelAuto setText:LOGIN_AUTO_VI];
    [loginBtn setTitle:LOGIN_BTN_VI forState:UIControlStateNormal];
    [labelNoti setText:LOGIN_NOTI_VI];
    [btnSummit setTitle:LOGIN_SUMMIT_VI forState:UIControlStateNormal];
    [idSearchLabel setText:LOGIN_ID_FIND_VI];
    [pwdSearchLabel setText:LOGIN_PWD_FIND_VI];
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
