//
//  WebViewController.m
//
//  Created by gclee on 2015. 10. 28..
//  Copyright (c) 2015년 gclee. All rights reserved.
//

#import "WebViewController.h"
#import "WebView.h"
#import "configViewController.h"
#import "NavigationBarView.h"
#import "UIViewController+MMDrawerController.h"
#import "LoginViewController.h"
#import "ToolBarView.h"
#import "setInforViewController.h"


@interface WebViewController () <WebViewDelegate, ToolBarViewDelegate>
{
    NSString *webViewUrl;
    NSURLRequest *webViewRequest;
    
    BOOL isSearchText;
    
    //CPPopupBrowserView *popUpBrowserView;
    
    NSString *zoomViewerScheme;
    
    //ShakeModule *shakeModule;
    
    NavigationBarView *navigationBarView;
    ToolBarView *toolBarView;
    //CPWebviewControllerFullScreenMode fullScreenMode;
    
    UIView *statusBarView;
    UIView *dummyView;
    
    BOOL isSkipParent;
    BOOL isIgnore;
    BOOL isProduct;
    
    NSInteger gShowNavigation;
    
}

//@property (nonatomic, strong) CPNavigationBarView *navigationBarView;

@end

@implementation WebViewController

- (void)setUrl:(NSString *)url
{
    webViewUrl = url;
}

- (id)initWithUrl:(NSString *)url
{
    if (self = [super init]) {
        webViewUrl = url;
    }
    
    return self;
}

- (id)initWithUrl:(NSString *)url isPop:(BOOL)isPop
{
    if (self = [self initWithUrl:url]) {
        isSkipParent = isPop;
    }
    
    return self;
}

- (id)initWithUrl:(NSString *)url isPop:(BOOL)isPop isIgnore:(BOOL)ignore
{
    if (self = [self initWithUrl:url]) {
        isSkipParent = isPop; //백버튼을 눌렀을때 WebViewController 패스
        isIgnore = ignore; //상품상세 url이 들어왔을 경우 무한루프 방지
    }
    
    return self;
}

- (id)initWithUrl:(NSString *)url isPop:(BOOL)isPop isIgnore:(BOOL)ignore isProduct:(BOOL)product
{
    if (self = [self initWithUrl:url]) {
        isSkipParent = isPop; //백버튼을 눌렀을때 WebViewController 패스
        isIgnore = ignore; //상품상세 url이 들어왔을 경우 무한루프 방지
        isProduct = product; //상품상세 native에서 들어왔을 경우 웹뷰내에 상품상세url이 호출되면 navigation pop (ex. 주문에서 history back)
    }
    
    return self;
}

- (id)initWithRequest:(NSURLRequest *)request
{
    if (self = [super init]) {
        webViewRequest = request;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /////////////////////
    BOOL isForceMember = [[NSUserDefaults standardUserDefaults] boolForKey:kForceMemberViewY];
    if(isForceMember == YES){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kForceMemberViewY];
        
        setInforViewController *SetInforViewController = [[setInforViewController alloc] init];
        [SetInforViewController setDelegate:self];
        [self.navigationController pushViewController:SetInforViewController animated:YES];
    }

    
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];

    // iOS7 Layout
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
//    for (UIView *subView in self.navigationController.navigationBar.subviews) {
//        if ([subView isKindOfClass:[NavigationBarView class]]) {
//            [subView removeFromSuperview];
//        }
//    }
//    
//    // Navigation : viewDidLoad에서 한번, viewDidAppear에서 한번 더 한다.
//    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationController.navigationBar addSubview:[self navigationBarView:0]]; //defaut gnb

    // Layout
    [self initLayout];
    
    //fullScreenMode
    //fullScreenMode = CPWebviewControllerFullScreenModeNone;
    
    // setCurrentWebViewController
    //[[CPCommonInfo sharedInfo] setCurrentWebViewController:self];
    
    // CPSchemeManager delegate
    //[[CPSchemeManager sharedManager] setDelegate:self];
    NSLog(@"CPSchemeManager setDelegate WebViewController");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Layout
    [self initLayout];
    
    if (webViewRequest) {
        [self.webView loadRequest:webViewRequest];
    }
    else {
        if (webViewUrl.length > 0) {
            
            NSString *replaced = [webViewUrl stringByReplacingOccurrencesOfString:@"locale=ko"
                                                                withString:@"locale=%@"];
            
            replaced = [replaced stringByReplacingOccurrencesOfString:@"locale=vi"
                                                                       withString:@"locale=%@"];
            
            webViewUrl = replaced;
            
            NSString* gLocalLang = @"";
            NSString *callUrl = @"";
            
            gLocalLang =[[NSUserDefaults standardUserDefaults] stringForKey:klang];
            callUrl = [NSString stringWithFormat:webViewUrl, gLocalLang];
            
            NSURL *Nurl = [NSURL URLWithString:callUrl];
            NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:Nurl];
            
            NSMutableString *cookieStringToSet = [[NSMutableString alloc] init];
            NSHTTPCookie *cookie;
            
            for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
                NSLog(@"%@=%@", cookie.name, cookie.value);
                [cookieStringToSet appendFormat:@"%@=%@;",cookie.name, cookie.value];
            }
                                
            if (cookieStringToSet.length) {
                
                [mutableRequest setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
                NSLog(@"Cookie : %@", cookieStringToSet);
            }
            
            [self openWebView:callUrl mutableRequest:mutableRequest];
            
            webViewUrl = @"";
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Navigation : viewDidLoad에서 한번, viewDidAppear에서 한번 더 한다.
//    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationController.navigationBar addSubview:[self navigationBarView:0]];

    //Exception URL은 풀스크린으로 보여줌 (저장된 상태값으로 보여줌. PC보기에서 URL을 체킹하지 못하는 오류가 있음.)
//    if (fullScreenMode != CPWebviewControllerFullScreenModeNone) {
//        [self setExceptionFrame:(fullScreenMode == CPWebviewControllerFullScreenModeOn)];
//    }
    
//    if (isSkipParent) {
//        NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
//        
//        if (viewControllers.count >= 2) {
//            [viewControllers removeObjectAtIndex:viewControllers.count-2];
//            self.navigationController.viewControllers = viewControllers;
//        }
//        
//        isSkipParent = NO;
//    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // setCurrentWebViewController
    //[[CPCommonInfo sharedInfo] setCurrentWebViewController:nil];
    
    //[self.webView setHiddenPopover:YES];
}

