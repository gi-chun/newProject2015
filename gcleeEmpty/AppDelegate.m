//
//  AppDelegate.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 10. 21..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import "AppDelegate.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "defines.h"
#import "amsLibrary.h"
#import "AFHTTPRequestOperationManager.h"
#import "BTWCodeguard.h"
#import "AFHTTPRequestOperation.h"
#import "KTBiOS.h"
#import "XMLDictionary.h"
#include <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import "SBJson.h"
#import "SafeOnPushClient.h"

@interface AppDelegate () <SafeOnPushClientDelegate>
{
    UINavigationController  *_navigation;
    BOOL isTutoShow;
    NSTimer         *netSessionTimer;
    
    NSMutableData           *_receiveData;
    NSInteger bannerType; //0:left main, 1:main
}
@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    
    
//    NSString *strFirst = [[NSUserDefaults standardUserDefaults] stringForKey:kFirstExecY];
//    
//    if(strFirst == nil){
//        isTutoShow = YES;
//        //MYViewController *introductionView = [[MYViewController alloc] init];
//        self.introductionView = [[MYViewController alloc] init];
//        self.introductionView.delegate = self;
//        [self.window setRootViewController:self.introductionView];
//        ///////////////////////////////////////////////////////////////////////////////////////////
//    }else{
        BOOL isTuto = [[NSUserDefaults standardUserDefaults] boolForKey:kTutoY];
        if(isTuto == NO){
            isTutoShow = YES;
            self.introductionView = [[MYViewController alloc] init];
            self.introductionView.delegate = self;
            [self.window setRootViewController:self.introductionView];
            
        }else{
           isTutoShow = NO;
//            self.introductionView = [[MYViewController alloc] init];
//            self.introductionView.delegate = self;
//            
//            [self.window setRootViewController:self.introductionView];
        }
    //}
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // handler code here
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (userInfo != nil) {
        NSLog(@"%@", userInfo);
        
        [[SafeOnPushClient sharedInstance] receiveNotification:userInfo delegate:self];
    }

    
    //
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    [[NSUserDefaults standardUserDefaults] setObject:currSysVer forKey:kosVer];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //loginY init
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // uuid
    NSString* uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"UDID:: %@", uniqueIdentifier);
    [[NSUserDefaults standardUserDefaults] setObject:uniqueIdentifier forKey:kUUID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    [[NSUserDefaults standardUserDefaults] setObject:versionString forKey:kCurrentVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //set language
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* languages = [userDefaults objectForKey:@"AppleLanguages"];
    NSString* localLang = languages[0];
    NSString* currentLang = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    
    NSRange range = {0,2};
    localLang = [localLang substringWithRange:range];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:klang]){
        NSLog(@"klang:: %@", currentLang);
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:localLang forKey:klang];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }


    //////////////////////////////////////////////////////////////////////////////
    // 앱의 푸쉬 수신여부 설정
//    if (IsAtLeastiOSVersion(@"8.0")) {
//        UIUserNotificationType types = UIUserNotificationTypeBadge |
//        UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//        
//        UIUserNotificationSettings *mySettings =
//        [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        
//        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        
//    }else{
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    }
    
    
     //////////////////////////////////////////////////////////////////////////////
    
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor magentaColor];
//    [self.window makeKeyAndVisible];
    
//    SplashViewController *splashVC = [[SplashViewController alloc] initWithNibName:NibName(@"SplashViewController") bundle:nil];
//    _navigation = [[UINavigationController alloc] initWithRootViewController:splashVC];
    
