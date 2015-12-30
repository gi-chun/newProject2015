//
//  leftViewController.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 10. 21..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import "UIViewController+MMDrawerController.h"
#import "leftViewController.h"
#import "leftMenuView.h"
#import "LoginViewController.h"
#import "configViewController.h"
#import "setInforViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"
#import "WebViewController.h"
#import "Appdelegate.h"


#import "amsLibrary.h"
//#import "KTBiOS.h"
#import "XMLDictionary.h"

@interface leftViewController (){
    leftMenuView* menuView;
}

@end

@implementation leftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadContentsView];
    
//    ////////////////////////////////
//    // 탈옥체크
//    amsLibrary *ams = [[amsLibrary alloc] init];
//    NSInteger result = [ams a3142:@"AHN_3379024345_TK"]; //AHN_3379024345_TK, 201 크면 안되면
//    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
//    NSInteger roundedValue = round(interval);
//    
//    NSLog(@"Jailbreak Result : %ld" , (long)result);
//    NSLog(@"time interval  : %ld" , (long)roundedValue);
//    NSLog(@"checking Result : %ld" , (long)(result - roundedValue));
//    NSInteger lastResult = (result - roundedValue);
//    
//    //if(lastResult > 200)
//    if(lastResult > 20)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"This App Jailbreak phone NO Service. App Stop" delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//        [alert show];
//        
//        [NSThread sleepForTimeInterval:5000.0];
//        
//        UIApplication *app = [UIApplication sharedApplication];
//        [app performSelector:@selector(suspend)];
//        
//        //wait 2 seconds while app is going background
//        [NSThread sleepForTimeInterval:10.0];
//        //exit app when app is in background
//        exit(0);
//    }

    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    WebViewController *homeViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).homeWebViewController;
    [homeViewController setViewAlpha:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    if (self.navigationController.navigationBar.isHidden) {
//        [self.navigationController setNavigationBarHidden:YES];
//    }
    
    WebViewController *homeViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).homeWebViewController;
    [homeViewController setViewAlpha:1];
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginY];
    if(isLogin == YES){
        [self setViewLogin];
    }
    [self.navigationController setNavigationBarHidden:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setViewLogin
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginY];
    if(isLogin == YES){
        [self getMembership];
    }else{
        [self loadContentsView];
    }
}

- (void)setViewLogout
{
    [self setDataAfterlogout];
    [self loadContentsView];
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

- (void)getMembership
{
//    UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
//    [likeImageView setCenter:CGPointMake(kScreenBoundsWidth/2, kScreenBoundsHeight/2)];
//    [likeImageView setImage:[UIImage imageNamed:@"loding_cha_01@3x.png"]];
//    [self.view addSubview:likeImageView];
//    [self.view bringSubviewToFront:likeImageView];
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
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *rootDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *indiv_infoDic = [NSMutableDictionary dictionary];
    
    //
    [rootDic setObject:@"sfg.sunny.task.user.UserTask" forKey:@"task"];
    [rootDic setObject:@"getMembership" forKey:@"action"];
    [rootDic setObject:@"" forKey:@"serviceCode"];
    [rootDic setObject:@"" forKey:@"requestMessage"];
    [rootDic setObject:@"" forKey:@"responseMessage"];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:kCardCode]){
        [indiv_infoDic setObject:[[NSUserDefaults standardUserDefaults] stringForKey:kCardCode] forKey:@"user_seq"];
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
           
            //[self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            
            dicItems = nil;
            dicItems = [dicResponse objectForKey:@"indiv_info"];
            //NSString* sCardNm = dicItems[@"user_seq"];
            NSString* sGrade = dicItems[@"mb_grade"];
            NSString* sGradeNm = dicItems[@"mb_grade_nm"];
            NSString* sPoint = dicItems[@"mb_point"];
            NSLog(@"sPoint: ===============> %@", sPoint);
            NSString* sBadge = dicItems[@"badge"];
            
            //set kCardCode
            
            [[NSUserDefaults standardUserDefaults] setObject:sGrade forKey:kMb_grade];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:sGradeNm forKey:kMb_grade_nm];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:sPoint forKey:kMb_point];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:sBadge forKey:kBadge];
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
            
            [self loadContentsView];
            ////////////////////////////////////////////////////////////////////////////
            
            NSLog(@"getCookie end ==>" );
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];

}

