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




@interface AppDelegate ()
{
    UINavigationController  *_navigation;
    BOOL isTutoShow;
}
@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    
    
    NSString *strFirst = [[NSUserDefaults standardUserDefaults] stringForKey:kFirstExecY];
    
    if(strFirst == nil){
        isTutoShow = YES;
        //MYViewController *introductionView = [[MYViewController alloc] init];
        self.introductionView = [[MYViewController alloc] init];
        self.introductionView.delegate = self;
        [self.window setRootViewController:self.introductionView];
        ///////////////////////////////////////////////////////////////////////////////////////////
    }else{
        BOOL isTuto = [[NSUserDefaults standardUserDefaults] boolForKey:kTutoY];
        if(isTuto == YES){
            isTutoShow = YES;
            self.introductionView = [[MYViewController alloc] init];
            self.introductionView.delegate = self;
            [self.window setRootViewController:self.introductionView];
            
        }else if(isTuto == NO){
            NSLog(@"istotu view no");
            
        }else{
            isTutoShow = YES;
            self.introductionView = [[MYViewController alloc] init];
            self.introductionView.delegate = self;
            
            [self.window setRootViewController:self.introductionView];
        }
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // handler code here
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //lang
    
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
    
//    ////////////////////////////////
//    // 버전정보
//    NSString* strVerion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    NSString* strBundle = [[NSBundle mainBundle]bundleIdentifier];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:strVerion forKey:kCurrentVersion];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    [[Codeguard sharedInstance]setAppName:strBundle];
//    [[Codeguard sharedInstance]setAppVer:strVerion];
//    
//    NSString *serverURL=nil;
//    
//    serverURL = CODEGUARD_SERVER_URL;
//    
//    [[Codeguard sharedInstance]setChallengeRequestUrl:[NSString stringWithFormat:@"%@/CodeGuard/check.jsp", serverURL]];
//    [[Codeguard sharedInstance]setEtcData:@"버전업데이트및공지"];
//    [[Codeguard sharedInstance]setTimeOut:60.0f];
//    NSString* token=[[Codeguard sharedInstance]requestAndGetToken];
//    
//    token = [token stringByAddingPercentEscapesUsingEncoding:-2147482590];
//    token = [token stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
//    token = [token stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
//    token = [token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
//    
//    NSLog(@"token : %@", token);
// 
//    // 버전정보
//    NSMutableString *XMLString = [[NSMutableString alloc] init];
//    [XMLString appendString:@"plainXML="];
//    [XMLString appendString:@"<REQEUST task=\"sfg.sphone.task.sbank.Sbank_info\" action=\"doStart\">"];
//    [XMLString appendString:@"<서비스구분 value=\"SUNNYCLUBVN\" />"];
//    [XMLString appendString:@"<채널구분코드 value=\"92\" />\""];
//    [XMLString appendString:@"<QORTLS value=\"V3\" />"];
//    [XMLString appendString:@"<Client버전 value=\""];
//    [XMLString appendString:strVerion];
//    [XMLString appendString:@"\" />"];
//    [XMLString appendString:@"<배경구분 value=\"\" />"];
//    [XMLString appendString:@"<codeGuardName value=\"버전업데이트및공지\" />"];
//    [XMLString appendString:@"<COM_SUBCHN_KBN value=\"92\" />"];
//    [XMLString appendString:@"<VERSION value=\""];
//    [XMLString appendString:strVerion];
//    [XMLString appendString:@"\" />"];
//    [XMLString appendString:@"</REQEUST>"];
//    [XMLString appendString:@"&CODE_RESPONSE_TOKEN="];
//    [XMLString appendString:token];
//    //[XMLString appendString:@""];
//    
//    //XML 만들기
//////    NSString *strXML = [NSString stringWithFormat:@"plainXML=<REQUEST task=\"sfg.sphone.task.sbank.Sbank_info\" action=\"doStart\"><채널구분코드 value=\"%@\"/><서비스구분 value=\"%@\"/><Client버젼 value=\"%@\"/><배경구분 value=\"%@\"/><VERSION value=\"%@\"/><COM_SUBCHN_KBN value=\"%@\"/></REQUEST>", @"92", @"SUNNYCLUBVN", strVerion, @"", strVerion, @"92"];
//////    
////    //전문조합
////    NSString *postStr = [NSString stringWithFormat:@"%@&%@", strXML, token];
////    NSLog(@"postStr:%@",postStr);
//    
//    NSData* postData = [XMLString dataUsingEncoding:-2147481280];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:API_VERSION_INOF_URL]];
//    [request setHTTPBody:postData];
//    [request setHTTPMethod:@"POST"];
//    
//    NSURLResponse *resp = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&error];
//    
//    //<errorCode value="1999" 종료처리
//    //정식승인된 앱이 아닙니다
//    //앱버전정보
//    //현재 버전정보 --
//    //다운받는 URI
//    
//    //강제업뎅트
//    //강제업데이트
//    //업데이트 있느닞?
//    
//    NSString *rtnStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"return lowdata:%@",rtnStr);
//    
//    //////////////////////////////////////////////
//    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:rtnStr];
//    NSLog(@"dictionary: %@", xmlDoc);
//    
//    //1999 에러처리
//     NSDictionary *subDoc = xmlDoc[@"errorCode"];
//    NSString* strTemp = subDoc[@"_value"];
//    //* k
//    if([strTemp isEqualToString:@"1999"]){
//        
//        if([temp isEqualToString:@"ko"]){
//            strDesc = NOT_NOMAL_APP_KO;
//        }else if([temp isEqualToString:@"vi"]){
//            strDesc = NOT_NOMAL_APP_VI;
//        }
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strDesc delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//        [alert show];
//        
//        //잠시 죽이는것 주석
//        [self performSelector:@selector(appShutdown) withObject:nil afterDelay:6];
//    }
//    
//    //최신버전 -
//    subDoc = xmlDoc[@"최신버전"];
//    strTemp = subDoc[@"_value"];
//    //strTemp = @"1.0.1";
//    [[NSUserDefaults standardUserDefaults] setObject:strTemp forKey:kUpdateVersion];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    //업데이트 URI
//    subDoc = xmlDoc[@"최신신버전_URL"];
//    strTemp = subDoc[@"_value"];
//    
//    NSString* strLastVersionUrl = strTemp;
//    [[NSUserDefaults standardUserDefaults] setObject:strTemp forKey:kUpdateUri];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    //업데이트 ---
//    //강제업데이트  ---
//    subDoc = xmlDoc[@"강제업데이트여부"];
//    strTemp = subDoc[@"_value"];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:strTemp forKey:kForceUpdateY];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    if([strTemp isEqualToString:@"Y"]){
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strLastVersionUrl]];
//    }
//    
//    /////////////////////////////////////////////

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
    
    ////////////////////////////////////////////////
    
    