//    mainViewController *mainViewCnr = [[mainViewController alloc] init];
//    _navigation = [[UINavigationController alloc] initWithRootViewController:mainViewCnr];
//    [_navigation setNavigationBarHidden:YES];
//    
//    self.window.rootViewController = _navigation;
//    [self.window makeKeyAndVisible];

    //    self.window.rootViewController = self.mainViewController;
    
    ////////////////////////////////
    
    amsLibrary *ams = [[amsLibrary alloc] init];
    NSInteger result = [ams a3142:@"AHN_3379024345_TK"]; //AHN_3379024345_TK, 201 크면 안되면
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSInteger roundedValue = round(interval);
    
    NSLog(@"Jailbreak Result : %ld" , (long)result);
    NSLog(@"time interval  : %ld" , (long)roundedValue);
    NSLog(@"checking Result : %ld" , (long)(result - roundedValue));
    NSInteger lastResult = (result - roundedValue);
    
    NSString* temp;
    NSString* strDesc;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        strDesc = JAILBREAK_CHK_KO;
    }else if([temp isEqualToString:@"vi"]){
        strDesc = JAILBREAK_CHK_VI;
    }
    
    if(lastResult > 200)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strDesc delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(appShutdown) withObject:nil afterDelay:6];
    }
    
    ////////////////////////////////
    // 버전정보
    NSString* strVerion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString* strBundle = [[NSBundle mainBundle]bundleIdentifier];
    
    [[NSUserDefaults standardUserDefaults] setObject:strVerion forKey:kCurrentVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[Codeguard sharedInstance]setAppName:strBundle];
    [[Codeguard sharedInstance]setAppVer:strVerion];
    
    NSString *serverURL=nil;
    
    serverURL = CODEGUARD_SERVER_URL;
    
    [[Codeguard sharedInstance]setChallengeRequestUrl:[NSString stringWithFormat:@"%@/CodeGuard/check.jsp", serverURL]];
    [[Codeguard sharedInstance]setEtcData:@"버전업데이트및공지"];
    [[Codeguard sharedInstance]setTimeOut:60.0f];
    NSString* token=[[Codeguard sharedInstance]requestAndGetToken];
    
    token = [token stringByAddingPercentEscapesUsingEncoding:-2147482590];
    token = [token stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    token = [token stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    token = [token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSLog(@"token : %@", token);
 
    // 버전정보
    NSMutableString *XMLString = [[NSMutableString alloc] init];
    [XMLString appendString:@"plainXML="];
    [XMLString appendString:@"<REQEUST task=\"sfg.sphone.task.sbank.Sbank_info\" action=\"doStart\">"];
    [XMLString appendString:@"<서비스구분 value=\"SUNNYCLUBVN\" />"];
    [XMLString appendString:@"<채널구분코드 value=\"92\" />\""];
    [XMLString appendString:@"<QORTLS value=\"V3\" />"];
    [XMLString appendString:@"<Client버전 value=\""];
    [XMLString appendString:strVerion];
    [XMLString appendString:@"\" />"];
    [XMLString appendString:@"<배경구분 value=\"\" />"];
    [XMLString appendString:@"<codeGuardName value=\"버전업데이트및공지\" />"];
    [XMLString appendString:@"<COM_SUBCHN_KBN value=\"92\" />"];
    [XMLString appendString:@"<VERSION value=\""];
    [XMLString appendString:strVerion];
    [XMLString appendString:@"\" />"];
    [XMLString appendString:@"</REQEUST>"];
    [XMLString appendString:@"&CODE_RESPONSE_TOKEN="];
    [XMLString appendString:token];
    //[XMLString appendString:@""];
    
    //XML 만들기
////    NSString *strXML = [NSString stringWithFormat:@"plainXML=<REQUEST task=\"sfg.sphone.task.sbank.Sbank_info\" action=\"doStart\"><채널구분코드 value=\"%@\"/><서비스구분 value=\"%@\"/><Client버젼 value=\"%@\"/><배경구분 value=\"%@\"/><VERSION value=\"%@\"/><COM_SUBCHN_KBN value=\"%@\"/></REQUEST>", @"92", @"SUNNYCLUBVN", strVerion, @"", strVerion, @"92"];
////    
//    //전문조합
//    NSString *postStr = [NSString stringWithFormat:@"%@&%@", strXML, token];
//    NSLog(@"postStr:%@",postStr);
    
    NSData* postData = [XMLString dataUsingEncoding:-2147481280];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:API_VERSION_INOF_URL]];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    
    NSURLResponse *resp = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&error];
    
    //<errorCode value="1999" 종료처리
    //정식승인된 앱이 아닙니다
    //앱버전정보
    //현재 버전정보 --
    //다운받는 URI
    
    //강제업뎅트
    //강제업데이트
    //업데이트 있느닞?
    
    NSString *rtnStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"return lowdata:%@",rtnStr);
    
    //////////////////////////////////////////////
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:rtnStr];
    NSLog(@"dictionary: %@", xmlDoc);
    
    //1999 에러처리
     NSDictionary *subDoc = xmlDoc[@"errorCode"];
    NSString* strTemp = subDoc[@"_value"];
    //* k
    if([strTemp isEqualToString:@"1999"]){
        
        if([temp isEqualToString:@"ko"]){
            strDesc = NOT_NOMAL_APP_KO;
        }else if([temp isEqualToString:@"vi"]){
            strDesc = NOT_NOMAL_APP_VI;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strDesc delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        
        //잠시 죽이는것 주석
        [self performSelector:@selector(appShutdown) withObject:nil afterDelay:6];
    }
    
    //최신버전 -
    subDoc = xmlDoc[@"최신버전"];
    strTemp = subDoc[@"_value"];
    //strTemp = @"1.0.1";
    [[NSUserDefaults standardUserDefaults] setObject:strTemp forKey:kUpdateVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //업데이트 URI
    subDoc = xmlDoc[@"최신신버전_URL"];
    strTemp = subDoc[@"_value"];
    
    NSString* strLastVersionUrl = strTemp;
    [[NSUserDefaults standardUserDefaults] setObject:strTemp forKey:kUpdateUri];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //업데이트 ---
    //강제업데이트  ---
    subDoc = xmlDoc[@"강제업데이트여부"];
    strTemp = subDoc[@"_value"];
    
    [[NSUserDefaults standardUserDefaults] setObject:strTemp forKey:kForceUpdateY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if([strTemp isEqualToString:@"Y"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strLastVersionUrl]];
    }
    
    /////////////////////////////////////////////

    ////////////////////////////////////////////////
    //KTB 프록시 체크
    
    if([self isCellNetwork] == NO){
        
        NSString * returnStr = checkProxy();
        
        if([returnStr isEqualToString:@"y"]){
            
            if([temp isEqualToString:@"ko"]){
                strDesc = USE_PROXY_KO;
            }else if([temp isEqualToString:@"vi"]){
                strDesc = USE_PROXY_VI;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strDesc delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(appShutdown) withObject:nil afterDelay:6];
            
        }
//        NSString* checkProxy(void);
//        NSString* getProxyInfo(void);
    }
    
    //dowload banner file
    [self getListBanner];
    
    //left main
    bannerType = 0;
    //NSString *url = [fileUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = @"";
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *downloadConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [downloadConnection start];
    // main

    
    //ko  set language
    //[languages insertObject:@"de" atIndex:0]; // ISO639-1
    //[[NSUserDefaults standardUserDefaults] synchronize];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //cookie
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSMutableArray* cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
    NSLog(@"cookie dictionary found is %@",cookieDictionary);
    
    for (int i=0; i < cookieDictionary.count; i++)
    {
        NSLog(@"cookie found is %@",[cookieDictionary objectAtIndex:i]);
        NSMutableDictionary* cookieDictionary1 = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDictionary1];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        
    }
    
    if(isTutoShow == NO){
        [self didFinishIntro];
    }
    
    //session continue
    [self startSessionTimer];
    
    return YES;
}