- (void)loadContentsView
{
    for (UIView *subView in [self.view subviews]) {
        [subView removeFromSuperview];
    }
    
//    if (self.navigationController.navigationBar.isHidden) {
//        [self.navigationController setNavigationBarHidden:YES];
//    }
    [self.navigationController setNavigationBarHidden:YES];
    
    //[self.view setBackgroundColor:[UIColor blueColor]];
    
    menuView = nil;
    
    if(kScreenBoundsWidth > 400){
        menuView = [[leftMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth-130.0, kScreenBoundsHeight)];
    }else{
        menuView = [[leftMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kScreenBoundsHeight)];
    }
    
    //leftMenuView* menuView = [[leftMenuView alloc] initWithFrame:self.view.frame];
    //leftMenuView* menuView = [[leftMenuView alloc] initWithFrame:self.view.bounds];
    [menuView setDelegate:self];
    [self.view addSubview:menuView];
    
//    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [menuButton setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2, 36, 36)];
//    [menuButton setBackgroundImage:[UIImage imageNamed:@"icon_navi_home.png"] forState:UIControlStateNormal];
//    [menuButton setBackgroundImage:[UIImage imageNamed:@"icon_navi_login.png"] forState:UIControlStateHighlighted];
//    [menuButton addTarget:self action:@selector(touchMenuButton) forControlEvents:UIControlEventTouchUpInside];
//    //[menuButton setAccessibilityLabel:@"메뉴" Hint:@"왼쪽 메뉴로 이동합니다"];
//    [self.view addSubview:menuButton];
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - total menu delegate

- (void)didTouchMenuItem:(NSInteger)menuType
{
    //#1 Sunny Club
    //#2 Sunny Bank
    //#3 Event / 공지
    //#4 설정
    
//    configViewController* configController = [[configViewController alloc] init];
//    //[loginController setDelegate:self];
//    [self.navigationController pushViewController:configController animated:YES];
//    [self.navigationController setNavigationBarHidden:NO];
    
    
    //[self.mm_drawerController toggleDrawerSide:MMDrawerSideNone animated:YES completion:nil];
    [self.mm_drawerController closeDrawerAnimated:true completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(didTouchMenuItem:)]) {
        [self.delegate didTouchMenuItem:menuType];
    }
    
//    NSString *strMenuType = [NSString stringWithFormat:@"didTouchMenuItem menuType %d", menuType];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:strMenuType delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//    [alert show];
//    
//    //setting
//    if(menuType == 4){
//        LoginViewController *loginController = [[LoginViewController alloc] init];
//        //[loginController setDelegate:self];
//        [self.navigationController pushViewController:loginController animated:YES];
//        [self.navigationController setNavigationBarHidden:NO];
//        
//    }
}

- (void)didTouchCloseBtn
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"didTouchCloseBtn" delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//    [alert show];
    
    if ([self.delegate respondsToSelector:@selector(didTouchCloseBtn)]) {
        [self.delegate didTouchCloseBtn];
    }
    
}

- (void)didTouchLetterBtn
{
   if ([self.delegate respondsToSelector:@selector(didTouchLetterBtn)]) {
        [self.delegate didTouchLetterBtn];
    }
    
}

- (void)didTouchLogOutBtn
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"didTouchLogOutBtn" delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)didTouchLogInBtn
{
    if ([self.delegate respondsToSelector:@selector(didTouchLogOutBtn)]) {
        [self.delegate didTouchLogInBtn];
    }
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"didTouchLogInBtn" delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//    [alert show];
    
}

- (void)didTouchSummitBtn
{
    if ([self.delegate respondsToSelector:@selector(didTouchSummitBtn)]) {
        [self.delegate didTouchSummitBtn];
    }
    
}

- (void)didTouchAD
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"didTouchAD" delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//    [alert show];
    
    [self.mm_drawerController closeDrawerAnimated:true completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(didTouchAD)]) {
        [self.delegate didTouchAD];
    }
    
}

@end