- (void)didReceiveMemoryWarning
    {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (void)initLayout
{
    if(self.webView == nil){
        //    self.webView = [[WebView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kScreenBoundsHeight-kToolBarHeight-kNavigationHeight-kWebViewMarginY*2) isSub:YES];
        self.webView = [[WebView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kScreenBoundsHeight-kNavigationHeight-kStatusBarY) isSub:YES];
        [self.webView setDelegate:self];
        [self.webView setHiddenToolBarView:NO];
        [self.view addSubview:self.webView];
    }
    
//    toolBarView = [[ToolBarView alloc] initWithFrame:CGRectMake(0, kScreenBoundsHeight-kToolBarHeight*2, kScreenBoundsWidth, kToolBarHeight*2) toolbarType:1];
//    [toolBarView setDelegate:self];
//    [toolBarView setHidden:NO];
//    [self.view addSubview:toolBarView];
    
}

- (NavigationBarView *)navigationBarView:(NSInteger)navigationType
{
    if( navigationType == 4){
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeightHide) type:navigationType];
    }else{
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType];
    }
    
    [navigationBarView setDelegate:self];
    
    
    //    // 개발자모드 진입점
    //    [self initDeveloperInfo:logoButton];
    //    //    }
    
    return navigationBarView;
}

#pragma mark - Private Methods

- (void)openWebView:(NSString *)url request:(NSURLRequest *)request
{
    //BOOL isException = [CPCommonInfo isExceptionalUrl:url];
    BOOL isException = false;
    CGRect webViewFrame;
    
    // Exception URL은 네비게이션바없는 풀화면으로 보여줌
    if (isException) {
        [self.navigationController setNavigationBarHidden:YES];
        
        if ([SYSTEM_VERSION intValue] > 6) {
            webViewFrame = CGRectMake(0, 0, kScreenBoundsWidth, kScreenBoundsHeight-kNavigationHeight);
        }
        else {
            webViewFrame = CGRectMake(0, 0, kScreenBoundsWidth, kScreenBoundsHeight-kNavigationHeight);
        }
    }
    else {
        [self.navigationController setNavigationBarHidden:NO];
        webViewFrame = CGRectMake(0, 0, kScreenBoundsWidth, kScreenBoundsHeight-kNavigationHeight);
    }
    
    if (self.webView) {
        [self.webView setFrame:webViewFrame];
        [self.webView updateFrame];
        
        if (request) {
            [self.webView loadRequest:request];
        }
        else {
            [self.webView open:url];
        }
    }
    else {
        self.webView = [[WebView alloc] initWithFrame:webViewFrame isSub:YES];
        [self.webView setDelegate:self];
        [self.webView open:url];
        [self.webView setHiddenToolBarView:NO];
        [self.view addSubview:self.webView];
    }
}

//
- (void)openWebView:(NSString *)url mutableRequest:(NSMutableURLRequest *)request
{
    
    //BOOL isException = [CPCommonInfo isExceptionalUrl:url];
    BOOL isException = false;//중요 중요
    CGRect webViewFrame;
    

NSInteger showNavigation = 1; //1: show, 2: hidden
    
#ifdef TEST_SERVER_DEFINE
    if(!([url rangeOfString:@"vntst.shinhanglobal.com/sunny/sunnyclub/index.jsp"].location == NSNotFound)){
    //if(!([url rangeOfString:@"vntst.shinhanglobal.com/sunny/sunnyclub/index_2nd.jsp"].location == NSNotFound)){
        //TODO
        NSLog(@"문자열이 포함됨");
        gShowNavigation = 0;
        [self initNavigation:0];
        
    }else if (!([url rangeOfString:@"vntst.shinhanglobal.com/sunny/bank/main.jsp"].location == NSNotFound)){
        //TODO
        NSLog(@"문자열이 포함됨");
        gShowNavigation = 3;
        [self initNavigation:3];
    }else{
        isException = true;
        gShowNavigation = 4;
        [self initNavigation:4];
    }
#else
    if(!([url rangeOfString:@"online.shinhan.com.vn/sunny/sunnyclub/index.jsp"].location == NSNotFound)){
        //TODO
        NSLog(@"문자열이 포함됨");
        gShowNavigation = 0;
        [self initNavigation:0];
        
    }else if (!([url rangeOfString:@"online.shinhan.com.vn/sunny/bank/main.jsp"].location == NSNotFound)){
        //TODO
        NSLog(@"문자열이 포함됨");
        gShowNavigation = 3;
        [self initNavigation:3];
    }else{
        isException = true;
        gShowNavigation = 4;
        [self initNavigation:4];
    }
#endif
    
    //[self.webView stop];
    
    // Exception URL은 네비게이션바없는 풀화면으로 보여줌
    if (isException) {
        [self.navigationController setNavigationBarHidden:YES];
        
        //16
        if ([SYSTEM_VERSION intValue] > 6) {
            //webViewFrame = CGRectMake(0, 15, kScreenBoundsWidth, kScreenBoundsHeight-250);
            webViewFrame = CGRectMake(0, kStatusBarY, kScreenBoundsWidth, kScreenBoundsHeight-(kToolBarHeight+kStatusBarY));
        }
        else {
            //webViewFrame = CGRectMake(0, 15, kScreenBoundsWidth, kScreenBoundsHeight-250);
            webViewFrame = CGRectMake(0, kStatusBarY, kScreenBoundsWidth, kScreenBoundsHeight-(kToolBarHeight+kStatusBarY));
        }
        //[self.webView reCreateToolbar];
    }
    else {
        [self.navigationController setNavigationBarHidden:NO];
        //webViewFrame = CGRectMake(0, 0, kScreenBoundsWidth, kScreenBoundsHeight-kNavigationHeight);
        webViewFrame = CGRectMake(0, kNavigationHeight+kToolBarHeight+kStatusBarY, kScreenBoundsWidth, kScreenBoundsHeight-(kNavigationHeight+kToolBarHeight+kStatusBarY));
    }
    
    if (self.webView) {
        [self.webView setFrame:webViewFrame];
        [self.webView updateFrame];
        
        if (request) {
            [self.webView loadRequest:request];
        }
        else {
            [self.webView open:url];
        }
    }
    else {
        self.webView = [[WebView alloc] initWithFrame:webViewFrame isSub:YES];
        [self.webView setDelegate:self];
        
        if (request) {
            [self.webView loadRequest:request];
        }
        else {
            [self.webView open:url];
        }
        
        [self.webView setHiddenToolBarView:NO];
        [self.view addSubview:self.webView];
    }
}


- (void)openSettingViewController
{
//    SetupController *viewController = [[SetupController alloc] init];
//    viewController.delegate = self;
//    
//    [self.navigationController pushViewController:viewController animated:YES];
}

