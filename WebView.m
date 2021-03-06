//
//  WebView.m
//
//  Created by gclee on 2015. 10. 27..
//  Copyright (c) gclee. All rights reserved.
//

#import "WebView.h"
#import "ToolBarView.h"
//#import "UIImage+ImageWithColor.h"
#import "CPLoadingView.h"
//#import "HttpRequest.h"
#import "NSMutableArray+Stack.h"

typedef NS_ENUM(NSInteger, RequestNotifyType)
{
	RequestNotifyTypeRefusedPushAgree
};

@interface WebView () <UIWebViewDelegate,
                        UIScrollViewDelegate,
                        ToolBarViewDelegate>
{
    ToolBarView *toolBarView;
    
	//CPProductOption	*productView;
    
    CGFloat buttonWidth;
    CGFloat buttonHeight;
    
//    UIButton *toggleButton;

    CPLoadingView *loadingView;
    
    UIScrollView *currentScrollView;
    //PullToRefreshView *pull;
    BOOL isPullToRefresh;
    
    //CPErrorView *errorView;
    
    BOOL isSubWebView;
	BOOL isToolBarAnimation;
	BOOL isDelayMakeProductOption;
	
	//푸쉬 알림 거부
	UIView *_refusedPushAgreeView;
    
	NSInteger _requestType;
    
    NSString *reloadUrl;
    NSTimer         *netCheckTimer;
    NSInteger               netTimeOutSecond;
    UIView *checkNetTimoutView;
    
    CGFloat fZoomInCurrent;
    NSMutableArray *myStack;
    
    NSString *webViewUrl;
}

@end

@implementation WebView

- (id)initWithFrame:(CGRect)frame isSub:(BOOL)isSub
{
    isSubWebView = isSub;
    
    self = [self initWithFrame:frame];
    
    if (self) {
        //
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if(_webView)
        {
            [self destroyWebView];
        }
        
        myStack = [[NSMutableArray alloc] init];
        
        //CGFloat marginY = (kScreenBoundsWidth > 320)?0:10;
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)-kToolBarHeight)];
        //_webView = [[UIWebView alloc] initWithFrame:frame];
        [_webView setDelegate:self];
        [_webView setScalesPageToFit:YES];
        [_webView setContentMode:UIViewContentModeScaleToFill]; //UIViewContentModeScaleAspectFit
        
        [_webView setClipsToBounds:YES];
        [_webView setAllowsInlineMediaPlayback:YES];
        [_webView setMediaPlaybackRequiresUserAction:NO];
        [_webView.scrollView setScrollsToTop:YES];
        [_webView.scrollView setDelegate:self];
        [_webView.scrollView setDecelerationRate:UIScrollViewDecelerationRateNormal];
        [_webView.scrollView setBounces:NO];
        [_webView setOpaque:NO];
        [_webView.scrollView setShowsHorizontalScrollIndicator:true];
        [_webView.scrollView setShowsVerticalScrollIndicator:true];
        
        [_webView setBackgroundColor:UIColorFromRGB(0xffffff)];
        
//        [_webView.scrollView zoomToRect:CGRectMake(0,0,_webView.scrollView.contentSize.width+300, _webView.scrollView.contentSize.height+300) animated:YES];
        
        
        [self addSubview:_webView];
        
        if ([SYSTEM_VERSION intValue] >= 5) {
            [_webView setMediaPlaybackAllowsAirPlay:YES];
        }
		
        // 메인탭에만 pullToRefresh를 허용
//        if (!isSubWebView) {
//            // get webview's scrollview for PullToRefresh
//            for (UIView* subView in _webView.subviews) {
//                if ([subView isKindOfClass:[UIScrollView class]]) {
//                    currentScrollView = (UIScrollView *)subView;
//                    currentScrollView.delegate = (id) self;
//                }
//            }
//            
////            pull = [[PullToRefreshView alloc] initWithScrollView:currentScrollView];
////            [pull setDelegate:self];
////            [currentScrollView addSubview:pull];
//        }
        
        // 툴바
        toolBarView = [[ToolBarView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-kToolBarHeight, CGRectGetWidth(frame), kToolBarHeight) toolbarType:1];
        [toolBarView setDelegate:self];
        [toolBarView setHidden:NO];
        [self addSubview:toolBarView];
        
//        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kScreenBoundsHeight - kToolBarHeight)];
//        [bgImageView setImage:[UIImage imageNamed:@"bottom_top_banner.png"]];
//        [self addSubview:bgImageView];

        buttonWidth = kScreenBoundsWidth / 7;
        buttonHeight = kToolBarHeight;
        
        // 탑버튼
        _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_topButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth, CGRectGetHeight([self frame])-(kToolBarHeight-kWebViewTopMarginY*2)-(buttonHeight), buttonWidth, buttonHeight)];
        [_topButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth+7, CGRectGetHeight([self frame])-(buttonHeight+10), buttonWidth, buttonHeight)];
        [_topButton setImage:[UIImage imageNamed:@"bottom_top_btn.png"] forState:UIControlStateNormal];
        [_topButton addTarget:self action:@selector(touchTopButton) forControlEvents:UIControlEventTouchUpInside];
        [_topButton setHidden:YES];
        //[_topButton setAccessibilityLabel:@"위로" Hint:@"화면을 위로 이동합니다"];
        [self addSubview:_topButton];
        
        // 상품 확대보기 버튼
