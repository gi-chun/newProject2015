//
//  leftLoginView.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 10..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import "leftLoginView.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"
#import "CPLoadingView.h"
#import "WebViewController.h"
#import "AppDelegate.h"


@interface leftLoginView ()
{
    //NSDictionary *_item;
    //NSMutableDictionary *_AreaItem;
    NSString * _title;
    UILabel* labelMenu;
    UILabel* labelMailId;
    UILabel* labelId;
    UILabel* labelCardNumber;
    UILabel* labelPoint;
    UIImageView *cardImageView;
    UIImageView *idImageView;
    UIButton* loginButton;
    UIButton* logoutButton;
    UIButton* summitButton;
    CPLoadingView *loadingView;
}
@end

@implementation leftLoginView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:UIColorFromRGB(0xf68a1e)];
        //[self setBackgroundColor:[UIColor clearColor]];
        
        //[self showContents];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:UIColorFromRGB(0xf68a1e)];
        //[self setBackgroundColor:[UIColor clearColor]];
        
        //LoadingView
        loadingView = [[CPLoadingView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2-40,
                                                                      CGRectGetHeight(self.frame)/2-40,
                                                                      80,
                                                                      80)];
        
        _title = title;
        
        BOOL isAuto = [[NSUserDefaults standardUserDefaults] boolForKey:kAutoLogin];
        if(isAuto == YES)
        {
            [self loginProcess];
        }
        
        [self showContents];
        
        NSString* temp;
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
            [self initScreenView_ko];
        }else if([temp isEqualToString:@"vi"]){
            [self initScreenView_vi];
        }else{
            temp = @"EN";
        }

    }
    
    return self;
}

#pragma mark - CPLoadingView

- (void)startLoadingAnimation
{
    [self addSubview:loadingView];
    [loadingView startAnimation];
}

- (void)stopLoadingAnimation
{
    [loadingView stopAnimation];
    [loadingView removeFromSuperview];
}

- (void) loginProcess
{
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
    
//    UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
//    [likeImageView setCenter:CGPointMake(kScreenBoundsWidth/2+marginX, kScreenBoundsHeight/2)];
//    [likeImageView setImage:[UIImage imageNamed:@"loding_cha_01@3x.png"]];
//    [self addSubview:likeImageView];
//    [self bringSubviewToFront:likeImageView];
//    
//    if ([SYSTEM_VERSION intValue] > 7) {
//        likeImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
//        [UIView animateWithDuration:3.0f
//                              delay:0
//             usingSpringWithDamping:0.2f
//              initialSpringVelocity:6.0f
//                            options:UIViewAnimationOptionAllowUserInteraction
//                         animations:^{
//                             likeImageView.transform = CGAffineTransformIdentity;
//                         }
//                         completion:^(BOOL finished) {
//                             [likeImageView removeFromSuperview];
//                         }];
//    }
//    else {
//        [UIView animateWithDuration:1.0f animations:^{
//            [likeImageView removeFromSuperview];
//        }];
//    }

    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self startLoadingAnimation];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *rootDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *indiv_infoDic = [NSMutableDictionary dictionary];
    
    //회원가입
    [rootDic setObject:@"" forKey:@"task"];
    [rootDic setObject:@"" forKey:@"action"];
    [rootDic setObject:@"M2010N" forKey:@"serviceCode"];
    [rootDic setObject:@"S_SNYM2010" forKey:@"requestMessage"];
    [rootDic setObject:@"R_SNYM2010" forKey:@"responseMessage"];
    
    NSString *strId = [[NSUserDefaults standardUserDefaults] stringForKey:kId];
    NSString *strPwd = [[NSUserDefaults standardUserDefaults] stringForKey:kPwd];
    if([[NSUserDefaults standardUserDefaults] stringForKey:kId] == nil){
        return;
    }
    
    [indiv_infoDic setObject:strId forKey:@"email_id"];
    [indiv_infoDic setObject:strPwd forKey:@"pinno"];
    
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
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            
            dicItems = nil;
            dicItems = [dicResponse objectForKey:@"indiv_info"];
            NSString* sCardNm = dicItems[@"user_seq"];
            
            //set kCardCode
            [[NSUserDefaults standardUserDefaults] setObject:sCardNm forKey:kCardCode];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString* sUserNm = dicItems[@"user_nm"];
            [[NSUserDefaults standardUserDefaults] setObject:sUserNm forKey:kUserNm];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //mail
            NSString* sEmail = dicItems[@"email"];
            [[NSUserDefaults standardUserDefaults] setObject:sEmail forKey:kEmail];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //mail id
            NSString* sEmail_id = dicItems[@"email_id"];
            [[NSUserDefaults standardUserDefaults] setObject:sEmail_id forKey:kEmail_id];
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
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoginY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
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
        
        [self showContents];
        
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self stopLoadingAnimation];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Login Fail %@", error] delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
        //        [alert show];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self stopLoadingAnimation];
        
    }];
}