- (void) getListBanner{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *rootDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *indiv_infoDic = [NSMutableDictionary dictionary];
    
    //
    [rootDic setObject:COMMON_TASK_USR forKey:@"task"];
    [rootDic setObject:@"getListBanner" forKey:@"action"];
    [rootDic setObject:@"" forKey:@"serviceCode"];
    [rootDic setObject:@"" forKey:@"requestMessage"];
    [rootDic setObject:@"" forKey:@"responseMessage"];
    
    [indiv_infoDic setObject:@"2" forKey:@"d_1"];
    
    [sendDic setObject:rootDic forKey:@"root_info"];
    [sendDic setObject:indiv_infoDic forKey:@"indiv_info"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:sendDic];
    NSLog(@"request json: %@", jsonString);
    
    NSDictionary *parameters = @{@"plainJSON": jsonString};
    
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
    
    [manager POST:API_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSString *responseData = (NSString*) responseObject;
        NSArray *jsonArray = (NSArray *)responseData;
        NSDictionary * dicResponse = (NSDictionary *)responseData;
        
        //warning
        NSDictionary *dicItems = [dicResponse objectForKey:@"WARNING"];
        
        if(dicItems){
            NSString* sError = dicItems[@"msg"];
            
            
        }else{
            
//            dicItems = nil;
//            dicItems = [dicResponse objectForKey:@"indiv_info"];
//            NSString* sCardNm = dicItems[@"user_seq"];
//            
//            //set kCardCode
//            [[NSUserDefaults standardUserDefaults] setObject:sCardNm forKey:kLeftMainBannerUrl];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            //set id, pwd
//            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kMainBannerUrl];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            NSLog(@"Response ==> %@", responseData);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];

    
}

#pragma mark -  NSURLConnection Delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
    
    NSLog(@"banner file download:%lu", (unsigned long)[_receiveData length]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    // 파일쓰기
    NSError *error = nil;
    NSString *fileName  = @"";
    if(bannerType == 0){ //left main
        fileName  = @"sunny_banner_left.png";
    }else{               //main
        fileName  = @"sunny_banner_main.png";
    }
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    [_receiveData writeToFile:[NSString stringWithFormat:@"%@/%@", docsDir, fileName] options:NSDataWritingAtomic error:&error];
    
    if (!error) {
        
        NSString *path = [docsDir stringByAppendingPathComponent:fileName];
        NSLog(@"file save path:%@", path);
        
        if ([[NSFileManager defaultManager] fileExistsAtPath: path])
        {
            NSLog(@"file write success %@", error);
        }
        
    } else {
        NSLog(@"file write error %@", error);
    }
    
    _receiveData = nil;
    
    [self anotherBanner];
}

- (void)anotherBanner{
    
    bannerType = 1;
    //left main
    //NSString *url = [fileUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = @"";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *downloadConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [downloadConnection start];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
    

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    amsLibrary *ams = [[amsLibrary alloc] init];
    NSInteger result = [ams a3142:@"AHN_3379024345_TK"]; //AHN_3379024345_TK, 201 크면 안되면
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSInteger roundedValue = round(interval);
    
    NSLog(@"Jailbreak Result : %ld" , (long)result);
    NSLog(@"time interval  : %ld" , (long)roundedValue);
    NSLog(@"checking Result : %ld" , (long)(result - roundedValue));
    NSInteger lastResult = (result - roundedValue);
    
    NSString* temp;
    NSString* strDesc;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        strDesc = JAILBREAK_CHK_KO;
    }else if([temp isEqualToString:@"vi"]){
        strDesc = JAILBREAK_CHK_VI;
    }
    
    if(lastResult > 200)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strDesc delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(appShutdown) withObject:nil afterDelay:6];
    }

    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginY];
    if(isLogin == YES){
        
        //session continue
        [self startSessionTimer];
        
        //login status -- to continue session, login data send to server
        
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
        
        NSString* strEmail_id = [[NSUserDefaults standardUserDefaults] stringForKey:kId];
        NSString* strPinNo = [[NSUserDefaults standardUserDefaults] stringForKey:kPwd];
        
        [indiv_infoDic setObject:strEmail_id forKey:@"email_id"];
        [indiv_infoDic setObject:strPinNo forKey:@"pinno"];
        
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
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoginY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                NSLog(@"getCookie end ==>" );
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"session continue - relogin Error: %@", error);
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }];
        
    }

    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - APNS Notification Regist Results
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"apns device token register success : %@", deviceToken);
    NSLog(@"device token : %@", [deviceToken description]);
    [[SafeOnPushClient sharedInstance] setDeviceToken:deviceToken];
    
    NSString *oriToken = [NSString stringWithFormat:@"%@", deviceToken];
    
    NSString *deviceTokens = [[[[oriToken description]
                                stringByReplacingOccurrencesOfString:@"<" withString:@""]
                               stringByReplacingOccurrencesOfString:@">" withString:@""]
                              stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    
//    NSCharacterSet *angleBrackets = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
//    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:angleBrackets];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:receivedDataString delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    [alert show];
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokens forKey:kUserDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[[SettingManager sharedInstance] setDeviceToken:[NSString stringWithFormat:@"%@", deviceToken]];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"apns device token register fail  : %@", error);
}