- (NSString *)removeQueryStringWithUrl:(NSString *)url
{
//    NSString *appVCA = [APP_VERSION stringByReplacingOccurrencesOfRegex:@"[^0-9]+" withString:@""];
//    NSString *appVersionSet = [NSString stringWithFormat:@"%@&appVCA=%@&appVersion=%@&deviceId=%@", URL_QUERY_VARS, appVCA, APP_VERSION, DEVICE_ID];
//    
//    if (url && ![[url trim] isEqualToString:@""]) {
//        NSMutableString *tempUrl = [[NSMutableString alloc] initWithString:url];
//        
//        return [tempUrl stringByReplacingOccurrencesOfString:appVersionSet withString:@""];
//    }
    
    return url;
}

- (void)openProductViewController:(NSString *)prdNo isPop:(BOOL)isPop parameters:(NSDictionary *)parameters
{
//    CPProductViewController *viewController = [[CPProductViewController alloc] initWithProductNumber:prdNo
//                                                                                               isPop:isPop
//                                                                                          parameters:parameters];
//    [self.navigationController pushViewController:viewController animated:NO];
}

#pragma mark - CPNavigationBarViewDelegate

- (void)didTouchBackButton
{
//    for (UIView *subView in self.navigationController.navigationBar.subviews) {
//        if ([subView isKindOfClass:[NavigationBarView class]]) {
//            [subView removeFromSuperview];
//        }
//    }
//    
//    // Navigation : viewDidLoad에서 한번, viewDidAppear에서 한번 더 한다.
//    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationController.navigationBar addSubview:[self navigationBarView:0]]; //defaut gnb
//    
//    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didTouchBankButton
{
    NSString* gLocalLang = @"";
    if([[NSUserDefaults standardUserDefaults] stringForKey:klang]){
        gLocalLang = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    }
    NSString *callUrl = @"";
    
    callUrl = [NSString stringWithFormat:SUNNY_BANK_URL, gLocalLang];
    
    NSURL *Nurl = [NSURL URLWithString:callUrl];
    
    [self.webView stop];
    webViewUrl = callUrl;
    
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:Nurl];
    
    NSMutableString *cookieStringToSet = [[NSMutableString alloc] init];
    NSHTTPCookie *cookie;
    
    for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        NSLog(@"%@=%@", cookie.name, cookie.value);
        [cookieStringToSet appendFormat:@"%@=%@;",cookie.name, cookie.value];
    }
                        
    if (cookieStringToSet.length) {
        [mutableRequest setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
        NSLog(@"Cookie : %@", cookieStringToSet);
    }
    
    [self openWebView:callUrl mutableRequest:mutableRequest];

}

- (void)didTouchSunnyButton
{
    NSString* gLocalLang = @"";
    if([[NSUserDefaults standardUserDefaults] stringForKey:klang]){
        gLocalLang = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    }
    NSString *callUrl = @"";

    callUrl = [NSString stringWithFormat:SUNNY_CLUB_URL, gLocalLang];
    
    [self.webView stop];
    webViewUrl = callUrl;
    
    NSURL *Nurl = [NSURL URLWithString:callUrl];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:Nurl];
    
    NSMutableString *cookieStringToSet = [[NSMutableString alloc] init];
    NSHTTPCookie *cookie;
    
    for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        NSLog(@"%@=%@", cookie.name, cookie.value);
        [cookieStringToSet appendFormat:@"%@=%@;",cookie.name, cookie.value];
    }
                        
    if (cookieStringToSet.length) {
        [mutableRequest setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
        NSLog(@"Cookie : %@", cookieStringToSet);
    }
    
    [self openWebView:callUrl mutableRequest:mutableRequest];
    
}

- (void)touchSearchButton
{
    NSString* gLocalLang = @"";
    if([[NSUserDefaults standardUserDefaults] stringForKey:klang]){
        gLocalLang = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    }
    NSString *callUrl = @"";
    
    callUrl = [NSString stringWithFormat:SHINHAN_SEARCH_URL, gLocalLang];
    
    [self.webView stop];
    webViewUrl = callUrl;
    
    NSURL *Nurl = [NSURL URLWithString:callUrl];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:Nurl];
    
    NSMutableString *cookieStringToSet = [[NSMutableString alloc] init];
    NSHTTPCookie *cookie;
    
    for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        NSLog(@"%@=%@", cookie.name, cookie.value);
        [cookieStringToSet appendFormat:@"%@=%@;",cookie.name, cookie.value];
    }
                        
    if (cookieStringToSet.length) {
        [mutableRequest setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
        NSLog(@"Cookie : %@", cookieStringToSet);
    }
    
    [self openWebView:callUrl mutableRequest:mutableRequest];
    
}


- (void)touchLocationButton
{
    NSString* gLocalLang = @"";
    if([[NSUserDefaults standardUserDefaults] stringForKey:klang]){
        gLocalLang = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    }
    NSString *callUrl = @"";
    
    callUrl = [NSString stringWithFormat:SHINHAN_LOCATION_URL, gLocalLang];
    
    [self.webView stop];
    webViewUrl = callUrl;
    
    NSURL *Nurl = [NSURL URLWithString:callUrl];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:Nurl];
    
    NSMutableString *cookieStringToSet = [[NSMutableString alloc] init];
    NSHTTPCookie *cookie;
    
    for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        NSLog(@"%@=%@", cookie.name, cookie.value);
        [cookieStringToSet appendFormat:@"%@=%@;",cookie.name, cookie.value];
    }
                        
    if (cookieStringToSet.length) {
        [mutableRequest setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
        NSLog(@"Cookie : %@", cookieStringToSet);
    }
    
    [self openWebView:callUrl mutableRequest:mutableRequest];
    
}



- (void)didTouchMenuButton
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    
//    if ([[CPCommonInfo sharedInfo] currentNavigationType] == CPNavigationTypeMart) {
//        
//        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        CPMenuViewController *menuViewController = app.menuViewController;
//        
//        [menuViewController didTouchInMart];
//        
//        //AccessLog - 사이드메뉴
//        [[AccessLog sharedInstance] sendAccessLogWithCode:@"MAMART0001"];
//    }
}

- (void)didTouchBasketButton
{
    //NSString *cartUrl = [[CPCommonInfo sharedInfo] urlInfo][@"cart"];
    
    //NSString *cartUrl = @"http://m.naver.com";
    NSString *cartUrl = @"https://vntst.shinhanglobal.com/sunny/index3.jsp";
    [self openWebView:cartUrl request:nil];
}

- (void)didTouchLogoButton
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:ReloadHomeNotification object:self];
}

- (void)didTouchMartButton
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    CPHomeViewController *homeViewController = app.homeViewController;
//    
//    [homeViewController didTouchMartButton];
//    [homeViewController goToPageAction:@"MART"];
}