- (void) setDataAfterlogout
{
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUUID];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUserDeviceToken];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:klang];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey: kAutoLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kId];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kPwd];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUserNm];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kEmail];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kEmail_id];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey: kLoginY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kCardCode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey: kAgreeOk];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey: kPushY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kYYYYMMDD];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kCurrentVersion];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUpdateVersion];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey: kTutoY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kLoginData];
    [[NSUserDefaults standardUserDefaults] synchronize];


}

- (void) logoutProcess
{
//    UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
//    [likeImageView setCenter:CGPointMake(kScreenBoundsWidth/2, kScreenBoundsHeight/2)];
//    [likeImageView setImage:[UIImage imageNamed:@"loding_cha_01@3x.png"]];
//    [self addSubview:likeImageView];
//    [self bringSubviewToFront:likeImageView];
//    
//    if ([SYSTEM_VERSION intValue] > 7) {
//        likeImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
//        [UIView animateWithDuration:3.0f
//                              delay:0
//             usingSpringWithDamping:0.2f
//              initialSpringVelocity:6.0f
//                            options:UIViewAnimationOptionAllowUserInteraction
//                         animations:^{
//                             likeImageView.transform = CGAffineTransformIdentity;
//                         }
//                         completion:^(BOOL finished) {
//                             [likeImageView removeFromSuperview];
//                         }];
//    }
//    else {
//        [UIView animateWithDuration:1.0f animations:^{
//            [likeImageView removeFromSuperview];
//        }];
//    }

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *rootDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *indiv_infoDic = [NSMutableDictionary dictionary];
    
    //
    [rootDic setObject:@"" forKey:@"task"];
    [rootDic setObject:@"" forKey:@"action"];
    [rootDic setObject:@"A3130U" forKey:@"serviceCode"];
    [rootDic setObject:@"" forKey:@"requestMessage"];
    [rootDic setObject:@"" forKey:@"responseMessage"];
    
//    NSString *strId = [[NSUserDefaults standardUserDefaults] stringForKey:kId];
//    NSString *strPwd = [[NSUserDefaults standardUserDefaults] stringForKey:kPwd];
//    if([[NSUserDefaults standardUserDefaults] stringForKey:kId] == nil){
//        return;
//    }
//    
//    [indiv_infoDic setObject:strId forKey:@"email_id"];
//    [indiv_infoDic setObject:strPwd forKey:@"pinno"];
    
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
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            
            dicItems = nil;
            dicItems = [dicResponse objectForKey:@"indiv_info"];
            NSString* sCardNm = dicItems[@"user_seq"];
            
            //set kCardCode
            [[NSUserDefaults standardUserDefaults] setObject:sCardNm forKey:kCardCode];
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
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
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
            
            [self setDataAfterlogout];
            [self showContents];
            [self didLogOutShowContents];
            
            //web view refresh
             WebViewController *homeViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).homeWebViewController;
            [homeViewController webViewReload];
            [homeViewController.navigationController popToRootViewControllerAnimated:YES];
            
             [logoutButton setEnabled:true];
            
//            NSString* temp;
//            temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
//            if([temp isEqualToString:@"ko"]){
//                
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Logout Success" delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//            [alert show];
//            }else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Logout Success" delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//            }

            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Login Fail %@", error] delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
        //        [alert show];
        
        //[self showContentsLogout];
        //[self showContents];

        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
         [logoutButton setEnabled:true];
        
    }];
    
    
    
    [loginButton setEnabled:true];
    
    
}


#pragma showContents


- (void)showContents
{
    [self removeContents];
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginY];
    if(isLogin == YES)
    {
        _loginStatus = 1;
    }else{
        _loginStatus = 0;
    }
    
    //150
    CGFloat meWidth = self.bounds.size.width;
    CGFloat meHeight = self.bounds.size.height;
    CGFloat meY = self.bounds.origin.y;
    
    //360
    // 320 * 40
    /*
     const static CGFloat ICON_HEIGHT     =     50;
     const static CGFloat ICON_WIDTH      =    50;
     const static CGFloat LABEL_WIDTH     =    100;
     */

    CGFloat titleLabelMarginX = 0.f;
    CGFloat loginBtnMarginX = 0.f;
    CGFloat labelMarginX = 0.f;
    CGFloat logoutMarginX = 0.f;
    CGFloat cardMarginX = 0.f;
    CGFloat cardNumberX = 0.0f;
    CGFloat pointX = 0.0f;
    