#pragma mark - Recieve Push Notifications
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[SafeOnPushClient sharedInstance] receiveNotification:userInfo delegate:self];
    NSLog(@"didReceiveRemoteNotification : \n%@", userInfo);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"push test" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];

    
    NSDictionary *dic = [userInfo objectForKey:@"aps"];
    
    NSString *message = [dic objectForKey:kSOAlert];
    NSString *messageId = [dic objectForKey:kSOMessageId];
    
    // 포그라운드에서의 푸쉬 처리
    [self receiveRemoteNotification:userInfo withAppState:YES];
}

- (void)receiveRemoteNotification:(NSDictionary *)info withAppState:(BOOL)onForeground
{
    NSLog(@"푸쉬 들어옴 %@", info);
    // 데이터가 없는 경우는 처리하지 않는다
    if (!info)
        return;
    
    NSString* _pushOpenUrl = @"";
    
    // 앱 실행중일 떄
    if (onForeground) {
        
        _pushOpenUrl = [info objectForKey:@"linkUrl"];
        
        if ([_pushOpenUrl rangeOfString:@"mail."].location != NSNotFound) {
            
            _pushOpenUrl = [_pushOpenUrl stringByReplacingOccurrencesOfString:@"mail."
                                                                   withString:@"mmail."];
            
        }
        
        // url이 없는 경우
        if ([_pushOpenUrl isEqualToString:@""] || !_pushOpenUrl) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[[info objectForKey:@"aps"] objectForKey:@"alert"]
                                                           delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        // url이 있는 경우
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[[info objectForKey:@"aps"] objectForKey:@"alert"]
                                                           delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:@"열기", nil];
            [alert show];
            
        }
    }
    
    // 앱 실행중이 아닐 때
    else {
        _pushOpenUrl = [[info objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"linkUrl"];
        
        if ([_pushOpenUrl rangeOfString:@"mail."].location != NSNotFound) {
            
            _pushOpenUrl = [_pushOpenUrl stringByReplacingOccurrencesOfString:@"mail."
                                                                   withString:@"mmail."];
            
        }
        
        //[self pushAction];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        //[self pushAction];
    }
}