//        _zoomViewerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_zoomViewerButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth, CGRectGetHeight(frame)-(buttonHeight*2)-40, buttonWidth, buttonHeight)];
//        [_zoomViewerButton setImage:[UIImage imageNamed:@"icon_zoomviewer_nor.png"] forState:UIControlStateNormal];
//        [_zoomViewerButton setImage:[UIImage imageNamed:@"icon_zoomviewer_selected.png"] forState:UIControlStateHighlighted];
//        [_zoomViewerButton addTarget:self action:@selector(touchZoomViewerButton) forControlEvents:UIControlEventTouchUpInside];
//        [_zoomViewerButton setHidden:YES];
//        //[_zoomViewerButton setAccessibilityLabel:@"상품 확대보기" Hint:@"상품 확대보기로 이동합니다"];
//        [self addSubview:_zoomViewerButton];
        
        // pre버튼
        _preButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_preButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth, CGRectGetHeight([self frame])-(kToolBarHeight-kWebViewTopMarginY*2)-((buttonHeight+10)*2), buttonWidth, buttonHeight)];
        [_preButton setFrame:CGRectMake(-5, CGRectGetHeight([self frame])-(buttonHeight+10), buttonWidth, buttonHeight)];

        [_preButton setImage:[UIImage imageNamed:@"bottom_back_btn.png"] forState:UIControlStateNormal];
        [_preButton setImage:[UIImage imageNamed:@"bottom_back_btn.png"] forState:UIControlStateHighlighted];
        [_preButton addTarget:self action:@selector(touchpreButton) forControlEvents:UIControlEventTouchUpInside];
        [_preButton setHidden:true];
        [self addSubview:_preButton];
        
        // zoom in
        _zoomInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zoomInButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth, CGRectGetHeight([self frame])-(kToolBarHeight-kWebViewTopMarginY*2)-((buttonHeight+10)*2), buttonWidth, buttonHeight)];
        [_zoomInButton setImage:[UIImage imageNamed:@"zoom_in.png"] forState:UIControlStateNormal];
        [_zoomInButton setImage:[UIImage imageNamed:@"zoom_in_press.png"] forState:UIControlStateHighlighted];
        [_zoomInButton addTarget:self action:@selector(touchZoomInButton) forControlEvents:UIControlEventTouchUpInside];
        [_zoomInButton setHidden:false];
        [self addSubview:_zoomInButton];
        
        // zoom out
        _zoomOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zoomOutButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth, CGRectGetHeight([self frame])-(kToolBarHeight-kWebViewTopMarginY*2)-(buttonHeight), buttonWidth, buttonHeight)];
        [_zoomOutButton setImage:[UIImage imageNamed:@"zoom_out.png"] forState:UIControlStateNormal];
        [_zoomOutButton setImage:[UIImage imageNamed:@"zoom_out_press.png"] forState:UIControlStateHighlighted];
        [_zoomOutButton addTarget:self action:@selector(touchZoomOutButton) forControlEvents:UIControlEventTouchUpInside];
        [_zoomOutButton setHidden:false];
        [self addSubview:_zoomOutButton];
        
//        // 토글버튼
//        toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [toggleButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth, CGRectGetHeight(frame)-buttonHeight, buttonWidth, buttonHeight)];
//        [toggleButton setImage:[UIImage imageNamed:@"icon_tabbar_07fullclose_nor.png"] forState:UIControlStateNormal];
//        [toggleButton setImage:[UIImage imageNamed:@"icon_tabbar_07fullclose_nor.png"] forState:UIControlStateHighlighted];
//        [toggleButton addTarget:self action:@selector(touchToggleButton) forControlEvents:UIControlEventTouchUpInside];
//        [toggleButton setHidden:YES];
//        [toggleButton setAccessibilityLabel:@"토글" Hint:@"툴바를 올립니다"];
//        [self addSubview:toggleButton];
        
//        // 더보기 팝오버메뉴
//        CGFloat popOverViewX = buttonWidth * 5;
//        popOverView = [[CPPopOverView alloc] initWithFrame:CGRectMake(0, 0, 120, 160)];
//        [popOverView setDelegate:self];
//        [popOverView setCenter:CGPointMake(popOverViewX+buttonWidth/2, CGRectGetHeight(frame)-(buttonHeight+80))];
//        [popOverView setHidden:YES];
////        [self addSubview:popOverView];
//        
//        // 즐겨찾기 팝오버메뉴
//        popOverViewX = buttonWidth * 3;
//        snapshotPopOverView = [[CPSnapshotPopOverView alloc] initWithFrame:CGRectMake(0, 0, 120, 70)];
//        [snapshotPopOverView setDelegate:self];
//        [snapshotPopOverView setCenter:CGPointMake(popOverViewX+buttonWidth/2, CGRectGetHeight(frame)-(buttonHeight+35))];
//        [snapshotPopOverView setHidden:YES];
////        [self addSubview:snapshotPopOverView];
		
		//알리미 수신동의
		[self initRefusedPushAgreeView:frame];
		
        //LoadingView
        loadingView = [[CPLoadingView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2-40,
                                                                      CGRectGetHeight(self.frame)/2-40,
                                                                      80,
                                                                      80)];
    }
    return self;
}

- (void)destroyWebView
{
    NSLog(@"destroyWebView : %@", [self url]);
    
//    [self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView stopLoading];
    [self.webView setDelegate:nil];
    [self.webView removeFromSuperview];
    self.webView = nil;
    
    // Clearing cache Memory
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    [myStack delAll];
    
    
    
//    // Deleting all the cookies
//    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//    }
    
    self.topButton = nil;
    self.preButton = nil;
    self.zoomViewerButton = nil;
    
    [self stopLoadingAnimation];
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"warning url : %@", [self url]);
    
//    self.webView = nil;
//    self.topButton = nil;
//    self.preButton = nil;
//    self.zoomViewerButton = nil;
//    
//    [self stopLoadingAnimation];
    
    // Clearing cache Memory
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    [myStack delAll];
    
//    // Deleting all the cookies
//    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
//        NSLog(@"cookie:%@", cookie);
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//    }
}

- (void)setUrl:(NSString *)url
{
    webViewUrl = url;
}

- (void)setViewId:(NSInteger)viewId
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, 50)];
    [label setBackgroundColor:RGBA(0x00, 0x00, 0x00, 0.8f)];
    [label setFont:[UIFont systemFontOfSize:24]];
    [label setText:[NSString stringWithFormat:@"%li", (long)viewId]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:UIColorFromRGB(0xffffff)];
    [self addSubview:label];
}

- (void)initRefusedPushAgreeView:(CGRect)frame
{
//	_refusedPushAgreeView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(frame)-31, 91, 21)];
//	[self addSubview:_refusedPushAgreeView];
//	
//	UIImageView *bgView = [[UIImageView alloc] initWithFrame:_refusedPushAgreeView.bounds];
//	bgView.image = [UIImage imageNamed:@"image_no_agree_push_bg.png"];
//	[_refusedPushAgreeView addSubview:bgView];
//	
//	UILabel *textLabel = [[UILabel alloc] initWithFrame:_refusedPushAgreeView.bounds];
//	//textLabel.text = @"  알리미수신거부(무료)";
//	textLabel.backgroundColor = [UIColor clearColor];
//	textLabel.textColor = UIColorFromRGB(0xffffff);
//	textLabel.font = [UIFont systemFontOfSize:9.f];
//	textLabel.textAlignment = NSTextAlignmentLeft;
//	[_refusedPushAgreeView addSubview:textLabel];
//	
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = _refusedPushAgreeView.bounds;
//    //    [btn setImage:[UIImage imageWithColor:UIColorFromRGB(0x000000) width:btn.frame.size.width height:btn.frame.size.height] forState:UIControlStateHighlighted];
//    [btn setImage:[UIImage imageWithColor:UIColorFromRGB(0x000000) size:btn.frame.size] forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(onClickRefusedPushAgreeButton:) forControlEvents:UIControlEventTouchUpInside];
//    [_refusedPushAgreeView addSubview:btn];
//    
//    [_refusedPushAgreeView setHidden:YES];
//    [_refusedPushAgreeView setAlpha:0.f];
}