//    if(kScreenBoundsWidth > 400){
//        titleLabelMarginX = 80;
//        
//        loginBtnMarginX = 40;
//        labelMarginX = 2;
//        logoutMarginX =90;
//        
//    }else{
//        titleLabelMarginX = (kScreenBoundsWidth > 320)?10:0;
//        
//        loginBtnMarginX = (kScreenBoundsWidth > 320)?50:0;
//        labelMarginX = (kScreenBoundsWidth > 320)?2:0;
//        logoutMarginX = (kScreenBoundsWidth > 320)?60:0;
//        
//    }
    
        if(kScreenBoundsWidth > 400){
            titleLabelMarginX = 80;
    
            loginBtnMarginX = 155;
            labelMarginX = 2;
            logoutMarginX =10;
            cardMarginX = 0;
            cardNumberX = 35;
            pointX = 30;
    
        }else{
            titleLabelMarginX = (kScreenBoundsWidth > 320)?10:0;
            loginBtnMarginX = (kScreenBoundsWidth > 320)?140+110:80+115;
            labelMarginX = (kScreenBoundsWidth > 320)?2:0;
            logoutMarginX = (kScreenBoundsWidth > 320)?100:50;
            cardMarginX = (kScreenBoundsWidth > 320)?40:20;
            cardNumberX = (kScreenBoundsWidth > 320)?40:35;
            pointX = (kScreenBoundsWidth > 320)?-10:10;
            
        }

    
    //label
    // 100, 26
    labelMenu = [[UILabel alloc] initWithFrame:CGRectMake(10, 24, meWidth-20, 60)]; //94/2
    [labelMenu setBackgroundColor:[UIColor clearColor]];
    [labelMenu setTextColor:UIColorFromRGB(0xffffff)];
    [labelMenu setFont:[UIFont systemFontOfSize:15]];
    //[labelMenu setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    //setFont:[UIFont systemFontOfSize:15]];
    //    [labelMenu setShadowColor:[UIColor whiteColor]];
    //    [labelMenu setShadowOffset:CGSizeMake(0,2)];
    [labelMenu setTextAlignment:NSTextAlignmentLeft];
    [labelMenu setNumberOfLines:0];
    //[labelMenu sizeToFit];
    
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        [labelMenu setText:LEFT_DES_KO];
    }else{
        [labelMenu setText:LEFT_DES_VI];
    }
    [self addSubview:labelMenu];
    
    //login button
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, CGRectGetMaxY(labelMenu.frame)+20, meWidth-loginBtnMarginX, 50)];
    [loginButton setBackgroundColor:[UIColor clearColor]]; //icon_main_login, btn_login_save.png
    [loginButton setBackgroundImage:[UIImage imageNamed:@"total_menu_login_btn_press.png"] forState:UIControlStateHighlighted];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"total_menu_login_btn.png"] forState:UIControlStateNormal];
    //[emptyButton setImage:[UIImage imageNamed:@"icon_main_login.png"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(didTouchLogInBtn) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *btnString = nil;
    if([temp isEqualToString:@"ko"]){
        btnString = LEFT_LOGIN_KO;
    }else{
        btnString = LEFT_LOGIN_VI;
    }
    [loginButton setTitle:btnString forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [loginButton setTitleColor:UIColorFromRGB(0xf05921) forState:UIControlStateNormal];
    [loginButton setTitleColor:UIColorFromRGB(0xf05921) forState:UIControlStateHighlighted];
    
    loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self addSubview:loginButton];
    
    //summit button
    summitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [summitButton setFrame:CGRectMake(CGRectGetMaxX(loginButton.frame)+5, CGRectGetMaxY(labelMenu.frame)+20, meWidth-loginBtnMarginX, 50)];
    [summitButton setBackgroundColor:[UIColor clearColor]]; //icon_main_login, btn_login_save.png
    [summitButton setBackgroundImage:[UIImage imageNamed:@"total_menu_login_btn_press.png"] forState:UIControlStateHighlighted];
    [summitButton setBackgroundImage:[UIImage imageNamed:@"total_menu_login_btn.png"] forState:UIControlStateNormal];
    [summitButton addTarget:self action:@selector(didTouchSummitBtn) forControlEvents:UIControlEventTouchUpInside];
    
    btnString = nil;
    if([temp isEqualToString:@"ko"]){
        btnString = LOGIN_SUMMIT_KO;
    }else{
        btnString = LOGIN_SUMMIT_VI;
    }
    [summitButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [summitButton.titleLabel setNumberOfLines:0];
    [summitButton setTitle:btnString forState:UIControlStateNormal];
    [summitButton setTitleColor:UIColorFromRGB(0xf05921) forState:UIControlStateNormal];
    [summitButton setTitleColor:UIColorFromRGB(0xf05921) forState:UIControlStateHighlighted];
    
    summitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    
    [self addSubview:summitButton];

    
    //////////////////////////////////////////////////////////////////////////////////////////
    // id image
    idImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 12, 13)];
    //[idImageView setBackgroundColor:UIColorFromRGB(0x105921)];
    idImageView.contentMode = UIViewContentModeScaleAspectFit;
    [idImageView setImage:[UIImage imageNamed:@"total_menu_email_icon.png"]];
    [self addSubview:idImageView];
    
    //id label
    labelId = [[UILabel alloc] initWithFrame:CGRectMake(35, 2, meWidth-100, 20) ];
    [labelId setBackgroundColor:[UIColor clearColor]];
    [labelId setTextColor:UIColorFromRGB(0xffffff)];
    [labelId setFont:[UIFont systemFontOfSize:15]];
    [labelId setTextAlignment:NSTextAlignmentLeft];
    [labelId setNumberOfLines:0];
     _stringId = (_loginStatus == 1)?[[NSUserDefaults standardUserDefaults] stringForKey:kUserNm]:@"";
    [labelId setText:_stringId];
    [self addSubview:labelId];
    
    //mail id label
    labelMailId = [[UILabel alloc] initWithFrame:CGRectMake(35, 16, meWidth-100, 20) ];
    [labelMailId setBackgroundColor:[UIColor clearColor]];
    [labelMailId setTextColor:UIColorFromRGB(0xffffff)];
    [labelMailId setFont:[UIFont systemFontOfSize:13]];
    [labelMailId setTextAlignment:NSTextAlignmentLeft];
    [labelMailId setNumberOfLines:0];
    _mailId = (_loginStatus == 1)?[[NSUserDefaults standardUserDefaults] stringForKey:kEmail_id]:@"";
    [labelMailId setText:_mailId];
    [self addSubview:labelMailId];
    
    //logout button
    logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutButton setFrame:CGRectMake(meWidth - (30+logoutMarginX), 5, 30, 30)];
    [logoutButton setBackgroundColor:[UIColor clearColor]]; //icon_main_login, btn_login_save.png
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"total_menu_logout_btn.png"] forState:UIControlStateHighlighted];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"total_menu_logout_btn.png"] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(didTouchLogOutBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:logoutButton];
    
    // card image
    cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10-cardMarginX, 36, meWidth-40, 135)];
    //[cardImageView setBackgroundColor:UIColorFromRGB(0x105921)];
    cardImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *cardImageName;
    NSString *grade;
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:kMb_grade]){
        grade = [[NSUserDefaults standardUserDefaults] stringForKey:kMb_grade];
    }
    
    if([grade isEqualToString:@"0"]){
        cardImageName =  @"card_img_b.png";
    }else if([grade isEqualToString:@"1"]){
        cardImageName =  @"card_img_s.png";
    }else if([grade isEqualToString:@"2"]){
        cardImageName =  @"card_img_g.png";
    }else if([grade isEqualToString:@"3"]){
        cardImageName =  @"card_img_v.png";
    }
    
    [cardImageView setImage:[UIImage imageNamed:cardImageName]];
    [self addSubview:cardImageView];
    
    //card number label
    _cardNumber =  [[NSUserDefaults standardUserDefaults] stringForKey:kCardCode] ;
    labelCardNumber = [[UILabel alloc] initWithFrame:CGRectMake(55+cardNumberX, 85, meWidth-65, 40) ];
    [labelCardNumber setBackgroundColor:[UIColor clearColor]];
    [labelCardNumber setTextColor:UIColorFromRGB(0xffffff)];
    [labelCardNumber setFont:[UIFont systemFontOfSize:14]];
    [labelCardNumber setTextAlignment:NSTextAlignmentLeft];
    [labelCardNumber setNumberOfLines:0];
    [labelCardNumber setText:_cardNumber];
    [self addSubview:labelCardNumber];
    
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
    labelPoint = [[UILabel alloc] initWithFrame:CGRectMake(pointX, 113, meWidth-65, 40) ];
    [labelPoint setBackgroundColor:[UIColor clearColor]];
    [labelPoint setTextColor:UIColorFromRGB(0xffffff)];
    [labelPoint setFont:[UIFont systemFontOfSize:12]];
    [labelPoint setTextAlignment:NSTextAlignmentCenter];
    [labelPoint setNumberOfLines:0];
    [labelPoint setText:strPoint];
    [self addSubview:labelPoint];
    
    [self setVisableItem];
    
    
}