- (void)pushAction
{
    
}

#pragma mark - Intro
- (void)didFinishIntro
{
    NSLog(@"finish intro ");
    
//    UIViewController * leftSideDrawerViewController = [[LeftTotalViewController alloc] initWithNibName:@"leftTotalViewController" bundle:nil];
    UIViewController * leftSideDrawerViewController = [[leftViewController alloc] init];
    _gLeftViewController = (leftViewController*)leftSideDrawerViewController;
//    _homeWebViewController = [[WebViewController alloc] init];
//    [_homeWebViewController setUrl:SUNNY_CLUB_URL];
    UIViewController * centerViewController = [[WebViewController alloc] init];
    _homeWebViewController = (WebViewController*)centerViewController;
    [_homeWebViewController setDelegate:_gLeftViewController];
    [_gLeftViewController setDelegate:_homeWebViewController];
    [_homeWebViewController setUrl:SUNNY_CLUB_URL];
    
    //    UIViewController * rightSideDrawerViewController = [[MMExampleRightSideDrawerViewController alloc] init];
    
    //    UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:centerViewController];
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    [navigationController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];
    
    //    UINavigationController * rightSideNavController = [[UINavigationController alloc] initWithRootViewController:rightSideDrawerViewController];
    //    [rightSideNavController setRestorationIdentifier:@"MMExampleRightNavigationControllerRestorationKey"];
    
    UINavigationController * leftSideNavController = [[UINavigationController alloc] initWithRootViewController:leftSideDrawerViewController];
    [leftSideNavController setRestorationIdentifier:@"MMExampleLeftNavigationControllerRestorationKey"];
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:navigationController
                             leftDrawerViewController:leftSideNavController
                             rightDrawerViewController:nil];
    [self.drawerController setShowsShadow:YES];
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumRightDrawerWidth:150.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    [self.window setRootViewController:self.drawerController];
}