//    NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
//    const char * eucKRString = [XMLString cStringUsingEncoding:encoding];

//    NSString* strTemp = [XMLString stringByAddingPercentEscapesUsingEncoding:-2147482590];
//    //    ////////////////////////////////////////////////////////////////////////////////////////////////////////
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
////    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
////    NSMutableDictionary *rootDic = [NSMutableDictionary dictionary];
////    NSMutableDictionary *indiv_infoDic = [NSMutableDictionary dictionary];
//    
//    //NSLog(@"request date: %@", strTemp);
//    
//    //NSDictionary *parameters = @{@"plainXML": XMLString};
//    NSDictionary *parameters = XMLString;
//    
//    
//    [manager POST:API_VERSION_INOF_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"RESULT: %@", responseObject);
//        
//        
//        NSString *responseData = (NSString*) responseObject;
//        //NSString *strResponse = [NSString stringWithUTF8String:responseData];
//        //NSXMLParser* parser = null;
//        //NSString *yourXMLString = [[GDataXMLDocument rootElement] xmlString];
//        NSString * YOURSTRING = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",YOURSTRING);
//
//        
//        NSLog(@"RESULT: %@", responseObject);
////        NSArray *jsonArray = (NSArray *)responseData;
////        NSDictionary * dicResponse = (NSDictionary *)responseData;
////        
////        //warning
////        NSDictionary *dicItems = [dicResponse objectForKey:@"WARNING"];
////        
////        if(dicItems){
////            NSString* sError = dicItems[@"msg"];
////            NSLog(@"ERR ==> %@", sError );
////             NSLog(@"ERR ==> %@", sError );
////            
////        }else{
////            
////            dicItems = nil;
////            dicItems = [dicResponse objectForKey:@"indiv_info"];
////            NSString* sCardNm = dicItems[@"user_seq"];
////            
////            
////            
////            NSLog(@"getCookie end ==>" );
////        }
////        
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"Error: %@", error);
//        NSLog(@"Error: %@", error);
//        
//    }];

    
    
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
    
    return YES;
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
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - APNS Notification Regist Results
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"APNS 디바이스 토큰 등록 성공 : %@", deviceToken);
    //[[SettingManager sharedInstance] setDeviceToken:[NSString stringWithFormat:@"%@", deviceToken]];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"APNS 디바이스 토큰 등록 실패 : %@", error);
}

#pragma mark - Recieve Push Notifications
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 포그라운드에서의 푸쉬 처리
    [self receiveRemoteNotification:userInfo withAppState:YES];
}

- (void)receiveRemoteNotification:(NSDictionary *)info withAppState:(BOOL)onForeground
{
    NSLog(@"푸쉬 들어옴 %@", info);
    // 데이터가 없는 경우는 처리하지 않는다
    if (!info)
        return;
    
//    _pushOpenUrl = @"";
//    
//    // 앱 실행중일 떄
//    if (onForeground) {
//        
//        _pushOpenUrl = [info objectForKey:@"linkUrl"];
//        
//        if ([_pushOpenUrl rangeOfString:@"mail."].location != NSNotFound) {
//            
//            _pushOpenUrl = [_pushOpenUrl stringByReplacingOccurrencesOfString:@"mail."
//                                                                   withString:@"mmail."];
//            
//        }
//        
//        // url이 없는 경우
//        if ([_pushOpenUrl isEqualToString:@""] || !_pushOpenUrl) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[[info objectForKey:@"aps"] objectForKey:@"alert"]
//                                                           delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        
//        // url이 있는 경우
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[[info objectForKey:@"aps"] objectForKey:@"alert"]
//                                                           delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:@"열기", nil];
//            [alert show];
//            
//            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:_pushOpenUrl
//            //                                                           delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:@"열기", nil];
//            //            [alert show];
//            
//            
//        }
//    }
//    
//    // 앱 실행중이 아닐 때
//    else {
//        _pushOpenUrl = [[info objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"linkUrl"];
//        
//        if ([_pushOpenUrl rangeOfString:@"mail."].location != NSNotFound) {
//            
//            _pushOpenUrl = [_pushOpenUrl stringByReplacingOccurrencesOfString:@"mail."
//                                                                   withString:@"mmail."];
//            
//        }
//        
//        [self pushAction];
//    }
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




@end