- (void)removeContents
{
    
    if(labelCardNumber){
        [labelCardNumber removeFromSuperview];
        labelCardNumber = nil;
    }
    
    if(labelMenu){
        [labelMenu removeFromSuperview];
        labelMenu = nil;
    }
    
    if(labelMailId){
        [labelMailId removeFromSuperview];
        labelMailId = nil;
    }
    
    if(labelId){
        [labelId removeFromSuperview];
        labelId = nil;
    }
    
    if(cardImageView){
        [cardImageView removeFromSuperview];
        cardImageView = nil;
    }
    if(idImageView){
        [idImageView removeFromSuperview];
        idImageView = nil;
    }
    if(loginButton){
        [loginButton removeFromSuperview];
        loginButton = nil;
    }
    if(logoutButton){
        [logoutButton removeFromSuperview];
        logoutButton = nil;
    }
    if(summitButton){
        [summitButton removeFromSuperview];
        summitButton = nil;
    }
    if(labelPoint){
        [labelPoint removeFromSuperview];
        labelPoint = nil;
    }
}

- (void)onClickButton
{
    
}

- (void)onLogOut
{
    
}

- (void)setVisableItem
{
    //_loginStatus = 0;
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginY];
    
    if(isLogin == YES)
    {
        _loginStatus = 1;
    }else{
        _loginStatus = 0;
    }
    
    //labelId: id
    if(_loginStatus){ //log on
        
        [idImageView setHidden:false];
        [labelId setHidden:false];
        [labelMailId setHidden:false];
        [cardImageView setHidden:false];
        [logoutButton setHidden:false];
        [labelCardNumber setHidden:false];
        [labelPoint setHidden:false];
        
        [labelMenu setHidden:true];
        [loginButton setHidden:true];
        [summitButton setHidden:true];
        
        
    }else{            //log off
        
        _title = @"";
        [labelId setText:@""];
        [labelMailId setText:@""];
        
        [idImageView setHidden:true];
        [labelId setHidden:true];
        [labelMailId setHidden:true];
        [logoutButton setHidden:true];
        [cardImageView setHidden:true];
        [labelCardNumber setHidden:true];
        [labelPoint setHidden:true];
        
        [labelMenu setHidden:false];
        [loginButton setHidden:false];
        [summitButton setHidden:false];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //delete it
        [logoutButton setEnabled:false];
        //log out
        [self logoutProcess];
        
        //    if ([self.delegate respondsToSelector:@selector(didTouchLogOutBtn)]) {
        //        [self.delegate didTouchLogOutBtn];
        //    }
    }
}