- (void)didTouchMyInfoButton
{
    //[self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)didTouchSearchButton:(NSString *)keywordUrl;
{
    if (keywordUrl) {
        [self openWebView:keywordUrl request:nil];
    }
}

- (void)didTouchSearchButtonWithKeyword:(NSString *)keyword
{
//    CPProductListViewController *viewConroller = [[CPProductListViewController alloc] initWithKeyword:keyword referrer:webViewUrl];
//    [self.navigationController pushViewController:viewConroller animated:YES];
}

- (void)didTouchMartSearchButton
{
//    CPMartSearchViewController *viewController = [[CPMartSearchViewController alloc] init];
//    [viewController setDelegate:self];
////    [self.navigationController pushViewController:viewController animated:NO];
////    [self.navigationController setNavigationBarHidden:YES];
//    [self presentViewController:viewController animated:NO completion:nil];
}

- (void)searchTextFieldShouldBeginEditing:(NSString *)keyword keywordUrl:(NSString *)keywordUrl
{
//    CPSearchViewController *viewController = [[CPSearchViewController alloc] init];
//    [viewController setDelegate:self];
//    
////    if ([SYSTEM_VERSION intValue] < 7) {
////        [viewController setWantsFullScreenLayout:YES];
////    }
//    
////    viewController.defaultUrl = keywordUrl;
////    viewController.isSearchText = isSearchText;
////    
////    if (isSearchText) {
////        viewController.defaultText = keyword;
////    }
//    
//    [self presentViewController:viewController animated:NO completion:nil];
//    [self.navigationController pushViewController:viewController animated:NO];
//    [self.navigationController setNavigationBarHidden:YES];
}
    
- (void)searchTextFieldShouldBeginEditing
{
    
}

#pragma mark - WebViewDelegate - WebView

- (BOOL)webView:(WebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
{
    NSString *url = request ? request.URL.absoluteString : nil;
    
    //openLoginPage
    //getMemberInfo
    //app://openLoginPage
    
    
    if ([url hasPrefix:@"app"]) {
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        [alert show];
        
        if(!([url rangeOfString:@"prev"].location == NSNotFound)){
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];

            if([_webView isGoBack]){
                [_webView myGoBack];
            }else{
                
                [self.navigationController popToRootViewControllerAnimated:YES];
               
                [self didTouchGoSunny];
//                if ([self.delegate respondsToSelector:@selector(didTouchGoSunny)]) {
//                    [self.delegate didTouchGoSunny];
//                }
            }
            
            return NO;
        }

        if(!([url rangeOfString:@"alert"].location == NSNotFound)){
            //app://alert?msg=메세지&url=/sunny/mmlll.jsp?aaaaaa
            NSRange range = [url rangeOfString:@"="];
            range.location = range.location + 1;
            //메세지&url=...
            NSString* subString = [url substringFromIndex:range.location];
            range = [subString rangeOfString:@"&"];
            range.location = range.location - 1;
            NSString* alertMsg = [subString substringToIndex:range.location];
            //url
            range = [subString rangeOfString:@"="];
            range.location = range.location + 1;
            NSString* strUrl = [subString substringFromIndex:range.location];
            
            if([strUrl length] < 1){
                NSString* gLocalLang = @"";
                if([[NSUserDefaults standardUserDefaults] stringForKey:klang]){
                    gLocalLang = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
                }
                
                strUrl = [NSString stringWithFormat:SUNNY_CLUB_URL, gLocalLang];
                
                [self gotoDirectUrl:webViewUrl];
                // Clearing cache Memory
                [[NSURLCache sharedURLCache] removeAllCachedResponses];
                [[NSURLCache sharedURLCache] setDiskCapacity:0];
                [[NSURLCache sharedURLCache] setMemoryCapacity:0];
                
                [_webView execute:@"document.body.innerHTML = \"\";"];
                
                [_webView setHiddenpreButton:true];
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kViewLevelY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSString* newString = [alertMsg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:newString delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
                [alert show];

                
                return NO;
                
            }else{
                //NSString* gLocalLang = @"";
                NSString* localLang;
                if([[NSUserDefaults standardUserDefaults] stringForKey:klang]){
                    localLang = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
                }
                
                strUrl = [NSString stringWithFormat:@"%@%@?locale=%@", SUNNY_DOMAIN, strUrl, localLang];
            }
            
            [self gotoDirectUrl:strUrl];
            
            // Clearing cache Memory
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            [[NSURLCache sharedURLCache] setDiskCapacity:0];
            [[NSURLCache sharedURLCache] setMemoryCapacity:0];
            
            [_webView execute:@"document.body.innerHTML = \"\";"];
            
            [_webView setHiddenpreButton:true];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kViewLevelY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString* newString = [alertMsg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:newString delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            
            return NO;
        }
        
        if(!([url rangeOfString:@"openLoginPage"].location == NSNotFound)){
            
            //login
            LoginViewController *loginController = [[LoginViewController alloc] init];
            
            BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kCallAd];
            if(isLogin == YES){
                [loginController setLoginType:LoginTypeAD];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kCallAd];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }else{
                [loginController setLoginType:LoginTypeAD];
            }
            
            [loginController setDelegate:self];
            [self.navigationController pushViewController:loginController animated:YES];
            
            //        }else if(!([url rangeOfString:@"getMemberInfo"].location == NSNotFound)){
            //            //send to server memberinfo
            //            if([[NSUserDefaults standardUserDefaults] stringForKey:kLoginData]){
            //
            //                NSString *functionCall = [NSString stringWithFormat:@"getMemberInfo(%@)", [[NSUserDefaults standardUserDefaults] stringForKey:kLoginData]];
            //
            //                [webView execute:functionCall];
            //                
            //            }
        }
        
        return NO;
    }
    
    //common/message/processMsg.html?
    if(!([url rangeOfString:@"common/message/processMsg.html?"].location == NSNotFound)){
        return false;
    }
    
    if(!([url rangeOfString:@"about"].location == NSNotFound)){
        return false;
    }
    
    NSLog(@"url:%@", url);
    [[NSUserDefaults standardUserDefaults] setObject:webViewUrl forKey:kPrevUrl];
    [[NSUserDefaults standardUserDefaults] synchronize];
    webViewUrl = url;
    [_webView setUrl:webViewUrl];
    
    
    
#ifdef TEST_SERVER_DEFINE
    //0: club 1:previous 2:   3:bank 4:hide
    NSInteger showNavigation = 1; //1: show, 2: hidden
    //https://vntst.shinhanglobal.com/sunny/index.jsp?w2xPath=/sunny/card/000S1710M00.xml
    
    if(!([url rangeOfString:@"vntst.shinhanglobal.com/sunny/sunnyclub/index.jsp"].location == NSNotFound)){
    //if(!([url rangeOfString:@"vntst.shinhanglobal.com/sunny/sunnyclub/index_2nd.jsp"].location == NSNotFound)){
        //TODO
        NSLog(@"문자열이 포함됨");
        [self.navigationController setNavigationBarHidden:NO];
        showNavigation = 0;
        gShowNavigation = 0;
        [self initNavigation:0];
        
    }else if (!([url rangeOfString:@"vntst.shinhanglobal.com/sunny/bank/main.jsp"].location == NSNotFound)){
        //TODO
        NSLog(@"문자열이 포함됨");
        [self.navigationController setNavigationBarHidden:NO];
        showNavigation = 3;
        gShowNavigation = 3;
        [self initNavigation:3];
    }else{
        
        
        if (([url rangeOfString:@"facebook"].location != NSNotFound)){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            return NO;
        }
        
        if (([url rangeOfString:@"twitter"].location != NSNotFound)){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            return NO;
        }
            
        //sunny없는 URL은 외부 사파리 호출
        if (([url rangeOfString:@"sunny"].location == NSNotFound)){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            return NO;
        }else{
            
            [self.navigationController setNavigationBarHidden:YES];
            showNavigation = 4;
            gShowNavigation = 4;
            [self initNavigation:4];
        }
    }
    
#else // real server
    
    //0: club 1:previous 2:   3:bank 4:hide
    NSInteger showNavigation = 1; //1: show, 2: hidden
    if(!([url rangeOfString:@"online.shinhan.com.vn/sunny/sunnyclub/index.jsp?"].location == NSNotFound)){
        //TODO
        NSLog(@"문자열이 포함됨");
        [self.navigationController setNavigationBarHidden:NO];
        showNavigation = 0;
        gShowNavigation = 0;
        [self initNavigation:0];
        
    }else if (!([url rangeOfString:@"online.shinhan.com.vn/sunny/bank/main.jsp?"].location == NSNotFound)){
        //TODO
        NSLog(@"문자열이 포함됨");
        [self.navigationController setNavigationBarHidden:NO];
        showNavigation = 3;
        gShowNavigation = 3;
        [self initNavigation:3];
    }else{
        
        if (([url rangeOfString:@"facebook"].location != NSNotFound)){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            return NO;
        }
        
        if (([url rangeOfString:@"twitter"].location != NSNotFound)){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            return NO;
        }
        
        //sunny없는 URL은 외부 사파리 호출
        if (([url rangeOfString:@"sunny"].location == NSNotFound)){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            return NO;
        }else{
            
            [self.navigationController setNavigationBarHidden:YES];
            showNavigation = 4;
            gShowNavigation = 4;
            [self initNavigation:4];
        }
    }
#endif
    
    //sunny/sunnyclub
    if (([url rangeOfString:@"sunny/sunnyclub"].location != NSNotFound)){
        [webView setZoomBtnVisible:1];
    }else{
        [webView setZoomBtnVisible:0];
    }
    
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    CGRect naviViewFrame;
    CGRect webViewFrame;
    CGRect toolViewFrame;
    
    if (showNavigation == 4) {   // hide navigation
        
        naviViewFrame = CGRectMake(0, kStatusBarY, kScreenBoundsWidth, kNavigationHeightHide-kStatusBarY);
        webViewFrame = CGRectMake(0, kStatusBarY, kScreenBoundsWidth, kScreenBoundsHeight-kToolBarHeight);
        toolViewFrame = CGRectMake(0, kScreenBoundsHeight-(kToolBarHeight+kStatusBarY), kScreenBoundsWidth, kToolBarHeight);
        
        if (navigationBarView) {
            [self.navigationController.navigationBar setFrame:naviViewFrame];
        }
        if (self.webView) {
            [self.webView setFrame:webViewFrame];
            [self.webView updateFrameSunnyForStatusHide];
        }
        
        [statusBarView removeFromSuperview];
        statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kStatusBarY)];
        [self.view addSubview:statusBarView];
        [statusBarView setBackgroundColor:UIColorFromRGB(0xe0e0e0)];
        
    }
    else {                      // show navigation
        [statusBarView removeFromSuperview];
        //[_webView stackAllDel];
        
        naviViewFrame = CGRectMake(0, kStatusBarY, kScreenBoundsWidth, kNavigationHeight);
        webViewFrame = CGRectMake(0, kWebViewTopMarginY, kScreenBoundsWidth, kScreenBoundsHeight-kNavigationHeight-kToolBarHeight-kWebViewTopMarginY*2);
//        webViewFrame = CGRectMake(0, kWebViewTopMarginY, kScreenBoundsWidth, kScreenBoundsHeight-(kToolBarHeight+kNavigationHeight+kWebViewMarginY*2));
        
        //toolViewFrame = CGRectMake(0, kScreenBoundsHeight-kToolBarHeight-kWebViewMarginY, kScreenBoundsWidth, kToolBarHeight);
        toolViewFrame = CGRectMake(0, kScreenBoundsHeight-(kToolBarHeight+kWebViewMarginY)*2, kScreenBoundsWidth, kToolBarHeight);
        
        if (navigationBarView) {
            [self.navigationController.navigationBar setFrame:naviViewFrame];
        }
        
        if (self.webView) {
            [self.webView setFrame:webViewFrame];
            [self.webView updateFrameSunny:showNavigation];
        }
    }

    return YES;
}