- (void)updateFrame
{
   // _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 6, CGRectGetWidth(frame),
    
//    CGRect webViewFrame;
//    webViewFrame = CGRectMake(0, 30, kScreenBoundsWidth, kScreenBoundsHeight);
//    [self.webView setFrame:webViewFrame];
}

- (void)updateFrameSunny:(NSInteger)gnbType
{
     //_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 6, CGRectGetWidth(frame),
    
    CGRect webViewFrame;
    webViewFrame = CGRectMake(0, 0, CGRectGetWidth([self frame]), CGRectGetHeight([self frame])-kToolBarHeight);
    [self.webView setFrame:webViewFrame];
    
    CGSize contentSize = self.webView.scrollView.contentSize;
    CGSize viewSize = webViewFrame.size;
    
    float sfactor = viewSize.width / contentSize.width;
    
//    self.webView.scrollView.minimumZoomScale = sfactor;
//    self.webView.scrollView.maximumZoomScale = sfactor;
//    self.webView.scrollView.zoomScale = sfactor;
    
    CGRect toolViewFrame;
    toolViewFrame = CGRectMake(0, CGRectGetHeight([self frame])-(kToolBarHeight-kWebViewTopMarginY*2), CGRectGetWidth([self frame]), kToolBarHeight);
    [toolBarView setFrame:toolViewFrame];
    
    CGFloat topButtonMarginX = 0.0f;
    if(kScreenBoundsWidth > 400){
        topButtonMarginX = 7;
        
    }else{
        topButtonMarginX = (kScreenBoundsWidth > 320)?0:0;
    }
    
    [_topButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth+7, CGRectGetHeight([self frame])-(buttonHeight-12)+topButtonMarginX, buttonWidth, buttonHeight)];
    [_preButton setFrame:CGRectMake(-5, CGRectGetHeight([self frame])-(buttonHeight-12)+topButtonMarginX, buttonWidth, buttonHeight)];
    
    [_zoomInButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth, CGRectGetHeight([self frame])-(kToolBarHeight-kWebViewTopMarginY*2) - (buttonHeight*2+10) - (buttonHeight+10) , buttonWidth, buttonHeight)];
    [_zoomOutButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth, CGRectGetHeight([self frame])-(kToolBarHeight-kWebViewTopMarginY*2) - (buttonHeight*2+10) , buttonWidth, buttonHeight)];
    
//    if(gnbType == 0){ //sunny
//        [_zoomInButton setHidden:false];
//        [_zoomOutButton setHidden:false];
//    }else{
//        [_zoomInButton setHidden:true];
//        [_zoomOutButton setHidden:true];
//
//    }
}

- (void)setZoomBtnVisible:(NSInteger)isShow
{
    if(isShow == 0){ //hide
        [_zoomInButton setHidden:true];
        [_zoomOutButton setHidden:true];
    }else{
        [_zoomInButton setHidden:false];
        [_zoomOutButton setHidden:false];
        
    }
}

- (void)updateFrameSunnyForStatusHide
{
    //_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 6, CGRectGetWidth(frame),
    
    CGRect webViewFrame;
    webViewFrame = CGRectMake(0, 0, CGRectGetWidth([self frame]), CGRectGetHeight([self frame])-(kToolBarHeight));
    //webViewFrame = CGRectMake(0, kStatusBarY, kScreenBoundsWidth, kScreenBoundsHeight-kToolBarHeight);
    [self.webView setFrame:webViewFrame];
    
    CGSize contentSize = self.webView.scrollView.contentSize;
    CGSize viewSize = webViewFrame.size;
    
    float sfactor = viewSize.width / contentSize.width;
    
//    self.webView.scrollView.minimumZoomScale = sfactor;
//    self.webView.scrollView.maximumZoomScale = sfactor;
//    self.webView.scrollView.zoomScale = sfactor;
    
    CGRect toolViewFrame;
    toolViewFrame = CGRectMake(0, CGRectGetHeight([self frame])-(kToolBarHeight), CGRectGetWidth([self frame]), kToolBarHeight);
//    toolViewFrame = CGRectMake(0, kScreenBoundsHeight-(kToolBarHeight+kStatusBarY), kScreenBoundsWidth, kToolBarHeight);
    [toolBarView setFrame:toolViewFrame];
    
    
    [_topButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth+7, CGRectGetHeight([self frame])-(buttonHeight+((kToolBarHeight-buttonHeight)/2)), buttonWidth, buttonHeight)];
    [_preButton setFrame:CGRectMake(-5, CGRectGetHeight([self frame])-(buttonHeight+((kToolBarHeight-buttonHeight)/2)), buttonWidth, buttonHeight)];

    [_zoomInButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth, CGRectGetHeight([self frame])-(kToolBarHeight+kNavigationHeight)+kStatusBarY*2 - (buttonHeight*2+10)- (buttonHeight+10) , buttonWidth, buttonHeight)];
    [_zoomOutButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth, CGRectGetHeight([self frame])-(kToolBarHeight+kNavigationHeight)+kStatusBarY*2 - (buttonHeight*2+10) , buttonWidth, buttonHeight)];
    
//    [_zoomInButton setHidden:false];
//    [_zoomOutButton setHidden:false];
    
//    [self bringSubviewToFront:_topButton];
}


- (void)setForwardButton:(BOOL)enable
{
    UIButton *forwardButton = (UIButton *)[toolBarView viewWithTag:1];
    [toolBarView setButtonProperties:forwardButton enable:enable];
}

#pragma mark - PullToRefreshViewDelegate

//-(void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view
//{
//    isPullToRefresh = YES;
//    [self reload];
//}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
//    [NSURLCache setSharedURLCache:sharedCache];
    
    [self.webView setHidden:false];
    
    netTimeOutSecond = NET_TIME_OUT;
    [self startNetCheckTimer];
    
    NSString *url = request ? request.URL.absoluteString : nil;