/*
 isNetworkReachable() 메소드는 wifi든 3G든 네트워크의 연결여부를 알려준다. (YES일경우 네트워크 연결 됨. NO 일경우 네트워크 연결안됨.)
 
 isCellNetwork() 메소드는 3G냐 wifi냐를 알려준다. (YES 일경우 3G망으로 접속, NO 일경우 WIFI로 접속 한경우)

 
 */
//-(BOOL) isNetworkReachable
//{
//    struct sockaddr_in zeroAddr;
//    bzero(&zeroAddr, sizeof(zeroAddr));
//    zeroAddr.sin_len = sizeof(zeroAddr);
//    zeroAddr.sin_family = AF_INET;
//    SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithAddress(NULL, (structsockaddr *)&zeroAddr);
//    SCNetworkReachabilityFlags flag;
//    SCNetworkReachabilityGetFlags(target, &flag);
//    if(flag & kSCNetworkFlagsReachable){
//        return YES;
//    }else {
//        return NO;
//    }
//}

-(BOOL)isCellNetwork{
    struct sockaddr_in zeroAddr;
    bzero(&zeroAddr, sizeof(zeroAddr));
    zeroAddr.sin_len = sizeof(zeroAddr);
    zeroAddr.sin_family = AF_INET;
    SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddr);
    SCNetworkReachabilityFlags flag;
    SCNetworkReachabilityGetFlags(target, &flag);
    if(flag & kSCNetworkReachabilityFlagsIsWWAN){
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - startNetCheckTimer

- (void)startSessionTimer    // 타이머 시작
{
    if (netSessionTimer) {
        [netSessionTimer invalidate];
        netSessionTimer = nil;
    }
    
    netSessionTimer = [NSTimer scheduledTimerWithTimeInterval:SESSION_CONTINUE_SEND target:self selector:@selector(onTick) userInfo:nil repeats:YES];
}

- (void)stopSessionTimer    // 타이머 시작
{
    
    if (netSessionTimer) {
        [netSessionTimer invalidate];
        netSessionTimer = nil;
    }
    
}

- (void)onTick{
    
    NSLog(@"send session continue Tick...");
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginY];
    if(isLogin == YES){
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
        NSMutableDictionary *rootDic = [NSMutableDictionary dictionary];
        NSMutableDictionary *indiv_infoDic = [NSMutableDictionary dictionary];
        
        [rootDic setObject:@"" forKey:@"task"];
        [rootDic setObject:@"" forKey:@"action"];
        [rootDic setObject:@"A3140U" forKey:@"serviceCode"];
        [rootDic setObject:@"" forKey:@"requestMessage"];
        [rootDic setObject:@"" forKey:@"responseMessage"];
        
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
                
            }else{
                
                dicItems = nil;
                dicItems = [dicResponse objectForKey:@"indiv_info"];
                NSString* sCardNm = dicItems[@"user_seq"];
                
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
                
                NSLog(@"getCookie end ==>" );
                
            }
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@", error);
            
        }];

        
    }

    
}





@end