- (void)setExceptionFrame:(BOOL)isException
{
    CGRect subWebViewFrame;
    
    if (isException) {
        [self.navigationController setNavigationBarHidden:YES];
        
        if ([SYSTEM_VERSION intValue] > 6) {
            subWebViewFrame = CGRectMake(0, STATUSBAR_HEIGHT, kScreenBoundsWidth, kScreenBoundsHeight-STATUSBAR_HEIGHT);
        }
        else {
            subWebViewFrame = CGRectMake(0, 0, kScreenBoundsWidth, kScreenBoundsHeight-STATUSBAR_HEIGHT);
        }
    }
    else {
        [self.navigationController setNavigationBarHidden:NO];
        subWebViewFrame = CGRectMake(0, 0, kScreenBoundsWidth, kScreenBoundsHeight-64);
    }
    
    if (self.webView) {
        [self.webView setFrame:subWebViewFrame];
        [self.webView updateFrame];
        [self.webView setHiddenToolBarView:NO];
    }
    
//    if (isException) fullScreenMode = CPWebviewControllerFullScreenModeOn;
//    else             fullScreenMode = CPWebviewControllerFullScreenModeOff;
}

- (BOOL)webView:(WebView *)webView openUrlScheme:(NSString *)urlScheme
{
//    return [[CPSchemeManager sharedManager] openUrlScheme:urlScheme sender:nil changeAnimated:YES];
//    NSLog(@"test test test");
    return false;
}