//    NSLog(@"shouldStartLoadWithRequest %@", url);
    
    //웹뷰에 노출되는 버튼은 일단 숨김
    [self.preButton setHidden:YES];
    
    //URL끝에 #이 들어가면 Request를 취소
    if ([url hasSuffix:@"#"]) {
        return NO;
    }
    
    if ([url hasSuffix:@"about"]) {
        return NO;
    }
    
    //URL스킴 체크
    if ([self.delegate respondsToSelector:@selector(webView:openUrlScheme:)]) {
        if ([self.delegate webView:self openUrlScheme:request.URL.absoluteString]) {
            return NO;
        }
    }
    
    if ([self isMatchedUrl:url]) {
        //네비게이션 바 세팅
//        if ([self.delegate respondsToSelector:@selector(initNavigation:)] && [self isNeedLoadingUrl:url]) {
//            //[self.delegate initNavigation:[Modules isMatchedGNBUrl:url]];
//            //[self.delegate initNavigation:0];
//        }
        
        if (![url hasPrefix:@"app"] && ![url hasPrefix:@"about"]) {
            if (([url rangeOfString:@"Processing"].location == NSNotFound) && ([url rangeOfString:@"xml"].location == NSNotFound)){
                [myStack push:url];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:)]) {
            
            BOOL isShouldLoad = [self.delegate webView:self shouldStartLoadWithRequest:request];
            
            if (isShouldLoad) {
                //BOOL isHomeMenu = [CPCommonInfo isHomeMenuUrl:url];
                BOOL isHomeMenu = true;
                
//                if (!loadingView.isAnimating && !isHomeMenu && !isPullToRefresh && [self isNeedLoadingUrl:url]) {
//                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//                    [self startLoadingAnimation];
//                }
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                [self startLoadingAnimation];
                
            }
            else {
                return isShouldLoad;
            }
        }
        
        //reloadUrl = url;
    }
    return YES;
}

- (BOOL)isNeedLoadingUrl:(NSString *)url
{
    //#태그 붙은 얘들은 로딩뷰 안보여줌
    //#dummyArea 장바구니 옵션변경
    //#s_filter 검색
    //#complete 주문완료후 뒤로가기 버튼
    //#sec 이벤트
    //이벤트탭 혜택존     //정규표현식으로 변경
    
//    if ([url.lowercaseString isMatchedByRegex:@"#[a-z]+"]) {
//        return NO;
//    }
    
    return YES;
}

- (BOOL)isMatchedUrl:(NSString *)url
{
//    if ([url isMatchedByRegex:@"/a.st?"] || [url isMatchedByRegex:@"/app.st?"]) {
//        return NO;
//    }
//    
//    if ([url isMatchedByRegex:@"/api.recopick.com"]) {
//        return NO;
//    }
//    
//    if ([url isMatchedByRegex:@""]) {
//        return NO;
//    }
//    
////    if ([url.lowercaseString isMatchedByRegex:@"#[a-z]+"]) {
////        //#dummyArea 장바구니 옵션변경
////        //#s_filter 검색
////        //#complete 주문완료후 뒤로가기 버튼
////        //#sec 이벤트
////        //정규표현식으로 변경
////        //        NSLog(@"isMatchedByRegex url : %@", url);        
////        return NO;
////    }
//    
//    if ([url isMatchedByRegex:@"^(https?|mailto|mecard|geo|smsto):.*"]) {
//        return YES;
//    }
//    
//    return NO;
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webview
{
	[self hideRefusedPushAgreeView];
	
//	AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//	[app addRefusedPushAgreeCount:webview.request.URL.absoluteString];
	
    //UIButton *reloadButton = (UIButton *)[toolBarView viewWithTag:CPToolBarButtonTypeReload];
    //gclee
    //UIButton *reloadButton = (UIButton *)[toolBarView viewWithTag:2];
    //[toolBarView setReloadButtonProperties:reloadButton isReload:YES];
    
//    NSLog(@"webViewDidStartLoad:%@", webview.request.URL.absoluteString);
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
//    if (self.webView.isLoading) {
//        return;
//    }
    
    fZoomInCurrent = 1.0f;
    CGSize contentSize = self.webView.scrollView.contentSize;
    CGSize viewSize = self.frame.size;
    
    float sfactor = viewSize.width / contentSize.width;
    
//    self.webView.scrollView.minimumZoomScale = sfactor;
//    self.webView.scrollView.maximumZoomScale = sfactor;
//    self.webView.scrollView.zoomScale = sfactor;
    
//    self.webView.scrollView.minimumZoomScale = 1;
//    self.webView.scrollView.maximumZoomScale = 20;
    self.webView.scrollView.zoomScale = 2;
    self.webView.scrollView.zoomScale = 1;
    
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:self];
    }
    
//    @implementation UIWebView (Resize)
//    
//    - (void)sizeViewPortToFitWidth {
//        [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ", (int)self.frame.size.width]];
//    }
//    
//    @end
    
//    UIButton *backButton = (UIButton *)[toolBarView viewWithTag:CPToolBarButtonTypeBack];
//    [toolBarView setButtonProperties:backButton enable:[self.webView canGoBack]];
    
    float meHeight = kScreenBoundsHeight;
    if(meHeight <= 480){
        [_preButton setHidden:true];
    }else{
        BOOL isViewLevel = [[NSUserDefaults standardUserDefaults] boolForKey:kViewLevelY];
        if(isViewLevel == NO){
            [_preButton setHidden:true];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kViewLevelY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            [_preButton setHidden:([self.webView canGoBack])?false:true];
        }
    }
    //
    //UIButton *forwardButton = (UIButton *)[toolBarView viewWithTag:1];
//    if (self.currentSubWebViewIndx == self.maxSubWebViewIndx) {
//        [toolBarView setButtonProperties:forwardButton enable:[self.webView canGoForward]];
//    }
    
//    UIButton *reloadButton = (UIButton *)[toolBarView viewWithTag:2];
//    [toolBarView setReloadButtonProperties:reloadButton isReload:NO];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self stopLoadingAnimation];
    [self stopNetCheckTimer];
    
    
    NSString *url = aWebView.request.URL.absoluteString;
//    NSLog(@"webViewDidFinishLoad:%@", url);
    
    // pullToRefresh finish
    //[pull finishedLoading];
    isPullToRefresh = NO;
    