#pragma mark - Selectors
- (void)didTouchLogOutBtn
{
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOGIN_KO message:LOGIN_OUT_ASK_KO delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOGIN_VI message:LOGIN_OUT_ASK_VI delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        [alert show];
    }
    
}

- (void)didTouchLogInBtn
{
    if ([self.delegate respondsToSelector:@selector(didTouchLogInBtn)]) {
        [self.delegate didTouchLogInBtn];
    }
    
}

- (void)didLogOutShowContents
{
    if ([self.delegate respondsToSelector:@selector(didLogOutShowContents)]) {
        [self.delegate didLogOutShowContents];
    }
}

- (void)didTouchSummitBtn
{
    if ([self.delegate respondsToSelector:@selector(didTouchSummitBtn)]) {
        [self.delegate didTouchSummitBtn];
    }
}

#pragma mark -initScreenView
-(void)initScreenView_ko{
    
    [labelMenu setText:LEFT_DES_KO];
    [loginButton setTitle:LEFT_LOGIN_KO forState:UIControlStateNormal];
    [summitButton setTitle:LOGIN_SUMMIT_KO forState:UIControlStateNormal];
    
}

-(void)initScreenView_vi{
    
    [labelMenu setText:LEFT_DES_VI];
    [loginButton setTitle:LEFT_LOGIN_VI forState:UIControlStateNormal];
    [summitButton setTitle:LOGIN_SUMMIT_VI forState:UIControlStateNormal];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