#pragma mark - WebViewDelegate - Navigation Bar

- (void)initNavigation:(NSInteger)navigationType
{
    for (UIView *subView in self.navigationController.navigationBar.subviews) {
        if ([subView isKindOfClass:[NavigationBarView class]]) {
            [subView removeFromSuperview];
//            NSLog(@"CPNavigationBarView removeFromSuperview");
        }
    }
    
    switch (navigationType) {
        case 1:
            [self.navigationController.navigationBar addSubview:[self navigationBarView:1]];
            [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
            break;
        case 2:
            [self.navigationController.navigationBar addSubview:[self navigationBarView:2]];
            [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
            break;
        case 3:
            [self.navigationController.navigationBar addSubview:[self navigationBarView:3]];
            [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
            break;
        case 4:
            [self.navigationController.navigationBar addSubview:[self navigationBarView:4]];
            [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
            break;

        default:
            [self.navigationController.navigationBar addSubview:[self navigationBarView:0]];
            [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
            break;
    }
}


#pragma mark - WebViewDelegate - Button

- (void)didTouchZoomViewerButton
{
//    if (!zoomViewerScheme || [@"" isEqualToString:[zoomViewerScheme trim]]) {
//        return;
//    }
//    
//    [[CPSchemeManager sharedManager] openUrlScheme:[NSString stringWithFormat:@"app://popupBrowser/%@", zoomViewerScheme] sender:nil changeAnimated:NO];
}

#pragma mark - WebViewDelegate - Toolbar

- (void)webViewGoBack
{
    [self.navigationController setNavigationBarHidden:NO];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didTouchToolBarButton:(UIButton *)button
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"didTouchAD in web" delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//    [alert show];
    //new
    //광고 열기
    //[self didTouchAD];
    [self didTouchMainAD];
}


#pragma mark - CPMartSearchViewControllerDelegate

- (void)martSearchWithKeyword:(NSString *)keyword
{
    [navigationBarView setSearchTextField:keyword];
    
//    //인코딩
//    keyword = [Modules encodeAddingPercentEscapeString:keyword];
//    
//    if (keyword) {
//        NSString *searchUrl = [[CPCommonInfo sharedInfo] urlInfo][@"martSearch"];
//        searchUrl = [searchUrl stringByReplacingOccurrencesOfString:@"{{keyword}}" withString:keyword];
//        
//        [self openWebView:searchUrl request:nil];
//    }
    
//    isCloseSearch = YES;
}

#pragma mark - CPSearchViewControllerDelegate

- (void)searchWithKeyword:(NSString *)keyword
{
    [navigationBarView setSearchTextField:keyword];
    
    //인코딩
//    keyword = [Modules encodeAddingPercentEscapeString:keyword];
    
//    if (keyword) {
//        CPProductListViewController *viewConroller = [[CPProductListViewController alloc] initWithKeyword:keyword referrer:webViewUrl];
//        [self.navigationController pushViewController:viewConroller animated:YES];
//        
//    }
}

- (void)reloadWebViewData
{
    [self.webView reload];
}

- (void)searchWithAdvertisement:(NSString *)url
{
    [self.webView open:url];
}

#pragma mark - CPPopupViewControllerDelegate

- (void)popupViewControllerCloseAndMoveUrl:(NSString *)url
{
    [self openWebView:url request:nil];
}

- (void)popupviewControllerOpenOtpController:(NSString *)option
{
//    [self otp:option];
}

- (void)popupviewControllerMoveHome:(NSString *)option
{
//    [self moveToHome:option];
}

- (void)popupviewControllerOpenBrowser:(NSString *)option
{
//    [self openBrowser:option];
}

#pragma mark - CPContactViewControllerDelegate

- (void)didTouchContactConfirmButton:(NSString *)jsonData;
{
    NSString *javascript = [NSString stringWithFormat:@"contactList('{\"contactList\":%@}')", jsonData];
    [self.webView execute:javascript];
    
//    isCloseContact = YES;
}

#pragma mark - CPPopupBrowserViewDelegate

- (void)popupBrowserViewOpenUrlScheme:(NSString *)urlScheme
{
    //[[CPSchemeManager sharedManager] openUrlScheme:urlScheme sender:nil changeAnimated:YES];
}

#pragma mark - CPVideoPopupViewDelegate

- (void)didTouchProductButton:(NSString *)productUrl
{
//    if (popUpBrowserView) {
//        [popUpBrowserView removePopupBrowserView];
//    }
//    
//    [self openWebView:productUrl request:nil];
}

//- (void)didTouchFullScreenButton:(CPMoviePlayerViewController *)player
//{
//    //[self presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)player];
//}


#pragma mark - SetupControllerDelegate

//- (void)setupController:(SetupController *)controller gotoWebPageWithUrlString:(NSString *)urlString
//{
//    [self.webView open:urlString];
//}

#pragma mark - CPSchemeManagerDelegate

//ads
- (void)setSearchTextField:(NSString *)keyword
{   
    [navigationBarView setSearchTextField:keyword];
}

//zoomViewer
- (void)setZoomViewer:(NSArray *)options
{
    zoomViewerScheme = [@"open/" stringByAppendingString:options[1]];
    
    if ([[options objectAtIndex:0] isEqualToString:@"show"]) {
        [self.webView.zoomViewerButton setHidden:NO];
    }
    
    if ([[options objectAtIndex:0] isEqualToString:@"hide"]) {
        [self.webView.zoomViewerButton setHidden:YES];
    }
}

//canOpenApp
//- (void)executeCanOpenApplication:(NSString *)option
//{
//    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:URLDecode(option)]];
//    
//    [self.webView execute:[NSString stringWithFormat:@"canOpenApplication('%d', '%@')", canOpen, URLDecode(option)]];
//}

- (void)openWebView:(NSString *)url
{
    [self.webView open:url];
}

//toolbar action
- (void)webViewToolbarAction:(NSString *)option
{
    if ([option isEqualToString:@"top"]) {
        [self.webView actionTop];
    }
    else if ([option isEqualToString:@"back"]) {
        [self.webView actionBackWord];
    }
    else if ([option isEqualToString:@"forward"]) {
        [self.webView actionForward];
    }
    else if ([option isEqualToString:@"reload"] || [option isEqualToString:@"refresh"]) {
        [self.webView actionReload];
    }
    else if ([option isEqualToString:@"close"]) {
        [self.navigationController popViewControllerAnimated:NO];
//        [self removeSubWebView];
    }
    else if ([option hasPrefix:@"external"]) {
        NSString *requestUrl = [self removeQueryStringWithUrl:[self.webView url]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestUrl]];
    }
}

//moveToHome
- (void)moveToHomeAction:(NSString *)option
{
    if ([option isEqualToString:@"home"]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:WebViewControllerNotification object:self];
//        
//        [self.subWebView removeFromSuperview];
//        
//        [self reloadHomeTab];
    }
}

#pragma mark - total menu delegate

- (void)didTouchMenuItem:(NSInteger)menuType
{
    
//    NSString *strMenuType = [NSString stringWithFormat:@"webView didTouchMenuItem menuType %d", menuType];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:strMenuType delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//    [alert show];
    
    NSString* gLocalLang = @"";
    if([[NSUserDefaults standardUserDefaults] stringForKey:klang]){
        gLocalLang = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    }
    NSString *callUrl = @"";
    
    //Sunny Club
    if(menuType == 1){
        //gLocalLang = @"ko";
        callUrl = [NSString stringWithFormat:SUNNY_CLUB_URL, gLocalLang];
    }
    //Sunny Bank
    if(menuType == 2){
        //gLocalLang = @"ko";
        callUrl = [NSString stringWithFormat:SUNNY_BANK_URL, gLocalLang];
    }
    //news
    if(menuType == 3){
        //gLocalLang = @"ko";
        callUrl = [NSString stringWithFormat:NEW_NEWS_URL, gLocalLang];
    }
    
    //setting
    if(menuType == 4){
        
        [self.mm_drawerController closeDrawerAnimated:true completion:nil];
        
        configViewController *configController = [[configViewController alloc] init];
        [configController setDelegate:self];
        [self.navigationController pushViewController:configController animated:YES];
        [self.navigationController setNavigationBarHidden:NO];
        
        return;
        
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self.webView stop];
    webViewUrl = callUrl;

    NSURL *Nurl = [NSURL URLWithString:callUrl];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:Nurl];
    
    NSMutableString *cookieStringToSet = [[NSMutableString alloc] init];
    NSHTTPCookie *cookie;
    
    for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        NSLog(@"%@=%@", cookie.name, cookie.value);
        [cookieStringToSet appendFormat:@"%@=%@;",cookie.name, cookie.value];
    }
                        
    if (cookieStringToSet.length) {
        [mutableRequest setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
        NSLog(@"Cookie : %@", cookieStringToSet);
    }
    
    [self openWebView:callUrl mutableRequest:mutableRequest];
    
    
}

- (void)didTouchNewButton
{
    [self setUrl:@""];
    
    NSString* gLocalLang = @"";
    if([[NSUserDefaults standardUserDefaults] stringForKey:klang]){
        gLocalLang = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    }
    NSString *callUrl = @"";
    
    //gLocalLang = @"ko";
    callUrl = [NSString stringWithFormat:NEW_NEWS_URL, gLocalLang];

    
    NSURL *Nurl = [NSURL URLWithString:callUrl];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:Nurl];
    
    NSMutableString *cookieStringToSet = [[NSMutableString alloc] init];
    NSHTTPCookie *cookie;
    
    for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        NSLog(@"%@=%@", cookie.name, cookie.value);
        [cookieStringToSet appendFormat:@"%@=%@;",cookie.name, cookie.value];
    }
    
    if (cookieStringToSet.length) {
        [mutableRequest setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
        NSLog(@"Cookie : %@", cookieStringToSet);
    }
    
    [self openWebView:callUrl mutableRequest:mutableRequest];
}

- (void)didTouchHelpButton
{
    [self setUrl:@""];
    
    NSString* gLocalLang = @"";
    if([[NSUserDefaults standardUserDefaults] stringForKey:klang]){
        gLocalLang = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    }
    NSString *callUrl = @"";
    
    callUrl = [NSString stringWithFormat:HELP_LIST_URL, gLocalLang];
    
    NSURL *Nurl = [NSURL URLWithString:callUrl];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:Nurl];
    
    NSMutableString *cookieStringToSet = [[NSMutableString alloc] init];
    NSHTTPCookie *cookie;
    
    for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        NSLog(@"%@=%@", cookie.name, cookie.value);
        [cookieStringToSet appendFormat:@"%@=%@;",cookie.name, cookie.value];
    }
                        
    if (cookieStringToSet.length) {
        [mutableRequest setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
        NSLog(@"Cookie : %@", cookieStringToSet);
    }
    
    [self openWebView:callUrl mutableRequest:mutableRequest];
    
}