//    if ([Modules isMatchedProductUrl:url]) {
//        self.isProductDidLoad = NO;
//    }
    self.isProductDidLoad = NO;
    
    self.isExistsSubWebView = YES;
    
    if (![self.zoomViewerButton isHidden]) {
        [self.zoomViewerButton setHidden:YES];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}

- (void)webView:(UIWebView *)webview didFailLoadWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:self didFailLoadWithError:error];
    }
    
    //[self stopLoadingAnimation];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
//    errorView = [[CPErrorView alloc] initWithFrame:self.frame];
//    [errorView setDelegate:self];
//    [self addSubview:errorView];
}

#pragma mark - Public Methods

- (void)loadRequest:(NSURLRequest *)request
{
    //호출된 이전 리퀘스트의 캐쉬를 지우고 새로운 리퀘스트를 만듬
    if ([SYSTEM_VERSION intValue] > 6.5) {
    //if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        if (request) {
            [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            
        }
    }
    
    //[myStack delAll];
    
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:request.URL.absoluteString]
                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                           timeoutInterval:10000];
    
    [self.webView loadRequest:request];
}

- (void)loadMutableRequest:(NSMutableURLRequest *)request
{
    //호출된 이전 리퀘스트의 캐쉬를 지우고 새로운 리퀘스트를 만듬
    if ([SYSTEM_VERSION intValue] > 6.5) {
        //if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        if (request) {
            [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            
        }
    }
    
    
    [myStack delAll];
    
    [self.webView loadRequest:request];

}

- (void)open:(NSString *)url
{
	if (url && ![url isEqualToString:@""]) {

		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
		
		if (url && request) {
			
			[self.webView performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:TRUE];

			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				[self.webView performSelectorOnMainThread:@selector(loadRequest:) withObject:request waitUntilDone:NO];
			});
		}
		else {
			if ([self.delegate respondsToSelector:@selector(webView:openUrlScheme:)]) {
				[self.delegate webView:self openUrlScheme:url];
			}
		}
	}
}

- (NSString *)execute:(NSString *)script
{
    NSString *executeScript = [NSString stringWithFormat:@"try{%@;}catch(e){}", script];
    
    NSString *returnString = [self.webView stringByEvaluatingJavaScriptFromString:executeScript];
    NSData *returnData = returnString ? [returnString dataUsingEncoding:NSUTF8StringEncoding] : nil;
	
    return returnData ? [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] : nil;
}

//- (BOOL)toggleButtonHiddenStatus
//{
//	return toggleButton.hidden;
//}

- (void)setHiddenToolBarView:(BOOL)isHidden
{
    if (isHidden) {
//        NSLog(@"setHiddenToolBarView:%@, %@", NSStringFromCGRect(self.frame), NSStringFromCGRect(self.bounds));
        
        
        // -- [self.webView setFrame:self.bounds];
        
        
//        [self.topButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth, CGRectGetHeight(self.frame)-(buttonHeight), buttonWidth, buttonHeight)];
//		
//		[_refusedPushAgreeView setFrame:CGRectMake(10, CGRectGetHeight(self.frame)-31,
//												   _refusedPushAgreeView.frame.size.width, _refusedPushAgreeView.frame.size.height)];
    }
    else {
        
        NSLog(@"self.frame : %@", NSStringFromCGRect(self.frame));
//        [self.webView setFrame:CGRectMake(0, 0, CGRectGetMaxX(self.frame), CGRectGetHeight(self.frame)-kToolBarHeight)];
//                    NSLog(@"self.webView.frame : %@", NSStringFromCGRect(self.webView.frame));
        
        // -- [self.webView setFrame:self.bounds];
        
        
//        [toolBarView setFrame:CGRectMake(0, CGRectGetMaxY(self.webView.frame), CGRectGetWidth(self.frame), kToolBarHeight)];
        
//        [self.topButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth, CGRectGetHeight(self.frame)-(buttonHeight*2), buttonWidth, buttonHeight)];
//
//        [_refusedPushAgreeView setFrame:CGRectMake(10, CGRectGetHeight(self.frame)-31-kToolBarHeight,
//                                                   _refusedPushAgreeView.frame.size.width, _refusedPushAgreeView.frame.size.height)];
    }
    
    [toolBarView setHidden:isHidden];
}

- (void)setHiddenpreButton:(BOOL)isHidden
{
    [self.preButton setHidden:isHidden];
    
//    if (isHidden) {
//        [self.topButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth, CGRectGetHeight(self.frame)-(buttonHeight*2), buttonWidth, buttonHeight)];
//    }
//    else {
//        [self.topButton setFrame:CGRectMake(kScreenBoundsWidth-buttonWidth, CGRectGetHeight(self.frame)-(buttonHeight*3), buttonWidth, buttonHeight)];
//    }
}

- (NSString *)url
{
	return self.webView.request.URL.absoluteString;
}

- (void)reload
{
	[self.webView reload];
}

- (void)stop
{
	[self.webView performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
}

- (void)goTopWithAnimated:(BOOL)animated
{
    [self.webView.scrollView setContentOffset:CGPointZero animated:animated];
}

- (NSInteger)isGoBack
{
    if ([self.webView canGoBack]) {
        return 1;
    }else{
        return 0;
    }
    
    return 1;
}

- (void)myGoBack
{
//    [self.webView stopLoading];
//    [self.webView reload];
    
    
    if ([self.webView canGoBack]) {

        if ([SYSTEM_VERSION intValue] > 7.0) {
            //[[NSURLCache sharedURLCache] removeAllCachedResponses];
            [self.webView goBack];
        }else{
            if ([self.delegate respondsToSelector:@selector(gotoPrev:)]) {
                NSString* strDummy = [myStack pop];
                if (([strDummy rangeOfString:@"bank"].location != NSNotFound)){
                    if([strDummy isEqualToString:webViewUrl]){
                        strDummy = [myStack pop];
                    }
                    [self.delegate gotoPrev:strDummy];
                }else{
                    NSString* strGoUrl = [myStack pop];
                    [self.delegate gotoPrev:strGoUrl];
                }
            }
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(webViewGoBack)]) {
            [self.delegate webViewGoBack];
        }
    }
}

- (void)goFoward
{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (void)actionTop
{
	[self.webView.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)actionBackWord
{
	[self myGoBack];
}

- (void)actionForward
{
	[self goFoward];
}

- (void)actionReload
{
	[self reload];
}

- (void)setHiddenPopover:(BOOL)hidden
{
    [toolBarView setHiddenPopover:YES];
}

#pragma mark - Selectors

- (void)touchTopButton
{
    [self.webView.scrollView setContentOffset:CGPointZero animated:YES];
    
//    if ([self.webView.request.URL.absoluteString hasPrefix:@""]) {
//        //AccessLog - 검색창 탑 버튼
//        [[AccessLog sharedInstance] sendAccessLogWithCode:@"ASRPF01"];
//    }
}

- (void)touchZoomViewerButton
{
    if ([self.delegate respondsToSelector:@selector(didTouchZoomViewerButton)]) {
        [self.delegate didTouchZoomViewerButton];
    }
}

- (void)touchpreButton
{
    if ([self.webView canGoBack]) {
        [self myGoBack];
        //[self.webView goBack];
    }
//    SBJSON *parser = [[SBJSON alloc] init];
//    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *script = [userDefaults objectForKey:@"offeringMapScript"];
//    NSDictionary *mapScript = script ? [parser objectWithString:script] : nil;
//    
//    if (mapScript) {
//        [self execute:[mapScript objectForKey:@"script"]];
//    }
}

- (void)touchZoomInButton{
    
//    CGSize c_contentSize = self.webView.scrollView.contentSize;
//    c_contentSize.height += 10;
//    c_contentSize.width += 10;
//    self.webView.scrollView.contentSize = c_contentSize;
//    CGSize viewSize = _webView.frame.size;
//    
//    float sfactor = viewSize.width / c_contentSize.width;
//
    fZoomInCurrent += 0.2f;
    
    if(fZoomInCurrent > ZOOMIN_MAX_LENGTH){
        fZoomInCurrent = ZOOMIN_MAX_LENGTH;
    }
    
    self.webView.scrollView.zoomScale = fZoomInCurrent;
    
}

- (void)touchZoomOutButton{
//    CGSize c_contentSize = self.webView.scrollView.contentSize;
//    c_contentSize.height -= 10;
//    c_contentSize.width -= 10;
//    self.webView.scrollView.contentSize = c_contentSize;
//    CGSize viewSize = _webView.frame.size;
//    
//    float sfactor = viewSize.width / c_contentSize.width;
    fZoomInCurrent -= 0.2f;
    if(fZoomInCurrent < ZOOMOUT_MAX_LENGTH){
        fZoomInCurrent = 1.0f;
    }
    self.webView.scrollView.zoomScale = fZoomInCurrent;
    
}

//- (void)touchToggleButton
//{
//	if (productView) {
//		[productView setHidden:NO];
//	}
//    NSLog(@"touchToggleButton : %@", NSStringFromCGRect(self.frame));
//	
//    CGRect webViewFrame = CGRectMake(0, 0, CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame)-kToolBarHeight);
//	CGRect toolBarViewFrame = CGRectMake(0, CGRectGetMaxY(webViewFrame)-self.frame.origin.y, CGRectGetMaxX(self.frame), kToolBarHeight);
//	CGFloat moveHeight = toolBarView.frame.origin.y - toolBarViewFrame.origin.y;
//    
//	[UIView animateWithDuration:0.5f animations:^{
//		[toolBarView setFrame:toolBarViewFrame];
////        [self.webView setFrame:webViewFrame];
//		
//		[_refusedPushAgreeView setFrame:CGRectMake(10, CGRectGetHeight(self.frame)-31-kToolBarHeight,
//												   _refusedPushAgreeView.frame.size.width, _refusedPushAgreeView.frame.size.height)];
//		
//		if (productView) {
//			[productView setAlpha:1.f];
//			[productView setFrame:CGRectMake(productView.frame.origin.x,
//											 productView.frame.origin.y - moveHeight,
//											 productView.frame.size.width,
//											 productView.frame.size.height)];
//		}
//		
//	} completion:^(BOOL finished) {
//        [self.webView setFrame:webViewFrame];
//		[toggleButton setHidden:YES];
//	}];
//}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
//     view	UIWebBrowserView *	0x14be2400	0x14be2400
//    _input	UIWebFormSelectPeripheral *	0x145b6200	0x145b6200
//    _selectControl	UIWebSelectSinglePicker *	0x145cb910	0x145cb910
    
    //UIWebBrowserView* UIView = (UIWebBrowserView*)view;
    
     NSLog(@"scroll capture");
     NSLog(@"scroll capture");
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
    //if(scale == 1.14374995f || scale == 1 || scale == 1.1440000534057617){
    if( scale >= 1 && scale < 1.15){
        self.webView.scrollView.zoomScale = 0.5f;
        return;
    }
    
    _webView.scrollView.maximumZoomScale = 20;
    //_webView.scrollView.minimumZoomScale = 1;
    fZoomInCurrent = scale;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger contentOffset = scrollView.contentOffset.y;
    // 스크롤뷰가 바운스되는 경우는 상황에서 제외
//    if (contentOffset < 0 || contentOffset > scrollView.contentSize.height - scrollView.frame.size.height) {
//        return;
//    }
    
//    if (![popOverView isHidden]) {
//        [popOverView setHidden:YES];
//    }
//    
//    if (![snapshotPopOverView isHidden]) {
//        [snapshotPopOverView setHidden:YES];
//    }
    [toolBarView setHiddenPopover:YES];
	
	//푸쉬 허용 동의 팝업
	CGFloat currentOffsetY = scrollView.contentOffset.y + _webView.frame.size.height;
	if (currentOffsetY >= scrollView.contentSize.height-50.f) {
		[self showRefusedPushAgreeView];
	}
	else {
		[self hideRefusedPushAgreeView];
	}

    // 탑 버튼 처리
    static NSInteger lastContentOffset = 0;
    static BOOL isScrollingToUp = NO;
    if (lastContentOffset > contentOffset) {
        //if (contentOffset < 50) {
        if (contentOffset < 30) {
            [UIView animateWithDuration:0.5f animations:^{
                [self.topButton setHidden:YES];
            }];
        }
        isScrollingToUp = NO;
    }
    else if (lastContentOffset < contentOffset) {
        if (NO == isScrollingToUp) {
            [self.topButton setHidden:NO];
        }
        isScrollingToUp = YES;
    }
    
    lastContentOffset = scrollView.contentOffset.y;
}

#pragma mark - CPToolBarViewDelegate

- (void)didTouchToolBarButton:(UIButton *)button buttonInfo:(NSDictionary *)buttonInfo
{
    
    if ([self.delegate respondsToSelector:@selector(didTouchToolBarButton:)]) {
        [self.delegate didTouchToolBarButton:button];
    }
    
//    switch (button.tag) {
//        case 1:
//            if ([button isEnabled]) {
//                //히스토리가 없을 경우 홈으로
//                if ([self.webView canGoBack]) {
//                    if (![self.zoomViewerButton isHidden]) {
//                        [self.zoomViewerButton setHidden:YES];
//                    }
//                    
//                    [self.webView goBack];
//                }
//                else {
//                    if ([self.delegate respondsToSelector:@selector(didTouchToolBarButton:)]) {
//                        [self.delegate didTouchToolBarButton:button];
//                    }
//                }
//            }
//            break;
//        case 2:
//            if ([button isEnabled]) {
//                if (self.currentSubWebViewIndx < self.maxSubWebViewIndx && ![self.webView canGoForward]) {
//                    if ([self.delegate respondsToSelector:@selector(didTouchToolBarButton:)]) {
//                        [self.delegate didTouchToolBarButton:button];
//                    }
//                }
//                else {
//                    if ([self.webView canGoForward]) {
//                        [self.webView goForward];
//                        
//                        //웹페이지 내부링크(#)가 포함된 URL은 canGoForward가 YES 인데 히스토리 스택에는 없기 때문에 이동이 안된다(iOS bug?)
//                        if (self.currentSubWebViewIndx == self.maxSubWebViewIndx) {
//                            UIButton *forwardButton = (UIButton *)[toolBarView viewWithTag:2];
//                            [toolBarView setButtonProperties:forwardButton enable:NO];
//                        }
//                    }
//                    else {
//                        if ([self.delegate respondsToSelector:@selector(didTouchToolBarButton:)]) {
//                            [self.delegate didTouchToolBarButton:button];
//                        }
//                    }
//                }
//            }
//            break;
//        case 3:
//        {
//            if ([self.webView isLoading]) {
//                [self.webView stopLoading];
//                [self.webView goBack];
////                UIButton *reloadButton = (UIButton *)[toolBarView viewWithTag:CPToolBarButtonTypeReload];
//                [toolBarView setReloadButtonProperties:button isReload:NO];
//            }
//            else {
////                if (!nilCheck([self url])) {
//////                    NSLog(@"%@", [self url]);
////                    [self.webView reload];
////                }
////                else {
//////                    NSLog(@"empty: %@", reloadUrl);
////                    [self open:reloadUrl];
////                }
//                [self open:reloadUrl];
//            }
//            break;
//        }
//        case 4:
//            [self touchTopButton];
//            break;
//		case 5:
//        default:
//            if ([self.delegate respondsToSelector:@selector(didTouchToolBarButton:)]) {
//                [self.delegate didTouchToolBarButton:button];
//            }
//            break;
//    }
}

- (void)didTouchPopOverButton:(UIButton *)button buttonInfo:(NSDictionary *)buttonInfo
{
    if ([self.delegate respondsToSelector:@selector(didTouchPopOverButton:buttonInfo:)]) {
        [self.delegate didTouchPopOverButton:button buttonInfo:buttonInfo];
//        [popOverView setHidden:YES];
    }
}

- (void)didTouchSnapshotPopOverButton:(UIButton *)button buttonInfo:(NSDictionary *)buttonInfo
{
    if ([self.delegate respondsToSelector:@selector(didTouchSnapshotPopOverButton:buttonInfo:)]) {
        [self.delegate didTouchSnapshotPopOverButton:button buttonInfo:buttonInfo];
//        [snapshotPopOverView setHidden:YES];
    }
}

#pragma mark - CPErrorViewDelegate

- (void)didTouchRetryButton
{
    //[errorView removeFromSuperview];
    
    [self reload];
}

#pragma mark - productOption Methods

- (void)makeProductOption
{
	//툴바가 없으면 화면에 그릴 수 없다.
	if (!toolBarView) return;
	
	if (isToolBarAnimation) {
		isDelayMakeProductOption = YES;
		return;
	}
	
	//Toolbar가 숨겨져있다면 원위치시킨다.
//	if ([self toggleButtonHiddenStatus] == NO) {
//		[self touchToggleButton];
//	}
	
	CGRect viewFrame = [self frame];
	
//	productView = [[CPProductOption alloc] initWithToolbarView:toolBarView parentView:self];
//	[productView setExecuteWebView:self];
//	[self addSubview:productView];
//	productView.alpha = 0.f;
//	
//	//상단에 보여줄 옵션 안내문구
//	if (NO == [[NSUserDefaults standardUserDefaults] boolForKey:@"drawerGuideView"])
//	{
//		UIImage *imgProductOptionGuide = [UIImage imageNamed:@"option_balloon"];
//		UIImageView *guideView = [[UIImageView alloc] initWithFrame:CGRectMake((viewFrame.size.width/2)-(imgProductOptionGuide.size.width/2) ,
//																			   productView.frame.origin.y - imgProductOptionGuide.size.height,
//																			   imgProductOptionGuide.size.width,
//																			   imgProductOptionGuide.size.height)];
//		guideView.image = imgProductOptionGuide;
//		[self addSubview:guideView];
//		guideView.alpha = 0.f;
//		
//		[productView setGuideView:guideView];
//		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"drawerGuideView"];
//	}
	
	//툴바를 항상 앞으로 놓는다.
	[self bringSubviewToFront:toolBarView];

	//에니메이션
//	[UIView animateWithDuration:0.5f animations:^{
//		productView.alpha = 1.f;
//	} completion:^(BOOL finished) {
//	}];
}

- (void)closeProductOption
{
//	if (productView) {
//		[productView closeDrawer];
//	}
}

- (void)destoryProductOption
{
//	for (UIView *view in self.subviews) {
//		if ([view isKindOfClass:[CPProductOption class]]) {
//			[view removeFromSuperview];
//		}
//	}
}

#pragma mark - Override Methods

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // UIView will be 'transparent' for touch events if we return NO.
//     NSLog(@"scrolling:%@", self.isScrolling?@"Y":@"N");
    
    //iCarousel이 스크롤 중에는 웹뷰의 터치를 막음
    return !self.isScrolling;
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


#pragma mark - refusedPushAgreeView Methods.
- (void)showRefusedPushAgreeView
{
//	AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//	if (![app enableRefusedRushAgree]) return;
	
	if (_refusedPushAgreeView.alpha > 0.f) return;
	
	[_refusedPushAgreeView setHidden:NO];
	[UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		_refusedPushAgreeView.alpha = 1.f;
	} completion:^(BOOL isComplete){
		
	}];
}