- (void)didTouchCloseBtn
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"didTouchCloseBtn" delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//    [alert show];
    
    [self.mm_drawerController closeDrawerAnimated:true completion:nil];
}

- (void)didTouchLetterBtn
{
    [self setUrl:@""];
    
    NSString* gLocalLang = @"";
    if([[NSUserDefaults standardUserDefaults] stringForKey:klang]){
        gLocalLang = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    }
    NSString *callUrl = @"";
    
    callUrl = [NSString stringWithFormat:LETTER_URL, gLocalLang];
    
    NSURL *Nurl = [NSURL URLWithString:callUrl];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:Nurl];
    
    NSMutableString *cookieStringToSet = [[NSMutableString alloc] init];
    NSHTTPCookie *cookie;
    
    for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        NSLog(@"%@=%@", cookie.name, cookie.value);
        [cookieStringToSet appendFormat:@"%@=%@;",cookie.name, cookie.value];
    }
                        
    if (cookieStringToSet.length) {
        [mutableRequest setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
        NSLog(@"Cookie : %@", cookieStringToSet);
    }
    
    [self openWebView:callUrl mutableRequest:mutableRequest];

    [self.mm_drawerController closeDrawerAnimated:true completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)didTouchLogOutBtn
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"didTouchLogOutBtn" delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)didTouchLogInBtn
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"didTouchLogInBtn" delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//    [alert show];
    
    [self.mm_drawerController closeDrawerAnimated:true completion:nil];
    
    setInforViewController *loginController = [[LoginViewController alloc] init];
    [loginController setDelegate:self];
    [self.navigationController pushViewController:loginController animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)didTouchSummitBtn
{
    [self.mm_drawerController closeDrawerAnimated:true completion:nil];
    
    setInforViewController *SetInforViewController = [[setInforViewController alloc] init];
    [SetInforViewController setDelegate:self];
    [self.navigationController pushViewController:SetInforViewController animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)didTouchAD
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"didTouchAD in web" delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//    [alert show];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kCallAd];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString* gLocalLang = @"";
    NSString *callUrl = @"";
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:klang]){
        gLocalLang = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    }
    
    //callUrl = [NSString stringWithFormat:SHINHAN_ZONE_URL, gLocalLang];
    callUrl = [[NSUserDefaults standardUserDefaults] stringForKey:kLeftMainBannerUrl];
    
    if([callUrl length] < 1){
        callUrl = [NSString stringWithFormat:SHINHAN_ZONE_URL, gLocalLang];
        //return;
    }
    
    NSURL *Nurl = [NSURL URLWithString:callUrl];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:Nurl];
    
    NSMutableString *cookieStringToSet = [[NSMutableString alloc] init];
    NSHTTPCookie *cookie;
    
    for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        NSLog(@"%@=%@", cookie.name, cookie.value);
        [cookieStringToSet appendFormat:@"%@=%@;",cookie.name, cookie.value];
    }
                        
    if (cookieStringToSet.length) {
        [mutableRequest setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
        NSLog(@"Cookie : %@", cookieStringToSet);
    }
    
    [self openWebView:callUrl mutableRequest:mutableRequest];
}