- (void)hideRefusedPushAgreeView
{
	if (_refusedPushAgreeView.alpha < 1.f) return;
	
	[UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		_refusedPushAgreeView.alpha = 0.f;
	} completion:^(BOOL isComplete){
		[_refusedPushAgreeView setHidden:YES];
	}];
}

- (void)showAlertRequestError:(NSString *)errorMessage
{
//	[UIAlertView showWithTitle:NSLocalizedString(@"AlertTitle", nil)
//					   message:errorMessage
//			 cancelButtonTitle:nil
//			 otherButtonTitles:@[ NSLocalizedString(@"Confirm", nil) ]
//					  tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {}];
}

- (void)reCreateToolbar
{
//     [toolBarView removeFromSuperview];
//    // 툴바
//     toolBarView = [[ToolBarView alloc] initWithFrame:CGRectMake(0, kScreenBoundsHeight-(kToolBarHeight), kScreenBoundsWidth, kToolBarHeight-0) toolbarType:1];
//    
//    [toolBarView setDelegate:self];
//    [toolBarView setHidden:NO];
//    [self addSubview:toolBarView];

}

- (BOOL)parsePushEnable:(NSDictionary *)response
{
	BOOL isFind = NO;
	BOOL enable = NO;
	
	if ([response objectForKey:@"groups"])
	{
		NSArray *groups = [response objectForKey:@"groups"];
		
		for (int i=0; i<groups.count; i++)
		{
			NSString *groupId = groups[i][@"groupId"];
			
			if (groupId && groupId.length > 0 && [groupId isEqualToString:@"02"]) {
				
				NSArray *items = groups[i][@"items"];
				
				if (items && items.count > 0)
				{
					for (int j=0; j<items.count; j++)
					{
						NSString *itemId = items[j][@"itemId"];
						
						if (itemId && itemId.length > 0 && [itemId isEqualToString:@"0201"])
						{
							enable = [items[j][@"value"] boolValue];
							isFind = YES;
							break;
						}
					}
				}
			}
			
			if (isFind) break;
		}
	}
	
	return enable;
}