- (void)didTouchMainAD
{
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"didTouchAD in web" delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
    //    [alert show];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kCallAd];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString* gLocalLang = @"";
    NSString *callUrl = @"";
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:klang]){
        gLocalLang = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    }
    
    callUrl = [NSString stringWithFormat:SHINHAN_EVENT_URL, gLocalLang];
    callUrl = [[NSUserDefaults standardUserDefaults] stringForKey:kMainBannerUrl];
    if([callUrl length] < 1){
        return;
    }
    [self.webView stop];
    //webViewUrl = callUrl;
    
    NSURL *Nurl = [NSURL URLWithString:callUrl];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:Nurl];
    
    NSMutableString *cookieStringToSet = [[NSMutableString alloc] init];
    NSHTTPCookie *cookie;
    
    for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        NSLog(@"%@=%@", cookie.name, cookie.value);
        [cookieStringToSet appendFormat:@"%@=%@;",cookie.name, cookie.value];
    }
                        
    if (cookieStringToSet.length) {
        [mutableRequest setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
        NSLog(@"Cookie : %@", cookieStringToSet);
    }
    
    [self openWebView:callUrl mutableRequest:mutableRequest];
}

- (void)didTouchGoSunny
{
    NSString* gLocalLang = @"";
    if([[NSUserDefaults standardUserDefaults] stringForKey:klang]){
        gLocalLang = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    }
    NSString *callUrl = @"";
    
    callUrl = [NSString stringWithFormat:SUNNY_CLUB_URL, gLocalLang];
    
    [self.webView stop];
    webViewUrl = callUrl;
    
    NSURL *Nurl = [NSURL URLWithString:callUrl];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:Nurl];
    
    NSMutableString *cookieStringToSet = [[NSMutableString alloc] init];
    NSHTTPCookie *cookie;
    
    for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        NSLog(@"%@=%@", cookie.name, cookie.value);
        [cookieStringToSet appendFormat:@"%@=%@;",cookie.name, cookie.value];
    }
                        
    if (cookieStringToSet.length) {
        [mutableRequest setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
        NSLog(@"Cookie : %@", cookieStringToSet);
    }
    
    [self openWebView:callUrl mutableRequest:mutableRequest];
    
}



- (void)resetADImage{
    
    [self.webView redrawADImage];
    
}

- (void)webViewReload{
    [self.webView reload];
}

-(void)gotoPrev:(NSString*)callUrl
{
    
    [self.webView stop];
//    if([[NSUserDefaults standardUserDefaults] stringForKey:kPrevUrl]){
//        callUrl = [[NSUserDefaults standardUserDefaults] stringForKey:kPrevUrl];
//    }
    NSURL *Nurl = [NSURL URLWithString:callUrl];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:Nurl];
    
    NSMutableString *cookieStringToSet = [[NSMutableString alloc] init];
    NSHTTPCookie *cookie;
    
    for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        NSLog(@"%@=%@", cookie.name, cookie.value);
        [cookieStringToSet appendFormat:@"%@=%@;",cookie.name, cookie.value];
    }
    if(cookieStringToSet.length) {
        [mutableRequest setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
        NSLog(@"Cookie : %@", cookieStringToSet);
    }
    
    [self openWebView:callUrl mutableRequest:mutableRequest];

}

- (void)gotoPushUrl:(NSString *)url{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    NSString* gLocalLang = @"";
    NSString *callUrl = @"";
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:klang]){
        gLocalLang = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    }
    
    callUrl = [[NSUserDefaults standardUserDefaults] stringForKey:kPushUrl];
    
    [self.webView stop];
    webViewUrl = callUrl;
    
    NSURL *Nurl = [NSURL URLWithString:callUrl];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:Nurl];
    
    NSMutableString *cookieStringToSet = [[NSMutableString alloc] init];
    NSHTTPCookie *cookie;
    
    for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        NSLog(@"%@=%@", cookie.name, cookie.value);
        [cookieStringToSet appendFormat:@"%@=%@;",cookie.name, cookie.value];
    }
                        
    if (cookieStringToSet.length) {
        [mutableRequest setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
        NSLog(@"Cookie : %@", cookieStringToSet);
    }
    
    [self openWebView:callUrl mutableRequest:mutableRequest];
}

- (void)gotoDirectUrl:(NSString *)url{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self.webView stop];
    webViewUrl = url;
    
    NSURL *Nurl = [NSURL URLWithString:url];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:Nurl];
    
    NSMutableString *cookieStringToSet = [[NSMutableString alloc] init];
    NSHTTPCookie *cookie;
    
    for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        NSLog(@"%@=%@", cookie.name, cookie.value);
        [cookieStringToSet appendFormat:@"%@=%@;",cookie.name, cookie.value];
    }
                        
    if (cookieStringToSet.length) {
        [mutableRequest setValue:cookieStringToSet forHTTPHeaderField:@"Cookie"];
        NSLog(@"Cookie : %@", cookieStringToSet);
    }
    
    [self openWebView:url mutableRequest:mutableRequest];
}

- (void)setViewAlpha:(NSInteger)alphaValue{
    //[self.view setAlpha:alphaValue];
    if(alphaValue){
//        [dummyView removeFromSuperview];
//        dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kScreenBoundsHeight)];
//        [self.view addSubview:dummyView];
//        [dummyView setBackgroundColor:UIColorFromRGB(0x000000)];
//        [dummyView setAlpha:0.8f];
        
        [self.navigationController.navigationBar setAlpha:0.1f];
        [self.view setAlpha:0.1f];
        NSArray* tempVCA = [self.navigationController viewControllers];
        for(UIViewController *tempVC in tempVCA)
        {
            [tempVC.view setAlpha:0.1f];
        }
    }else{
        //[dummyView removeFromSuperview];
        [self.navigationController.navigationBar setAlpha:1.0f];
        [self.view setAlpha:1.0f];
        NSArray* tempVCA = [self.navigationController viewControllers];
        for(UIViewController *tempVC in tempVCA)
        {
            [tempVC.view setAlpha:1.0f];
        }

    }
    
    
    
}

@end