- (void)redrawADImage{
    
    [toolBarView redrawADImage];
    
}

- (void)initNetCheckView
{
    
    [self.webView setHidden:YES];
    [self.zoomInButton setHidden:YES];
    [self.zoomOutButton setHidden:YES];

    
    CGRect viewFrame = [self frame];
    
    CGFloat marginX = 0;
    CGFloat marginY = 0;
    CGFloat marginYY = 0;
    
    float meHeight = kScreenBoundsHeight;
    if(meHeight <= 480){
        marginX = 0;
        marginY = 0;
    }else{
        marginX = 0;
        marginY = 15;
        marginYY = -10;
        if(kScreenBoundsWidth > 320){
            if(kScreenBoundsWidth > 400){
                marginX = 45;
                marginY = 15;
                marginYY = -40;
            }else{
                marginX = 25;
                marginY = 15;
                marginYY = -25;
            }
        }
    }
    
    if(checkNetTimoutView)
    {
        [checkNetTimoutView removeFromSuperview];
    }
    
    checkNetTimoutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height)];
    [self addSubview:checkNetTimoutView];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(20+marginX, 20+marginY, 280, 220)];
    bgView.image = [UIImage imageNamed:@"error_img.png"];
    [checkNetTimoutView addSubview:bgView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(45+marginX, 120+marginY+marginYY , viewFrame.size.width/4*3, viewFrame.size.height/3)];
    NSString* temp;
    NSString* labelText;
    NSString* btnText;
    
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        labelText = NET_WORK_CHECK_KO;
        btnText = NET_WORK_RELOAD_KO;
    }else{
        labelText = NET_WORK_CHECK_VI;
        btnText = NET_WORK_RELOAD_VI;
    }
    textLabel.text = labelText;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.numberOfLines = 0;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = UIColorFromRGB(0x000000);
    textLabel.font = [UIFont systemFontOfSize:15.f];
    textLabel.textAlignment = NSTextAlignmentLeft;
    [checkNetTimoutView addSubview:textLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20+marginX,CGRectGetMaxY(textLabel.frame) , 280, 40);
    //[btn setBackgroundColor:[UIColor clearColor]];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"login_btn_press.png"] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
    [btn setTitle:btnText forState:UIControlStateNormal];
    [btn setTitle:btnText forState:UIControlStateHighlighted];
    [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onClickReloadButton) forControlEvents:UIControlEventTouchUpInside];
    [checkNetTimoutView addSubview:btn];
    
    [checkNetTimoutView setHidden:NO];
    [checkNetTimoutView setAlpha:1.f];
}

- (void)onClickReloadButton{
    
    netTimeOutSecond = NET_TIME_OUT;
    [self startNetCheckTimer];
    [self.webView setHidden:NO];
    [checkNetTimoutView setHidden:YES];
    [self.webView reload];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self startLoadingAnimation];
    
    
}

- (void)startNetCheckTimer    // 타이머 시작
{
    
    if(checkNetTimoutView)
        [checkNetTimoutView setHidden:YES];
    
    if (netCheckTimer) {
        [netCheckTimer invalidate];
        netCheckTimer = nil;
    }
    
    //scheduledTimerWithTimeInterval:3
    //timerWithTimeInterval:timerInterval
    netCheckTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTick) userInfo:nil repeats:YES];
    
    
}

- (void)stopNetCheckTimer    // 타이머 시작
{
    
    if(checkNetTimoutView)
        [checkNetTimoutView setHidden:YES];
    
    if (netCheckTimer) {
        [netCheckTimer invalidate];
        netCheckTimer = nil;
    }
    
}


- (void)onTick{
    
    NSLog(@"Tick...");
    
    if(netTimeOutSecond > 0){
        netTimeOutSecond--;
        NSLog(@"timer time %ld ", (long)netTimeOutSecond);
        if(netTimeOutSecond == 0){
            NSLog(@"web contents load 30 second Time Out ! ");
            
            [self stopNetCheckTimer];
            [self.webView stopLoading];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [self stopLoadingAnimation];
            
            [self initNetCheckView];
            
            
        }
    }
    
}

- (void)stackAllDel{
    [myStack delAll];
}



@end
